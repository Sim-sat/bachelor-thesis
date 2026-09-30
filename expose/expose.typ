// Exposé zur Bachelorarbeit
// Kompilieren: typst compile expose.typ  (oder: typst watch expose.typ)

#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2.5cm),
  numbering: "1",
)
#set text(
  font: "Libertinus Serif",
  size: 11pt,
  lang: "de",
)
#set par(
  justify: true,
  leading: 0.65em,
)
#set heading(numbering: "1.1")

#show link: set text(fill: blue)
#show link: underline

// Titelblock
#align(center)[
  #text(size: 16pt, weight: "bold")[Exposé zur Bachelorarbeit]
  #v(0.5em)
  #text(size: 11pt)[
    Simon Sattelberger \
    Matrikelnummer: q7362730 \
    Bachelor Informatik\
    #datetime.today().display("[day].[month].[year]")
  ]
  #v(0.5em)
  #text(size: 11pt)[Betreuer: Prof. Dr.-Ing. habil. Dr. h.c. Herwig Unger]
]

#v(1.5em)

= Motivation und Problemstellung



= Forschungsfrage und Zielsetzung

Es soll untersucht werden inwiefern sich LLMs für das Bestimmen der wichtigsten Ereignise aus einem Nachrichten Textkorpus benutzen lassen.


= Geplantes Vorgehen

Einen Textkorpus (z.B. ccnews #footnote[#link("https://huggingface.co/datasets/sentence-transformers/ccnews/viewer/pair/train?p=2&row=216")]) soll verwendet werden als Eingabe. Aufgrund der Größe der meisten verfübaren Korpara macht es sinn diese auf eine kleine Anzahl wie 1000 Einträge zu reduzieren. Ein Python-Skript soll nun die API einer beliebigen LLM aufrufen, um die wichtigsten Ereignisse zu extrahieren. Zu jedem Ereignis soll ein Zeitstempel erstellt werden. Es muss beachtet werden, dass die Artikel teilweise später als das Ereignise veröffentlicht werden und somit der Zeitstempel der Artikel nicht immer übernommen werden kann. Außerdem muss untersucht werden, welche Modelle und Einstellungen (Reasoning o.ä) zu den besten Ergebnissen führen. Die Ausgabe geschieht entweder als CSV-Datei oder in einer Datenbank (z.B. sqlite). Die Ereignisse könnten außerdem in ihrer Bedeutung gewichtet werden. Dabei bietet sich vielleicht die neu erschienen Typesafe AI Jev #footnote[#link("https://docs.typesafe.ai/introduction")] an, die anstatt Text zu generieren typisierte, strukutierte Entscheidungen liefert. Dies könnte auch genutzt werden, um die extrahierten Ereignisse einer bestehenden Liste an Kategorien zuzuordnen.

= Vorläufige Literatur

#bibliography("references.bib", style: "iso-690-numeric", title: none)
