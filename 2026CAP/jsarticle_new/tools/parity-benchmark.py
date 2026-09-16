"""Frozen-copy timing, watch editing, and strict PDF comparison.
Usage: python parity-benchmark.py BASELINE CANDIDATE OUTPUT [--watch]
All generated files and edit probes stay beneath OUTPUT.
"""
import argparse, hashlib, json, pathlib, shutil, statistics, subprocess, time

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def run(root, output, timings=False):
    cmd = ["typst", "compile", "--root", str(root), str(root/"main.typ"), str(output)]
    if timings:
        cmd += ["--timings", str(output.with_suffix(".timings.json"))]
    start = time.perf_counter()
    try:
        p = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8", timeout=120)
        elapsed = time.perf_counter()-start
        pages = None
        if p.returncode == 0:
            from pypdf import PdfReader
            pages = len(PdfReader(output).pages)
        return dict(seconds=elapsed, code=p.returncode,
                    warnings=p.stderr, timeout=False, pages=pages)
    except subprocess.TimeoutExpired:
        return dict(seconds=120, code=None, warnings="", timeout=True)

def compare(a, b, output, render=True):
    import pdfplumber
    from pypdf import PdfReader
    from PIL import Image, ImageChops
    errors = []
    with pdfplumber.open(a) as x, pdfplumber.open(b) as y:
        if len(x.pages) != len(y.pages):
            errors.append("page count")
        for i, (p, q) in enumerate(zip(x.pages, y.pages), 1):
            if len(p.chars) != len(q.chars):
                errors.append(f"page {i} glyph count")
                continue
            for j, (c, d) in enumerate(zip(p.chars, q.chars)):
                # PDF subset prefixes are build-local, not font identities.
                for key in ("text", "fontname"):
                    u, v = c[key], d[key]
                    if key == "fontname":
                        u, v = u.split("+")[-1], v.split("+")[-1]
                    if u != v:
                        errors.append(f"page {i} glyph {j} {key}")
                if any(abs(c[k]-d[k]) > .001 for k in ("x0","x1","top","bottom","size")):
                    errors.append(f"page {i} glyph {j} position")
    def annotations(path):
        reader = PdfReader(path)
        pages = {p.indirect_reference.idnum: i for i,p in enumerate(reader.pages)}
        def clean(v):
            if hasattr(v, "idnum"):
                if v.idnum in pages:
                    return {"page": pages[v.idnum]}
                return clean(v.get_object())
            if isinstance(v, dict):
                return {str(k): clean(x) for k,x in v.items()
                        if str(k) not in ("/P","/Parent")}
            if isinstance(v, (list,tuple)):
                return [clean(x) for x in v]
            return str(v)
        return [[clean(a.get_object()) for a in p.get("/Annots", [])] for p in reader.pages]
    if annotations(a) != annotations(b):
        errors.append("annotations")
    if render:
        for name, path in (("before", a), ("after", b)):
            subprocess.run(["pdftoppm", "-r", "144", "-png", str(path),
                            str(output/name)], check=True, capture_output=True)
    for p in sorted(output.glob("before-*.png")):
        q = output / p.name.replace("before-", "after-", 1)
        with Image.open(p) as x, Image.open(q) as y:
            if x.size != y.size or ImageChops.difference(x.convert("RGB"), y.convert("RGB")).getbbox():
                errors.append(p.name+" pixels")
    return {"equal": not errors, "errors": errors[:50], "error_count": len(errors)}

def watch(root, output):
    working = output/"watch-copy"
    shutil.copytree(root, working)
    source = working/"main.typ"
    original = source.read_text(encoding="utf-8-sig")
    pdf = output/"watch.pdf"
    # Append a controlled, separate probe; no live authored files are edited.
    probe = '\n#pagebreak()\n#text(size: 11pt)[Probe A]\n#ruby[신체][身體]\n$x+1$\n#place(bottom+right, dx: 0pt)[Probe]\n'
    source.write_text(original+probe, encoding="utf-8")
    log = (output/"watch.log").open("w", encoding="utf-8")
    p = subprocess.Popen(["typst","watch","--root",str(working),str(source),str(pdf)],
                         stdout=log, stderr=log)
    def wait(stamp):
        start=time.perf_counter()
        while time.perf_counter()-start < 120:
            if p.poll() is not None:
                raise RuntimeError("watch exited; see watch.log")
            if pdf.exists() and pdf.stat().st_mtime_ns != stamp:
                last=pdf.stat()
                time.sleep(.15)
                if last.st_mtime_ns == pdf.stat().st_mtime_ns and last.st_size == pdf.stat().st_size:
                    return time.perf_counter()-start
            time.sleep(.02)
        raise TimeoutError("watch output timeout")
    result={}
    try:
        wait(None)
        edits={
            "prose": ("Probe A","Probe B"),
            "ruby_math": ("$x+1$","$x+2$"),
            "font": ("size: 11pt","size: 12pt"),
            "position": ("dx: 0pt","dx: 1pt"),
        }
        for name,(old,new) in edits.items():
            samples=[]
            for index in range(6):
                # Let the watcher finish its output-event debounce before
                # another edit; this delay is outside the timed interval.
                time.sleep(1)
                # Use fresh values, not undo/redo cache hits. Discard the
                # first edit as a warm-up for this edit category.
                replacement={
                    "prose": f"Probe B{index}",
                    "ruby_math": f"$x+{index+2}$",
                    "font": f"size: {12+index/10}pt",
                    "position": f"dx: {index+1}pt",
                }[name]
                value=probe.replace(old,replacement)
                stamp=pdf.stat().st_mtime_ns
                source.write_text(original+value, encoding="utf-8")
                elapsed=wait(stamp)
                if index:
                    samples.append(elapsed)
            result[name]={"samples":samples,"median":statistics.median(samples)}
            print("watch",name,result[name],flush=True)
    finally:
        p.terminate()
        try: p.wait(timeout=5)
        except subprocess.TimeoutExpired: p.kill(); p.wait()
        log.close()
    return result

def main():
    parser=argparse.ArgumentParser()
    parser.add_argument("baseline",type=pathlib.Path)
    parser.add_argument("candidate",type=pathlib.Path)
    parser.add_argument("output",type=pathlib.Path)
    parser.add_argument("--watch",action="store_true")
    args=parser.parse_args()
    args.output.mkdir(parents=True,exist_ok=False)
    report={"version":subprocess.check_output(["typst","--version"],text=True,encoding="utf-8"),
            "commit":subprocess.check_output(["git","rev-parse","HEAD"],text=True,encoding="utf-8"),
            "fonts":subprocess.check_output(["typst","fonts"],text=True,encoding="utf-8"),
            "roots":{}, "runs":{"baseline":[],"candidate":[]}}
    roots={"baseline":args.baseline.resolve(),"candidate":args.candidate.resolve()}
    for name,root in roots.items():
        report["roots"][name]={"path":str(root),"hashes":{
            str(p.relative_to(root)):digest(p) for p in sorted(root.rglob("*")) if p.is_file()}}
        report[name+"_warmup"]=run(root,args.output/(name+".pdf"))
    for i in range(5):
        for name in (("baseline","candidate") if i%2==0 else ("candidate","baseline")):
            sample=run(roots[name],args.output/(name+".pdf"))
            report["runs"][name].append(sample)
            (args.output/"results.json").write_text(json.dumps(report,indent=2),encoding="utf-8")
            print(name,i,sample,flush=True)
    report["medians"]={name:statistics.median(r["seconds"] for r in runs)
                       for name,runs in report["runs"].items()}
    if all(r["code"]==0 for runs in report["runs"].values() for r in runs):
        report["comparison"]=compare(args.output/"baseline.pdf",args.output/"candidate.pdf",args.output)
    (args.output/"results.json").write_text(json.dumps(report,indent=2),encoding="utf-8")
    if args.watch:
        report["watch"]={}
        for name,root in roots.items():
            out=args.output/name
            out.mkdir()
            report["watch"][name]=watch(root,out)
    (args.output/"results.json").write_text(json.dumps(report,indent=2),encoding="utf-8")
    print(json.dumps({k:v for k,v in report.items() if k in ("medians","comparison","watch")}),flush=True)

if __name__=="__main__":
    main()
