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
#show footnote: set text(fill: blue)

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

Täglich erscheinen weltweit sehr viele Nachrichtenartikel, in denen dieselben Ereignisse von verschiedenen Quellen mehrfach, zeitversetzt und unterschiedlich ausführlich beschrieben werden. Um aus dieser Textmenge die wesentlichen Ereignisse zu gewinnen, ist eine strukturierte Darstellung mit Zeitangabe und Gewichtung wünschenswert, die sich filtern, sortieren und weiterverarbeiten lässt. Klassische Verfahren der Ereignisextraktion sind meist an vordefinierte Ereignistypen oder annotierte Trainingsdaten gebunden. Große Sprachmodelle (LLMs) können Texte dagegen ohne aufgabenspezifisches Training verarbeiten und strukturierte Ausgaben erzeugen. Offen ist jedoch, wie zuverlässig sie Ereignisse, Zeitangaben und Wichtigkeit bestimmen können, insbesondere wenn ein Artikel erst nach dem Ereignis erscheint und relative Zeitangaben aufgelöst werden müssen
= Forschungsfrage und Zielsetzung

Ein Textkorpus englischer Nachrichtenartikel wird per LLM-API analysiert und die wichtigsten Ereignise werden mit Attributen (Beschreibung, Datum, Uhrzeit, Gewichtung) in einer CSV-Datei oder Datenbank gespeichert. Es ist zu überprüfen, wie zuverlässig eine LLM diese Informationen extrahieren kann


= Geplantes Vorgehen

Einen Textkorpus (z.B. ccnews #footnote[#link("https://huggingface.co/datasets/sentence-transformers/ccnews/viewer/pair/train?p=2&row=216")]) soll verwendet werden als Eingabe. Aufgrund der Größe der meisten verfübaren Korpara macht es sinn diese auf eine kleine Anzahl wie 1000 Einträge zu reduzieren. Ein Python-Skript soll nun die Artikel vorbereiten, um die optimale Verarbeitung durch eine LLM zu erreichen. Die LLM wird per API aufgerufen, um die wichtigsten Ereignisse aus einem Artikel zu extrahieren. Der prompt muss die Metadaten des Artikels enthalten, um relative Zeitangaben auflösen zu können. Zu jedem Ereignis soll auch ein Zeitstempel erstellt werden. Es muss beachtet werden, dass die Artikel teilweise später als das Ereignise veröffentlicht werden und somit der Zeitstempel der Artikel nicht immer übernommen werden kann. Außerdem muss untersucht werden, welche Modelle, Einstellungen (z.B. Reasoning) und Prompts zu den besten Ergebnissen führen. Zusätzlich kann der Unterschied von Freitextausgabe und erzwungener Ausgabe in einem definierten JSON-Schema des LLM untersucht werden. Die Ausgabe des Skripts geschieht entweder als CSV-Datei oder in einer Datenbank (z.B. sqlite). Die Ereignisse könnten außerdem in ihrer Bedeutung gewichtet werden. Dabei bietet sich vielleicht ein System-One-Modell (auch Decision Model) wie Jev AI #footnote[#link("https://docs.typesafe.ai/introduction")] an, die anstatt Text zu generieren typisierte, strukutierte Entscheidungen mit Konfidenzangabe liefern. Dies könnte auch genutzt werden, um die extrahierten Ereignisse einer bestehenden Liste an Kategorien zuzuordnen. Da diese Modelle erst seit einigen Wochen öffentlich sind, gibt es noch veiel offene Fragen zu den Vorteilen dieser Modelle.

= Evaluation

Ein kleines manuell annotiertes Sample kann als Referenz genommen werden, um die verschiedenen Ansätze miteinander zu vergleichen.

= Vorläufige Literatur

#bibliography("references.bib", style: "iso-690-numeric", title: none)
