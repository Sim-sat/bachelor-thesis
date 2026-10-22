import csv
import json
import sys
from typing import Literal

import anthropic
from dotenv import load_dotenv
from pydantic import BaseModel

load_dotenv()

MODEL = "claude-haiku-5-5"

PROMPT = """Extract all events from the news article below.

An event is a concrete happening that the article reports as having occurred or as firmly planned, with a known point or period in time.
- Not events: speculation ("is expected to", "likely", "may"), states, opinions, evaluations, statistics.
- Statements are not events. If a statement reports a happening, that happening is the event.
- Happenings with different main actors are separate events.
- A sub-happening with its own place or its own consequences is a separate event.
- Skip happenings whose time cannot be determined from the article (e.g. only the date of the report is given). Skip planned happenings without a date or period.

For each event give:
- description: one English sentence
- date: YYYY-MM-DD, the point in time or the start of the period; resolve relative dates ("on Tuesday") using the publication date; use 01 for unknown day or month
- date_precision: day, month or year
- status: occurred or planned

Published: {published}
Headline: {headline}

{body}"""


class Event(BaseModel):
    description: str
    date: str
    date_precision: Literal["day", "month", "year"]
    status: Literal["occurred", "planned"]


class Events(BaseModel):
    events: list[Event]


client = anthropic.Anthropic()  # Reads ANTHROPIC_API_KEY.
out = csv.writer(sys.stdout)
out.writerow(["article_id", "description", "date", "date_precision", "status"])

lines = open(sys.argv[1], encoding="utf-8").readlines()
for n in sys.argv[2:]:  # Zeilennummern im Korpus, ab 1
    a = json.loads(lines[int(n) - 1])
    r = client.messages.parse(
        model=MODEL,
        max_tokens=16000,
        messages=[{"role": "user", "content": PROMPT.format(**a)}],
        output_format=Events,
    )
    for e in r.parsed_output.events:
        out.writerow([a["id"], e.description, e.date, e.date_precision, e.status])
    print(f"Zeile {n}: {r.usage.input_tokens} in, {r.usage.output_tokens} out", file=sys.stderr)
