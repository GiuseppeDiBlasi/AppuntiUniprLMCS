#import "../../Template typst/template.typ": c-border, definition, example, note, sqglb, sqle, sqlub, theorem, sleq
#import "@preview/fletcher:0.5.8": diagram, edge, node, shapes
#import "@preview/lovelace:0.3.1": *

= Lezione 3 del 25 settembre 2026

Nella lezione precedente abbiamo parlato di operazioni insiemistiche, insiemi parzialmente ordinati (PoSet), insieme delle parti (Power Set), diagrammi di Hasse, operatori lub e glb e una introduzione ai reticoli.

In questa lezione introduciamo il concetto di lattice (reticolo) completo.
Prendiamo in considerazione il seguente PoSet:

$chevron.l cal(P)("X"), subset.eq, union, inter chevron.r$

- Come elemento top abbiamo: $X$
- Come bottom: $emptyset$

Se prendiamo il PoSet:

$chevron.l ZZ, <=, max, min chevron.r$ è un PoSet e anche un reticolo, ma non è *completo*.

#definition(name: "Complete lattice (Reticolo completo)")[
  Dato: $chevron.l "X", subset.eq.sq, union.sq, inter.sq chevron.r$ è completo se:

  - Qualunque sottoinsieme di $X$ ha *lub*
  - Deve avere il bottom element
]

#v(0.5cm)

#example(name: "Esempio reticolo completo")[
  Se prendiamo $chevron.l ZZ union {-infinity, +infinity}, <=, max, min chevron.r$ questo è un reticolo completo.
  Qui abbiamo aggiunto $-infinity$ e $+infinity$ all'insieme.

  #align(center)[
    #grid(
      columns: (2em, auto, 1fr),
      column-gutter: 4em,
      align: (left, center + horizon, left + horizon),

      [],

      diagram(
        spacing: (0.5em, 0.5em),

        node((0, 0), $+infinity$, name: <top>),
        node((0, 1), $dots.v$, name: <d1>),
        node((0, 2), $2$, name: <n2>),
        node((0, 3), $1$, name: <n1>),
        node((0, 4), $0$, name: <n0>),
        node((0, 5), $-1$, name: <m1>),
        node((0, 6), $-2$, name: <m2>),
        node((0, 7), $dots.v$, name: <d2>),
        node((0, 8), $-infinity$, name: <bot>),

        edge(<top>, <d1>, "-"),
        edge(<d1>, <n2>, "-"),
        edge(<n2>, <n1>, "-"),
        edge(<n1>, <n0>, "-"),
        edge(<n0>, <m1>, "-"),
        edge(<m1>, <m2>, "-"),
        edge(<m2>, <d2>, "-"),
        edge(<d2>, <bot>, "-"),
      ),

      [
        Se $chevron.l "X", subset.sq.eq, union.sq, inter.sq chevron.r$ è completo se ha $top$ (Top) e $bot$ (Bottom).

        Possiamo riscriverlo anche così, specificando gli elementi top e bottom:

        $chevron.l "X", subset.sq.eq, union.sq, inter.sq, top, bot chevron.r$

      ],
    )
  ]
]
#pagebreak()

#note()[
  Se abbiamo solo l'operatore *lub*, o anche il *glb*, possiamo dire che partendo dalla definizione del *lub*, possiamo indurre il *glb* e viceversa. *Questo vale solamente per reticoli completi.* I due concetti, si dice che sono in dualità; stessa cosa $top$ e $bot$.

  $union.sq$ induce $inter.sq$ $-> quad$ $union.sq "S" = union.sq {"y" | forall "s" in "S", "y" subset.eq.sq "x"}$

  $inter.sq$ induce $union.sq$ $-> quad$ $inter.sq "S" = inter.sq {"y" | forall "s" in "S", "x" subset.eq.sq "y"}$

  #v(0.5cm)

  Se prendiamo $chevron.l ZZ, union {-infinity, +infinity}, <=, max, min chevron.r$ questo è un reticolo completo.

  Prendendo come esempio il reticolo dell' @ex-lub-glb possiamo calcolare lub e glb:

  #align(center)[
    #grid(
      columns: (auto, 1fr),
      column-gutter: 4em,
      align: (left, center + horizon, left + horizon),

      diagram(
        node-stroke: none,
        node-fill: none,
        spacing: (1.5em, 2.5em),

        node((3, 0), $top$, name: <T>),
        node((2, 1), $h$, name: <h>),
        node((4, 1), $i$, name: <i>),
        node((1, 2), $e$, name: <e>),
        node((3, 2), $f$, name: <f>),
        node((5, 2), $g$, name: <g>),
        node((0, 3), $a$, name: <a>),
        node((2, 3), $b$, name: <b>),
        node((4, 3), $c$, name: <c>),
        node((6, 3), $d$, name: <d>),
        node((3, 4), $bot$, name: <bot>),

        edge(<T>, <h>, "-"),
        edge(<T>, <i>, "-"),
        edge(<h>, <e>, "-"),
        edge(<h>, <f>, "-"),
        edge(<i>, <f>, "-"),
        edge(<i>, <g>, "-"),
        edge(<e>, <a>, "-"),
        edge(<e>, <b>, "-"),
        edge(<f>, <b>, "-"),
        edge(<f>, <c>, "-"),
        edge(<g>, <c>, "-"),
        edge(<g>, <d>, "-"),
        edge(<a>, <bot>, "-"),
        edge(<b>, <bot>, "-"),
        edge(<c>, <bot>, "-"),
        edge(<d>, <bot>, "-"),

        // node(enclose: (<f>, <g>, <c>), stroke: blue, shape: shapes.ellipse, inset: 12pt),
      ),

      [
        $"lub" -> union.sq {bot, c} = c$

        $"glb" -> inter.sq {i, top} = i$
      ],
    )
  ]


]

== Relazioni

Iniziamo ora a dare un'occhiata alle relazioni, partiamo definendo formalmente cos'è una relazione:

#definition(name: "Relazione")[
  Dati due insiemi $X, Y$ , il loro prodotto cartesiano è definito come:

  $ X times Y = { (x, y) | x in X, y in Y} $.

  Una relazione $R$ è definita:

  $R subset.eq X times Y$

  $(x, y) in R, thick x thick "r" thick y$, "r" indica una relazione tra $x$ e $y$.

  L'operatore *r*, indica $x$ in relazione con $y$.
]

Gli ordinamenti parziali, ovvero i PoSet che abbiamo visto fino ad ora, sono un tipo di relazione.
Altri tipi di relazione sono le funzioni:

#definition(name: "Funzioni")[
  $forall (x, y) in R, exists.not (x', y'), x eq x' and y eq.not y'$

  $f subset.eq X times Y approx f: X -> Y$

  - $X$ è il dominio di $f$.
  - $Y$ è il codominio di $f$.

  $(x, y) in f approx f(x) = y$
]

//_Inserire esempio funzioni con concetto di environment presentato dal prof, concetto utilizzato per analisi statica_

Le relazioni ci permettono di modellare la semantica di un programma come una funzione calcolata su un complete lattice.
Per esempio:

#definition(name: "Funzioni tra PoSet: monotonia, order-embedding e isomorfismo")[
  Prendiamo 2 PoSet  e una funzione $f$ che li mette in relazione:

  $chevron.l X, sqle(X) chevron.r quad chevron.l Y, sqle(Y) chevron.r quad quad f: X -> Y$

  Possiamo dire che:

  - $f$ è *monotona* se: $x_1 sqle(X) x_2 => f(x_1) sqle(Y) f(x_2)$
  - $f$ è *order-embedding* se: $x_1 sqle(X) x_2 <=> f(x_1) sqle(Y) f(x_2)$
  - $f$ è un *isomorfismo* se:
    - è un *order-embedding*
    - e se è *suriettiva*: $forall y in Y, exists x => f(x) = y$

  _Ricordiamo che la funzione è un tipo di relazione._
]

#v(1cm)

#example(name: "Relazioni e reticoli")[

  #align(center)[
    #grid(
      columns: (auto, auto),
      column-gutter: 3em,
      align: (center + horizon, left + horizon),

      diagram(
        spacing: (2.5em, 2.5em),

        // poset X: diamante 0 - {1,2} - 3
        node((1, 0), $3$, name: <n3>),
        node((0, 1), $1$, name: <n1>),
        node((2, 1), $2$, name: <n2>),
        node((1, 2), $0$, name: <n0>),

        // catena Y: a - b - c
        node((4, 0), $c$, name: <c>),
        node((4, 1), $b$, name: <b>),
        node((4, 2), $a$, name: <a>),

        // ordine dentro X (nero, senza freccia)
        edge(<n3>, <n1>, "-"),
        edge(<n3>, <n2>, "-"),
        edge(<n1>, <n0>, "-"),
        edge(<n2>, <n0>, "-"),

        // ordine dentro Y (nero, senza freccia)
        edge(<c>, <b>, "-"),
        edge(<b>, <a>, "-"),

        // funzione f (blu, con freccia)
        edge(<n3>, <c>, "->", stroke: blue),
        edge(<n1>, <b>, "->", stroke: blue, bend: 30deg),
        edge(<n2>, <b>, "->", stroke: blue),
        edge(<n0>, <a>, "->", stroke: blue),
      ),

      [
        // qui va il tuo testo esplicativo, es:
        - $f$ *monotona*: ✓
        - $f$*order-embedding*: ✗
        - $f$ *isomorfismo*: ✗
      ],
    )
  ]

  #v(1cm)

  Prendiamo in considerazione il reticolo qui sopra e vediamo nel
  dettaglio come dimostrare se $f$ è monotona:
  riprendendo la definizione dobbiamo comparare ogni possibile coppia:


  #align(center)[
    #table(
      columns: 3,
      align: center + horizon,
      table.header([Coppia in $X$], [Vale $x_1 subset.eq_X x_2$?], [$f(x_1) subset.eq_Y f(x_2)$?]),
      $0 subset.eq 1$, [vero], [$a subset.eq b$ → vero],
      $0 subset.eq 2$, [vero], [$a subset.eq b$ → vero],
      $1 subset.eq 3$, [vero], [$b subset.eq c$ → vero],
      $2 subset.eq 3$, [vero], [$b subset.eq c$ → vero],
      $0 subset.eq 3$, [transitiva], [$a subset.eq c$ → vero],
    )
  ]

  Per quanto riguarda la proprietà dell'order-embedding che non viene rispettata è dovuta al fatto che gli elementi
  $1$ e $2$, che non sono comparabili in $X$ vengono mappati sullo stesso valore in $Y$.

  Abbiamo che: $f(1) sleq(Y) f(2)$ è vera come affermazione, ma non implica che $1 sleq(X) 2$.

  In questo caso non possiamo parlare di isomorfismo perché:
  - Non è order-embedding.
  - È suriettiva, tutte le $y in Y$ sono mappate a una $x in X$.
  Entrambe le condizioni *DEVONO* essere rispettate.

  #line(length: 100%, stroke: 3.5pt + c-border)


  #v(0.8cm)

  #align(center)[
    #grid(
      columns: (auto, auto),
      column-gutter: 3em,
      align: (center + horizon, left + horizon),

      diagram(
        spacing: (3em, 2em),

        node((0, 0), $2$, name: <x2>),
        node((0, 1), $1$, name: <x1>),
        node((0, 2), $0$, name: <x0>),

        node((1, 0), $c$, name: <yc>),
        node((1, 1), $b$, name: <yb>),
        node((1, 2), $a$, name: <ya>),

        edge(<x2>, <x1>, "-"),
        edge(<x1>, <x0>, "-"),
        edge(<yc>, <yb>, "-"),
        edge(<yb>, <ya>, "-"),

        edge(<x2>, <yc>, "->", stroke: blue),
        edge(<x1>, <yc>, "->", stroke: blue, bend: -20deg),
        edge(<x0>, <ya>, "->", stroke: blue),
      ),

      [
        - $f$ *monotona*: ✓
        - $f$ *order-embedding*: ✗
        - $f$ *isomorfismo*: ✗

      ],
    )
  ]

  Il caso riportato qui sopra abbiamo $f$ che è monotona, ma non è order-embedding.
  Guardando più nel dettaglio possiamo vedere che la coppia $(1, 2)$ è confrontabile e abbiamo che: $1 subset.sq.eq 2 => f(1) subset.sq.eq f(2)$

  Questa condizione è rispettata, ma siccome dobbiamo prendere in considerazione *TUTTE* le coppie di $(x_1, x_2)$
  dobbiamo controllare anche la coppia $(2, 1)$ e abbiamo: $f(2) subset.sq.eq f(1) arrow.r.double.not 2 subset.sq.eq 1$

  #line(length: 100%, stroke: 3.5pt + c-border)

  #align(center)[
    #grid(
      columns: (auto, auto),
      column-gutter: 3em,
      align: (center + horizon, left + horizon),

      diagram(
        spacing: (3em, 2em),

        node((0, 0), $2$, name: <x2>),
        node((0, 1), $1$, name: <x1>),
        node((0, 2), $0$, name: <x0>),

        node((1, 0), $c$, name: <yc>),
        node((1, 1), $b$, name: <yb>),
        node((1, 2), $a$, name: <ya>),

        edge(<x2>, <x1>, "-"),
        edge(<x1>, <x0>, "-"),
        edge(<yc>, <yb>, "-"),
        edge(<yb>, <ya>, "-"),

        edge(<x2>, <yc>, "->", stroke: blue),
        edge(<x1>, <yb>, "->", stroke: blue),
        edge(<x0>, <ya>, "->", stroke: blue),
      ),

      [
        - $f$ *monotona*: ✓
        - $f$ *order-embedding*: ✓
        - $f$ *isomorfismo*: ✓

      ],
    )
  ]

  Diamo un'occhiata a quest'ultimo esempio, possiamo vedere che $f$ è monotona.
  Per quanto riguarda l'order embedding in questo caso è rispettato, nello specifico, se dovessimo prendere la coppia di valori $(1, 2)$ e $(2,1)$ possiamo dire che:

  - $f(1) subset.sq.eq f(2) => 1 subset.sq.eq 2$ è vera.
  - $f(2) subset.sq.eq f(1) => 2 subset.sq.eq 1$ è vera, dato che entrambe le condizioni sono false.

  Controlliamo se questa relazione è isomorfa:
  - È order-embedding ✓
  - È suriettiva, tutte le $y in Y$ sono mappate ad almeno una $x in X$.


  #line(length: 100%, stroke: 3.5pt + c-border)

  #align(center)[
    #grid(
      columns: (auto, auto),
      column-gutter: 3em,
      align: (center + horizon, left + horizon),

      diagram(
        spacing: (3em, 2em),

        node((0, 0), $2$, name: <x2>),
        node((0, 1), $1$, name: <x1>),
        node((0, 2), $0$, name: <x0>),

        node((1, 0), $c$, name: <yc>),
        node((1, 1), $b$, name: <yb>),
        node((1, 2), $a$, name: <ya>),

        edge(<x2>, <x1>, "-"),
        edge(<x1>, <x0>, "-"),
        edge(<yc>, <yb>, "-"),
        edge(<yb>, <ya>, "-"),

        edge(<x2>, <yc>, "->", stroke: blue),
        edge(<x1>, <ya>, "->", stroke: blue),
        edge(<x0>, <yb>, "->", stroke: blue),
      ),

      [
        - $f$ *monotona*: ✗
        - $f$ *order-embedding*: ✗
        - $f$ *isomorfismo*: ✗
      ],
    )
  ]

  Verifichiamo che $f$ sia monotona, partiamo dalla definizione di monotona:
  $ f "monotona se:" x sqle(X) y => f(x) sqle(Y) f(y) $

  Prendiamo $x = 0$ e $y = 1$, e calcoliamo $f(0) = b$ e $f(1) = a$, e otteniamo:

  $ 0 sqle(X) 1 arrow.r.double.not b sqle(Y) a $

  Come possiamo vedere per i valori appartenenti ad $X$ l'ordinamento viene rispettato, mentre per i valori in $Y$ non viene rispettato, di conseguenza la funzione $f$ non è monotona.
  Detto volgarmente, guardando il diagramma della relazione si può vedere un incrocio dall'insieme $X$ all'insieme $Y$.
]



#definition(name: "Join/meet preserving function")[
  Dati due PoSet: $chevron.l X, sqle(X), union.sq_X, inter.sq_X chevron.r$, $chevron.l Y, sqle(Y), union.sq_Y, inter.sq_Y chevron.r$

  Prendiamo in considerazione anche la funzione: $f: X -> Y$

  Possiamo definire il *join preserving function*: $f(x_1 union.sq_X x_2) = f(x_1) union.sq_Y f(x_2)$

  E definire il *meet preserving function*: $f(x_1 inter.sq_X x_2) = f(x_1) inter.sq_Y f(x_2)$
]

== Catene (Chain) <catene>

Il concetto di *catena* ci torna molto utile per il calcolo del punto fisso per determinate funzioni.

Diamo una definizione di catena.

#definition(name: "Catena")[
  Prendiamo il PoSet : $chevron.l X, sqle(X) chevron.r$; prendiamo un sotto insieme $S subset.eq X chevron.r$,
  $S$ è una catena se: $forall x, y in S$, $x subset.sq.eq y or y subset.sq.eq x$, ($S$ è totalmente ordinato.)

  Una *catena ascendente* è una sequenza $(cal(l)_n), n in NN, quad i <= j => cal(l)_i subset.sq.eq cal(l)_j$
]

Diamo ora un'occhiata a un concetto fondamentale per interpretazione astratta.

#definition(name: "Ascending Chain Condition (ACC)")[
  Prendiamo il PoSet $chevron.l X, sqle(X) chevron.r$ soddisfa *ACC* se non esistono catene ascendenti infinite strettamente crescenti.
  Ogni catena dopo un numero finito di passi si stabilizza; qui torna il concetto di calcolo del punto fisso visto a Linguaggi Interpreti e Compilatori.

  $exists k >= 0, forall j >= k quad cal(l)_k = cal(l)_j$

  - Se $X$ è finito,  allora è *ACC*
  - $cal(P)(X)$ solo se $X$ è finito, allora è *ACC*
]


Diamo ora un'occhiata a vari esempi di catene che rispettano, e non rispettano la condizione ACC.

#example(name: "Esempi di ACC")[
  $chevron.l ZZ, <= chevron.r$ non è ACC: $0 < 1 < 2 < dots$ è strettamente crescente all'infinito.

  $chevron.l NN, <= chevron.r$ non è ACC: $0 < 1 < 2 < dots$ è strettamente crescente all'infinito.

  $chevron.l NN, >= chevron.r$ è ACC: una catena ascendente è $x_0 >= x_1 >= x_2 >= dots$, e non può decrescere all'infinito in $NN$, quindi si stabilizza (es. $5 >= 3 >= 1 >= 0 >= 0 >= dots$).
]

#pagebreak()

Il prof ha dato la definizione di continous map (mappe continue) che verranno riprese nella lezione successiva.

#definition(name: "Continuous maps")[
  Prendiamo due PoSet $X, Y$ e una relazione che li lega:

  $chevron.l X, subset.sq.eq_X, union.sq_X, inter.sq_X chevron.r chevron.l Y, subset.sq.eq_Y, union.sq_Y, inter.sq_Y chevron.r, quad f: X -> Y$

  $f$ è continua se: per tutte le catene $C subset.eq X$ valgono le seguenti proprietà:

  - Esiste $union.sq_X C$
  - Esiste $union.sq_Y f(C)$
  - Esiste $union.sq_Y f(C) = f(union.sq_X C)$
]
