#import "../template.typ": *

= Einleitung <einleitung>

== Motivation und Problemstellung

Täglich erscheinen weltweit sehr viele Nachrichtenartikel, in denen dieselben Ereignisse von verschiedenen Quellen mehrfach, zeitversetzt und unterschiedlich ausführlich beschrieben werden. Um aus dieser Textmenge die wesentlichen Ereignisse zu gewinnen, ist eine strukturierte Darstellung mit Zeitangabe und Gewichtung wünschenswert, die sich filtern, sortieren und weiterverarbeiten lässt. Klassische Verfahren der Ereignisextraktion sind meist an vordefinierte Ereignistypen oder annotierte Trainingsdaten gebunden @Doddington2004. Ein #acr("LLM") kann Texte dagegen allein anhand von Anweisungen und Beispielen im Prompt bearbeiten, ohne dafür nachtrainiert zu werden @Brown2020.

== Forschungsfrage und Zielsetzung

Ziel der Arbeit ist es, aus einem Korpus englischer Nachrichtenartikel mithilfe eines #acr("LLM") automatisch die wichtigsten Ereignisse zu extrahieren und mit Attributen in einer #acr("CSV")-Datei oder Datenbank zu speichern.

#quote(block: true)[
  Wie zuverlässig kann ein #acrs("LLM") Ereignisse samt Zeitangaben aus Nachrichtenartikeln extrahieren, und welchen Einfluss haben Modellwahl, Prompt und Einstellungen auf die Qualität?
]

== Aufbau der Arbeit

// Kurzer Überblick über die folgenden Kapitel, mit Querverweisen:
@grundlagen beschreibt die Grundlagen, @methodik das Vorgehen, @umsetzung die Umsetzung und @evaluation die Evaluation. Die Ergebnisse werden in @diskussion diskutiert, @fazit schließt mit Fazit und Ausblick.
