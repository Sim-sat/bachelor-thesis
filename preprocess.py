import json
import sys

for line in open(sys.argv[1], encoding="utf-8"):
    a = json.loads(line)
    print(json.dumps({
        "id": a["id"],
        "published": a["webPublicationDate"],
        "headline": a["fields"]["headline"],
        "body": a["fields"]["bodyText"],
    }, ensure_ascii=False))
