# Bachelorarbeit – Projektstand

## Rahmen
- FernUniversität in Hagen, Lehrstuhl Kommunikationsnetze, Betreuer: Prof. Dr.-Ing. habil. Dr. h.c. Herwig Unger
- Thema: Ereignisextraktion aus einem Nachrichtenkorpus per LLM (Claude API), Ergebnisse in DB/CSV
- Exposé angenommen; Anmeldung ca. Anfang November 2026, danach 3 Monate Bearbeitungszeit
- Ziel: solide Note (~2), Scope bewusst klein halten
- Textsatz: Typst, eigene Vorlage (aus dem Exposé erweitert), Editor Neovim
- Zeitbudget vor Anmeldung: mind. 1 h/Tag; ab Anmeldung deutlich mehr nötig (ECTS in Prüfungsordnung prüfen)
- Python-Skripte so kurz wie möglich halten

## Korpus
- Guardian Content API, `section=world`, `type=article`, `tag=-tone/comment`, 01.–30.09.2026, `order-by=oldest`
- Felder: `show-fields=headline,trailText,bodyText,wordcount`, `show-tags=tone,series`
- `page-size` max. 200 → 3 Seiten; Abruf über `get_sample_dataset.py` (Ausgabe per stdout als JSONL)
- API-Key in `.env` (`GUARDIAN_API_KEY`), wird per `dotenv` geladen
- Datei: `guardian_world_2026-09.jsonl`, 475 Artikel; Rechte geklärt, darf ins Repo
- Entscheidung: **keine Filterung nach Artikeltyp** – Frage ist, ob beliebige Ereignisse extrahierbar sind; Typ wird stattdessen als Auswertungsvariable genutzt
- Ausnahme `-tone/comment` (Meinungsbeiträge) im Datenkapitel begründen

### Aufbereitung (`preprocess.py`)
- `python preprocess.py guardian_world_2026-09.jsonl > guardian_world_2026-09.clean.jsonl`
- Ausgabe je Artikel nur `id`, `published`, `headline`, `body` – das geht ans LLM
- Bewusst weggelassen: `url`, `wordcount`, `type` (Typ könnte die Extraktion beeinflussen; alles über `id` im Rohkorpus nachschlagbar)
- **Text wird nicht bereinigt** – Robustheit gegenüber realen Texten ist Teil der Untersuchung

### Verteilung nach Artikeltyp
- Hauptkategorie per Tone-Tag, Priorität: newsletter > letters > callout > obituaries > analysis > explainers > features > profiles > interview > news
- Begründung: 54 Artikel haben mehrere Tone-Tags, immer `news` + spezifischerer Tag (24× newsletter, 18× features, 5× analysis, 3× features+newsletter, 2× explainers, je 1× interview/profiles) → spezifischer Tag gewinnt; Reihenfolge der übrigen betrifft nur die 3 features+newsletter-Fälle
- Typ wird für die Evaluation über `id` aus dem Rohkorpus bestimmt (Logik steht in Listing `lst:laden` im Datenkapitel)

| Typ | Anzahl |
|---|---|
| news | 283 |
| features | 71 |
| explainers | 36 |
| newsletter | 27 |
| analysis | 20 |
| ohne Tag | 14 |
| letters | 13 |
| obituaries | 5 |
| callout | 3 |
| profiles | 2 |
| interview | 1 |

## Beobachtungen am Korpus (für Daten- und Fehleranalyse)
- Briefings (z. B. Ukraine war briefing) sehr ereignisdicht; Newsletter enthalten viel Rauschen und Ereignisse anderer Ressorts
- Zero-Width-Zeichen (stehen roh in der Datei, vor einzelnen Wörtern; Agentur-Tracking): 525× U+2060, 387× U+200C, 34× U+200B, in ~100 Artikeln. In Neovim: `/\%u200c`. Falls bei der Evaluation Strings exakt verglichen werden → dort normalisieren, nicht in den Daten
- ` • ` hat mehrere Bedeutungen, darf **nicht** pauschal abgeschnitten werden:
  - Korrekturhinweise („This article was amended on …“): 22 Artikel → prüfen, ob das LLM sie als Ereignis ausgibt
  - Trenner zwischen Leserbriefen (letters)
  - Lebensdaten in Nachrufen („born …; died …“) – echte Ereignisse
  - Boilerplate: Leserbrief-Fußzeile (10×), Leserbrief-Aufruf (1×), Hinweise auf Hilfsangebote (2×)
- HTML (`<strong>`) nur in `trailText` (14 Leserbriefe) – irrelevant, da `trailText` nicht ans LLM geht
- Relative Zeitangaben („on Tuesday“, „six months ago“) → über `published` auflösen; Datum mit Präzisionsangabe
- Offene Schema-Fragen: historische Ereignisse, angekündigte Ereignisse (Status `geplant`), Behauptungen vs. bestätigte Fakten

## Abgleich mit dem Exposé – offene Entscheidungen
- **„Wichtigste Ereignisse“**: Exposé definiert sie als Ereignisse, über die ein Artikel hauptsächlich berichtet. Entscheiden: nur Hauptereignisse (wenige je Artikel, Gold-Set billiger) oder alle Ereignisse. Bestimmt Schema, Gold-Set-Aufwand und Evaluation
- **Gruppierung gleicher Ereignisse über Artikel hinweg** (Embeddings/LLM) steht im Exposé als „sollen“, fehlt aber im Plan → einplanen oder mit Betreuer klären
- **Varianten**: Exposé nennt Modellwahl, Einstellungen (Reasoning), Prompt, optional Freitext vs. JSON-Schema; Plan sieht nur einen Vergleich vor → Forschungsfrage in der Einleitung ggf. eingrenzen
- Gewichtung (Jev/Decision Model) im Exposé optional → weglassen
- Exposé: ca. 1000 Artikel, Korpus hat 475 – im Datenkapitel kurz begründen (Zeitfenster ein Monat, damit Ereignisse mehrfach vorkommen)
- Uhrzeit wird im Exposé als Attribut genannt; Gold-Set muss sie dann enthalten
- Kosten, Laufzeit, Fehlerrate (ungültige Ausgaben) mit erfassen

## Gliederung
1. Einleitung (Motivation, Forschungsfrage, Aufbau)
2. Grundlagen (Event Extraction, LLMs/strukturierte Ausgabe, Metriken)
3. Verwandte Arbeiten
4. Datengrundlage (Korpusauswahl, Abruf, Zusammensetzung, Vorverarbeitung)
5. Konzept (Ereignisdefinition, Schema, Pipeline)
6. Implementierung (Aufbau, Prompt-Design, Speicherung)
7. Evaluation (Gold-Set, Matching, Ergebnisse gesamt/je Typ, Fehleranalyse)
8. Diskussion (Einordnung, Limitationen)
9. Fazit und Ausblick
Anhang: Prompts, Schema, Beispielausgaben

## Umfang
- **Max. 60 Seiten gesamt** (inkl. Deckblatt, Verzeichnisse, Literatur, Anhang/Quelltext)
- Overhead ca. 16–18 S. (Deckblatt 1, Inhalt 2, Abb./Tab./Quelltext je 1, Abkürzungen 1, Literatur 3–4, Erklärung 1, Anhang 5–6) → Hauptteil ~42 S., davon ~3–4 S. Leerraum durch Seitenumbruch je Kapitel
- Budget Hauptteil: Einleitung 2 · Grundlagen 5–6 · Verwandte Arbeiten 3–4 · Datengrundlage 3–4 · Konzept 5 · Implementierung 4 · **Evaluation 10** · Diskussion 3 · Fazit 1–2
- Platz sparen: Abb./Tab./Quelltextverzeichnis auf eine Seite; Quelltextverzeichnis ggf. streichen; Anhang knapp, Rest ins Repo
- TODO: Eigenständigkeitserklärung in Vorlage ergänzen
- Literatur: Ziel 25–35 Quellen

## Stand der Kapitel (17.10.2026)
- 01 Einleitung: Motivation + Forschungsfrage aus Exposé übernommen; Aufbau fehlt
- 02 Grundlagen: nur Gerüst mit Platzhaltern
- 03, 05–09: Gerüste mit Überschriften laut Gliederung (F1-Formel bereits in 07)
- 04 Datengrundlage: erster Entwurf (Korpus, Abruf, Vorbereitung, Typ-Tabelle + jq-Listing)
- Anhang: Gerüst
- Literatur: 4 Einträge (Doddington2004, Brown2020, Reimers2019 + 1)

## Plan
- **Vor Anmeldung:** ~~Vorverarbeitung~~, Datenkapitel fertig, Ereignisdefinition/Schema + Annotationsleitfaden entwerfen, Extraktions-Prototyp an 10–20 Artikeln, 5 Artikel probeannotieren (Zeit messen), Matching-Regel festlegen, Literatur sammeln, Rückfragen an Betreuer (Ein-Personen-Gold-Set ok? Umfang? Gruppierung Pflicht?)
- **Monat 1:** Schema einfrieren; Gold-Set (~50 Artikel, geschichtet nach Typ, fester Seed; Größe nach Probeannotation anpassen) annotieren *bevor* Prompts optimiert werden; Pipeline über alle 475 Artikel (Modellversion/Temperature fixieren, Rohausgaben speichern), Konzept- und Implementierungskapitel
- **Monat 2:** Evaluationsskript (Precision/Recall/F1, je Artikeltyp), genau ein Vergleich (Prompt- oder Modellvariante), ~10 Artikel erneut annotieren (Intra-Annotator-Übereinstimmung), Ergebniskapitel + Fehleranalyse
- **Monat 3:** Grundlagen/verwandte Arbeiten fertig, Diskussion, Einleitung/Fazit zuletzt, Korrektur; letzte 2 Wochen Puffer
- Arbeitsweise: nach jeder Coding-Session Stichpunkte ins passende Kapitel
