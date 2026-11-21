// ============================================================
//  TEMPLATE ACCADEMICO PER PRESENTAZIONI — Typst
//  Stesso stile di template.typ (appunti), formato 16:9.
//
//  Uso:
//    #import "slides-template.typ": *
//    #show: slides.with(title: "...", authors: (...), ...)
//
//  Struttura (basata sui titoli):
//    = Sezione        -> marcatore (nessuna slide), nome in alto a destra
//    == Titolo slide  -> nuova slide con titolo
//    (testo, box, ecc. sotto il titolo)
// ============================================================

// ---------- Palette colori (identica al template appunti) ----------
#let c-primary = rgb("#1a365d")
#let c-secondary = rgb("#2c5282")
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

#let c-exam-bg = rgb("#fff0f7")
#let c-exam-bd = rgb("#c23b7a")
#let c-recall-bg = rgb("#eefafa")
#let c-recall-bd = rgb("#1f8a8a")

// --------- Variabili matematiche (invariate) -------
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

// ---------- Box generico ----------
#let styled-box(title, bg, bd, body) = block(
  width: 100%,
  fill: bg,
  stroke: (left: 4pt + bd),
  inset: (left: 16pt, right: 16pt, top: 12pt, bottom: 12pt),
  radius: (top-right: 5pt, bottom-right: 5pt),
  above: 0.8em,
  below: 0.8em,
  breakable: false,
)[
  #if title != none [
    #text(weight: "bold", size: 0.9em, fill: bd)[#title]
    #v(0.3em)
  ]
  #text(size: 0.9em)[#body]
]

#let styled-block(
  fill: c-def-bg,
  border: c-def-bd,
  title: none,
  body,
) = styled-box(title, fill, border, body)

// ---------- Box semantici ----------
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

#let formula(name: none, body) = figure(
  kind: "formula",
  supplement: [Formula],
  numbering: "1",
  gap: 0pt,
  outlined: false,
  caption: name,
  body,
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

#let note(body) = styled-box("Nota", c-note-bg, c-note-bd, body)
#let warning(body) = styled-box("Attenzione", c-warn-bg, c-warn-bd, body)

// ---------- Utilità per slide ----------

// Separatore orizzontale
#let separator(
  color: c-border,
  thickness: 0.6pt,
  width: 100%,
  above: 0.8em,
  below: 0.8em,
) = block(above: above, below: below, width: 100%)[
  #align(center)[#line(length: width, stroke: thickness + color)]
]

// Due colonne (o più): #cols[...][...]
#let cols(..bodies, gutter: 1.2em, columns: auto) = {
  let items = bodies.pos()
  grid(
    columns: if columns == auto { (1fr,) * items.len() } else { columns },
    gutter: gutter,
    ..items,
  )
}

// Frase/messaggio centrale a tutto schermo
#let focus(body) = align(center + horizon)[
  #block(width: 85%)[
    #text(size: 1.6em, weight: "bold", fill: c-primary)[#body]
  ]
]

// Testo "spento" (per dettagli secondari)
#let muted(body) = text(fill: c-muted, size: 0.85em)[#body]

// Slide con titolo libero (alternativa a "== Titolo")
#let slide(title: none, body) = {
  if title != none { heading(level: 2, title) }
  body
}

// ============================================================
//  FUNZIONE PRINCIPALE DEL TEMPLATE
// ============================================================
#let slides(
  title: "",
  subtitle: none,
  authors: (),
  date: none,
  institution: none,
  body,
) = {
  // ---------- Metadati ----------
  set document(title: title, author: authors.map(a => a.name))

  // ---------- Tipografia ----------
  set text(font: "New Computer Modern", size: 20pt, lang: "it")
  set par(justify: false, leading: 0.7em, first-line-indent: 0pt)
  set list(indent: 0.6em, body-indent: 0.6em, marker: ([•], [–], [·]))
  set enum(indent: 0.6em, body-indent: 0.6em)
  show list: set block(above: 0.9em, below: 0.9em)
  show enum: set block(above: 0.9em, below: 0.9em)
  set list(spacing: 0.9em)
  set enum(spacing: 0.9em)

  // ---------- Pagina (16:9) ----------
  set page(
    paper: "presentation-16-9",
    margin: (x: 1.8cm, top: 2.6cm, bottom: 1.9cm),
    header: context {
      let secs = query(heading.where(level: 1).before(here()))
      align(right + horizon)[
        #text(size: 12pt, fill: c-secondary, style: "italic")[
          #if secs.len() > 0 [#secs.len() #h(0.2em) · #h(0.2em) #secs.last().body]
        ]
      ]
    },
    footer: context {
      let cur = counter(page).get().first()
      let tot = counter(page).final().first()
      let frac = cur / tot
      stack(
        dir: ttb,
        spacing: 0.35em,
        // barra di avanzamento
        block(width: 100%, height: 2.5pt, fill: c-border, radius: 1pt)[
          #block(width: frac * 100%, height: 2.5pt, fill: c-primary, radius: 1pt)
        ],
        grid(
          columns: (1fr, 2fr, 1fr),
          align(left)[
            #text(size: 10pt, fill: c-muted)[
              #if authors.len() > 0 [#authors.first().name]
            ]
          ],
          align(center)[
            #text(size: 10pt, fill: c-muted)[#title]
          ],
          align(right)[
            #text(size: 10pt, fill: c-text-grey)[#cur / #tot]
          ],
        ),
      )
    },
  )

  // ---------- Riferimenti ----------
  show ref: it => box(
    fill: rgb("#e3f0fb"),
    stroke: 0.5pt + rgb("#9cc5e8"),
    inset: (x: 4pt),
    outset: (y: 3pt),
    radius: 2pt,
    text(size: 0.85em, fill: rgb("#1a4f80"), it),
  )

  // ---------- Figure speciali ----------
  show figure.where(kind: "definizione"): set block(breakable: false)
  show figure.where(kind: "esempio"): set block(breakable: false)
  show figure.where(kind: "teorema"): set block(breakable: false)
  show figure.where(kind: "esame"): it => context {
    let n = counter(figure.where(kind: "esame")).at(it.location()).first()
    styled-box([📝 Possibile domanda d'esame #n], c-exam-bg, c-exam-bd, [
      #it.body
      #if it.caption != none [
        #v(0.2em)
        #line(length: 100%, stroke: 0.5pt + c-exam-bd)
        #v(0.2em)
        #text(weight: "bold", fill: c-exam-bd)[Risposta.] #it.caption.body
      ]
    ])
  }
  show figure.where(kind: "formula"): it => context {
    let n = counter(figure.where(kind: "formula")).at(it.location()).first()
    styled-box(
      [Formula #n] + if it.caption != none [ --- #it.caption.body] else [],
      c-def-bg,
      c-def-bd,
      align(center, it.body),
    )
  }

  show math.equation.where(block: true): set block(above: 1.2em, below: 1.2em)

  // ---------- Titoli ----------
  set heading(numbering: "1")

  // Livello 1: sezione -> nessuna slide propria, solo un marcatore.
  // Il nome compare in alto a destra su tutte le slide della sezione.
  show heading.where(level: 1): it => []

  // Livello 2: titolo di una nuova slide
  show heading.where(level: 2): it => {
    pagebreak(weak: true)
    place(
      top + left,
      dy: -1.7cm,
      block(width: 100%)[
        #text(weight: "bold", size: 26pt, fill: c-primary)[#it.body]
        #v(-0.2em)
        #line(length: 100%, stroke: 1.2pt + c-primary)
      ],
    )
  }

  // Livello 3: sottotitolo dentro la slide
  show heading.where(level: 3): it => block(above: 1em, below: 0.6em)[
    #text(weight: "bold", size: 1.1em, fill: c-secondary)[#it.body]
  ]

  show heading.where(level: 4): it => block(above: 0.8em, below: 0.5em)[
    #text(weight: "bold", size: 1em, fill: c-tertiary, style: "italic")[#it.body]
  ]

  // ---------- Link ----------
  show link: it => text(fill: c-secondary)[#underline(it)]

  // ---------- Citazioni ----------
  show quote: it => block(
    width: 100%,
    fill: rgb("#f7f7f8"),
    inset: (left: 14pt, right: 14pt, top: 10pt, bottom: 10pt),
    stroke: (left: 3pt + c-border),
  )[#text(style: "italic")[#it.body]]

  // ---------- Codice ----------
  show raw.where(block: true): it => block(
    width: 100%,
    fill: c-code-bg,
    inset: 12pt,
    radius: 4pt,
    stroke: 0.6pt + c-border,
  )[#text(font: "DejaVu Sans Mono", size: 0.7em)[#it]]

  show raw.where(block: false): it => box(
    fill: c-code-bg,
    inset: (x: 3pt, y: 0pt),
    outset: (y: 2pt),
    radius: 2pt,
  )[#text(font: "DejaVu Sans Mono", size: 0.8em)[#it]]

  // ---------- Tabelle ----------
  set table(
    stroke: (x, y) => if y == 0 { (bottom: 1pt + c-primary) } else { (bottom: 0.4pt + c-border) },
    inset: 9pt,
  )
  show table.cell.where(y: 0): set text(weight: "bold", fill: c-primary)

  // ---------- Figure e didascalie ----------
  show figure.caption: it => text(size: 0.65em, fill: c-muted)[
    #text(weight: "bold")[#it.supplement #context it.counter.display(it.numbering).] #it.body
  ]

  // ---------- Note a piè di pagina ----------
  set footnote.entry(indent: 0em)
  show footnote.entry: it => text(size: 10pt, fill: c-text-grey)[#it]

  // ============================================================
  //  SLIDE DI TITOLO
  // ============================================================
  page(
    margin: (x: 2.5cm, y: 2cm),
    header: none,
    footer: none,
    fill: white,
  )[
    // fascia colorata a sinistra
    #place(top + left, dx: -2.5cm, dy: -2cm, rect(width: 0.9cm, height: 100% + 4cm, fill: c-primary))
    #place(top + left, dx: -1.6cm, dy: -2cm, rect(width: 0.25cm, height: 100% + 4cm, fill: c-quarternary))

    #align(center + horizon)[
      #text(size: 38pt, weight: "bold", fill: c-primary)[#title]
      #if subtitle != none [
        #v(0.4em)
        #text(size: 22pt, fill: c-secondary, style: "italic")[#subtitle]
      ]
      #v(1.2em)
      #line(length: 30%, stroke: 1.5pt + c-primary)
      #v(1.2em)

      #grid(
        columns: (1fr,) * calc.max(1, calc.min(3, authors.len())),
        gutter: 1.5em,
        ..authors.map(a => align(center)[
          #text(weight: "bold", size: 16pt)[#a.name] \
          #text(size: 12pt, fill: rgb("#444444"))[
            #if "affiliation" in a [#a.affiliation \ ]
            #if "email" in a [#link("mailto:" + a.email)[#a.email]]
          ]
        ])
      )

      #if institution != none [
        #v(0.8em)
        #text(size: 14pt, fill: c-text-grey)[#institution]
      ]
      #if date != none [
        #v(0.6em)
        #text(size: 12pt, fill: c-muted)[#date]
      ]
    ]
  ]

  // ============================================================
  //  CORPO
  // ============================================================
  body
}

