#import "../template.typ": *

= Konzept <konzept>


== Ereignisdefinition

Ein Ereignis ist ein konkretes Geschehnis, das im Artikel explizit als stattgefunden oder als fest geplant berichtet wird. Als fest geplant gelten Ereignisse mit konkretem Termin oder offizieller Ankündigung. Sie werden mit dem Attribut _Status_ gesondert gekennzeichnet. Einem Ereignis ist zwingend ein Zeitpunkt oder Zeitraum zugeordnet, wobei die Präzision variieren kann (z. B. Tag, Monat, Jahr). Allerdings muss die Zeitangabe im Artikel selbst stehen, da nicht das Allgemeinwissen des #acr("LLM") geprüft werden soll.  Spekulative oder hypothetische Geschehnisse („is expected to“, „likely“, „may“) gelten nicht als Ereignis. Ebenfalls ausgeschlossen sind Zustände, Meinungen und Bewertungen sowie statistische Angaben. Aussagen sind selbst keine Ereignisse. Gibt eine Aussage jedoch ein Geschehnis wieder, wird dieses als Ereignis erfasst. Maßgeblich ist allein die Darstellung im Artikel: Der Wahrheitsgehalt der berichteten Ereignisse wird nicht überprüft, da dies den Rahmen der Arbeit überschreiten würde. Ereignisse mit unterschiedlichen Hauptakteuren werden als getrennte Ereignisse betrachtet, auch wenn sie kausal zusammenhängen und/oder zeitgleich eintreten (z.~B. König Harald stirbt, Haakon wird König). Jedes Ereignis wird berichtet mit folgenden Attributen: Beschreibung(ein Satz), Datum, Datumspräzision und Status.

== Ereignisschema

Text …

#figure(
  table(
    columns: (auto, auto, 1fr),
    align: (left, left, left),
    table.header([*Attribut*], [*Werte*], [*Bedeutung*]),
    [`description`], [Text (Englisch)], [Das Geschehnis in einem Satz],
    [`date`],
    [`JJJJ-MM-TT`],
    [Zeitpunkt bzw. Beginn des Zeitraums; nicht bekannte Teile werden mit der Präzision gekennzeichnet],

    [`date_precision`], [`day` | `month` | `year`], [Genauigkeit der Datumsangabe im Artikel],
    [`status`], [`occurred` | `planned`], [Stattgefunden oder fest geplant],
  ),
  caption: [Attribute eines Ereignisses],
) <tab:schema>

#figure(
  table(
    columns: (auto, 1fr),
    align: (left, left),
    table.header([*Attribut*], [*Wert*]),
    [`description`], [King Harald V of Norway dies in hospital.],
    [`date`], [`2026-08-28`],
    [`date_precision`], [`day`],
    [`status`], [`occurred`],
  ),
  caption: [Beispielereignis aus einem Artikel vom 01.09.2026 („died on Friday“)],
) <tab:schema-beispiel>

== Aufbau der Pipeline <sec:pipeline>

// - Überblick als Abbildung: Artikel → Extraktion (LLM) → Ereignisse → Gruppierung → Gewichtung → CSV/SQLite
// - Eingabe je Artikel: `published`, `headline`, `body` (kein Artikeltyp, damit er die Extraktion nicht beeinflusst)
// - `published` nötig, um relative Zeitangaben aufzulösen ("on Friday" → 2026-08-28)
// - Definition und Regeln A–C (Teilgeschehen, Datum der Meldung, geplant ohne Termin) explizit im Prompt

Text …

== Gruppierung <sec:gruppierung>

// - Ziel: dieselben Ereignisse aus verschiedenen Artikeln zusammenfassen (z. B. Tod Harald V in mehreren Artikeln)
// - Kandidaten: nur Ereignisse in einem gemeinsamen Zeitfenster vergleichen (Datum ± n Tage)
// - Ansätze laut Exposé: Embeddings + Ähnlichkeitsschwelle; LLM entscheidet paarweise; Kombination
//   (Embeddings schlagen Kandidatenpaare vor, LLM verifiziert)
// - Offen: welcher Ansatz bzw. Vergleich, Schwellwert, Umgang mit unterschiedlicher Datumspräzision
// - Ergebnis je Gruppe: einheitliche Beschreibung (Grundlage für die Gewichtung), Anzahl der Artikel

Text …

== Gewichtung <sec:gewichtung>

// - Gewichtung = weltweite Bedeutung eines Ereignisses, je Gruppe (nicht je Artikel, nicht im Extraktionsschema)
// - Drei Verfahren im Vergleich:
//   - Gruppengröße (Anzahl Artikel) als einfache Basis; spiegelt Schwerpunkte des Guardian wider
//   - Jev (System-One-Modell, Fragetyp Score) mit Rubrik in 5 Stufen: lokal, national, regional, international, global
//   - Claude mit derselben Rubrik
// - Eingabe: Beschreibung der Gruppe, nicht der Artikeltext (Bedeutung hängt am Ereignis, nicht am Artikel)
// - Score = Erwartungswert über die Stufen 0–4 → kontinuierlich, zum Sortieren geeignet
// - 5 statt 10 Stufen: jede Stufe muss eindeutig beschreibbar sein
// - Vortest (14 Ereignisse, 19.10.): Jev nahezu deterministisch (±0,03), aber formulierungsabhängig
//   ("Russia attacks Kyiv, 12 killed" 3,58 vs. "Massive Russian bombardment of Kyiv kills at least 12" 3,38)
//   → einheitliche Gruppenbeschreibung; Rangkorrelation mit Claude 0,91
// - Referenz für die Evaluation: Wikipedia-Portal "Current events", September 2026

Text …

== Varianten <sec:varianten>

// - Extraktion: Modellwahl, Einstellungen (Reasoning), Prompt; optional Freitext vs. JSON-Schema
// - Gruppierung: Embeddings vs. LLM vs. Kombination
// - Gewichtung: Gruppengröße vs. Jev vs. Claude
// - Alle Extraktionsvarianten werden gegen dieselbe Referenzannotation ausgewertet
// - Offen: konkrete Modelle und Prompt-Varianten festlegen (nach Prototyp)

Text …
