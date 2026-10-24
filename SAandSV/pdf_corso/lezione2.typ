#import "../../Template typst/template.typ": definition, example, note, sqglb, sqle, sqlub, theorem
#import "@preview/fletcher:0.5.8": diagram, edge, node, shapes
#import "@preview/lovelace:0.3.1": *

= Lezione 2 del 24 settembre 2026

== Teoria dei reticoli

Per arrivare a parlare dei reticoli, in questa lezione si inizia con un ripasso dei concetti di insiemistica.

Partiamo col definire un insieme:


#definition(name: "Insieme")[
  Un insieme $"S"$ è una collezione di elementi non ripetuti.

  === Implicazione

  $ "S"_1 subset "S"_2 eq.delta forall "s" in "S"_1 => "s" in "S"_2 $

  === Or logico

  $ "S"_1 union "S"_2 eq.delta {"s" | "s" in "S"_1 or "s" in "S"_2} $

  === And logico

  $ "S"_1 inter "S"_2 eq.delta {"s" | "s" in "S"_1 and "s" in "S"_2} $


]

== Ordinamenti parziali (PoSet)

#definition(name: "Insieme parzialmente ordinato")[
  Un insieme si dice parzialmente ordinato se rispetta le seguenti proprietà:

  - *Riflessiva:* $forall "x" in "X" => "x" subset.sq.eq "x"$
  - *Anti-simmetrica:* $forall "x", "y" in "X", "x" subset.sq.eq "y" and "y" subset.sq.eq "x" => "x" = "y"$
  - *Transitiva:* $forall "x", "y", "z" in "X", "x" subset.sq.eq "y" and "y" subset.sq.eq "z" => "x" subset.sq.eq "z"$

  L'insieme è ordinato parzialmente perché non tutti gli elementi sono confrontabili tra loro, altrimenti si parlerebbe di ordinamento totale.

  Per rappresentare i PoSet usiamo la seguente notazione:

  $chevron.l "X", subset.sq.eq chevron.r quad --> quad chevron.l cal(P)(ZZ), subset.eq chevron.r$

  - $"X"$, è l'insieme degli elementi
  - $subset.sq.eq$, è l'operatore di ordinamento

]


#definition(name: "Power set (Insieme delle parti)")[
  Dato un insieme $"S"$, $cal(P)("S")$ è l'insieme di tutti i sottoinsiemi di S.
  ==== Esempi:
  - $cal(P)(emptyset) = {emptyset}$
  - $cal(P)(ZZ) = {emptyset, {0}, {1}, {0, 1}, ...}$
  - $cal(P)("S")$, anche $"S"$ è un insieme che fa parte dell'insieme delle parti.
]

#example(name: "Verificare un Poset")[
  $cal(P)("S")$ è un PoSet? Per decidere se è un PoSet dobbiamo dimostrare le 3 proprietà:

  - *Riflessivo:* $forall X in cal(P)(S) quad => quad X subset.eq X$
  - *Anti-simmetrico*: $forall X, Y in cal(P)(S), quad X subset.eq Y and Y subset.eq X => X = Y$
  - *Transitiva:* $forall X, Y, Z in cal(P)(S), quad X subset.eq Y and Y subset.eq Z => X subset.eq Z$
]

#note()[
  Se $chevron.l cal(P)("S"), subset.sq.eq chevron.r$  è un PoSet,
  è uguale a: $chevron.l cal(P)("S"), supset.sq.eq chevron.r$ ?

  In linea generale sì, questa proprietà è valida.

  $chevron.l NN, <= thin chevron.r$ è un PoSet.

  $chevron.l NN, >= thin chevron.r$ è un PoSet.

  $chevron.l NN, < thin chevron.r$ non è un PoSet.
]

== Diagrammi di Hasse

È un modo per poter rappresentare graficamente un PoSet.

Dando una definizione formale:

#definition(name: "Diagramma di Hasse")[
  Dato $chevron.l "X", subset.sq.eq chevron.r$, traccio una linea per collegare due elementi *SOLO SE:*

  - $"x" subset.sq "y"$
  - $exists.not "z" in "X", "x" subset.sq "z" subset.sq "y"$
]

#pagebreak()

#example(name: "Diagramma di Hasse")[

  #v(1.5cm)

  #align(center)[
    #diagram(
      spacing: (2cm, 1.5cm),
      node-stroke: none, // Rimuove i bordi dai nodi per avere solo il testo

      // Livello 3 (In alto): Insieme completo
      node((0, 0), [$\{-1, 0, 1\}$], name: <top>),

      // Livello 2: Sottoinsiemi di 2 elementi
      node((-1.5, 1), [$\{-1, 0\}$], name: <m1_0>),
      node((0, 1), [$\{-1, 1\}$], name: <m1_1>),
      node((1.5, 1), [$\{0, 1\}$], name: <0_1>),

      // Livello 1: Sottoinsiemi di 1 elemento
      node((-1.5, 2), [$\{-1\}$], name: <m1>),
      node((0, 2), [$\{0\}$], name: <0>),
      node((1.5, 2), [$\{1\}$], name: <1>),

      // Livello 0 (In basso): Insieme vuoto
      node((0, 3), [$emptyset$], name: <bot>),

      // --- Collegamenti (dall'insieme vuoto ai singoli) ---
      edge(<bot>, <m1>, "-"),
      edge(<bot>, <0>, "-"),
      edge(<bot>, <1>, "-"),

      // --- Collegamenti dai singoli alle coppie ---
      edge(<m1>, <m1_0>, "-"),
      edge(<m1>, <m1_1>, "-"),
      edge(<0>, <m1_0>, "-"),
      edge(<0>, <0_1>, "-"),
      edge(<1>, <m1_1>, "-"),
      edge(<1>, <0_1>, "-"),

      // --- Collegamenti dalle coppie al massimo ---
      edge(<m1_0>, <top>, "-"),
      edge(<m1_1>, <top>, "-"),
      edge(<0_1>, <top>, "-"),
    )
  ]
]

Vediamo alcuni esempi di PoSet e di diagrammi di Hasse:

#example[
  Prendiamo l'insieme dei divisori di 12, $X = {1, 2, 3, 4, 6, 12}$ e operatore di ordinamento $x subset.sq.eq y$ se $x$ divide $y$.
  Quindi definendolo formalmente abbiamo: $chevron.l X, | chevron.r$

  Verifichiamo che siano rispettate le 3 proprietà:
  - *Riflessiva*: $forall x in X, x subset.eq.sq x$, in questo caso ogni numero divide se stesso.
  - *Anti-simmetrica*: $forall x, y in X, "se" x subset.eq.sq y thick and thick y subset.eq.sq x$, quindi: $x | y thick and thick y | x thick => thick x = y$. Quindi se $x | y, x <= y, thick "se" y | x, thick y <= x, thick "quindi" x = y$
  - *Transitiva*: $forall x,y,z in X, "se" x subset.eq.sq y and y subset.eq.sq z => x subset.eq.sq z$, presi 3 numeri, se x divide y, e y divide z, allora x divide z. Anche questa proprietà è rispettata.

  Possiamo rappresentare questo PoSet come un diagramma di Hasse:


  #align(center)[
    #diagram(
      spacing: (1.4cm, 1cm),
      node-stroke: none,

      // nodi (x, y): y cresce verso il basso
      node((1, 0), $12$, name: <12>),
      node((0, 1), $4$, name: <4>),
      node((2, 1), $6$, name: <6>),
      node((0, 2), $2$, name: <2>),
      node((2, 2), $3$, name: <3>),
      node((1, 3), $1$, name: <1>),

      // archi (relazioni di copertura)
      edge(<1>, <2>),
      edge(<1>, <3>),
      edge(<2>, <4>),
      edge(<2>, <6>),
      edge(<3>, <6>),
      edge(<4>, <12>),
      edge(<6>, <12>),
    )
  ]

]


== Upper bound e Lower bound

Quando lavoriamo con diagrammi di Hesse è fondamentale, per i nostri scopi riguardanti l'analisi statica, trovare gli upper bound e i lower bound da un dato insieme $"S"$ all'interno di un diagramma.

Definiamo ora upper bound e il least upper bound.

#definition(name: "Upper bound e least upper bound (lub)")[
  Dato un PoSet $chevron.l "X", subset.sq.eq chevron.r,"S" subset.eq "X"$

  - $"s" in "X"$ è un *upper bound* se: $forall "s"' in "S", quad "s" supset.sq.eq "s"'$

  - $s in X$ è un *least upper bound* (lub) se: $forall "s"' in "UB", "s" subset.sq.eq "s"'$
]

Diamo un'occhiata ora alle definizioni di lower bound e greatest lower bound.

#definition(name: "Lower bound e greatest lower bound (glb)")[
  Dato un PoSet $chevron.l "X", subset.sq.eq ,"S" subset.eq "X" chevron.r$

  - $s in X$ è un *lower bound* di $S$ se $forall s' in S, s subset.sq.eq s'$
  - $s in X$ è un *greatest lower bound* se $forall s' in "LB", s' subset.sq.eq s$

]

#note()[
  Il *lub* e *glb* non sempre esistono, ma nel caso in cui dovessero esistere, sono *unici*.
]


#example(name: "Upper bound e least upper bound di un diagramma di Hasse")[
  Vediamo ora un esempio di upper bound e least upper bound.
  #align(center)[
    #diagram(
      spacing: (1.5cm, 1.2cm),
      node-stroke: none,

      // --- DEFINIZIONE DEI NODI (Testo) ---
      node((0, 0), [$\{ -1, 0, 1 \}$], name: <top>),
      node((-1, 1), [$\{ -1, 0 \}$], name: <pair_m1_0>),
      node((0, 1), [$\{ -1, 1 \}$], name: <pair_m1_1>),
      node((1, 1), [$\{ 0, 1 \}$], name: <pair_0_1>),
      node((-1, 2), [$\{ -1 \}$], name: <single_m1>),
      node((0, 2), [$\{ 0 \}$], name: <single_0>),
      node((1, 2), [$\{ 1 \}$], name: <single_1>),
      node((0, 3), [$nothing$], name: <empty>),

      // --- CERCHIATURE E ANNOTAZIONI ---
      // 1. Ovale rosso per TOP (UB)
      node((0, 0), [], stroke: red, fill: none, width: 2.2cm, height: 1cm, corner-radius: 0.5cm),
      node((0, -0.4), [#text(fill: red)[UB]], name: <ub_label>),

      // 2. Ovale rosso per \{-1, 0\} (LUB)
      node((-1, 1), [], stroke: red, fill: none, width: 2.2cm, height: 1cm, corner-radius: 0.5cm),
      node((-1.7, 1), [#text(fill: red)[LUB]], name: <lub_label>),

      // 3. Ovale di GRUPPO verde per \{-1\} e \{0\} (S)
      node((-0.5, 2), [], stroke: rgb("#2d5c3f"), fill: none, width: 6.0cm, height: 1.2cm, corner-radius: 0.6cm),
      node((-1.7, 2), [#text(fill: rgb("#2d5c3f"))[S]], name: <s_label>),

      // --- COLLEGAMENTI (LINEE BLU) ---
      edge(<pair_m1_0>, <top>, stroke: blue),
      edge(<pair_m1_1>, <top>, stroke: blue),
      edge(<pair_0_1>, <top>, stroke: blue),

      edge(<single_m1>, <pair_m1_0>, stroke: blue),
      edge(<single_m1>, <pair_m1_1>, stroke: blue),
      edge(<single_0>, <pair_m1_0>, stroke: blue),
      edge(<single_0>, <pair_0_1>, stroke: blue),
      edge(<single_1>, <pair_m1_1>, stroke: blue),
      edge(<single_1>, <pair_0_1>, stroke: blue),

      edge(<empty>, <single_m1>, stroke: blue),
      edge(<empty>, <single_0>, stroke: blue),
      edge(<empty>, <single_1>, stroke: blue),
    )
  ]

  Nel diagramma qui sopra possiamo vedere che i due insiemi $ {-1, 0, 1}, {-1, 0} $ sono entrambi upper bound
  per l'insieme $"S" = {{-1}, {0}}$.
  Il *least upper bound* in questo caso è l'insieme ${-1, 0}$.

  Seguendo la struttura del diagramma, in questo caso il LUB è sempre il primo UB che troviamo muovendoci verso l'alto lungo il diagramma.
]

#example(name: "Esempio con pseudocodice")[
  Vediamo un caso in cui un diagramma di Hasse può tornare utile per i nostri scopi.

  Prendiamo in considerazione il seguente pseudocodice:

  #pseudocode-list[
    + *int* arr[10]
    + *if* (function()) *then*
      + $x <- 5$
    + *else*
      + $x <- 7$
    + *end*
    + arr[x]
  ]

  Per questo pseudocodice possiamo creare un diagramma di Hasse con i possibili valori che x può assumere:

  #align(center)[
    #diagram(
      node-stroke: none,
      spacing: (3em, 3em),

      // Livello superiore
      node((1, 0), $\{5,6,7\}$, name: <567>),

      // Livello intermedio
      node((0, 1), $\{5,6\}$, name: <56>),
      node((1, 1), $\{5,7\}$, name: <57>),
      node((2, 1), $\{6,7\}$, name: <67>),

      // Livello inferiore
      node((0, 2), $\{5\}$, name: <5>),
      node((1, 2), $\{6\}$, name: <6>),
      node((2, 2), $\{7\}$, name: <7>),

      // Archi dal top ai sottoinsiemi di livello intermedio
      edge(<567>, <56>, "-"),
      edge(<567>, <57>, "-", label: text(red)[LUB], label-side: right),
      edge(<567>, <67>, "-"),

      // Archi dal livello intermedio ai singoletti
      edge(<56>, <5>, "-"),
      edge(<56>, <6>, "-"),
      edge(<57>, <5>, "-"),
      edge(<57>, <7>, "-"),
      edge(<67>, <6>, "-"),
      edge(<67>, <7>, "-"),
    )
  ]

  #v(1.5cm)

  In questo caso il LUB è l'insieme ${5, 7}$, questo ci permette di controllare se _x_ avrà un valore compreso tra 0 e 9 quando proviamo ad accedere all'array _arr_.
  Se avessimo scelto l'insieme ${5, 7, 12}$, che fa sempre parte del dominio della variabile _x_, avremmo ottenuto un falso positivo, dato che _x_ può assumere il valore 12 che è fuori dal bound ${0..9}$ dell'array.
]


Seguono esempi di diagrammi di Hasse con GLB e LUB:

#example(name: "Diagrammi di Hesse con lub e glb")[
  #grid(
    columns: 2,
    gutter: 5em,
    align: horizon,

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

      node(enclose: (<T>, <i>), stroke: green, shape: shapes.ellipse, inset: 12pt),
      node(enclose: (<i>,), stroke: orange, shape: shapes.ellipse, inset: 10pt),
      node(enclose: (<T>), stroke: red, shape: shapes.ellipse, inset: 10pt),
      node((rel: (1.2, -0.3), to: <i>), text(fill: orange)[glb]),
      node((rel: (-1.2, -0.3), to: <T>), text(fill: red)[lub]),
    ),

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

      node(enclose: (<f>, <g>, <b>, <c>), stroke: green, shape: shapes.ellipse, inset: 10pt),
      node(enclose: (<i>,), stroke: red, shape: shapes.ellipse, inset: 10pt),
      node(enclose: (<bot>,), stroke: orange, shape: shapes.ellipse, inset: 10pt),
      node((rel: (1.2, -0.3), to: <i>), text(fill: red)[lub]),
      node((rel: (1.2, 0.3), to: <bot>), text(fill: orange)[glb]),
    ),
  )

  Il diagramma di Hasse di sinistra, prendendo come insieme $S = {top, "i"}$, abbiamo come glb l'elemento $i$, questo perché il glb, se esiste, deve essere unico; l'altra scelta sarebbe ricaduta tra $f$ e $g$ che possono essere glb per l'insieme $S$.

  Invece per quello di destra, prendendo come insieme $S = {"f", "g", "b", "c"}$, abbiamo come glb l'elemento $bot$, e come lub $i$. Sempre per lo stesso discorso fatto per il diagramma di sinistra, lub e glb se esistono sono unici; $i$ collega direttamente tutti gli elementi di $S$, stessa cosa per $bot$.
] <ex-lub-glb>

#definition(name: "Supremo/Top/Maximum")[
  Un top di $"S" subset.eq "X"$ se: $"x" in "S"$, e $"x"$ è lub.
]

#definition(name: "Infinimum/Bottom/Minimum")[
  Un bottom di $"S" subset.eq "X"$ se $"x" in "S"$ e $"x"$ è glb.
]

#definition(name: "Operatori lub e glb")[
  Possiamo definire anche i due operatori lub e glb come segue:

  Per lub usiamo $union.sq "S" = "lub"$

  Per glb usiamo $inter.sq "S" = "glb"$

  Valgono anche le seguenti equivalenze:

  $ union.sq {"a", "b"} -> "a" union.sq "b" $

  $ inter.sq {"b", "c"} -> "b" inter.sq "c" $
]

#note()[
  Quando lavoriamo con PoSet possiamo definire anche gli operatori di lub e glb:

  $ chevron.l "X", subset.sq.eq, union.sq, inter.sq chevron.r $

]
== Lattice (Reticoli)

Una cosa importante in interpretazione astratta per l'analisi del software è il concetto di *lattice*, o reticolo.
Vedremo più avanti nel corso cosa ci permette di fare il concetto di reticolo per i nostri scopi.

Intanto diamo una definizione di reticolo:

#definition(name: "Reticolo (Lattice)")[
  Partendo da un PoSet $chevron.l "X", subset.sq.eq chevron.r$ è un reticolo se vengono rispettate le seguenti proprietà:

  - Join semi-lattice: $forall "x", "y" in "X", quad exists thin "x" union.sq "y"$; _Per ogni coppia $"x"$ e $"y"$ deve sempre esistere il lub_.
  - Meet semi-lattice: $forall "x", "y" in "X", quad exists thin "x" inter.sq "y"$; _Per ogni coppia $"x"$ e $"y"$ deve sempre esistere il glb_.

  _Il termine reticolo e lattice indicano la stessa cosa._

]
#v(1.5cm)

#example(name: "Esempi di join, meet semi-lattice e di reticolo")[

  #align(center)[
    #grid(
      columns: 2,
      gutter: 5em,
      align: horizon,

      figure(
        diagram(
          node-stroke: none,
          node-fill: none,
          spacing: (1.5em, 2.5em),

          node((1, 0), $top$, name: <T>),
          node((0, 1), $b$, name: <b>),
          node((2, 1), $c$, name: <c>),

          edge(<b>, <T>, "-"),
          edge(<c>, <T>, "-"),
        ),
        caption: [È un join semi-lattice],
      ),

      figure(
        diagram(
          node-stroke: none,
          node-fill: none,
          spacing: (1.5em, 2.5em),

          node((0, 0), $b$, name: <b>),
          node((2, 0), $c$, name: <c>),
          node((1, 1), $bot$, name: <bot>),

          edge(<b>, <bot>, "-"),
          edge(<c>, <bot>, "-"),
        ),
        caption: [È  un meet semi-lattice],
      ),
    )
  ]

  #align(center)[
    #figure(
      diagram(
        node-stroke: none,
        node-fill: none,
        spacing: (1.5em, 2.5em),

        node((1, 0), $top$, name: <T>),
        node((0, 1), $b$, name: <b>),
        node((2, 1), $c$, name: <c>),
        node((1, 2), $bot$, name: <bot>),

        edge(<b>, <T>, "-"),
        edge(<c>, <T>, "-"),
        edge(<b>, <bot>, "-"),
        edge(<c>, <bot>, "-"),
      ),
      caption: [Questo è un reticolo],
    )
  ]

]
Una domanda sollevata dal prof, se prendessimo il PoSet: $chevron.l cal(P)("X"), subset.eq, union, inter chevron.r$ è un reticolo.
Ma se $"X"$ è infinito, allora il reticolo è infinito anche in altezza?

Qualsiasi sottoinsieme di $X$, ottenuto tramite intersezione o unione, rimane sempre nell'insieme delle parti di $X$.

Per esempio: $chevron.l ZZ, <=, max, min chevron.r$ è un reticolo.

#definition(name: "Lub e Glb di un insieme S")[
  Possiamo dare un'altra definizione di _lub_ e _glb_ per un insieme $S$:

  $ "lub: " union.sq "S" = min{"s"' | forall "s" in "S", "s"' supset.sq "s"} $

  $ "glb: " inter.sq "S" = max{"s"' | forall "s" in "S", "s"' subset.sq "s"} $
]

#note()[
  Un altro esempio è quello dei linguaggi regolari, prendiamo in considerazione:

  $chevron.l "L"_("reg"), subset.eq, union, inter chevron.r$, questo è un PoSet.

  Questo perché  l'intersezione e l'unione di due o più linguaggi regolari è sempre un linguaggio regolare.
  Ma nel caso in cui dovessi prendere in considerazione un'unione infinita come:

  $ "L"_"i" = {"a"^"n", "b"^"n" | "n" in NN} $
  $ union "L"_"i" = {"a"^"n", "b"^"n" | n in NN} $

  Con questa unione infinita non abbiamo più un linguaggio regolare, è un reticolo, ma non completo.

  _La definizione di reticolo completo sarà nella prossima lezione._
]

