import csv
import sys

from sentence_transformers import SentenceTransformer

# Stellt je Artikel Referenz- (R) und LLM-Ereignisse (L) nach Datum sortiert untereinander
# und ordnet jedem L-Ereignis automatisch höchstens ein R-Ereignis zu (Spalte "match").
# Zuordnung: Kosinus-Ähnlichkeit der descriptions, gierig 1:1 innerhalb eines Artikels,
# nur oberhalb von THRESHOLD. Das Datum zählt bewusst nicht, es wird getrennt ausgewertet.
MODEL = "all-mpnet-base-v2"
THRESHOLD = 0.6

run = sys.argv[1]
events = {"R": [], "L": []}
for src, path in (("R", "ref/annotation.csv"), ("L", f"{run}/events.csv")):
    count = {}
    for e in csv.DictReader(open(path, encoding="utf-8")):
        count[e["line"]] = count.get(e["line"], 0) + 1
        events[src].append({**e, "id": f"{src}{count[e['line']]}", "match": "", "sim": ""})

model = SentenceTransformer(MODEL)
for src in events:
    emb = model.encode([e["description"] for e in events[src]], normalize_embeddings=True)
    for e, v in zip(events[src], emb):
        e["emb"] = v

for line in {e["line"] for e in events["R"] + events["L"]}:
    ls = [e for e in events["L"] if e["line"] == line]
    rs = [e for e in events["R"] if e["line"] == line]
    pairs = sorted(((float(l["emb"] @ r["emb"]), l, r) for l in ls for r in rs),
                   key=lambda p: p[0], reverse=True)
    used = set()
    for sim, l, r in pairs:
        if sim < THRESHOLD:
            break
        if l["match"] or r["id"] in used:
            continue
        l["match"], l["sim"], r["sim"] = r["id"], f"{sim:.2f}", f"{sim:.2f}"
        used.add(r["id"])

# Manuelle Korrekturen des Laufs (line,id,match; leeres match = kein Gegenstück)
try:
    for k in csv.DictReader(open(f"{run}/korrekturen.csv", encoding="utf-8")):
        l = next(e for e in events["L"] if e["line"] == k["line"] and e["id"] == k["id"])
        for other in events["L"]:  # R-Ereignis höchstens einmal vergeben
            if k["match"] and other["line"] == k["line"] and other["match"] == k["match"]:
                other["match"] = ""
        l["match"], l["sim"] = k["match"], "manuell"
except FileNotFoundError:
    pass

pairs = [(l, next(r for r in events["R"] if r["line"] == l["line"] and r["id"] == l["match"]))
         for l in events["L"] if l["match"]]
p, rc = len(pairs) / len(events["L"]), len(pairs) / len(events["R"])
print(f"L {len(events['L'])}  R {len(events['R'])}  Paare {len(pairs)}")
print(f"Precision {p:.3f}  Recall {rc:.3f}  F1 {2 * p * rc / (p + rc):.3f}")
for k in ("date", "date_precision", "status"):
    print(f"{k} korrekt: {sum(l[k] == r[k] for l, r in pairs) / len(pairs):.3f}")

rows = sorted(events["R"] + events["L"], key=lambda e: (int(e["line"]), e["date"], e["id"][0]))
with open(f"{run}/matching.csv", "w", newline="", encoding="utf-8") as f:
    out = csv.writer(f)
    out.writerow(["line", "id", "date", "date_precision", "status", "description", "match", "sim"])
    for e in rows:
        out.writerow([e[k] for k in ("line", "id", "date", "date_precision", "status", "description", "match", "sim")])
