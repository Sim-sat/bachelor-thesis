// Bachelorarbeit – Einstieg
// Kompilieren: typst compile thesis/main.typ

#import "template.typ": *

#show: thesis.with(
  title: [Automatische Extraktion von Ereignissen aus Nachrichtenartikeln mit großen Sprachmodellen],
  author: "Simon Sattelberger",
  student-id: "q7362730",
  supervisor: [Prof. Dr.-Ing. habil. Dr. h.c. Herwig Unger],
  chair: [Lehrgebiet Kommunikationsnetze],
  date: "TT.MM.JJJJ",
  logo: "feu-logo_blau_2018.jpg",
)

// ---------------------------------------------------------------- Verzeichnisse (römisch)

#outline(depth: 3)
#list-of(image, [Abbildungsverzeichnis])
#list-of(table, [Tabellenverzeichnis])
#list-of(raw, [Quelltextverzeichnis])

// ---------------------------------------------------------------- Hauptteil (arabisch)

#show: main-matter

#include "chapters/01-einleitung.typ"
#include "chapters/02-grundlagen.typ"
#include "chapters/03-methodik.typ"
#include "chapters/04-umsetzung.typ"
#include "chapters/05-evaluation.typ"
#include "chapters/06-diskussion.typ"
#include "chapters/07-fazit.typ"

// ---------------------------------------------------------------- Schlussteil (römisch, fortgesetzt)

#show: back-matter

#abbreviation-list()
#bibliography("references.bib", style: "ieee", title: [Literaturverzeichnis])

#show: appendix

#include "chapters/anhang.typ"
