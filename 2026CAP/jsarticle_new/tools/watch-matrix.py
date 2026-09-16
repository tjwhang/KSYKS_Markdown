"""Fresh-edit benchmark on existing immutable snapshots; serial, reversed project order."""
import json,pathlib,runpy,sys
m=runpy.run_path(str(pathlib.Path(__file__).with_name("parity-benchmark.py")))
root=pathlib.Path(sys.argv[1])
results={}
for project,order in (("jsarticle_new",("baseline","candidate")),("수능수학",("candidate","baseline"))):
    results[project]={}
    for variant in order:
        source=root/(project if variant=="baseline" else project+"-candidate")
        output=root/("fresh-watch-"+project+"-"+variant)
        output.mkdir()
        print(project,variant,flush=True)
        try: results[project][variant]=m["watch"](source,output)
        except Exception as e: results[project][variant]={"error":str(e)}
        (root/"fresh-watch-results.json").write_text(json.dumps(results,indent=2),encoding="utf-8")
print(json.dumps(results),flush=True)
