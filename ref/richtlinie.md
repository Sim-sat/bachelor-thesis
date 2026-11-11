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

**Test:** Lässt sich die Stelle als „X passiert“ formulieren, ohne etwas zu ergänzen, das nicht im Text steht? „a mid-2023 settlement … in which he sold stock“ → „Chambers settles with his family“ (ja). „was prime minister between 2021 and 2022“ → „Andersson becomes PM“ steht nicht im Text (nein).

Datierte Hintergrund-Ereignisse zählen, auch im Nebensatz oder als Substantiv („since Moscow invaded Ukraine in February 2022“, „a mid-2023 settlement“). Ebenso ein einzelner Rekord, Höchstwert oder Meilenstein mit Datum („This summer, Max became the country’s most-used messaging app“), nicht aber der Verlauf dorthin.

### Keine Ereignisse

| Fall | Beispiel |
|---|---|
| Spekulation, Vermutung, Prognose | „is believed to be“, „is expected to“, „could“, Wettervorhersage |
| Zustand, auch mit Zeitraum (Amtszeit) | „has been in Iran since 2002“, „controls 65% of Gaza“, „was prime minister between November 2021 and October 2022“ |
| Erkenntnis | „OpenAI became aware of the hack in August“ |
| Meinung, Bewertung | „a major setback for democracy“ |
| Statistik, Trend, Sammelangabe | „soared from 63 in 2016 to 2,845 in 2025“, „killed more soldiers in recent weeks“, „claimed 130 attacks in 2026“, „diesel prices jumped by 15.7% in July“, „175 killed or injured in a single week (3–9 September)“ |
| Sammel-Geschehen ohne Einzelereignis | „as Trump unveiled successive rounds of tariffs last year“ |
| Andauernder Prozess | „JNIM has continued to expand“, „sea ice had been falling since 14 September“, „over the past 18 months, Russians have been forced to install …“ |
| Kommunikation jeder Form: Aussage, Kritik, Post, Interview, Rede, Pressekonferenz | „Peskov said the vote showed …“, „Democrats lambasted Trump“, „writing on social media on Thursday“, „was interviewed on a TV news station“, „will deliver his keynote speech“. Berichtet die Aussage ein Geschehen, wird das Geschehen erfasst. **Ausnahme:** Sprechhandlung mit eigener Wirkung (siehe unten) → Ereignis |
| Entscheidung oder Absicht ohne berichtete Umsetzung | „a volunteer decided to leave“ |
| Verneintes Geschehen | „has yet to make any public statement“ |
| Geplant ohne Termin | „plans to visit Kyiv“ |

### Kommunikation: feste Liste

Die Grenze lässt sich nicht trennscharf begründen, deshalb gilt eine Festlegung:

| Einordnung | Fälle |
|---|---|
| Ereignis | Treffen, Gipfel, Telefonat, Verhandlung, Besuch |
| Kein Ereignis | Interview, Rede, Pressekonferenz, Post, Stellungnahme, Kritik, Werbespot |
| Ereignis, da eigene Wirkung | Einladung, Antrag, Urteil, Rücktritt, offizielle Meldung an eine Behörde, Veröffentlichung eines Berichts, einer Studie oder eines Buches |
| Kein Ereignis | Beiträge in Zeitungen und Magazinen („In her piece on Lübeck (…, 6 September)“) |

## Zeit

- **Die Zeitangabe muss im Artikel stehen.** Kein Weltwissen ergänzen, auch wenn es richtig wäre (Trump „at the beginning of his second term“ → kein Datum → kein Ereignis).
- **Regel B: Nur das Datum der Meldung bekannt → kein Ereignis.** „Russia damaged the plant, officials said on Tuesday“ (Dienstag = Aussage, nicht Angriff). Gilt auch, wenn gar kein Datum dasteht und nur das Publikationsdatum bekannt ist („Merz cancelled a plan to speak at the UN“).
  - Fällt dadurch die Hauptnachricht des Artikels weg, in `annotated.txt` mit `B` markieren: `265 B`.
- **Zeitbezug nur über ein undatiertes Ereignis** → kein Datum → kein Ereignis („shortly before the start of the academic year“).
- **Widersprüchliche Angaben** im Artikel → erste Nennung (Sitzung „on 22 September“, später „20 September meeting“ → 22.9.).
- **Unbestimmter Bezug auf ein anderes Ereignis** („shortly after the invasion in 2022“, „hours after a fire“) → nur übernehmen, was sicher folgt: Jahr unsicher → kein Ereignis; Tag unsicher → `month` (Brand vor dem Bericht vom Donnerstag → `month`).
- **Datum der Handlung, nicht des Inkrafttretens:** „In August, Spain doubled its diesel tax discount … from 1 September“ → August.
- **Zeitbezug übernehmen:** Eine Zeitangabe gilt für folgende Sätze weiter, solange sie erkennbar dieselbe Episode schildern (Mali-Offensive „In April“ → Tod des Verteidigungsministers, Fall von Kidal). Sie endet bei neuem Zeitbezug oder Themenwechsel.
- **Relative Angaben** über das Publikationsdatum auflösen (`cal 9 2026`):
  - Wochentage: das letzte vergangene, bei Zukunft („will convene on Sunday“) das nächste; ist der Wochentag der Erscheinungstag und steht das Verb im Futur („begins on Friday“ im Briefing vom Freitag), gilt der Erscheinungstag
  - auch in Zitaten über das Publikationsdatum auflösen („three days ago“, Gesprächsdatum unbekannt)
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

- „expected to“ + fester Termin → `planned` („expected to take place on 22 September“, „expected to launch“ im Wochenplan „Thursday“). „expected to“ als Prognose ohne Termin → kein Ereignis.
- Bloße Ankündigung → nicht die Ankündigung, sondern das angekündigte Geschehen mit dessen Termin (Merz kündigt Steuersenkung an; „taxes would be cut … from 1 October“ → Steuersenkung, 2026-10-01, `planned`). Absicht ohne festen Termin („aim of introducing a cap by 1 January 2027 at the latest“) → kein Ereignis.

## Abgrenzung: ein oder mehrere Ereignisse?

**Test:** Zählst du mehrere Geschehen („fünf Wahlen“) oder die Orte eines einzigen Geschehens („ein Taifun, vier Provinzen“)? Nur im ersten Fall wird aufgeteilt.

Die Begriffe folgen Hovy et al. (2013):

- **Subevent:** Teilschritt eines Ablaufs zur selben Zeit, am selben Ort und mit denselben Akteuren → mit dem Ganzen zusammenfassen. Handeln andere Akteure → eigenes Ereignis.
- **Membership:** mehrere gleichartige Geschehen, die als Menge berichtet werden → einzeln erfassen, wenn der Artikel sie einzeln nennt; nur gezählt → ein Ereignis.

| Regel | Beispiel |
|---|---|
| Dasselbe Geschehen wird pro Artikel nur **einmal** annotiert, egal wie oft es erwähnt wird | Duma-Wahl (10× erwähnt) → 1 Ereignis |
| Verschiedene **Hauptakteure** → getrennt, auch bei kausalem Zusammenhang | Harald V stirbt / Haakon wird König |
| **Mehrere Geschehen**, einzeln genannt → getrennt | Angriff auf Kuwait-Basis / Angriff auf VAE-Basis; elf Rücktritte mit Name und Jahr → 11 |
| **Reaktion** anderer Akteure → eigenes Ereignis | Dammbruch / Rettung von 1.260 Menschen; Sturmschaden / Evakuierung |
| **Unmittelbare Wirkung** gehört zum Geschehen | „embankment collapses, flattening 100 homes“, „attack kills 12“ |
| **Aufzählung getrennter Geschehen** → aufteilen | Wahlen in Polen, Italien, Spanien, Griechenland, Frankreich → 5 |
| **Aufzählung betroffener Orte** eines Geschehens → nicht aufteilen | Taifun über vier Provinzen → 1; Kundgebungen in Madrid, Barcelona und anderen Städten → 1 |
| Verschiedene **Gegenstände** mit eigenem Wert → getrennt | Diesel-Rekord / Benzin-Rekord am selben Tag → 2 |
| Nur **gezählte, nicht benannte** Geschehen → 1 | „two more state elections this weekend“ → 1 |
| **Teilschritt** (Subevent) oder **Beginn** eines Geschehens ist kein eigenes Ereignis | Minister besucht die Eröffnung einer Fabrik → nur die Eröffnung; Xi kommt am Mittwoch an / Gipfel diese Woche → 1 (Datum = Ankunft, `day`); „attacks continued early into Thursday“ → gehört zum Angriff |
| **Details** (Mittel, Ergebnisse anderer Beteiligter, Messwerte) → kein eigenes Ereignis | Waffentyp, Sitze der anderen Parteien, 416,5 mm Regen |
| Getrennte Abstimmungen am selben Tag → getrennt | Duma-Wahl / Wiederwahl Kadyrovs; Parlaments- / Präsidentschaftswahl Brasilien |
| Einzelner **Rekord- oder Höchstwert mit Datum** → Ereignis | Meereis-Maximum am 14. September |
| Ereignisse von Privatpersonen mit Datum → Ereignis | Freiwilliger tritt im Januar der Einheit bei; Autorin sieht den Film „last month“ in Paisley |

## Vorgehen pro Artikel

1. `art <Zeile>`, Wochentag des Publikationsdatums merken
2. Zeitausdrücke sind markiert, mit `n` einzeln anspringen und jeden Treffer prüfen (bei Briefings besonders wichtig, dort ca. 20–30 Minuten)
3. Rest überfliegen (Ereignisse ohne eigenes Zeitwort in derselben Episode)
4. Eintragen, Zeilennummer in `annotated.txt`
5. Neuer Grenzfall → Regel hier ergänzen, nicht nur im Kopf entscheiden
