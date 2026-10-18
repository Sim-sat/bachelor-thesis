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

Text …
