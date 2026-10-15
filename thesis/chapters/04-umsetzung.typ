#import "../template.typ": *

= Umsetzung <umsetzung>

// Architektur der Pipeline, Vorverarbeitung, API-Aufrufe, Gruppierung, Speicherung.

== Vorverarbeitung

Text … Beispiel für einen Quelltext (@lst:laden):

#figure(
  ```python
  from datasets import load_dataset

  ds = load_dataset("vblagoje/cc_news", split="train")
  per_day = ds.to_pandas()["date"].str[:10].value_counts()
  ```,
  caption: [Laden des Korpus],
) <lst:laden>

== Gruppierung gleicher Ereignisse

Beispiel für Pseudocode (@alg:gruppierung):

#algorithm(caption: [Gruppierung von Ereignissen])[
  *Input:* Ereignisse $E$, Schwellwert $tau$ \
  *Output:* Gruppen $G$ \
  1. $G <- emptyset$ \
  2. *für* $e in E$ *:* \
  #h(1.5em) 3. ordne $e$ der ähnlichsten Gruppe zu, falls Ähnlichkeit $>= tau$, sonst neue Gruppe \
  4. *return* $G$
] <alg:gruppierung>
