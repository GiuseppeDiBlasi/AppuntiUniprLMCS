#import "../../Template typst/template.typ": c-border, definition, example, note, sqglb, sqle, sqlub, theorem
#import "@preview/fletcher:0.5.8": diagram, edge, node, shapes

// ---------- Diagramma di sinistra: x := x+1 ----------
#let sinistra = diagram(
  spacing: (14mm, 13mm),
  node-stroke: none,

  node((0, 0), `x := x+1`),

  edge((0, 0), (-1, 1), "->"),
  edge((0, 0), (1, 1), "->"),

  node((-1, 1), align(center)[Kill: espressioni $backslash$ contenenti `x`]),
  node((1, 1), ${ x+1 }$),

  // freccia gialla al centro (spessore e punta ridotti)
  edge((0, 1.1), (0, 2), "-|>", stroke: 1.5pt + yellow.darken(10%), mark-scale: 90%),
  node((0, 2), text(size: 18pt)[$emptyset$]),
)

// ---------- Diagramma di destra: esempio con tre istruzioni ----------
#let destra = diagram(
  spacing: (12mm, 9mm),
  node-inset: 5pt,

  node((0, 0), `x := a+b`, stroke: 0.8pt),
  node((0, 1), `y := x+1`, stroke: 0.8pt),
  node((0, 2), `x := y+1`, stroke: 0.8pt),

  edge((0, 0), (0, 1), "->"),
  edge((0, 1), (0, 2), "->"),

  node((1, 0), ${ a+b }$, stroke: none),
  node((1, 1), ${ a+b, x+1 }$, stroke: none),
  node((1, 2), ${ a+b, y+1 }$, stroke: none),

  node(enclose: ((0, 0), (1, 2)), stroke: 1pt, inset: 10pt),
)

// Affiancati e rimpiccioliti automaticamente per entrare nella larghezza disponibile
#let contenuto = stack(dir: ltr, spacing: 1cm, sinistra, destra)

= Lezione 8 dell'8 ottobre 2026


La scorsa lezione abbiamo introdotto le analisi DFA e l'analisi delle available expressions, riprendiamo da lì definendole formalmente e guardiamo un esempio.

== Available expressions, pt. 2

#definition(name: "Available expression, formalizzazione")[
  È un tipo di analisi *forward* e definita.

  - Per ogni program point, nel nostro caso per ogni blocco, teniamo traccia dell'insieme delle available expressions.
  - Indichiamo con AExp($e$), l'insieme delle espressioni aritmetiche non banali in $e$.
  - Indichiamo con AExp($b$), l'insieme delle espressioni aritmetiche non banali in $b$.
  - Indichiamo con FV($a$), l'insieme delle variabili libere, free-variables, in $a$.

  Definiamo *kill* e *gen*:

  $bold("kill")(x := e) = {a in "AExp"(e) | x in "FV"(a)} quad bold("gen")(x := e) = {a in "AExp"(e) | x in.not "FV"(a)}$

]

#example[
  #layout(size => context {
    let m = measure(contenuto)
    let f = calc.min(1, size.width / m.width) // mai ingrandire, solo ridurre
    align(center, scale(f * 100%, reflow: true, contenuto))
  })

  Come possiamo vedere, nel caso $x := x + 1$ l'insieme *gen* è vuoto, questo perché $"FV"(x + 1)$ contiene la variabile $x$ e non è compatibile con la definizione dell'insieme *gen*, di conseguenza deve appartenere all'insieme $bold("kill") = { x }$.

]

Definiamo adesso le available expression in ingresso e in uscita da un blocco.

#definition(name: "Available expression, entry ed exit")[
  Le espressioni in ingresso verso un blocco sono le espressioni available in uscita dal blocco precedente
  Come già detto, l'available expression è un'analisi di tipo forward , le informazioni vengono propagate da stati di
  entry (ingresso) a stati d'uscita (exit).

  #align(center)[
    entry(_pp_) = exit(predecessor(_pp_))

    _pp_: program point.
  ]
]

Guardiamo un esempio per entry ed exit:

#pagebreak()

#example[
  // Blocco con il numero piccolo in alto a sinistra
  #let blocco(n, c) = [
    #place(top + left, dy: -1.1em, text(size: 6pt, gray.darken(30%))[#n])
    #c
  ]

  // Etichetta entry/exit allineata a sinistra
  #let etichetta(..righe) = box(width: 4.5cm, align(left, stack(spacing: 0.9em, ..righe)))

  #align(center)[
    #diagram(
      spacing: (35mm, 14mm),
      node-inset: 6pt,

      // blocchi
      node((0, 0), blocco(1, `x:=a+b`), stroke: 0.8pt),
      node((0, 1), blocco(2, `y:=x+1`), stroke: 0.8pt),
      node((0, 2), blocco(3, `x:=y+1`), stroke: 0.8pt),

      // frecce di flusso
      edge((0, 0), (0, 1), "->"),
      edge((0, 1), (0, 2), "->"),

      // entry / exit
      node(
        (1, 0),
        etichetta(
          $italic("entry")(1) = emptyset$,
          $italic("exit")(1) = {"a+b"}$,
        ),
        stroke: none,
      ),

      node(
        (1, 1),
        etichetta(
          $italic("entry")(2) = {"a+b"}$,
          $italic("exit")(2) = lr({ mat(delim: #none, "a+b,"; "x+1") })$,
        ),
        stroke: none,
      ),

      node(
        (1, 2),
        etichetta(
          $italic("exit")(3) = lr({ mat(delim: #none, "a+b,"; "y+1") })$,
        ),
        stroke: none,
      ),
    )]

]

Per combinare queste informazioni con l'operatore di join, dobbiamo tenere conto che, in ogni punto del programma, un'espressione è available solo se è già stata calcolata, e non più modificata, su ogni possibile percorso che porta a quel punto.
Guardiamo un esempio:

#example[
  // Blocco con il numero piccolo in alto a sinistra
  #let blocco(n, c) = [
    #place(top + left, dy: -1.1em, dx: -0.2em, text(size: 6pt, gray.darken(30%))[#n])
    #c
  ]

  #align(center)[
    #scale(70%, reflow: true, diagram(
      spacing: (30mm, 15mm),
      node-inset: 6pt,

      // blocchi (stessa larghezza)
      node((0, 0), blocco(1, `y:=a-b`), stroke: 1pt, width: 3.2cm),
      node((0, 1), blocco(2, `x:=y+b`), stroke: 1pt, width: 3.2cm),
      node((0, 2), blocco(3, `y>a+b`), stroke: 1pt, width: 3.2cm),
      node((0, 3), blocco(4, `y:=y-1`), stroke: 1pt, width: 3.2cm),

      // frecce dall'alto verso il basso
      edge((0, 0), (0, 1), "->"),
      edge((0, 1), (0, 2), "->"),
      edge((0, 2), (0, 3), "->"),
      node((0.22, 2.5), text(size: 9pt)[yes], stroke: none, inset: 0pt),

      // ritorno del ciclo: dal blocco 4, a sinistra, su, dentro il blocco 3
      edge((0, 3), (0, 3.7), (-0.9, 3.7), (-0.9, 2), (0, 2), "->"),

      // uscita "no": dal blocco 3 a destra e poi in basso
      edge((0, 2), (1, 2), (1, 3.7), "->"),
      node((0.75, 1.82), text(size: 9pt)[no], stroke: none, inset: 0pt),

      // risultati a destra
      node(
        (2.1, 1.2),
        align(left, stack(
          spacing: 1.1em,
          $italic("exit")(2) = { a - b, y + b }$,
          $italic("exit")(4) = { a - b, a + b }$,
          $italic("entry")(3) = ?$,
        )),
        stroke: none,
      ),
    ))]
]

Per calcolare il valore di _entry_(3) riprendiamo la formula che abbiamo scritto su per gli stati entranti e uscenti: _entry_(_pp_) = exit(predecessor(_pp_)).

Quindi per calcolare l'_entry_(3) dobbiamo prendere in considerazione l'_exit_ di tutti i blocchi che entrano dentro il blocco 3.
Abbiamo il blocco 2 e il blocco 4.
Prendiamo _exit_(2) e _exit_(4) e facciamo l'intersezione e otteniamo
- _exit_(2) = ${a - b, y + b}$
- _exit_(4) = ${a - b, a + b}$
- $italic("exit")(2) inter italic("exit")(4) = {a - b}$

_In questo caso dentro al blocco 4 abbiamo $y := y - 1$ il suo *gen* è $emptyset$, mentre il *kill* è ${y - 1, y + b}$_.

Formalizziamo le available expression in ingresso e in uscita da un blocco $i$.

#definition(name: "Available expression, exit e entry")[
  Se vogliamo formalizzare le available expression che entrano in un blocco $i$ possiamo farlo con:

  #align(center)[
    $bold("entry"(i) = inter {"exit"(i') | (i', i) in "edges"(G)})$
  ]

  Mentre per le available expression che escono da un blocco $i$:

  #align(center)[
    $bold("exit"(i) = ("entry"(i) backslash "kill"("stmt"(G, i))) union "gen"("stmt"(G, i)))$
  ]
]

// ---------- Flowchart ----------
#let blk(n, code) = box(width: 3.6cm, height: 0.9cm)[
  #align(center + horizon, raw(code))
  #place(top + left, dy: -0.32cm, dx: 1pt, text(size: 6pt)[#n])
]

#let flowchart = box(
  stroke: 1pt,
  inset: (x: 1.6cm, y: 0.6cm),
  diagram(
    node-stroke: 1pt,
    node-inset: 0pt,
    spacing: 0.7cm,
    node((0, 0), blk(1, "y:=a-b"), name: <b1>),
    node((0, 1), blk(2, "x:=y+b"), name: <b2>),
    node((0, 2), blk(3, "y:=x+2"), name: <b3>),
    edge(<b1>, <b2>, "->"),
    edge(<b2>, <b3>, "->"),
  ),
)

// ---------- Tabella ----------
#let ent(n) = $op("entry")(#n)$
#let row(n, entry, killvar, gen) = (
  [#n],
  entry,
  $(#ent(n) without {a in "AE" | #killvar in "FV"(a)}) union {#gen}$,
)

#let tabella = table(
  columns: 3,
  stroke: 0.6pt + black,
  align: center + horizon,
  inset: 9pt,
  table.header([*Block*], [*entry*], [*exit*]),
  ..row(1, $emptyset$, $y$, $a - b$),
  ..row(2, $op("exit")(1)$, $x$, $y + b$),
  ..row(3, $op("exit")(2)$, $y$, $x + 2$),
)

// ---------- Flowchart ----------
#let blk(n, code) = box(width: 3.6cm, height: 0.9cm)[
  #align(center + horizon, raw(code))
  #place(top + left, dy: -0.32cm, dx: 1pt, text(size: 6pt)[#n])
]

#let flowchart2 = box(
  stroke: 1pt,
  inset: 0.6cm,
  diagram(
    node-inset: 0pt,
    spacing: 0.7cm,
    node((0, 0), blk(1, "y:=a-b"), name: <b1>, stroke: 1pt),
    node((0, 1), blk(2, "x:=y+b"), name: <b2>, stroke: 1pt),
    node((0, 2), blk(3, "y>a+b"), name: <b3>, stroke: 1pt),
    node((0, 3), blk(4, "y:=y-x*x"), name: <b4>, stroke: 1pt),

    edge(<b1>, <b2>, "->"),
    edge(<b2>, <b3>, "->"),
    edge(<b3>, <b4>, "->"),

    // ciclo: da 4 torna a 3
    edge((0, 3), (0, 3.6), (-1, 3.6), (-1, 2), (0, 2), "->"),
    // uscita "no"
    edge((0, 2), (1, 2), (1, 4), "->"),

    node((0, 2.5), move(dx: 0.55cm, text(size: 9pt)[yes]), stroke: none),
    node((1, 2), move(dx: -0.35cm, dy: 0.3cm, text(size: 9pt)[no]), stroke: none),
  ),
)

// ---------- Tabella ----------
#let ent(n) = $op("entry")(#n)$
#let row(n, entry, stmt) = (
  [#n],
  entry,
  $(#ent(n) without op("kill")(#stmt)) union op("gen")(#stmt)$,
)

#let tabella2 = table(
  columns: 3,
  stroke: 0.6pt + black,
  align: center + horizon,
  inset: 9pt,
  table.header([*Block*], [*entry*], [*exit*]),
  ..row(1, $emptyset$, $y ":=" a - b$),
  ..row(2, $op("exit")(1)$, $x ":=" y + b$),
  ..row(3, $op("exit")(2) inter op("exit")(4)$, $y > a + b$),
  ..row(4, $op("exit")(3)$, $y ":=" y - x * x$),
)
Guardiamo due esempi di calcolo per entry ed exit.

#example[

  #scale(70%, reflow: true, grid(
    columns: 2,
    column-gutter: 2cm,
    align: horizon,
    flowchart, tabella,
  ))
]

#example[
  #scale(70%, reflow: true, grid(
    columns: 2,
    column-gutter: 2cm,
    align: horizon,
    flowchart2, tabella2,
  ))
]

== Altre analisi Dataflow

Fino ad ora abbiamo visto l'analisi delle available expressions, che è un tipo di analisi *forward* e *definita*.
- *Forward* perché l'analisi viene svolta raccogliendo informazioni seguendo il flusso originale del progamma, quindi dal blocco $A$ al blocco $B$.
- *Backward*, le informazioni sono propagate dall'exit del blocco all'entry dei blocchi precedenti, un esempio è l'analisi Live variable analysis.
- *Definita, o must,* perché un'espressione è considerata available se è disponibile in _*tutti*_ i cammini che arrivano a quel program point.
- *Possibile, o may*, perché un'informazione (ad esempio una variabile live o una definizione che raggiunge il punto) vale in un program point se vale in _*almeno un*_ cammino che arriva a quel punto, o che parte da esso nelle analisi backward.

Altri tipi di analisi sono:

#definition(name: "Live variables")[
  Per ogni program point, calcoliamo quali variabili _*possono (may)*_
  essere live all'uscita da quel punto. Una variabile è detta live se il suo valore può essere letto lungo almeno un cammino che parte dal program point, senza essere prima sovrascritto.

  Notare che nella definizione c'è _*may*_, questo ci indica che si tratta di un'analisi may e non definita; nei punti di join si fa l'unione degli insiemi.
]

#definition(name: "Reaching definitions")[
  Per ogni program point, calcoliamo quali assegnamenti possono (may) essere stati eseguiti e non sovrascritti quando l'esecuzione raggiunge quel punto lungo un qualche cammino.

  È un'analisi _*forward*_ e _*may*_: nei punti di join si fa l'unione degli insiemi.
]

#definition(name: "Very busy expressions")[
  Per ogni program point, calcoliamo quali espressioni devono (must) essere very busy all'uscita da quel punto. Un'espressione è very busy se, lungo tutti i cammini che partono da quel punto, viene usata prima che una qualsiasi delle variabili che vi compaiono sia ridefinita.

  È un'analisi _*backward*_ e _*must*_: nei punti di join si fa l'intersezione degli insiemi.
]

Ricapitolando velocemente:
- *Analisi Possible*: may, some paths, unione.
- *Analisi Definite*: must, all paths, intersezione.
- *Analisi Forward*: fino al program point.
- *Analisi Backward*: dal program point a ritroso.

== Lattice in analisi dataflow

Possiamo vedere le analisi dataflow come dei lattice, o reticoli. *TUTTE* le analisi dataflow sono dei _*complete lattice*_ e devono rispettare l'ACC @catene.

Possiamo definire l'analisi dell'available expression come un lattice:

- $chevron.l cal(P)(italic("AE")), supset.eq, italic("AE"), emptyset, inter, union chevron.r$

Per le live variable:

- $chevron.l cal(P)(italic("Var")), subset.eq, emptyset, italic("VAR"), inter, union chevron.r$

Dato che possiamo vedere le analisi dataflow come reticoli, teniamo in considerazione che per le analisi definite, o must, salendo lungo il reticolo perdiamo informazioni.

Ricordiamo che il valore $bot$ rappresenta uno stato di errore o di assenza di informazioni, mentre il valore $top$ rappresenta lo stato _*non lo so*_.

== Analisi distributive

Le analisi distributive sono semplici.
Ci permettono di calcolare _*COME*_ avviene la computazione, per esempio l'assegnamento di variabili, calcolo di espressioni, e non _*COSA*_ il programma calcola.

#definition(name: "Analisi distributiva")[
  Prendiamo in considerazione un lattice *$chevron.l cal(P)(X), subset.eq, emptyset, X, union, inter chevron.r$* e *$f: cal(P)(X) -> cal(P)(X)$*

  La funzione *$f$* è distributiva se: *$f(x union y) = f(x) union f(y)$*

  Tutte le analisi dataflow sono distributive, anche quando il lub è $inter$.
]

Le analisi più complesse non sono distributive, e spesso non possono essere formalizzate come analisi dataflow.
Per questo motivo è stata introdotta l'interpretazione astratta.


== Propagazione di costanti

#definition(name: "Propagazione di costanti")[
  Per ogni punto del programma, determinare se una variabile ha o meno un valore costante
  ogni volta che l’esecuzione raggiunge quel punto.

  - _*NON*_ è un tipo di analisi distributiva.

  Il lattice della CP è: $chevron.l {bot} union ZZ union {top}, subset.sq.eq, union.sq, inter.sq, bot, top chevron.l$
]

Guardiamo un esempio dove proviamo a dimostrare che la constant propagation sia un'analisi distributiva.

#example[
  #diagram(
    node-stroke: none,
    spacing: (4cm, 3cm),

    // Stato s0 (a sinistra)
    node(
      (0, 0),
      [
        $y |-> 1$ \
        $z |-> -1$
      ],
      name: <s0>,
    ),
    node((0, -0.25), text(fill: red, size: 2em)[$s_0$], inset: 0pt),

    // Stato s1 (a destra)
    node(
      (2.35, 0),
      [
        $y |-> 0$ \
        $z |-> 0$
      ],
      name: <s1>,
    ),
    node((2.35, -0.25), text(fill: red, size: 2em)[$s_1$], inset: 0pt),

    // Istruzione f (in basso, centrata)
    node((1.30, 1), $x := y + z$, stroke: 1.5pt, inset: 12pt, name: <f>),
    node((1.55, 1.25), text(fill: red, size: 2em, style: "italic")[$f$], inset: 0pt),

    // Frecce
    edge(<s0>, <f>, "->", label-side: left),
    edge(<s1>, <f>, "->"),
  )

  Proviamo a dimostrare che constant propagation sia una funzione distributiva, abbiamo $f$ e deve valere la proprietà che $f$ sia distributiva, quindi:

  #align(center)[
    $f(x union.sq y) = f(x) union.sq f(y)$
  ]

  Possiamo vedere l'insieme dei possibili valori come un lattice su cui poi dobbiamo calcolare il lub ($union.sq$) tra $x$ e $y$.

  #align(center)[
    #scale(65%, reflow: true, diagram(
      node-stroke: none,
      spacing: (1cm, 3.2cm),

      // Top e bottom
      node((0, -1), $top$, name: <top>),
      node((0, 1), $bot$, name: <bot>),

      // Livello intermedio
      node((-3, 0), $dots.h.c$),
      node((-2, 0), $-2$, name: <m2>),
      node((-1, 0), $-1$, name: <m1>),
      node((0, 0), $0$, name: <z>),
      node((1, 0), $1$, name: <p1>),
      node((2, 0), $2$, name: <p2>),
      node((3, 0), $dots.h.c$),

      // Linee da top verso i valori
      edge(<top>, <m2>, "-", shift: 0pt),
      edge(<top>, <m1>, "-"),
      edge(<top>, <z>, "-"),
      edge(<top>, <p1>, "-"),
      edge(<top>, <p2>, "-"),

      // Linee dai valori verso bottom
      edge(<m2>, <bot>, "-"),
      edge(<m1>, <bot>, "-"),
      edge(<z>, <bot>, "-"),
      edge(<p1>, <bot>, "-"),
      edge(<p2>, <bot>, "-"),
    ))
  ]

  Partiamo calcolando $f(s_0 union.sq s_1)$, applichiamo il lub che va calcolato per ogni coppia di variabile, vediamo nel reticolo che il lub per $s_0$ e $s_1$ è $top$, quindi otteniamo:


  $ f([y |-> top, z |-> top]) = [x |-> top, y |-> top, z |-> top] $



  Ricordiamo che usiamo $top$ per indicare che non sappiamo il valore indicato.
  Andiamo avanti calcolando la seconda parte dell'equazione:

  $
    f(s_0) union.sq f(s_1) = [x |-> 0, y |-> 1, z |-> -1] union.sq [x |-> 0, y |-> 0, z |-> 0] = [x |-> 0, y |-> top, z |-> top]
  $

  Confrontiamo i risultati:

  $ [x |-> top, y |-> top, z |-> top] != [x |-> 0, y |-> top, z |-> top] $


  Possiamo vedere che la proprietà che $f$ sia distributiva non viene rispettata, quindi la constant propagation non è un'analisi di tipo distributivo.
]

