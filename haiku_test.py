import anthropic
from dotenv import load_dotenv
from pydantic import BaseModel

load_dotenv()
client = anthropic.Anthropic()

events = [
    "A rat is discovered in Alberta, ending the province's status as the world's only rat-free region.",
    "Russia strikes the headquarters of Ukraine's intelligence service.",
    "Iran attacks 10 ships near the strait of Hormuz after US strikes.",
]

PROMPT = """Rate the global significance of this news event as a number from 0 to 4. Decimals are allowed.
0 = Local: relevant only to a city or region
1 = National: relevant to one country
2 = Regional: affects several countries
3 = International: consequences for many countries or major power blocs
4 = Global: worldwide consequences, historic significance

Event: {}"""


class Rating(BaseModel):
    score: float


for event in events:
    output = f"{event}:"
    for _ in range(10):
        r = client.messages.parse(
            model="claude-haiku-5-5",
            max_tokens=2000,
            messages=[{"role": "user", "content": PROMPT.format(event)}],
            output_format=Rating,
        )
        output += f" {r.parsed_output.score:.2f},"
    print(output, flush=True)
