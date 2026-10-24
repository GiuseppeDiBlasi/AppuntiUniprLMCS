// ============================================================
// REFERENCE.TYP — Cheat sheet completo dei componenti Typst
// Compila con:  typst compile reference.typ
// Preview live: typst watch reference.typ  (o :TypstPreview in Neovim)
// ============================================================

#set document(title: "Typst Reference", author: "Cheat Sheet")
#set page(paper: "a4", margin: 2.2cm, numbering: "1 / 1")
#set text(font: "Linux Libertine", size: 10.5pt, lang: "it")
#set heading(numbering: "1.1")
#set par(justify: true, leading: 0.65em)

#align(center)[
  #text(22pt, weight: "bold")[Typst — Reference completo]
  #v(0.2cm)
  #text(11pt, style: "italic")[Tutti i componenti principali in un unico file]
]
#v(0.5cm)

#outline(indent: auto)
#pagebreak()

// ------------------------------------------------------------
= Formattazione del testo
// ------------------------------------------------------------

*Grassetto*, _corsivo_, #underline[sottolineato], #strike[barrato],
#smallcaps[maiuscoletto], testo#super[apice], testo#sub[pedice].

#highlight[Testo evidenziato] e #text(fill: red)[testo colorato].

Un blocco citato:
#quote(block: true, attribution: [Autore Esempio])[
  La semplicità è la sofisticazione suprema.
]

// ------------------------------------------------------------
= Liste
// ------------------------------------------------------------

== Elenco puntato
- Primo elemento
- Secondo elemento
  - Sotto-elemento
- Terzo elemento

== Elenco numerato
+ Passo uno
+ Passo due
  + Sotto-passo
+ Passo tre

== Lista di termini
/ Typst: linguaggio di markup per documenti
/ Neovim: editor di testo modale
/ Arch Linux: distribuzione GNU/Linux minimale

// ------------------------------------------------------------
= Link, riferimenti e note
// ------------------------------------------------------------

Un link esterno: #link("https://typst.app")[sito ufficiale di Typst].

Un riferimento incrociato alla @tabella-dati e alla @fig-immagine.

Una nota a piè di pagina#footnote[Questo è il contenuto della nota.] inline nel testo.

// ------------------------------------------------------------
= Tabelle
// ------------------------------------------------------------

#figure(
  table(
    columns: (auto, 1fr, auto),
    align: (left, left, right),
    stroke: 0.5pt,
    table.header[*Nome*][*Descrizione*][*Anno*],
    [Typst], [Linguaggio di markup], [2023],
    [Neovim], [Editor modale], [2014],
    [Arch], [Distro rolling release], [2002],
  ),
  caption: [Esempio di tabella con intestazione],
) <tabella-dati>

// ------------------------------------------------------------
= Blocchi, box e layout
// ------------------------------------------------------------

#block(
  fill: rgb("#eef4ff"),
  stroke: 1pt + rgb("#4062bb"),
  radius: 6pt,
  inset: 10pt,
)[
  Questo è un blocco con sfondo, bordo colorato e angoli arrotondati.
]

#v(0.4cm)

== Colonne
#columns(2)[
  Questo testo viene disposto automaticamente su due colonne, utile per
  documenti tipo articoli o newsletter.

  #colbreak()
  Seconda colonna: il contenuto continua qui dopo l'interruzione manuale
  con #raw("#colbreak()").
]

== Griglia (grid)
#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 8pt,
  rect(fill: rgb("#ffe4e1"), height: 2cm)[Cella 1],
  rect(fill: rgb("#e1ffe4"), height: 2cm)[Cella 2],
  rect(fill: rgb("#e1e8ff"), height: 2cm)[Cella 3],
)

// ------------------------------------------------------------
= Matematica
// ------------------------------------------------------------

#set math.equation(numbering: "(1)")

Formula inline: $a^2 + b^2 = c^2$.

Formula in blocco, numerata automaticamente:
$ integral_0^infinity e^(-x^2) dif x = sqrt(pi) / 2 $ <eq-gauss>

Vedi l'@eq-gauss per l'integrale di Gauss.

Una matrice:
$ mat(1, 2, 3; 4, 5, 6; 7, 8, 9) $

Sistema di equazioni:
$ cases(
  x + y = 1,
  x - y = 3,
) $

// ------------------------------------------------------------
= Codice sorgente
// ------------------------------------------------------------

Codice inline: #raw("let x = 5", lang: "typ").

Blocco di codice con syntax highlighting:
```python
def fibonacci(n):
    a, b = 0, 1
    for _ in range(n):
        a, b = b, a + b
    return a
```

// ------------------------------------------------------------
= Immagini e figure
// ------------------------------------------------------------

// Uso "placeholder.svg" come esempio funzionante. Sostituiscilo con la tua
// immagine reale (png/jpg/svg) presente nella stessa cartella del file .typ.

#figure(
  image("placeholder.svg", width: 40%),
  caption: [Esempio di immagine con didascalia],
) <fig-immagine>

// ------------------------------------------------------------
= Forme geometriche di base
// ------------------------------------------------------------

#grid(
  columns: (1fr, 1fr, 1fr, 1fr),
  gutter: 10pt,
  align(center)[#rect(width: 2cm, height: 2cm, fill: blue.lighten(60%))],
  align(center)[#circle(radius: 1cm, fill: red.lighten(60%))],
  align(center)[#ellipse(width: 2.5cm, height: 1.5cm, fill: green.lighten(60%))],
  align(center)[#polygon(fill: orange.lighten(60%), (0pt, 0pt), (2cm, 0pt), (1cm, 2cm))],
)

#v(0.3cm)

Una linea semplice:
#line(length: 4cm, stroke: 1.5pt + blue)

Una linea diagonale con freccia (per diagrammi):
#line(start: (0pt, 0pt), end: (3cm, 1.5cm), stroke: (paint: black, thickness: 1pt))

// ------------------------------------------------------------
= Diagramma di flusso (nativo, senza pacchetti esterni)
// ------------------------------------------------------------

// Costruito componendo box + linee dentro un contenitore posizionato.
// Per diagrammi più complessi conviene il pacchetto "cetz" (vedi sotto).

#let nodo(testo) = box(
  fill: rgb("#fff3cd"),
  stroke: 1pt + black,
  radius: 4pt,
  inset: 8pt,
  align(center)[#testo],
)

#align(center)[
  #grid(
    columns: 1,
    rows: (auto, auto, auto, auto, auto),
    align: center,
    gutter: 4pt,
    nodo[Inizio],
    align(center)[#line(length: 0pt, angle: 90deg, stroke: 1pt)] , // spaziatore visivo
    nodo[Elabora dati],
    align(center)[↓],
    nodo[Fine],
  )
]

// ------------------------------------------------------------
= Grafico a barre (disegnato manualmente)
// ------------------------------------------------------------

// Un semplice bar chart costruito con rettangoli proporzionali,
// utile quando non si vuole dipendere da pacchetti esterni.

#let dati = (("Gen", 3), ("Feb", 5), ("Mar", 2), ("Apr", 7), ("Mag", 4))
#let max-val = 7

#align(center)[
  #grid(
    columns: dati.len(),
    column-gutter: 10pt,
    ..dati.map((coppia) => align(bottom)[
      #box(
        width: 1.2cm,
        height: 4cm * (coppia.at(1) / max-val),
        fill: blue.lighten(30%),
      )
      #v(2pt)
      #text(8pt)[#coppia.at(0)]
    ])
  )
]

// ------------------------------------------------------------
= Diagrammi e grafici avanzati con il pacchetto CeTZ
// ------------------------------------------------------------

// CeTZ è la libreria standard di Typst per disegni vettoriali complessi
// (diagrammi, grafici a torta, plot di funzioni, alberi, ecc).
// Richiede una connessione internet la prima volta, perché Typst scarica
// il pacchetto dal Typst Universe. Decommenta per usarlo:

// #import "@preview/cetz:0.3.1": canvas, draw
//
// #canvas(length: 1cm, {
//   import draw: *
//   line((0, 0), (4, 0), mark: (end: ">"))
//   line((0, 0), (0, 3), mark: (end: ">"))
//   line((0, 0), (3, 2))
//   content((3, 2), [$ f(x) $], anchor: "west")
// })

// Per grafici a torta / plot più elaborati esiste anche il pacchetto
// "@preview/cetz-plot", sempre da importare allo stesso modo.

// ------------------------------------------------------------
= Rotazione e scala
// ------------------------------------------------------------

#align(center)[
  #rotate(15deg)[#rect(width: 2cm, height: 1cm, fill: purple.lighten(60%))]
  #h(1cm)
  #scale(x: 150%, y: 100%)[#rect(width: 1cm, height: 1cm, fill: teal.lighten(60%))]
]

// ------------------------------------------------------------
= Variabili, funzioni e logica
// ------------------------------------------------------------

#let saluto(nome) = [Ciao, *#nome*!]
#saluto("mondo")

#let numeri = (1, 2, 3, 4, 5)
Somma: #numeri.sum(), Media: #(numeri.sum() / numeri.len())

#if numeri.len() > 3 [
  La lista ha più di 3 elementi.
] else [
  La lista ha 3 elementi o meno.
]

#for n in numeri [
  - Numero: #n
]
