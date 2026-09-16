"""Read-only manifest/dependency and byte parity audit. Exit nonzero on drift."""
import hashlib, json, pathlib, re, sys
root=pathlib.Path(__file__).resolve().parents[1]
target=pathlib.Path(sys.argv[1]).resolve() if len(sys.argv)>1 else root.parent/"수능수학"
files=json.loads((root/"engine-files.json").read_text(encoding="utf-8-sig"))["files"]
errors=[]
known=set(files)
local={"engine-local.typ"}
for rel in files:
    a,b=root/rel,target/rel
    if not a.is_file() or not b.is_file():
        errors.append("missing: "+rel)
        continue
    if a.read_bytes()!=b.read_bytes():
        errors.append("drift: "+rel)
    if a.suffix==".typ":
        for ref in re.findall(r'#(?:import|include)\s+"([^"]+)"',a.read_text(encoding="utf-8-sig")):
            if ref.startswith("@"): continue
            path=(a.parent/ref).resolve()
            try: dep=path.relative_to(root).as_posix()
            except ValueError:
                errors.append("outside root: "+rel+" -> "+ref); continue
            if dep not in known and dep not in local:
                errors.append("unregistered dependency: "+rel+" -> "+dep)
for folder in ("src","vendor"):
    for p in (root/folder).rglob("*.typ"):
        if p.relative_to(root).as_posix() not in known:
            errors.append("unregistered engine file: "+str(p.relative_to(root)))
for base in (root,target):
    if not (base/"engine-local.typ").is_file():
        errors.append("missing local profile: "+str(base))
lock=target/"engine-lock.json"
if lock.exists():
    data=json.loads(lock.read_text(encoding="utf-8-sig"))
    for rel in files:
        p=target/rel
        if p.exists() and data.get(rel,"").lower()!=hashlib.sha256(p.read_bytes()).hexdigest():
            errors.append("stale lock: "+rel)
print(json.dumps({"files":len(files),"errors":errors},ensure_ascii=False,indent=2))
sys.exit(bool(errors))
