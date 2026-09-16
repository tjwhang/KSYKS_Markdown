"""Run the same fixtures against frozen before/after engines, recording existing failures."""
import argparse,json,pathlib,shutil,subprocess
p=argparse.ArgumentParser()
for key in ("baseline","candidate","tests","output"): p.add_argument(key,type=pathlib.Path)
a=p.parse_args()
a.output.mkdir(parents=True,exist_ok=False)
results={}
expected={"v2-invalid-options":"options.page.colz","v2-invalid-basho":"config.layout.colums"}
for name,source in (("baseline",a.baseline),("candidate",a.candidate)):
    root=a.output/name
    shutil.copytree(source,root)
    shutil.copytree(a.tests,root/"tests",dirs_exist_ok=True)
    results[name]={}
    for test in sorted((root/"tests").glob("*.typ")):
        try:
            r=subprocess.run(["typst","compile","--root",str(root),str(test),
                str(root/(test.stem+".pdf"))],capture_output=True,text=True,encoding="utf-8",timeout=120)
            ok=(r.returncode!=0 and expected[test.stem] in r.stderr) if test.stem in expected else r.returncode==0
            results[name][test.stem]={"pass":ok,"code":r.returncode,"diagnostic":r.stderr}
        except subprocess.TimeoutExpired:
            results[name][test.stem]={"pass":False,"timeout":True}
        print(name,test.stem,results[name][test.stem]["pass"],flush=True)
    (a.output/"results.json").write_text(json.dumps(results,indent=2),encoding="utf-8")
regressions=[k for k,v in results["candidate"].items() if not v["pass"] and results["baseline"][k]["pass"]]
print(json.dumps({"new_failures":regressions,"baseline_failures":[k for k,v in results["baseline"].items() if not v["pass"]]}))
raise SystemExit(bool(regressions))
