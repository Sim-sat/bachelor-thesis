// Vorlage zur Bachelorarbeit
// Layout angelehnt an die scrbook-Vorlage (12pt, Ränder 2,8/2,8/3/4 cm, Zeilenabstand 1,2)

#import "abbreviations.typ": abbreviations

#let darkblue = rgb(0, 0, 100)
#let darkred = rgb(100, 0, 25)

// "1" im Hauptteil, "A" im Anhang – Präfix für Abbildungs- und Gleichungsnummern
#let _chapter-numbering = state("chapter-numbering", "1")
// letzte römische Seitenzahl vor dem Hauptteil (entspricht SeitenzahlSpeicher)
#let _front-last-page = state("front-last-page", 0)
#let _acr-used = state("acr-used", ())

#let _figure-kinds = (image, table, raw, "algorithm")

// Kopfzeile mit aktuellem Kapitel, entfällt auf Seiten mit Kapitelanfang
#let _chapter-header = context {
  let page = here().page()
  if query(heading.where(level: 1)).any(h => h.location().page() == page) { return }
  let before = query(heading.where(level: 1).before(here()))
  if before.len() == 0 { return }
  let hd = before.last()
  set text(size: 10pt, style: "italic")
  if hd.numbering != none {
    numbering(hd.numbering, ..counter(heading).at(hd.location()))
    h(0.6em)
  }
  hd.body
  v(-0.6em)
  line(length: 100%, stroke: 0.4pt)
}

// ---------------------------------------------------------------- Abkürzungen

#let _acr-entry(key) = {
  assert(key in abbreviations, message: "Unbekannte Abkürzung: " + key)
  abbreviations.at(key)
}

#let _acr-mark(key) = _acr-used.update(u => if key in u { u } else { u + (key,) })

// Erste Verwendung: Langform (Kurzform), danach nur Kurzform
#let acr(key) = {
  let (short, long) = _acr-entry(key)
  context {
    let target = label("acr-" + key)
    if key in _acr-used.get() { link(target, short) } else [#long (#link(target, short))]
  }
  _acr-mark(key)
}

// Immer Kurzform bzw. immer Langform
#let acrs(key) = {
  link(label("acr-" + key), _acr-entry(key).at(0))
  _acr-mark(key)
}
#let acrl(key) = {
  _acr-entry(key).at(1)
  _acr-mark(key)
}

#let abbreviation-list(title: [Abkürzungsverzeichnis]) = {
  heading(numbering: none, title)
  context {
    let used = _acr-used.final()
    let keys = abbreviations.keys().filter(k => k in used).sorted(key: k => lower(abbreviations.at(k).at(0)))
    grid(
      columns: (auto, 1fr),
      column-gutter: 2em,
      row-gutter: 0.9em,
      ..keys
        .map(k => {
          let (short, long) = abbreviations.at(k)
          ([#metadata(k)#label("acr-" + k)#strong(short)], long)
        })
        .flatten(),
    )
  }
}

// ---------------------------------------------------------------- Verzeichnisse

// Abbildungs-, Tabellen- oder Quelltextverzeichnis; entfällt, wenn leer
#let list-of(kind, title) = context {
  if query(figure.where(kind: kind)).len() > 0 {
    outline(title: title, target: figure.where(kind: kind))
  }
}

// ---------------------------------------------------------------- Umgebungen

#let algorithm(caption: none, body) = figure(
  kind: "algorithm",
  supplement: [Algorithmus],
  caption: caption,
  block(width: 100%, stroke: (y: 0.6pt), inset: (y: 0.6em), align(left, body)),
)

// ---------------------------------------------------------------- Seitenbereiche

#let main-matter(body) = {
  context _front-last-page.update(counter(page).get().first())
  set page(numbering: "1", header: _chapter-header)
  counter(page).update(1)
  body
}

// Abkürzungsverzeichnis, Literatur, Anhang: römisch, fortgesetzt nach den Verzeichnissen
#let back-matter(body) = {
  set page(numbering: "I")
  context counter(page).update(_front-last-page.get() + 1)
  body
}

#let appendix(body) = {
  set heading(numbering: "A.1", supplement: [Anhang])
  counter(heading).update(0)
  _chapter-numbering.update("A")
  body
}

// ---------------------------------------------------------------- Titelseite

#let _title-page(
  title,
  subtitle,
  author,
  student-id,
  degree,
  supervisor,
  second-supervisor,
  chair,
  faculty,
  date,
  logo,
) = page(numbering: none, header: none, {
  set align(center)
  set par(justify: false)
  set text(hyphenate: false)
  if logo != none { image(logo, width: 65%) } else {
    text(size: 18pt, weight: "bold")[FernUniversität in Hagen]
  }
  v(0.5em)
  text(size: 13pt)[#faculty \ #chair]

  v(1fr)
  text(size: 14pt, smallcaps[Bachelorarbeit])
  v(1em)
  text(size: 22pt, weight: "bold", title)
  if subtitle != none {
    v(0.5em)
    text(size: 15pt, subtitle)
  }
  v(1em)
  text(size: 13pt)[zur Erlangung des akademischen Grades \ #degree]
  v(1fr)

  set align(left)
  grid(
    columns: (auto, 1fr),
    column-gutter: 1.5em,
    row-gutter: 0.8em,
    [Vorgelegt von:], author,
    [Matrikelnummer:], student-id,
    [Betreuer:], supervisor,
    ..if second-supervisor != none { ([Zweitgutachter:], second-supervisor) },
    [Abgabedatum:], date,
  )
})

// ---------------------------------------------------------------- Hauptfunktion

#let thesis(
  title: [Titel der Arbeit],
  subtitle: none,
  author: "Vorname Nachname",
  student-id: "",
  degree: [Bachelor of Science (B.Sc.) Informatik],
  supervisor: [],
  second-supervisor: none,
  chair: [Lehrgebiet],
  faculty: [Fakultät für Mathematik und Informatik],
  date: datetime.today().display("[day].[month].[year]"),
  logo: none,
  body,
) = {
  set document(title: title, author: author)
  set page(
    paper: "a4",
    margin: (left: 2.8cm, right: 2.8cm, top: 3cm, bottom: 4cm),
    numbering: "I",
  )
  set text(font: "Libertinus Serif", size: 12pt, lang: "de", region: "DE")
  set par(justify: true, leading: 0.85em, spacing: 1.3em, first-line-indent: 0pt)

  // Überschriften
  set heading(numbering: "1.1")
  show heading: set block(above: 1.6em, below: 1em)
  show heading.where(level: 1): set heading(supplement: [Kapitel])
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    for kind in _figure-kinds { counter(figure.where(kind: kind)).update(0) }
    counter(math.equation).update(0)
    v(2.5em)
    set text(size: 22pt, weight: "bold")
    block(below: 1.5em, {
      if it.numbering != none {
        context numbering(it.numbering, ..counter(heading).at(it.location()))
        h(0.8em)
      }
      it.body
    })
  }
  show heading.where(level: 2): set text(size: 15pt)
  show heading.where(level: 3): set text(size: 13pt)

  // Verweise, Zitate, URLs
  show ref: set text(fill: darkblue)
  // Kapitelnummer am Ort der Abbildung bestimmen, nicht am Ort des Verweises
  show ref: it => {
    let el = it.element
    if el == none or el.func() != figure or el.numbering == none { return it }
    context {
      let loc = el.location()
      let fmt = _chapter-numbering.at(loc) + ".1"
      let num = numbering(fmt, counter(heading).at(loc).first(), ..el.counter.at(loc))
      link(loc, [#el.supplement~#num])
    }
  }
  show cite: set text(fill: darkred)
  show link: it => if type(it.dest) == str { text(fill: blue, it) } else { it }

  // Verzeichnisse: Kapitel fett; Abbildungen usw. mit Kapitelnummer an ihrer eigenen Stelle
  show outline.entry: it => {
    let el = it.element
    if el.func() == heading {
      if it.level == 1 {
        block(above: 1.6em, below: 0.9em, strong(it))
      } else { block(above: 0.9em, below: 0.9em, it) }
    } else if el.func() == figure {
      let loc = el.location()
      let fmt = _chapter-numbering.at(loc) + ".1"
      let num = numbering(fmt, counter(heading).at(loc).first(), ..el.counter.at(loc))
      link(loc, it.indented(num, it.inner(), gap: 1em))
    } else { it }
  }

  // Abbildungen, Tabellen, Quelltexte – kapitelweise nummeriert (z. B. 2.3)
  let chapter-wise(fmt) = n => context numbering(
    fmt.replace("1", _chapter-numbering.get(), count: 1),
    counter(heading).get().first(),
    n,
  )
  set figure(numbering: chapter-wise("1.1"))
  set math.equation(numbering: chapter-wise("(1.1)"))
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: raw): set figure(supplement: [Quelltext])
  show figure.where(kind: raw): set figure.caption(position: top)
  show figure: set block(breakable: true)
  set table(stroke: (x, y) => if y == 0 { (bottom: 0.6pt) }, inset: 0.5em)

  // Quelltext: grauer Hintergrund, Zeilennummern
  show raw: set text(font: "DejaVu Sans Mono", size: 9pt)
  show raw.where(block: true): it => {
    show raw.line: l => {
      box(width: 1.6em, align(right, text(fill: luma(120), str(l.number))))
      h(0.8em)
      l.body
    }
    block(fill: luma(240), inset: 0.7em, radius: 2pt, width: 100%, align(left, it))
  }

  _title-page(
    title,
    subtitle,
    author,
    student-id,
    degree,
    supervisor,
    second-supervisor,
    chair,
    faculty,
    date,
    logo,
  )
  counter(page).update(1)
  body
}
