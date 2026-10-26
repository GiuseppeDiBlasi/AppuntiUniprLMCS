// ============================================================
//  TEMPLATE ACCADEMICO PER APPUNTI — Typst
//  Uso:
//    #import "template.typ": academic-paper, definition, theorem,
//                             example, note, warning
//    #show: academic-paper.with(title: "...", authors: (...), ...)
// ============================================================

// ---------- Palette colori ----------
#let c-primary = rgb("#1a365d")   // blu accademico (titoli)
#let c-secondary = rgb("#2c5282")   // blu più chiaro (sottotitoli)
#let c-text-grey = rgb("#555555")
#let c-muted = rgb("#666666")
#let c-border = rgb("#c9d6e3")
#let c-tertiary = rgb("#4a7ab5")
#let c-quarternary = rgb("#3492eb")

#let c-def-bg = rgb("#eef4fb")
#let c-def-bd = rgb("#3170b8")
#let c-thm-bg = rgb("#f5eefb")
#let c-thm-bd = rgb("#7c3fb8")
#let c-ex-bg = rgb("#eefbf1")
#let c-ex-bd = rgb("#2f9e52")
#let c-note-bg = rgb("#fff9e6")
#let c-note-bd = rgb("#c99a1e")
#let c-warn-bg = rgb("#fdeeee")
#let c-warn-bd = rgb("#c0392b")
#let c-code-bg = rgb("#f4f5f7")

#let c-exam-bg = rgb("#fff0f7")   // rosa chiaro di sfondo
#let c-exam-bd = rgb("#c23b7a")   // magenta/rosa scuro per bordo/titolo

#let c-recall-bg = rgb("#eefafa")   // azzurro-teal chiaro
#let c-recall-bd = rgb("#1f8a8a")   // teal scuro per bordo/titolo

// --------- Variabili matematiche -------
#let sqle(x) = $scripts(subset.sq.eq)_(#x)$
#let supqle(x) = $scripts(supset.sq.eq)_(#x)$
#let sqlub(x) = $scripts(union.sq)_(#x)$
#let sqglb(x) = $scripts(inter.sq)_(#x)$

#let sleq(x) = $scripts(subset.eq)_(#x)$
#let slt(x) = $scripts(subset)_(#x)$

#let galois(c, a, alpha: $alpha$, gamma: $gamma$, gap: 6pt, base: 30%) = {
  $
    #c #box(baseline: base, stack(
      dir: ttb,
      spacing: gap,
      $attach(arrow.r.long, t: #alpha)$,
      $attach(arrow.l.long, b: #gamma)$,
    )) #a
  $
}

#let lbs = $bracket.l.stroked$
#let rbs = $bracket.r.stroked$

#let lps = $paren.l.stroked$
#let rps = $paren.r.stroked$

// ---------- Contatori per box numerati ----------
#let def-counter = counter("definition")
#let thm-counter = counter("theorem")
#let ex-counter = counter("example")


// ---------- Funzione generica per i box ----------
#let styled-box(title, bg, bd, body) = block(
  width: 100%,
  fill: bg,
  stroke: (left: 3pt + bd),
  inset: (left: 12pt, right: 12pt, top: 9pt, bottom: 9pt),
  radius: (top-right: 4pt, bottom-right: 4pt),
  above: 1em,
  below: 1em,
)[
  #if title != none [
    #text(weight: "bold", size: 10.5pt, fill: bd)[#title]
    #v(0.3em)
  ]
  #text(size: 10.5pt)[#body]
]

// ---------- Box generico "neutro" (nessuna etichetta/numerazione) ----------
// Utile quando vuoi solo sfondo + bordo colorato + angoli arrotondati,
// senza le categorie semantiche (definizione, teorema, ecc.) e i loro contatori.
// Esempio d'uso:
//   #styled-block[Testo con lo stile di default (blu).]
//   #styled-block(fill: rgb("#f0f0f0"), border: rgb("#888888"))[Testo grigio.]
//   #styled-block(title: "Osservazione")[Testo con un titolo a scelta.]
#let styled-block(
  fill: c-def-bg,
  border: c-def-bd,
  title: none,
  body,
) = styled-box(title, fill, border, body)

// ---------- Box semantici pronti all'uso ----------
#let definition(name: none, body) = figure(
  kind: "definizione",
  supplement: [Definizione],
  numbering: "1",
  gap: 0pt,
  outlined: false,
  {
    set align(left)
    context {
      let n = counter(figure.where(kind: "definizione")).display("1")
      styled-box(
        [Definizione #n] + if name != none [ --- #name] else [],
        c-def-bg,
        c-def-bd,
        body,
      )
    }
  },
)



#let exam(answer: none, body) = figure(
  kind: "esame",
  supplement: [Domanda],
  numbering: "1",
  gap: 0pt,
  outlined: false,
  caption: answer,
  body,
)

#let recall(topic: none, body) = styled-box(
  if topic != none [🔁 Richiamo — #topic] else [🔁 Richiamo],
  c-recall-bg,
  c-recall-bd,
  body,
)

#let theorem(name: none, body) = figure(
  kind: "teorema",
  supplement: [Teorema],
  numbering: "1",
  gap: 0pt,
  outlined: false,
  {
    set align(left)
    context {
      let n = counter(figure.where(kind: "teorema")).display("1")
      styled-box(
        [Teorema #n] + if name != none [ --- #name] else [],
        c-thm-bg,
        c-thm-bd,
        body,
      )
    }
  },
)

#let example(name: none, body) = figure(
  kind: "esempio",
  supplement: [Esempio],
  numbering: "1",
  gap: 0pt,
  outlined: false,
  {
    set align(left)
    context {
      let n = counter(figure.where(kind: "esempio")).display("1")
      styled-box(
        [Esempio #n] + if name != none [ --- #name] else [],
        c-ex-bg,
        c-ex-bd,
        body,
      )
    }
  },
)

#let note(body) = styled-box("Nota", c-note-bg, c-note-bd, body)
#let warning(body) = styled-box("Attenzione", c-warn-bg, c-warn-bd, body)

// ---------- Separatore orizzontale ----------
// Uso:
//   #separator()                         // linea di default
//   #separator(color: c-secondary)       // colore a scelta
//   #separator(thickness: 1.2pt, above: 2em, below: 2em)
#let separator(
  color: c-border,
  thickness: 0.6pt,
  width: 100%,
  above: 1.2em,
  below: 1.2em,
) = block(above: above, below: below, width: 100%)[
  #align(center)[
    #line(length: width, stroke: thickness + color)
  ]
]

#let exam-appendix(title: "Appendice: domande d'esame") = {
  heading(level: 1, numbering: none)[#title]

  context {
    let items = query(figure.where(kind: "esame"))
    if items.len() == 0 [
      _Nessuna domanda d'esame segnalata._
    ] else {
      for it in items {
        let loc = it.location()
        let n = counter(figure.where(kind: "esame")).at(loc).first()
        let page-n = counter(page).at(loc).first()
        let hs = query(selector(heading).before(loc))

        let origin = text(size: 8.5pt, weight: "regular", fill: c-muted)[
          #if hs.len() > 0 [
            #link(hs.last().location())[#hs.last().body], #h(0.3em)
          ]
          #link(loc)[pag. #page-n]
        ]

        styled-box(
          [📝 Domanda #n #h(1fr) #origin],
          c-exam-bg,
          c-exam-bd,
          [
            #it.body
            #if it.caption != none [
              #v(0.2em)
              #line(length: 100%, stroke: 0.5pt + c-exam-bd)
              #v(0.2em)
              #text(weight: "bold", fill: c-exam-bd)[Risposta.] #it.caption.body
            ]
          ],
        )
      }
    }
  }
}

// ============================================================
//  FUNZIONE PRINCIPALE DEL TEMPLATE
// ============================================================
#let academic-paper(
  title: "",
  subtitle: none,
  authors: (),
  date: none,
  abstract: none,
  toc: true, // mostra l'indice
  toc-depth: 2, // profondità indice (livelli di heading)
  body,
) = {
  // ---------- Metadati documento ----------
  set document(title: title, author: authors.map(a => a.name))

  // ---------- Impostazioni pagina ----------
  set page(
    paper: "a4",
    margin: (x: 2.5cm, top: 3cm, bottom: 2.7cm),
    header: context [
      #if counter(page).get().first() > 1 [
        #align(right)[
          #text(size: 8.5pt, fill: c-text-grey, style: "italic")[#title]
        ]
        #line(length: 100%, stroke: 0.4pt + c-border)
      ]
    ],
    footer: context [
      #line(length: 100%, stroke: 0.4pt + c-border)
      #v(0.2em)
      #grid(
        columns: (1fr, 1fr),
        align(left)[
          #text(size: 8pt, fill: c-muted)[
            #if authors.len() > 0 [#authors.first().name]
          ]
        ],
        align(right)[
          #text(size: 9pt, fill: c-text-grey)[
            #counter(page).display("1 / 1", both: true)
          ]
        ],
      )
    ],
  )

  show ref: it => box(
    fill: rgb("#e3f0fb"),
    stroke: 0.5pt + rgb("#9cc5e8"),
    inset: (x: 4pt),
    outset: (y: 3pt),
    radius: 2pt,
    text(size: 0.85em, fill: rgb("#1a4f80"), it),
  )

  show figure.where(kind: "definizione"): set block(breakable: true)
  show figure.where(kind: "esempio"): set block(breakable: true)
  show figure.where(kind: "teorema"): set block(breakable: true)
  show figure.where(kind: "esame"): it => context {
    let n = counter(figure.where(kind: "esame")).at(it.location()).first()
    styled-box([📝 Possibile domanda d'esame #n], c-exam-bg, c-exam-bd, it.body)
  }

  show math.equation.where(block: true): set block(above: 2em, below: 2em)

  // ---------- Tipografia base ----------
  set text(font: "New Computer Modern", size: 11pt, lang: "it")
  set par(justify: true, leading: 0.72em, first-line-indent: 0pt)

  // ---------- Numerazione ed enfasi dei titoli ----------
  set heading(numbering: "1.1")

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(0.3em)
    block(width: 100%)[
      #line(length: 100%, stroke: 1.2pt + c-primary)
      #v(0.4em)
      #text(font: "New Computer Modern", weight: "bold", size: 18pt, fill: c-primary)[
        #if it.numbering != none [#counter(heading).display() #h(0.4em)]
        #it.body
      ]
    ]
    v(0.6em)
  }

  show heading.where(level: 2): it => block(above: 1.8em, below: 0.8em)[
    #text(font: "New Computer Modern", weight: "bold", size: 13.5pt, fill: c-secondary)[
      #if it.numbering != none [#counter(heading).display() #h(0.4em)]
      #it.body
    ]
  ]

  show heading.where(level: 3): it => block(above: 2.2em, below: 0.6em)[
    #text(font: "New Computer Modern", weight: "bold", size: 11.5pt, fill: c-tertiary, style: "italic")[
      #if it.numbering != none [#counter(heading).display() #h(0.4em)]
      #it.body
    ]
  ]

  show heading.where(level: 4): it => block(above: 2.2em, below: 0.6em)[
    #text(font: "New Computer Modern", weight: "bold", size: 11.5pt, fill: c-tertiary, style: "italic")[
      #if it.numbering != none [#counter(heading).display() #h(0.4em)]
      #it.body
    ]
  ]

  // ---------- Link ----------
  show link: it => text(fill: c-secondary)[#underline(it)]

  // ---------- Citazioni ----------
  show quote: it => block(
    width: 100%,
    fill: rgb("#f7f7f8"),
    inset: (left: 12pt, right: 12pt, top: 8pt, bottom: 8pt),
    stroke: (left: 2.5pt + c-border),
  )[#text(style: "italic")[#it.body]]

  // ---------- Codice ----------
  show raw.where(block: true): it => block(
    width: 100%,
    fill: c-code-bg,
    inset: 10pt,
    radius: 4pt,
    stroke: 0.6pt + c-border,
  )[#text(font: "DejaVu Sans Mono", size: 9.3pt)[#it]]

  show raw.where(block: false): it => box(
    fill: c-code-bg,
    inset: (x: 3pt, y: 0pt),
    outset: (y: 2pt),
    radius: 2pt,
  )[#text(font: "DejaVu Sans Mono", size: 9.3pt)[#it]]

  // ---------- Tabelle ----------
  set table(
    stroke: (x, y) => if y == 0 { (bottom: 1pt + c-primary) } else { (bottom: 0.4pt + c-border) },
    inset: 7pt,
  )
  show table.cell.where(y: 0): set text(weight: "bold", fill: c-primary)

  // ---------- Figure e didascalie ----------
  show figure.caption: it => text(size: 9pt, fill: c-muted)[
    #text(weight: "bold")[#it.supplement #context it.counter.display(it.numbering).] #it.body
  ]

  // ---------- Note a piè di pagina ----------
  set footnote.entry(indent: 0em)
  show footnote.entry: it => text(size: 8.5pt, fill: c-text-grey)[#it]

  // ============================================================
  //  BLOCCO FRONTESPIZIO
  // ============================================================
  v(1cm)
  align(center)[
    #text(size: 20pt, weight: "bold", fill: c-primary)[#title]
    #if subtitle != none [
      #v(0.4em)
      #text(size: 13pt, fill: c-secondary, style: "italic")[#subtitle]
    ]
    #v(1.6em)

    #grid(
      columns: (1fr,) * calc.max(1, calc.min(3, authors.len())),
      gutter: 2.2em,
      ..authors.map(a => align(center)[
        #text(weight: "bold", size: 10.5pt)[#a.name] \
        #text(size: 9pt, fill: rgb("#444444"))[
          #if "affiliation" in a [#a.affiliation \ ]
          #if "email" in a [#link("mailto:" + a.email)[#a.email]]
        ]
      ])
    )

    #if date != none [
      #v(1em)
      #text(size: 9.5pt, fill: c-muted)[#date]
    ]
  ]

  v(1.8em)

  // ---------- Abstract ----------
  if abstract != none {
    pad(x: 1.5cm)[
      #align(center)[
        #text(weight: "bold", size: 10pt, fill: c-primary, tracking: 0.5pt)[ABSTRACT]
      ]
      #v(0.5em)
      #par(justify: true)[
        #text(size: 9.5pt, style: "italic")[#abstract]
      ]
    ]
    v(1.5em)
  }

  // ---------- Indice ----------
  if toc {
    line(length: 100%, stroke: 0.4pt + c-border)
    v(0.5em)
    text(size: 12pt, weight: "bold", fill: c-primary)[Indice]
    v(0.3em)
    outline(depth: toc-depth, indent: auto)
    v(0.5em)
    line(length: 100%, stroke: 0.4pt + c-border)
    pagebreak()
  }

  // ============================================================
  //  CORPO DEL DOCUMENTO
  // ============================================================
  body
}
