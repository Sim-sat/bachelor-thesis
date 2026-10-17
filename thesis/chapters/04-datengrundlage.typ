#import "../template.typ": *

= Datengrundlage <datengrundlage>

== Auswahl des Korpus

Die kostenlose API des Guardian hat sich als geeigneter Korpus angeboten, da die Artikel aktuell sind und über alle notwendigen Attribute verfügen.


== Abruf und Umfang

Es wurden insgesamt 475 Artikel aus der Rubik _World_ abgerufen. Dabei wurde sich beschränkt auf den gesamten Semptember 2026. Die API Antwort wurde mithilfe eines Python Skripts in einer JSONL Datei gespeichert. JSONL bietet in diesem Fall den Vorteil, dass es gestreamt werden kann, was bei der Datenmenge deutlich Performance-Vorteile ergibt. Mithilfe des Parameters ` "show-tags": "tone,series"` werden die Typen der Artikel aufgelistet, die dann mit @lst:laden zusammengefasst werden können. Die Verteilung der Artikeltypen zeigt @tab:artikeltypen.

== Vorbereitung

Da die API viele Felder mitliefert, die nicht notwendig sind, wurden die überflüssigen Felder mithilfe eines Python-Skripts entfernt. In der Sichtung der Daten sind einige Unstimmigkeiten aufgefallen:
+ Einige Inhalte enthalten Breitenlose Leerzeichen (U+200B–U+200D, U+2060 und U+FEFF)
+ Teilweise beinhalten sie Korrekturhinweise
Es wurde sich bewusst gegen die Bereinigung dieser Probleme entschieden, um die Robustheit gegenüber realen Texten zu prüfen.



#figure(
  ```bash
  jq -r '
    [.tags[] | select(.type=="tone") | .id | sub("^tone/"; "")] as $t
    | ["newsletter-tone","letters","callout","obituaries","analysis","explainers","features","profiles","interview","news"]
    | map(select(. as $p | $t | index($p))) | .[0] // "keiner"
  ' guardian_world_2026-09.jsonl | sort | uniq -c | sort -rn
  ```,
  caption: [Übersicht der Artikel Typen],
) <lst:laden>



#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, right, right),
    table.header([*Artikeltyp*], [*Anzahl*], [*Anteil*]),
    [News], [283], [59,6 %],
    [Features], [71], [14,9 %],
    [Explainers], [36], [7,6 %],
    [Newsletter], [27], [5,7 %],
    [Analysis], [20], [4,2 %],
    [Ohne Tag], [14], [2,9 %],
    [Letters], [13], [2,7 %],
    [Obituaries], [5], [1,1 %],
    [Callout], [3], [0,6 %],
    [Profiles], [2], [0,4 %],
    [Interview], [1], [0,2 %],
    table.hline(),
    [*Gesamt*], [*475*], [*100 %*],
  ),
  caption: [Zusammensetzung des Korpus nach Artikeltyp (Guardian-Tone-Tags, Hauptkategorie nach Priorität)],
) <tab:artikeltypen>

