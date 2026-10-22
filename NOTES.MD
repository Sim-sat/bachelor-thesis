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
  - Korrekturhinweise („This article was amended on …“): 23 Artikel (22 hinter ` • `, 1 ohne) → prüfen, ob das LLM sie als Ereignis ausgibt
  - Trenner zwischen Leserbriefen (letters)
  - Lebensdaten in Nachrufen („born …; died …“) – echte Ereignisse
  - Boilerplate: Leserbrief-Fußzeile (10×), Leserbrief-Aufruf (1×), Hinweise auf Hilfsangebote (2×)
- HTML (`<strong>`) nur in `trailText` (14 Leserbriefe) – irrelevant, da `trailText` nicht ans LLM geht
- Relative Zeitangaben („on Tuesday“, „six months ago“) → über `published` auflösen; Datum mit Präzisionsangabe
- Schema-Fragen entschieden (18.10.): historische Ereignisse ja (mit Datum); geplante nur wenn beschlossen/angekündigt (Status `geplant`); Aussagen keine Ereignisse; Behauptungen werden übernommen wie berichtet → Entwurf in `05-konzept.typ`

## Entscheidungen (18.10.2026, mit Betreuer zu besprechen)
- **Gruppierung gleicher Ereignisse über Artikel hinweg: wird gemacht** (laut Betreuer freiwillig; Embeddings/LLM), eigene Evaluation
- **Mehrere Vergleiche** (Modell, Einstellungen/Reasoning, Prompt; optional Freitext vs. JSON-Schema) – Forschungsfrage bleibt wie im Exposé
- **Referenzannotation wird allein erstellt** → Annotationsleitfaden + Intra-Annotator-Übereinstimmung
- **60 Seiten inkl. Anhang mit Code**
- Entschieden: alle Ereignisse laut Definition (nicht nur Hauptereignisse), **keine Rolle Haupt/Neben** – „wichtigste Ereignisse“ beantwortet die weltweite Gewichtung; Kontextereignisse wichtig für Gruppierung
- Schema (19.10.): `description` (Englisch, ein Satz), `date` (Zeitpunkt bzw. Beginn, kein Enddatum), `date_precision` (day/month/year), `status` (occurred/planned); keine Uhrzeit (im Text begründen, Exposé nennt sie)
- Unterschiedliche Hauptakteure → getrennte Ereignisse (Harald stirbt / Haakon wird König)
- Aussagen informieren nur: erfasst wird das berichtete Geschehen (Rücktritt, Sanktion, Ausnahmezustand), nie die Aussage selbst
- Regeln aus Pilot Zeile 16 (Ukraine-Briefing, 19.10.):
  - A: Teilgeschehen mit eigenem Ort oder eigenen Folgen = eigenes Ereignis (Lokdepot mit 6 Toten getrennt vom Großangriff auf Kyjiw)
  - B: Datum muss sich auf das Geschehen beziehen; nur das Datum der Meldung („officials said on Tuesday that Russia attacked …“) reicht nicht → kein Ereignis
  - C: Geplant ohne Termin/Zeitraum (Konsulat Bonn „will be closed“) → kein Ereignis
  - Ergebnis Zeile 16: 4 Ereignisse (Großangriff Kyjiw 01.09., Lokdepot 01.09., Angriff Novatek Ust-Luga 01.09., Klepach verliert Posten 2026-08)
  - Ergebnis Zeile 9 (Norwegen, 22.10.): 6 Ereignisse (Eid Haakon 01.09., Harald stirbt 28.08., Haakon wird König 28.08., Mette-Marit fehlt 01.09., Lungentransplantation 2026-06, Beerdigung 09.09. geplant). Hintergrund mit Zeitangabe zählt (Transplantation); Menschenmengen am Palast ohne Datum → nein; Umfragen = Statistik; Weihe in Trondheim „may“ → nein
  - Referenzannotation der Pilotartikel: `ref/pilot.csv` (10 Ereignisse)
  - Folge von B: LLM wird solche Ereignisse oft trotzdem extrahieren → Regel explizit in den Prompt; in Fehleranalyse beobachten
  - Erster Lauf (22.10., `extract.py`, claude-haiku-5-5, Effort Standard medium, Structured Outputs) auf Zeile 9 + 16 → `runs/pilot_haiku.csv`: Norwegen 6/6; Ukraine 4/4 + 2 zu viel, beide Regel B („officials said on Tuesday“, „Naftogaz said“) → P 0,83, R 1,0. Prompt bewusst eingefroren (nicht an 2 Artikeln optimieren)
  - Kosten: 4.265 in / 2.902 out Tokens ≈ 0,002 $; ganzer Korpus ≈ 0,50–0,70 $. Output (inkl. Denk-Tokens) ≈ ¾ der Kosten → Effort-Variante
- Vorher offen: „wichtigste Ereignisse“ – Exposé: Ereignisse, über die ein Artikel hauptsächlich berichtet. Nur Hauptereignisse (wenige je Artikel, Referenzannotation billiger) oder alle? Bestimmt Schema, Annotationsaufwand und Evaluation
- **Gewichtung = weltweite Bedeutung, nach der Gruppierung je Gruppe** (nicht im Extraktionsschema)
  - Vergleich: Gruppengröße (Basis) vs. **Jev** (TypeSafe, Fragetyp Score mit Rubrik 1–5, liefert Score + Konfidenz) vs. Claude mit gleicher Rubrik
  - Referenz: Wikipedia-Portal „Current events“ September 2026 (vorher prüfen, ob ausreichend gepflegt)
  - Risiko Jev: neu, Doku dünn (Preise/Limits/Versionen unklar) → vor Anmeldung mit ~5 Ereignissen testen; Fallback: nur Claude
  - Kosten laut Drittquellen 0,042 $/Mio. Input-Tokens, Output kostenlos → vernachlässigbar; Early Access, 32K Kontext; SDK `typesafe_sdk` in `.venv`, Key `TYPESAFE_API_KEY`
  - Test 1 (19.10., `jev_test.py`, `jev-latest`, Score mit 5 Stufen, Eingabe = Ereignisbeschreibung):
    - Score = Erwartungswert über Stufen **0–4** (aus `probabilities`), kontinuierlich → gut zum Sortieren
    - Sehr stabil: 3 Läufe je Ereignis, Schwankung ±0,03
    - Grob plausibel: Norwegen/Klepach/Kākāpō ≈ 1 (national), Novatek ≈ 3, Kyjiw ≈ 3,4–3,6
    - Wenig Differenzierung: fast nur Stufen 1 und 3; Harald-Tod (1,14) ≈ Mette-Marit (1,00)
    - Formulierungsabhängig: „Massive Russian bombardment of Kyiv kills at least 12“ 3,38 vs. „Russia attacks Kyiv, 12 killed“ 3,58 (Top-Stufe kippt) → pro Gruppe mit einheitlicher Beschreibung bewerten; Diskussion
    - Konfidenz sinkt bei unklaren Fällen (0,68 bei Kyjiw)
    - TODO: feste Modellversion statt `jev-latest`
  - Test 2 (19.10., 14 Ereignisse aus Korpus-Überschriften, lokal bis global) + Claude-Subagent blind mit gleicher Rubrik:
    - Rangkorrelation Jev vs. Claude: Spearman 0,91 (Pearson 0,90), mittlere Abweichung 0,45 Stufen
    - Jev nutzt jetzt volle Skala, ist extremer; Claude zieht zur Mitte (vorsichtiger)
    - Ausreißer Ratte in Alberta: Jev 2,19 mit **Konfidenz 0,0** (wohl wegen „world's only rat-free region“), Claude 0,76 → Konfidenz als Filter nutzbar
    - Größte Unterschiede: Altman/Amodei vor UN-Sicherheitsrat (Jev 3,89 vs. 3,28), Russland trifft Geheimdienst-HQ (2,87 vs. 2,42), Hormus (3,25 vs. 3,50)
    - Achtung: Claude-„Wahrscheinlichkeiten“ waren selbst angegeben, nicht vom Modell berechnet; in der Arbeit Claude per API mit festem Prompt, mehreren Läufen bzw. Logprobs/Wiederholungen
- Exposé: ca. 1000 Artikel, Korpus hat 475 – im Datenkapitel begründet (Zeitfenster ein Monat)
- Uhrzeit wird im Exposé als Attribut genannt; Referenzannotation müsste sie dann enthalten
- Kosten, Laufzeit, Fehlerrate (ungültige Ausgaben) mit erfassen

## Gliederung
1. Einleitung (Motivation, Forschungsfrage, Aufbau)
2. Grundlagen (Event Extraction, LLMs/strukturierte Ausgabe, Embeddings, Metriken)
3. Verwandte Arbeiten
4. Datengrundlage (Korpusauswahl, Abruf, Zusammensetzung, Vorverarbeitung)
5. Konzept (Ereignisdefinition, Schema, Pipeline, Gruppierung, Varianten)
6. Implementierung (Aufbau, Prompt-Design, Speicherung)
7. Evaluation (Referenzannotation, Matching, Ergebnisse gesamt/je Typ/je Variante, Gruppierung, Fehleranalyse)
8. Diskussion (Einordnung, Limitationen)
9. Fazit und Ausblick
Anhang: Prompts, Schema, Annotationsleitfaden, Skripte

## Umfang
- **Max. 60 Seiten gesamt** (inkl. Deckblatt, Verzeichnisse, Literatur, Anhang mit Code)
- Rest außer Hauptteil ca. 18–19 S.: Deckblatt 1, Inhalt 2, Abb./Tab./Quelltext 3, Abkürzungen 1, Literatur 3–4, Erklärung 1, Anhang 7
- Hauptteil max. ~41 S. (inkl. Leerraum durch Seitenumbruch je Kapitel)

| Kapitel | Plan | Stand 18.10. |
|---|---|---|
| 1 Einleitung | 2 | ⅓ (Motivation + Frage aus Exposé) |
| 2 Grundlagen | 5 | Gerüst |
| 3 Verwandte Arbeiten | 3 | Gerüst |
| 4 Datengrundlage | 3 | ~1¼ (Entwurf fertig) |
| 5 Konzept | 7 | Gerüst |
| 6 Implementierung | 4 | Gerüst |
| 7 Evaluation | 12 | Gerüst (F1-Formel) |
| 8 Diskussion | 3 | Gerüst |
| 9 Fazit | 2 | Gerüst |
| **Hauptteil** | **41** | |
| Anhang | 7 | 2 (Skripte B.1–B.3) |

- Schreibreihenfolge: 4 → 5 (mit Prototyp) → 6 → 7 → 2/3 (laufend nebenbei) → 8 → 1 → 9; Anhang laufend
- Platz sparen: Abb./Tab./Quelltextverzeichnis auf eine Seite; Quelltextverzeichnis ggf. streichen
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
- **Vor Anmeldung:** ~~Vorverarbeitung~~, Datenkapitel fertig, Ereignisdefinition/Schema + Annotationsleitfaden entwerfen, Extraktions-Prototyp an 10–20 Artikeln, 5 Artikel probeannotieren (Zeit messen), Matching-Regel festlegen, Literatur sammeln, Rückfragen an Betreuer (Referenzannotation durch eine Person ok? Umfang? Gruppierung Pflicht?)
- **Monat 1:** Schema einfrieren; Referenzannotation (~80 Artikel, geschichtet nach Typ, fester Seed; Größe nach Probeannotation anpassen) erstellen *bevor* Prompts optimiert werden; Pipeline über alle 475 Artikel (Modellversion/Temperature fixieren, Rohausgaben speichern), Konzept- und Implementierungskapitel
- **Monat 2:** Evaluationsskript (Precision/Recall/F1, je Artikeltyp), genau ein Vergleich (Prompt- oder Modellvariante), ~10 Artikel erneut annotieren (Intra-Annotator-Übereinstimmung), Ergebniskapitel + Fehleranalyse
- **Monat 3:** Grundlagen/verwandte Arbeiten fertig, Diskussion, Einleitung/Fazit zuletzt, Korrektur; letzte 2 Wochen Puffer
- Arbeitsweise: nach jeder Coding-Session Stichpunkte ins passende Kapitel
