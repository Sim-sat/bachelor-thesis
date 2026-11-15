#import "../template.typ": *

= Verwandte Arbeiten <verwandte-arbeiten>

== Ereignisextraktion mit #acr("LLM")s

// ChatIE, GoLLIE, @Li2025, @Xu2024
#cite(<Wei2024>, form: "prose") nutzen ChatGPT ohne weiteres Training für die Extraktion für Ereignissen, Entitäten und Relationen. Die Aufgabe wird dabei in zwei Schritte zerlegt. Im ersten Schritt wird eine Liste von Elementtypen benutzt, aus denen das Modell auswählen soll. Dadurch soll der Suchraum und die Rechenkomplexität reduziert werden. Da das verwendete #acr("LLM") noch keine Structured Outputs unterstützt hat#footnote[#link("https://openai.com/index/introducing-structured-outputs-in-the-api/")], wurde darum gebeten als Liste zu antworten. In Phase zwei werden mehrere Frage-Antwort-Runden benutzt, um für jeden Elementtypen das Element zu extrahieren. Anders als in dieser Arbeit sind die Ereignistypen fest vorgegeben und die Zeitangabe wird nicht gesondert erfasst.

#cite(<Sainz2024>, form: "prose") versuchen das Problem zu lösen, dass #acr("LLM")s schlechtere Ergebnisse bei Zero-Shot Aufgabn liefern als spezialisierte Modelle. Dabei wird das #acr("LLM") darauf nachtrainiert, Richtlinien zu befolgen. Auch wenn auf Daten aus Nachrichten- und Biomedizinkorpora trainiert wurde, wurden in beliebigen Domänen deutliche Verbesserungen festgestellt. Durchschnittlich waren die Ergebnisse 13 F1 Punkte besser als dasselbe Modell ohne Richtlinien. Im Gegenteil zu dieser Arbeit benutzt GoLLIE Nachtraining und benutzt feste Typen mit Triggern und Argumenten. Offen bleibt auch, inwiefern aktuelle Modelle wie Haiku 5.5 abschneiden und ob sie eventuell durch Vortraining beim Anbieter selbst darauf vortrainiert wurde.

#cite(<Xu2024>, form: "prose") fasst den Stand der Forschung für #acr("LLM")-gestützte Ereignisextraktion zusammen und kommt zu dem Schluss, dass #acr("LLM")s immer noch schlechter abschneiden als durch überwachtes Fine-Tuning veränderte Modelle @Xu2024[S.10]. ChatGPT schneidet schlechter ab als BERT-basierte Modelle in Standardaufgaben, allerdings deutlich besser in OpenIE Aufgaben. Damit sind Aufgaben ohne feste Typen gemeint, wie sie auch diese Arbeit verwendet @Xu2024[S.12].

#cite(<Li2025>, form: "prose") beschreibt das Verwenden von starren Typen als einen großen Nachteil von #acr("LLM")-basierten Ansätzen, die die Nützlichkeit in echten Anwendungen mindern. Außerdem stellen sie die Anforderung, dass ein solches System in der Lage sein muss dokumentenübergreifende Koreferenz zu erkennen. Genau an diesen Punkt knüpft @sec:gruppierung an.

== Ereigniserkennung in Nachrichtenströmen



== Wikipedia Current Events als Datenquelle

// WCEP-Datensatz

== Bedeutung von Nachrichten



== Abgrenzung dieser Arbeit
