import csv
import datetime
import importlib.metadata
import json
import pathlib
import sys
from typing import Literal

import anthropic
from dotenv import load_dotenv
from pydantic import BaseModel

load_dotenv()

MODEL = "claude-haiku-5-5"

PROMPT = """Extract all events from the news article below.

An event is a concrete happening that the article explicitly reports as having occurred or as firmly planned. Judge only by what the article says. Historical happenings count if the article dates them, even if they are mentioned only in passing.

Time:
- The article itself must give a point or period in time for the happening. Do not use outside knowledge.
- The time must belong to the happening itself. If only the date of a statement about it or the publication date is known, skip the happening.
- A time reference carries over to the following sentences as long as they clearly describe the same episode.
- If the time is uncertain, keep only the part that is certain. If not even the year is certain, skip the happening.

Not events:
- Speculation, forecasts, hypothetical or negated happenings, and intentions without a reported realisation.
- Planned happenings without a fixed date. Something "expected" on a fixed date counts as planned.
- States, ongoing processes and developments, opinions, evaluations, statistics and trends.
- Statements, interviews, speeches, press conferences, social media posts, criticism, and newspaper or magazine pieces. If a statement reports a happening, extract that happening.

These count as events: meetings, summits, phone calls, negotiations and visits, as well as invitations, applications, court rulings, resignations, official notifications and the publication of a report, study or book. For an announcement, extract the announced happening with its date, not the announcement.

One or several events:
- Extract each happening only once per article, using the most specific time given.
- Steps of a happening at the same time and place by the same actors, its direct effects and its details belong to that happening.
- Happenings with different main actors are separate events, even if they are causally linked or simultaneous.
- Several similar happenings that the article names individually are separate events. If they are only counted, extract one event.
- A single happening that affects several places is one event.

For each event give:
- description: one English sentence in the present tense, saying who did what and where if known
- date: YYYY-MM-DD, the point in time or the start of the period; resolve relative dates ("on Tuesday") using the publication date; use 01 for unknown day or month
- date_precision: day if the exact day is known, month for a month or a vague period such as "last week", year for a year or a season
- status: occurred, or planned if the happening lies after the publication date

Published: {published}
Headline: {headline}

{body}"""


class Event(BaseModel):
    description: str
    date: datetime.date
    date_precision: Literal["day", "month", "year"]
    status: Literal["occurred", "planned"]


class Events(BaseModel):
    events: list[Event]


EFFORT = "medium"
RUN = pathlib.Path("runs") / f"{datetime.date.today()}_haiku_{EFFORT}"
RUN.mkdir(parents=True, exist_ok=True)
(RUN / "meta.json").write_text(json.dumps(
    {"model": MODEL, "effort": EFFORT, "sdk": importlib.metadata.version("anthropic"), "prompt": PROMPT}, indent=2))

client = anthropic.Anthropic()  # Reads ANTHROPIC_API_KEY.
lines = open(sys.argv[1], encoding="utf-8").readlines()
todo = [l.split()[0] for l in open("ref/annotated.txt") if l.strip()]  # "B" = Überschrift ohne Ereignis

with open(RUN / "raw.jsonl", "w") as raw, open(RUN / "events.csv", "w", newline="") as f:
    out = csv.writer(f)
    out.writerow(["line", "article_id", "description", "date", "date_precision", "status"])
    for n in todo:
        a = json.loads(lines[int(n) - 1])
        r = client.messages.parse(
            model=MODEL,
            max_tokens=16000,
            output_config={"effort": EFFORT},
            messages=[{"role": "user", "content": PROMPT.format(**a)}],
            output_format=Events,
        )
        raw.write(json.dumps({"line": n, "response": r.to_dict()}, default=str) + "\n")
        if r.parsed_output is None:
            print(f"Zeile {n}: stop_reason={r.stop_reason}, übersprungen", file=sys.stderr)
            continue
        for e in r.parsed_output.events:
            out.writerow([n, a["id"], e.description, e.date, e.date_precision, e.status])
        print(f"Zeile {n}: {len(r.parsed_output.events)} Ereignisse", file=sys.stderr)
