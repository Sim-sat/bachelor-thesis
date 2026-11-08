from typesafe_sdk import Score, TypeSafeClient
from dotenv import load_dotenv

load_dotenv()

# Test 2: breiteres Spektrum, Beschreibungen nur aus den Überschriften des Korpus
events = [
    "A rat is discovered in Alberta, ending the province's status as the world's only rat-free region.",
    "Russia strikes the headquarters of Ukraine's intelligence service.",
    "Iran attacks 10 ships near the strait of Hormuz after US strikes.",
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
        output = f"{event}:"
        for _ in range(3):
            r = client.system_one(
                state=event, questions={"importance": importance}
            ).scores["importance"]
            output += f" {r.score:.2f} confidence={r.confidence},"
        print(output)
