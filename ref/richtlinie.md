# Annotationsrichtlinie

Grundlage: Ereignisdefinition in Kapitel 5. Annotiert werden die ersten 50 Artikel aus `sample.tsv` in der dortigen Reihenfolge.

## Format

`annotation.csv`, eine Zeile pro Ereignis:

```
line,description,date,date_precision,status
117,"A landslip in Suichuan county, Jiangxi, kills three people.",2026-09-05,day,occurred
```

- `line`: Zeilennummer im Korpus (wie in `sample.tsv`)
- `description`: ein englischer Satz im Präsens, immer in Anführungszeichen; wer, was, ggf. wo
- `date`: `JJJJ-MM-TT`; unbekannte Teile mit `01` (Monat: `2026-09-01`, Jahr: `2026-01-01`)
- `date_precision`: `day` | `month` | `year`
- `status`: `occurred` | `planned`
- keine Leerzeichen nach Kommas

`annotated.txt`: pro fertigem Artikel eine Zeile mit der Zeilennummer, auch bei 0 Ereignissen. Zeitaufwand pauschal ca. 10 Minuten pro Artikel (gemessen an den ersten 10).

## Was ist ein Ereignis?

Ein konkretes Geschehen, das der Artikel als stattgefunden oder fest geplant berichtet und dem der Artikel selbst einen Zeitpunkt oder Zeitraum zuordnet. Wahrheitsgehalt und Weltwissen spielen keine Rolle, maßgeblich ist allein der Text.

### Keine Ereignisse

| Fall | Beispiel |
|---|---|
| Spekulation, Vermutung, Prognose | „is believed to be“, „is expected to“, „could“, Wettervorhersage |
| Zustand | „has been in Iran since 2002“, „controls 65% of Gaza“ |
| Meinung, Bewertung | „a major setback for democracy“ |
| Statistik, Trend, Sammelangabe | „soared from 63 in 2016 to 2,845 in 2025“, „killed more soldiers in recent weeks“, „claimed 130 attacks in 2026“ |
| Andauernder Prozess | „JNIM has continued to expand“, „sea ice had been falling since 14 September“ |
| Aussage als solche | „Peskov said the vote showed …“ (berichtet eine Aussage ein Geschehen, wird das Geschehen erfasst) |
| Entscheidung oder Absicht ohne berichtete Umsetzung | „a volunteer decided to leave“ |
| Verneintes Geschehen | „has yet to make any public statement“ |
| Geplant ohne Termin | „plans to visit Kyiv“ |

## Zeit

- **Die Zeitangabe muss im Artikel stehen.** Kein Weltwissen ergänzen, auch wenn es richtig wäre (Trump „at the beginning of his second term“ → kein Datum → kein Ereignis).
- **Regel B: Nur das Datum der Meldung bekannt → kein Ereignis.** „Russia damaged the plant, officials said on Tuesday“ (Dienstag = Aussage, nicht Angriff). Gilt auch, wenn gar kein Datum dasteht und nur das Publikationsdatum bekannt ist („Merz cancelled a plan to speak at the UN“).
  - Fällt dadurch die Hauptnachricht des Artikels weg, in `annotated.txt` mit `B` markieren: `265 B`.
- **Zeitbezug übernehmen:** Eine Zeitangabe gilt für folgende Sätze weiter, solange sie erkennbar dieselbe Episode schildern (Mali-Offensive „In April“ → Tod des Verteidigungsministers, Fall von Kidal). Sie endet bei neuem Zeitbezug oder Themenwechsel.
- **Relative Angaben** über das Publikationsdatum auflösen (`cal 9 2026`):
  - Wochentage: das letzte vergangene, bei Zukunft („will convene on Sunday“) das nächste
  - „this year“ / „last year“ / „next year“ → `year`
  - „last month“, „in April“ → `month`
  - „X years ago“ → Jahr, `year`
  - „overnight“ → Tag vor der Veröffentlichung, `day`
- **Zeiträume:** Datum = Beginn.
  - Beginn eindeutig („this weekend“ → Samstag) → `day`
  - Geschehen liegt irgendwo in einem vagen Zeitraum („last week“, „late last month“) → `month`; reicht der Zeitraum über einen Monatswechsel, gilt der Monat mit den meisten Tagen
  - Jahreszeiten, „early 2026“ → `year`
- **Historische Ereignisse** zählen, wenn das Datum im Text steht („William of Orange invades England in 1688“).

## Status

Bezogen auf das **Publikationsdatum**: `planned`, wenn das Geschehen zum Erscheinen des Artikels noch bevorstand und einen Termin hat (Wahlen „in October“, „next year“, Sitzung „on Sunday“), auch wenn es inzwischen stattgefunden hat. Sonst `occurred`.

## Abgrenzung: ein oder mehrere Ereignisse?

| Regel | Beispiel |
|---|---|
| Dasselbe Geschehen wird pro Artikel nur **einmal** annotiert, egal wie oft es erwähnt wird | Duma-Wahl (10× erwähnt) → 1 Ereignis |
| Verschiedene **Hauptakteure** → getrennt, auch bei kausalem Zusammenhang | Harald V stirbt / Haakon wird König |
| Teilgeschehen mit **eigenem Ort oder eigener Folge** → getrennt (Regel A) | Angriff auf Kuwait-Basis / Angriff auf VAE-Basis |
| **Reaktion** anderer Akteure → eigenes Ereignis | Dammbruch / Rettung von 1.260 Menschen; Sturmschaden / Evakuierung |
| **Unmittelbare Wirkung** gehört zum Geschehen | „embankment collapses, flattening 100 homes“, „attack kills 12“ |
| **Aufzählung getrennter Geschehen** → aufteilen | Wahlen in Polen, Italien, Spanien, Griechenland, Frankreich → 5 |
| **Aufzählung betroffener Orte** eines Geschehens → nicht aufteilen | Taifun über vier Provinzen → 1 |
| **Details** (Mittel, Ergebnisse anderer Beteiligter, Messwerte) → kein eigenes Ereignis | Waffentyp, Sitze der anderen Parteien, 416,5 mm Regen |
| Getrennte Abstimmungen am selben Tag → getrennt | Duma-Wahl / Wiederwahl Kadyrovs |
| Einzelner **Rekord- oder Höchstwert mit Datum** → Ereignis | Meereis-Maximum am 14. September |
| Ereignisse von Privatpersonen mit Datum → Ereignis | Freiwilliger tritt im Januar der Einheit bei |

## Vorgehen pro Artikel

1. `art <Zeile>`, Wochentag des Publikationsdatums merken
2. Zeitausdrücke mit der Suche anspringen, jeden Treffer prüfen
3. Rest überfliegen (Ereignisse ohne eigenes Zeitwort in derselben Episode)
4. Eintragen, Zeilennummer in `annotated.txt`
5. Neuer Grenzfall → Regel hier ergänzen, nicht nur im Kopf entscheiden
