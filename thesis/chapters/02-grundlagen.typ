#import "../template.typ": *

= Grundlagen <grundlagen>

Dieses Kapitel führt die Begriffe und Verfahren ein, auf denen die weiteren Kapitel aufbauen: große Sprachmodelle, Ereignisextraktion, die Normalisierung von Zeitausdrücken, semantische Ähnlichkeit von Sätzen sowie die verwendeten Evaluationsmaße.

== Große Sprachmodelle <sec:llm>


== Ereignisextraktion <sec:ereignisextraktion>

Die #acr("IE") ist ein Teilgebiet des #acr("NLP"). Ihr Ziel ist es, aus unstrukturiertem Text strukturiertes Wissen zu gewinnen, etwa Entitäten, Relationen und Ereignisse, das anschließend z.~B. für Wissensgraphen oder Frage-Antwort-Systeme genutzt werden kann @Xu2024. Im Unterschied zu statischen Fakten halten Ereignisse fest, was passiert ist, wer daran beteiligt war, wann und wo es stattgefunden hat und welche Folgen es hatte @Li2025. Die Ereignisextraktion ist neben der Erkennung von Entitäten und Relationen eine der klassischen Aufgaben der #acr("IE") @Xu2024.

Für den Begriff des Ereignisses existiert keine einheitliche Definition. Die Annotationssprache TimeML fasst ihn weit: Ereignisse sind Situationen, die geschehen oder eintreten, und können punktuell sein oder einen Zeitraum andauern. Auch Zustände werden als Ereignisse betrachtet @Pustejovsky2003. Die Annotationsrichtlinien des Programms _Automatic Content Extraction_ (ACE) beschreiben ein Ereignis ebenfalls allgemein als etwas, das geschieht, häufig als Zustandsänderung. Annotiert werden jedoch nur Ereignisse aus einer festen Menge von acht Typen, etwa Angriffe, Todesfälle oder Festnahmen, jeweils zusammen mit ihren Beteiligten @LDC2005. Zusätzlich erhält jedes Ereignis Merkmale, die unter anderem angeben, ob es als tatsächlich geschehen berichtet wird oder nur angenommen, angekündigt oder gewünscht ist @LDC2005.

Die klassische Ereignisextraktion zerfällt in 4 Teilaufgaben @Li2025:
/ Trigger-Erkennung: Ein Ereignis wird im Text durch ein Auslösewort (Trigger) ausgedrückt, meist handelt es sich um ein Verb oder eine Nominalisierung. Die Aufgabe besteht nun darin, diese Wörter in Sätzen zu finden und einen Ereignistypen daraus abzuleiten. Die Typen sind dabei fest vorgegeben. Die Schwierigkeit besteht vorallem in der Mehrdeutigkeit der Sprache und in der Erstellung von Trainingsdatensätzen für Modelle @Le2021 @Li2025.
/ Argument Extraktion: identifiziert die Akteure eines erkannten Events und weist ihnen Rollen aus einem vordefinierten Schema zu. Das Schema muss einen Großteil an Möglichkeiten abdecken und ist daher nicht trivial zu erstellen. Sprachliche Mittel, wie die Verwendung von Pronomen statt Namen, erschweren das korrekte Erkennen von Akteuren weiter @Li2025. Allerdings können aus bereits erkannten Rollen, die weiteren Rollen teilweise abgeleitet werden. Gibt es einen "Verkäufer", ist die Wahrscheinlichkeit hoch, dass es auch einen "Käufer gibt" @Wang2019.
/ Ereigniskoreferenz: hat das Ziel Ereignisse zusammenzuführen, die gleich sind. Ereignisse können mehrmals in einem Text, oder auch in anderen Texten, berichtet werden. Trotzdem handelt es sich immer noch um dasselbe Ereignis. Vorrausetzungen sind unter anderem die gleichen Akteure und die gleichen Attribute wie der Zeitpunkt @Li2025. Darauf wird in @sec:gruppierung weiter eingegangen.
/ Extaktion von Beziehungen zwischen Ereignissen: Ereignisse in der echten Welt passieren selten alleine. Sie hängen miteinander zusammen und bedingen sich teilweise kausal oder temporal @Wang2020.


== Zeitausdrücke <sec:zeitausdruecke>
== Semantische Ähnlichkeit <sec:aehnlichkeit>

== Evaluationsgrundlagen <sec:evaluationsgrundlagen>

