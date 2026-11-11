#import "../template.typ": *

= Evaluation <evaluation>


== Referenzannotation

Um die Ereignisextraktion des #acr("LLM")s zu beurteilen ist es notwendig eine Vergleichsgrundlage zu haben. Es gibt keinen fertigen Datensatz mit der in dieser Arbeit benutzen Definition, daher wurde selber eine Referenzannotation erstellt. Es wurden 50 zufällig ausgewählte Artikel manuell annotiert. Dabei wurde dasselbe Format verwendet, wie es auch von dem #acr("LLM") verwendet wird @tab:schema-beispiel. Als Grundlage für die Annotation wurde die Definition aus @sec:definition genutzt mit einer Richtlinie, die um Grenzfälle ergänzt wurde. Der Aufwand war ca. 15 Minuten Pro Artikel. Insgesamt sind so 280 Ereignisse zusammen gekommen, im Schnitt 5,6 Ereignisse pro Artikel. 38 Ereignisse (14%) waren zum Zeitpunkt der Publikation geplant. Bei 10 der 50 Artikel entfällt die Hauptnachricht, da nur das Datum der Meldung und nicht das des Ereignisses selber bekannt ist @sec:definition.

#figure(
  table(
    columns: 4,
    align: (left, right, right, right),
    table.header([*Präzision*], [*vor 2026*], [*ab 2026*], [*gesamt*]),
    [`day`], [3], [84], [87],
    [`month`], [17], [68], [85],
    [`year`], [84], [24], [108],
    [*gesamt*], [104], [176], [280],
  ),
  caption: [Ereignisse der Referenzannotation nach Datumspräzision und Zeitraum],
) <tab:referenz>

Da nur eine Person annotiert hat, kann es trotz sorgfältiger Überlegung zu Unstimmigkeiten kommen. Um dem entgegen zu wirken, wurden zehn Artikel nach vier Wochen erneut annotiert und mit der ersten Fassung verglichen.

== Vorgehen der Bewertung

Es werden alle von dem #acr("LLM") extrahierten Ereignisse eines Artikels mit den Ereignissen der Referenzannotation verglichen. Die Ereignisse stimmen überein, wenn dasselbe Ereignis mit demselben Zeitstempel beschrieben wurde. Da das Feld `description` ein Freitextfeld ist, sind unterschiedliche Formulierungen nicht vermeidbar und erlaubt. Deshalb ist eine manuelle Überprüfung der Ereignisse notwendig. Bei gefundenen Paaren können die Attribute `date`, `date_precision` und `status` maschinell geprüft werden. Damit wird überprüft, wie gut das Modell die relativen Zeitangaben auflösen kann. Es werden drei Metriken verwendet:
- Precision: Anteil der Ereignisse, die korrekt gefunden wurden
- Recall: Wie viel der Referenzannotation wurde gefunden?
- F1: Zusammenfassung von Precision und Recall

== Bewertung der Gruppierung

Die Referenzannotation wurde manuell gruppiert. Wie bei der Extraktion wird sich manuell mit der Ausgabe verglichen.

== Bewertung der Gewichtung

Die Website#footnote[#link("https://en.wikipedia.org/wiki/Portal:Current_events/September_2026")] _Current_events_ auf Wikipedia ist eine händisch getroffene Auswahl and wichtigen Ereignissen pro Tag. Sie ist keine echte Referenz, dient aber als unabhängiger Vergleich. Verglichen wird, wie viele der als international oder global wichtig eingestuften Ereignisgruppen dort auftauchen. // wird noch geändert

== Ergebnisse Extraktion

== Ergebnisse Gruppierung/Gewichtung
