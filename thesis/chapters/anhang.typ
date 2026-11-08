#import "../template.typ": *

= Prompts <anhang-prompts>

// Vollständige Prompts, Beispielausgaben, zusätzliche Tabellen.

Text …

= Skripte zur Datenanalyse <anhang-skripte>

#figure(
  ```bash
  jq -r '
    [.tags[] | select(.type == "tone") | .id | sub("^tone/"; "") | sub("-tone$"; "")] as $t
    | ["newsletter", "letters", "callout", "obituaries", "analysis",
       "explainers", "features", "profiles", "interview", "news"]
    | map(select(. as $p | $t | index($p))) | .[0] // "ohne Tag"
  ' guardian_world_2026-09.jsonl | sort | uniq -c | sort -rn
  ```,
  caption: [Zählen der Artikeltypen nach Priorität],
) <lst:laden>

#figure(
  ```bash
  jq '[(.headline + .body) | scan("[\u200b-\u200d\u2060\ufeff]")] | length' \
    guardian_world_2026-09.clean.jsonl \
    | awk '{s += $1; if ($1 > 0) n++} END {print s, "Zeichen in", n, "Artikeln"}'
  ```,
  caption: [Zählen der breitenlosen Zeichen],
) <lst:zero-width>

#figure(
  ```bash
  jq -s 'map(select(.body | test("was amended on"))) | length' \
    guardian_world_2026-09.clean.jsonl
  ```,
  caption: [Zählen der Artikel mit Korrekturhinweis],
) <lst:korrekturen>

= Weitere Ergebnisse

#figure(
  table(
    columns: 5,
    align: (left, right, right, right, right),
    table.header([*Ereignis*], [*Jev Mittel*], [*Jev Spanne*], [*Haiku Mittel*], [*Haiku Spanne*]),
    [Ratte in Alberta], [2,77], [2,64–2,91], [0,67], [0,50–1,00],
    [Angriff auf Geheimdienst-HQ], [3,00], [2,98–3,03], [2,79], [2,50–3,10],
    [Schiffe in der Straße von Hormus], [3,31], [3,28–3,33], [3,50], [3,50–3,50],
  ),
  caption: [Vortest der Gewichtung mit zehn Aufrufen je Ereignis],
) <tab:vortest>
