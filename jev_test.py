from typesafe_sdk import Score, TypeSafeClient
from dotenv import load_dotenv

load_dotenv()

# Test 2: breiteres Spektrum, Beschreibungen nur aus den Überschriften des Korpus
events = [
    "A rat is discovered in Alberta, ending the province's status as the world's only rat-free region.",
    "Tokyo records 35 consecutive days of rain.",
    "Police use teargas on protesters as an 87-year-old disabled woman is evicted from her Madrid home.",
    "A former French culture minister goes on trial over corruption charges.",
    "Fiji declares a national HIV emergency.",
    "Swiss voters reject stricter neutrality rules that would have curbed Nato cooperation.",
    "Friedrich Merz's CDU suffers heavy losses as the far-right AfD wins a German state election.",
    "South Korea demands an apology from North Korea after a mine injures three soldiers.",
    "Canada's retaliatory tariffs on US goods take effect.",
    "The EU moves closer to a social media ban for children under 13.",
    "Russia strikes the headquarters of Ukraine's intelligence service.",
    "Iran attacks 10 ships near the strait of Hormuz after US strikes.",
    "Xi Jinping and Donald Trump hold a summit in the US.",
    "Sam Altman and Dario Amodei address the UN security council.",
]

importance = Score(
    instructions="Global significance of this news event",
    criteria=[
        "Local: relevant only to a city or region",
        "National: relevant to one country",
        "Regional: affects several countries",
        "International: consequences for many countries or major power blocs",
        "Global: worldwide consequences, historic significance",
    ],
)

with TypeSafeClient(model="jev-latest") as client:  # Reads TYPESAFE_API_KEY.
    for event in events:
        r = client.system_one(state=event, questions={"importance": importance}).scores["importance"]
        print(f"{r.score:.2f}  conf={r.confidence}  {event}")
        print("     ", r.probabilities)
