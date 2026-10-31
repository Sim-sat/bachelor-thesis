import json
import random
import sys

SEED = 2026
N = 80
EXCLUDE = {9, 16}  # Pilotartikel, später Few-Shot-Beispiele

lines = open(sys.argv[1], encoding="utf-8").readlines()
candidates = [n for n in range(1, len(lines) + 1) if n not in EXCLUDE]
for n in random.Random(SEED).sample(candidates, N):  # Reihenfolge = Annotationsreihenfolge
    a = json.loads(lines[n - 1])
    print(n, a["published"][:10], a["headline"], sep="\t")
