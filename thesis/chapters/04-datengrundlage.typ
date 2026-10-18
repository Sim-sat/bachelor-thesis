#import "../template.typ": *

= Datengrundlage <datengrundlage>

== Auswahl des Korpus

Die über die kostenlose #acr("API") abrufbaren Artikel des Guardian @GuardianAPI bieten sich als Korpus an, da die Artikel aktuell sind und über alle notwendigen Attribute verfügen, darunter Titel, Volltext, Tags und Zeitstempel. Zusätzlich werden die Artikeltexte ohne HTML, Navigation und Werbung zurückgegeben und besitzen redaktionell gepflegte Metadaten.


== Abruf und Umfang

Die Rubrik _World_ umfasst insgesamt rund 237.000 Artikel#footnote[Feld `total` der Antwort auf `/search?section=world&type=article`, abgerufen am 18.10.2026.], weshalb der Zeitraum auf September 2026 beschränkt wurde. Außerdem sollte so die Chance auf Artikel erhöht werden, die über dieselben Ereignisse schreiben, um die Gruppierung der Ereignisse zu untersuchen. Die #acr("API")-Antwort wurde mithilfe eines Python-Skripts in einer #acr("JSONL")-Datei gespeichert. #acr("JSONL") bietet in diesem Fall den Vorteil, dass jede Zeile ein Artikel ist und die Datei Zeile für Zeile verarbeitet und erweitert werden kann. Mithilfe des Parameters `show-tags=tone,series` werden die Typen der Artikel aufgelistet, die dann zusammengefasst werden können (siehe Anhang, @lst:laden). Die Verteilung der Artikeltypen zeigt @tab:artikeltypen. Für Artikel, die mehrere Typen haben (immer _news_ und ein weiterer), wurde der spezifischere gewählt. Zusätzlich wurden Meinungsbeiträge (`tone/comment`) über die #acr("API") ausgeschlossen. Das betraf im gewählten Zeitraum nur einen Artikel.

== Vorbereitung

Da die #acr("API") viele Felder mitliefert, die nicht notwendig sind, wurden die überflüssigen Felder mithilfe eines Python-Skripts entfernt. Übrig bleiben die Felder `id`, `published`, `headline` und `body`.

Bei der Sichtung der Daten zeigten sich einige Auffälligkeiten:
- 121 Artikel enthalten breitenlose Zeichen in Überschrift oder Fließtext (insgesamt 925, siehe @lst:zero-width)
- 23 Artikel enthalten Korrekturhinweise der Redaktion, z. B. „This article was amended on …“ (siehe @lst:korrekturen)

Auf eine Bereinigung wurde bewusst verzichtet, um die Robustheit gegenüber realen Texten zu prüfen.

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

