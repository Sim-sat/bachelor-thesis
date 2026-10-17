import json
import os
import urllib.parse
import urllib.request
from dotenv import load_dotenv

load_dotenv()
params = {
    "section": "world",
    "type": "article",
    "tag": "-tone/comment",
    "show-tags": "tone,series",
    "from-date": "2026-09-01",
    "to-date": "2026-09-30",
    "order-by": "oldest",
    "show-fields": "headline,trailText,bodyText,wordcount",
    "page-size": 200,
    "api-key": os.environ["GUARDIAN_API_KEY"],
}

page, pages = 1, 1
while page <= pages:
    url = "https://content.guardianapis.com/search?" + urllib.parse.urlencode(
        {**params, "page": page}
    )
    resp = json.load(urllib.request.urlopen(url))["response"]
    pages = resp["pages"]
    for article in resp["results"]:
        print(json.dumps(article, ensure_ascii=False))
    page += 1
