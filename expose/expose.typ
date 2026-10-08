// Exposé zur Bachelorarbeit

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
    1.10.2026
  ]
  #v(0.5em)
  #text(size: 11pt)[Betreuer: Prof. Dr.-Ing. habil. Dr. h.c. Herwig Unger]
]

#v(1.5em)

= Motivation und Problemstellung

Täglich erscheinen weltweit sehr viele Nachrichtenartikel, in denen dieselben Ereignisse von verschiedenen Quellen mehrfach, zeitversetzt und unterschiedlich ausführlich beschrieben werden. Um aus dieser Textmenge die wesentlichen Ereignisse zu gewinnen, ist eine strukturierte Darstellung mit Zeitangabe und Gewichtung wünschenswert, die sich filtern, sortieren und weiterverarbeiten lässt. Klassische Verfahren der Ereignisextraktion sind meist an vordefinierte Ereignistypen oder annotierte Trainingsdaten gebunden @Doddington2004. Große Sprachmodelle (LLMs) können Texte dagegen allein anhand von Anweisungen und Beispielen im Prompt bearbeiten, ohne dafür nachtrainiert zu werden @Brown2020, und strukturierte Ausgaben erzeugen#footnote[#link("https://platform.claude.com/docs/en/build-with-claude/structured-outputs")]. Offen ist jedoch, wie zuverlässig sie Ereignisse, Zeitangaben und Gewichtung bestimmen können, insbesondere wenn ein Artikel erst nach dem Ereignis erscheint und relative Zeitangaben aufgelöst werden müssen.

= Forschungsfrage und Zielsetzung

Ziel der Arbeit ist es, aus einem Korpus englischer Nachrichtenartikel mithilfe eines LLMs über eine API die wichtigsten Ereignisse zu extrahieren und mit Attributen (Beschreibung, Datum, Uhrzeit, ggf. Gewichtung) in einer CSV-Datei oder Datenbank zu speichern. Ein Ereignis gilt dabei als ein im Artikel berichtetes, zeitlich verortbares Geschehen, das sich in einem Satz beschreiben lässt. Als wichtig gelten Ereignisse, über die hauptsächlich in dem Artikel geschrieben wird. Die Arbeit untersucht dazu die folgende Frage: Wie zuverlässig kann ein LLM Ereignisse samt Zeitangaben aus Nachrichtenartikeln extrahieren, und welchen Einfluss haben Modellwahl, Prompt und Einstellungen auf die Qualität?

= Geplantes Vorgehen

Als Eingabe soll ein Textkorpus (z.~B. CC-News#footnote[#link("https://huggingface.co/datasets/vblagoje/cc_news")] oder die Guardian Open Platform API#footnote[#link("https://open-platform.theguardian.com/")]) verwendet werden. Aufgrund der Größe der meisten verfügbaren Korpora ergibt es Sinn, diese auf eine kleine Anzahl wie 1000 Einträge zu reduzieren, wobei ein sinnvolles Zeitfenster festzulegen ist, damit dieselben Ereignisse in mehreren Artikeln vorkommen. Ein Python-Skript soll die Artikel vorbereiten, um die optimale Verarbeitung durch ein LLM zu erreichen. Das LLM wird per API aufgerufen, um die wichtigsten Ereignisse aus einem Artikel zu extrahieren. Der Prompt muss die Metadaten des Artikels enthalten, um relative Zeitangaben auflösen zu können. Zu jedem Ereignis sollen auch Datum und Uhrzeit bestimmt werden. Es muss beachtet werden, dass die Artikel teilweise später als das Ereignis veröffentlicht werden und somit das Veröffentlichungsdatum des Artikels nicht immer übernommen werden kann. Außerdem muss untersucht werden, welche Modelle, Einstellungen (z. B. Reasoning) und Prompts zu den besten Ergebnissen führen. Zusätzlich kann der Unterschied zwischen einer Freitextausgabe und einer per JSON-Schema erzwungenen Ausgabe des LLM untersucht werden.

Optional können die Ereignisse zusätzlich in ihrer Bedeutung gewichtet werden. Dabei bietet sich vielleicht ein System-One-Modell (auch Decision Model) wie Jev#footnote[#link("https://docs.typesafe.ai/introduction")] an, das anstatt Text zu generieren typisierte, strukturierte Entscheidungen mit Konfidenzangabe liefert. Dies könnte auch genutzt werden, um die extrahierten Ereignisse einer bestehenden Liste an Kategorien zuzuordnen. Da diese Modelle erst seit einigen Wochen öffentlich sind, gibt es noch viele offene Fragen zu den Vorteilen dieser Modelle.

Darüber hinaus sollen gleiche Ereignisse aus verschiedenen Artikeln gruppiert werden. Dafür gibt es verschiedene Ansätze: Zum einen können die extrahierten Ereignisse mithilfe eines Embeddingmodells @Reimers2019 in Vektoren umgewandelt und anhand ihrer Ähnlichkeit gruppiert werden, wobei nur Ereignisse in einem gemeinsamen Zeitfenster verglichen werden. Zum anderen kann ein LLM paarweise entscheiden, ob zwei Ereignisse zueinander gehören. Denkbar ist außerdem eine Kombination, bei der ein Embeddingmodell Kandidatenpaare vorschlägt und das LLM diese verifiziert. Die Größe einer Gruppe könnte zusätzlich als Maß für die Bedeutung eines Ereignisses dienen.

Die Ausgabe des Skripts geschieht entweder als CSV-Datei oder in einer Datenbank (z.~B. sqlite).

= Evaluation

Für ein manuell annotiertes Teilsample von ca. 50 bis 100 Artikeln werden die Ereignisse samt Datum, Uhrzeit und ggf. Gewichtung von Hand erfasst. Die Ausgaben der Varianten werden dagegen mit Precision, Recall und F1 je Attribut verglichen. Zusätzlich werden Kosten, Laufzeit und Fehlerrate (z.~B. ungültige Ausgaben) erfasst. Die Zuordnung gleicher EReignisse wird im annotierten Teilsample gegen die manuelle Zuordnung geprüft.

= Vorläufige Literatur

#bibliography("references.bib", style: "ieee", title: none)

