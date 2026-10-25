#import "../template.typ": *

= Grundlagen <grundlagen>

// Umfang ≈ 5 Seiten

== Große Sprachmodelle <sec:llm>

// - Transformer-Architektur, nur so weit wie nötig (fehlt: Vaswani et al. 2017)
// - Vortraining, In-Context-Learning, Prompting, Zero-/Few-Shot (@Brown2020)
// - Reasoning / Denkphase vor der Antwort, Effort als Einstellung (fehlt: Wei et al. 2022, Chain-of-Thought)
// - Strukturierte Ausgabe: Ausgabe wird auf ein JSON-Schema beschränkt (Prinzip hier, Technik in Kapitel 6)

Text …

== Ereignisextraktion <sec:ereignisextraktion>

// - Ereignisbegriff in der Informationsextraktion
// - Klassische Aufgabe nach ACE: Trigger, Argumente mit Rollen, feste Ereignistypen (@Doddington2004)
// - Generative Extraktion mit LLMs statt Markieren von Textstellen (@Xu2024, @Li2025)
// - Überleitung: diese Arbeit nutzt einen vereinfachten Ereignisbegriff ohne Typen und Rollen (@konzept)

Text …

== Zeitausdrücke <sec:zeitausdruecke>

// - Absolute ("9 September") und relative Zeitangaben ("on Friday", "last month")
// - Normalisierung relativ zu einem Bezugsdatum, hier das Veröffentlichungsdatum (@Pustejovsky2003)
// - Unterschiedliche Granularität (Tag, Monat, Jahr) → Grundlage für `date_precision`
// - Regelbasierte Normalisierung als Alternative zum LLM (@Stroetgen2010)

Text …

== Semantische Ähnlichkeit <sec:aehnlichkeit>

// - Satz-Embeddings: Sätze als Vektoren, ähnliche Bedeutung → ähnliche Vektoren (@Reimers2019)
// - Kosinus-Ähnlichkeit, Schwellwert
// - Grundlage für die Gruppierung (@sec:gruppierung)

Text …

== Evaluationsgrundlagen <sec:evaluationsgrundlagen>

// - Precision, Recall, F1 (evtl. Lehrbuchquelle ergänzen)
// - Übereinstimmung von Annotationen, hier Intra-Annotator (@Artstein2008)
// - LLM-as-a-Judge: LLM bewertet, ob zwei Ereignisse übereinstimmen; Stärken und Verzerrungen (@Zheng2023, @Gu2026)

Text …
