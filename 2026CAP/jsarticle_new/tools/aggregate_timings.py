import collections
import json
import sys


def events(path):
    delimiter = b'},\x7b"name":'
    pending = b""
    first = True
    with open(path, "rb") as source:
        while chunk := source.read(8 * 1024 * 1024):
            parts = (pending + chunk).split(delimiter)
            pending = parts.pop()
            for part in parts:
                if first:
                    raw = part.lstrip(b"[") + b"}"
                    first = False
                else:
                    raw = b'\x7b"name":' + part + b"}"
                yield json.loads(raw)
    if pending:
        if first:
            raw = pending.lstrip(b"[").rstrip(b"]")
        else:
            raw = b'\x7b"name":' + pending.rstrip(b"]")
        if raw:
            yield json.loads(raw)


def main(path):
    stacks = collections.defaultdict(list)
    inclusive = collections.defaultdict(float)
    exclusive = collections.defaultdict(float)
    counts = collections.Counter()

    for event in events(path):
        phase = event.get("ph")
        thread = (event.get("pid"), event.get("tid"))
        if phase == "B":
            args = event.get("args") or {}
            key = (
                event.get("name", ""),
                args.get("file", ""),
                args.get("line", 0),
            )
            stacks[thread].append([key, float(event.get("ts", 0)), 0.0])
        elif phase == "E" and stacks[thread]:
            key, start, child = stacks[thread].pop()
            duration = float(event.get("ts", 0)) - start
            inclusive[key] += duration
            exclusive[key] += max(0.0, duration - child)
            counts[key] += 1
            if stacks[thread]:
                stacks[thread][-1][2] += duration

    rows = sorted(inclusive, key=lambda key: exclusive[key], reverse=True)
    print("exclusive_ms\tinclusive_ms\tcount\tname\tfile:line")
    for key in rows[:80]:
        name, file, line = key
        print(
            f"{exclusive[key] / 1000:.3f}\t{inclusive[key] / 1000:.3f}\t"
            f"{counts[key]}\t{name}\t{file}:{line}"
        )


if __name__ == "__main__":
    main(sys.argv[1])
