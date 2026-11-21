#import "../../Template typst/template.typ": (
  c-border, definition, example, lbs, note, rbs, separator, sqglb, sqle, sqlub, theorem,
)
#import "@preview/fletcher:0.5.8": diagram, edge, node, shapes
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

= Lezione 24 del 20 novembre 2026

Nelle ultime lezioni abbiamo visto domini astratti per le stringhe, suffisso, prefisso e char inclusion.
Un altro dominio astratto utile per le stringhe è quello degli automi.

== Dominio degli automi

Il dominio concreto di partenza è l'insieme delle parti per l'insieme di stringhe di un alfabeto $Sigma^*$, quindi $cal(P)(Sigma^*)$.
Il dominio astratto sarà il DFA che accetta le stringhe passate come argomento alla funzione d'astrazione $alpha$.

Ovviamente per un determinato insieme di stringhe S, abbiamo più DFA che possono accettare le stringhe contenute in esse. Noi vogliamo, come classe d'equivalenza, il DFA *minimo* che accetti tutte le stringhe contenute dentro all'insieme S.

#example(name: "Esempio di astrazione da stringhe a DFA")[
  Partiamo da un insieme $S = {"abc", "def"}$.

  La funzione $alpha(S)$ ci restituisce il DFA minimo che riconosce le stringhe 'abc' e 'def'.

  #figure(
    scale(60%, reflow: true, diagram(
      node-stroke: 0.08em,
      node-inset: 0.5em,
      spacing: (5em, 3.5em),
      edge-stroke: 0.07em,

      // Stati
      node((0, 1), $q_0$, name: <q0>, shape: circle),
      node((1, 0), $q_1$, name: <q1>, shape: circle),
      node((2, 0), $q_2$, name: <q2>, shape: circle),
      node((3, 1), $q_3$, name: <q3>, shape: circle, extrude: (0, 3)), // stato finale
      node((1, 2), $q_4$, name: <q4>, shape: circle),
      node((2, 2), $q_5$, name: <q5>, shape: circle),
      node((0, 3), $q_s$, name: <qs>, shape: circle), // stato pozzo

      // Ramo abc
      edge(<q0>, <q1>, "->", $a$, label-side: left),
      edge(<q1>, <q2>, "->", $b$, label-side: left),
      edge(<q2>, <q3>, "->", $c$, label-side: left),

      // Ramo def
      edge(<q0>, <q4>, "->", $d$, label-side: left),
      edge(<q4>, <q5>, "->", $e$, label-side: left),
      edge(<q5>, <q3>, "->", $f$, label-side: left),

      // Verso lo stato pozzo
      edge(<q0>, <qs>, "->", $c in Sigma without {a, d}$, label-side: right),
      edge(<q3>, <qs>, "->", $c in Sigma$, bend: 35deg, label-side: right),
      edge(<qs>, <qs>, "->", $c in Sigma$, bend: 130deg, loop-angle: 180deg),
    )),
    caption: [DFA minimo per S.],
  )

  Per le stringhe definite da: ${a^n | n in N}$ abbiamo:


  #let dfa = diagram.with(
    node-stroke: 0.08em,
    node-inset: 0.7em,
    node-outset: 0.2em,
    spacing: (9em, 6em),
    edge-stroke: 0.07em,
    label-sep: 0.6em,
  )

  #grid(
    columns: 2,
    column-gutter: 8em,
    align: bottom,

    // Sinistra: q0 iniziale e finale con self-loop su a
    figure(
      dfa(
        node((0, 0), $q_0$, name: <q0>, shape: circle, extrude: (0, 4)),
        edge((-0.5, 0), <q0>, "->"),
        // loop a destra (0deg = destra, 90deg = sopra)
        edge(<q0>, <q0>, "->", $a$, bend: 130deg, loop-angle: 0deg),
      ),
      caption: [DFA con un solo stato, iniziale e finale.],
    ),

    // Destra: q0 finale --a--> q1 finale con self-loop su a
    figure(
      dfa(
        node((0, 0), $q_0$, name: <q0>, shape: circle, extrude: (0, 4)),
        node((1, 0), $q_1$, name: <q1>, shape: circle, extrude: (0, 4)),
        edge(<q0>, <q1>, "->", $a$, label-side: left),
        // loop sopra q1
        edge(<q1>, <q1>, "->", $a$, bend: 130deg, loop-angle: 90deg),
      ),
      caption: [DFA con due stati, entrambi finali.],
    ),
  )

]

Passiamo ora a definire formalmente il dominio astratto.

#pagebreak()

== Dominio astratto dei DFA

Definiamo il dominio astratto come il seguente PoSet:
$ chevron.l "DFA"_(slash equiv), sqle("DFA"), union.sq_"DFA", inter.sq_"DFA", top_"DFA", bot_"DFA" chevron.r $

Come elemento top abbiamo il DFA minimo che accetta qualunque stringa dell'alfabeto, mentre come elemento bottom abbiamo il DFA minimo che non accetta nessuna stringa.

#let dfa = diagram.with(
  node-stroke: 0.08em,
  node-inset: 0.7em,
  node-outset: 0.2em,
  spacing: (9em, 6em),
  edge-stroke: 0.07em,
  label-sep: 0.6em,
)

#align(center)[


  #grid(
    columns: 2,
    column-gutter: 8em,
    align: bottom,

    // Bottom: q0 iniziale, non finale, self-loop su Σ
    figure(
      dfa(
        node((0, 0), $q_0$, name: <q0>, shape: circle),
        edge((-0.5, 0), <q0>, "->"),
        edge(<q0>, <q0>, "->", $c in Sigma$, bend: 130deg, loop-angle: 0deg),
      ),
      caption: [Bottom, DFA minimo che rifiuta tutte le stringhe.],
    ),

    // Top: q0 iniziale e finale, self-loop su Σ
    figure(
      dfa(
        node((0, 0), $q_0$, name: <q0>, shape: circle, extrude: (0, 4)),
        edge((-0.5, 0), <q0>, "->"),
        edge(<q0>, <q0>, "->", $c in Sigma$, bend: 130deg, loop-angle: 0deg),
      ),
      caption: [Top, DFA minimo che accetta tutte le stringhe.],
    ),
  )
]

=== Operatore lub

Definiamo il lub tra due automi $A_1$ e $A_2$:

$ A_1 sqlub("DFA") A_2 $

Il lub combina i due automi tramite $epsilon-"transizioni"$, così facendo otteniamo un NFA, dobbiamo poi usare *subset construction* per passare da un NFA a un DFA. Dal DFA ottenuto tramite la subset construction, dobbiamo poi minimizzarlo.

#let automa = figure(
  diagram(
    node-stroke: 0.08em,
    node-inset: 0.7em,
    node-outset: 0.2em,
    spacing: (7em, 3.5em),
    edge-stroke: 0.07em,
    label-sep: 0.6em,

    node((0, 1), $q_0$, name: <q0>, shape: circle),
    node((1, 0), $A_1$, name: <a1>, shape: rect, inset: 1em),
    node((1, 2), $A_2$, name: <a2>, shape: rect, inset: 1em),
    node((2, 1), $q_F$, name: <qf>, shape: circle, extrude: (0, 4)),

    edge(<q0>, <a1>, "->", $epsilon$, bend: -20deg, label-side: left),
    edge(<q0>, <a2>, "->", $epsilon$, bend: 20deg, label-side: right),
    edge(<a1>, <qf>, "->", $epsilon$, bend: -20deg, label-side: left),
    edge(<a2>, <qf>, "->", $epsilon$, bend: 20deg, label-side: right),
  ),
  caption: [Lub tra due automi.],
)

$ "min" lr(( #box(automa, baseline: 50%) )) $

== Operatore glb

Il glb tra due automi $A_1$ e $A_2$ è definito come:

$ A_1 sqglb("DFA") A_2 = "prodotto tra automi" $


== Operatore d'ordinamento

Definiamo l'operatore di ordinamento tra due automi $A_1$ e $A_2$ come segue:

$ A_1 sqle("DFA") A_2 <=> L(A_1) subset.eq L(A_2) = L(A_1) inter overline(L(A_2)) = emptyset $

La negazione di un automa $A$ che accetta tutte le stringhe dell'alfabeto $Sigma$, vuol dire che la sua negazione rifiuterà le stringhe dell'automa $A$ accettando tutte le altre.
Guardiamo un esempio di DFA e il suo corrispettivo negato:

#example(name: "DFA Negato")[

  #let dfa(finals) = {
    let st(pos, lbl, name) = node(
      pos,
      lbl,
      name: name,
      shape: circle,
      extrude: if name in finals { (0, 3) } else { (0,) },
    )

    diagram(
      node-stroke: 0.8pt,
      edge-stroke: 0.8pt,
      node-inset: 8pt,
      spacing: (4em, 4em),

      // stati
      st((0, 0), $q_0$, <q0>),
      st((1, 0), $q_1$, <q1>),
      st((2, 0), $q_2$, <q2>),
      st((1, 1), $q_s$, <qs>),

      // stato iniziale
      edge((-0.6, 0), <q0>, "-|>"),

      // transizioni
      edge(<q0>, <q1>, "-|>", $a$, label-side: left),
      edge(<q1>, <q2>, "-|>", $b$, label-side: left),
      edge(<q0>, <qs>, "-|>", $b$, label-side: right),
      edge(<q1>, <qs>, "-|>", $a$, label-side: left),
      edge(<q2>, <qs>, "-|>", $a, b$, label-side: left),

      // cappio sullo stato pozzo
      edge(<qs>, <qs>, "-|>", $c in Sigma$, bend: 130deg, loop-angle: -90deg),
    )
  }

  #align(center)[
    #grid(
      columns: 2,
      column-gutter: 6em,
      align: bottom,

      figure(
        dfa((<q2>,)),
        caption: [DFA $A$ con $Sigma = {a, b}$: accetta solo $a b$.],
      ),

      figure(
        dfa((<q0>, <q1>, <qs>)),
        caption: [DFA $overline(A)$, complemento di $A$: accetta tutto tranne $a b$.],
      ),
    )
  ]
]

Il PoSet degli automi è un reticolo, dato che abbiamo lub e glb per ogni elemento del dominio, ma non è un reticolo completo. Questo è dovuto al fatto che non tutti i sottoinsiemi possibili del dominio hanno lub e glb.

Non abbiamo una Galois Connection tra il concreto e l'astratto, questo perché in generale non esiste la best approximation per ogni elemento concreto del dominio concreto.

#example(name: "Perché non abbiamo la best approximation per i DFA")[
  Era già saltato fuori il perché nelle scorse lezioni, sia con i DFA che con altri domini.
  Non abbiamo la best abstraction perché per determinati linguaggi possiamo trovare sempre un DFA minimo che migliora l'approssimazione che abbiamo scelto.

  Per esempio ipotizziamo di voler approssimare il linguaggio:

  $ i in NN, L_i = {a^i b^i}, quad exists A_i "t.c:" quad union L_i = {a^n b^n | n in NN} $

  Questo è un linguaggio context-free, quindi per rappresentarlo tramite un DFA minimo dobbiamo realizzare una sua approssimazione.
  Per esempio se consideriamo $a^* b^*$, è un approssimazione per quel linguaggio, ma non è la migliore. Possiamo definire un'approssimazione migliore:

  $ {epsilon, "ab", "aabb"} union {a^n b^m | n + m > 4} $

  Anche per questa approssimazione, possiamo definire una migliore:

  $ {epsilon, "ab", "aabb", "aaabbb"} union {a^n b^m | n + m > 6} $

  E così via...

]

Guardiamo un esempio di analisi di stringhe tramite automi sul linguaggio JavaScript.

#example(name: "Esempio di DFA su un esempio concreto")[

  Prendiamo come esempio uno snippet di codice in JavaScript dove viene chiamata la funzione 'eval' che può portare a problemi di sicurezza.

  Prendiamo in considerazione il seguente snippet di codice:

  ```
  if(...)
    x = "a++;"
  else 
    x = "b++;"

  eval(x);

  ```

  Le possibili esecuzioni per 'eval' sono descritte dal seguente DFA:

  #align(center)[
    #scale(60%, reflow: true, diagram(
      node-stroke: 0.8pt,
      node-inset: 0pt,
      spacing: (2cm, 0.6cm),

      // stato iniziale
      edge((-0.8, 0), (0, 0), "-|>"),
      node((0, 0), "", shape: circle, radius: 11pt, name: <q0>),

      // ramo a
      node((1, -1), "", shape: circle, radius: 11pt, name: <a1>),
      node((2, -1), "", shape: circle, radius: 11pt, name: <a2>),
      node((3, -1), "", shape: circle, radius: 11pt, name: <a3>),

      // ramo b
      node((1, 1), "", shape: circle, radius: 11pt, name: <b1>),
      node((2, 1), "", shape: circle, radius: 11pt, name: <b2>),
      node((3, 1), "", shape: circle, radius: 11pt, name: <b3>),

      // stato finale (doppio cerchio)
      node((4, 0), "", shape: circle, radius: 11pt, name: <qf>),
      node((4, 0), "", shape: circle, radius: 7pt),

      // transizioni ramo a
      edge(<q0>, <a1>, $a$, "-|>"),
      edge(<a1>, <a2>, $+$, "-|>"),
      edge(<a2>, <a3>, $+$, "-|>"),
      edge(<a3>, <qf>, $;$, "-|>"),

      // transizioni ramo b
      edge(<q0>, <b1>, $b$, "-|>"),
      edge(<b1>, <b2>, $+$, "-|>"),
      edge(<b2>, <b3>, $+$, "-|>"),
      edge(<b3>, <qf>, $;$, "-|>"),
    ))
  ]

  Per questo snipet di codice, dobbiamo analizzare entrambi i branch, quindi abbiamo bisogno di un CFG che approssimi in maniera sound tutti i comportamenti possibili di quel codice.

  Per fare ciò, dobbiamo creare un CFG che esegue entrambi i branch dell'if:

  #let state(x, a, b) = align(left, text(size: 9pt)[
    $x arrow.r.bar top$ \
    $a arrow.r.bar [#a]$ \
    $b arrow.r.bar [#b]$
  ])


  #align(center)[
    #scale(55%, reflow: true, diagram(
      node-stroke: 0.8pt,
      node-inset: 8pt,
      spacing: (3.5cm, 2.6cm),

      // nodo di partenza (branch)
      node((1, 0), [#h(2.2cm)], shape: rect, name: <entry>),
      node((1, -0.55), state(top, "0,0", "0,0"), stroke: none),

      // rami
      node((0, 1), `a++;`, shape: rect, name: <a>),
      node((2, 1), `b++;`, shape: rect, name: <b>),

      // exit
      node((1, 2), [`exit`], shape: rect, inset: 14pt, name: <exit>),

      // archi
      edge(<entry>, <a>, $"TT"$, "-|>", label-side: left),
      edge(<entry>, <b>, $"TT"$, "-|>", label-side: right),
      edge(<a>, <exit>, "-|>"),
      edge(<b>, <exit>, "-|>"),

      // stati dopo ogni ramo
      node((-0.55, 1.65), state(top, "1,1", "0,0"), stroke: none),
      node((2.55, 1.65), state(top, "0,0", "1,1"), stroke: none),
    ))
  ]
  All'ingresso del blocco 'exit', facciamo il lub tra i due archi entranti e otteniamo la memoria:

  $ x arrow top; a arrow [0, 1]; b arrow [0, 1] $

  Così facendo abbiamo ottenuto un CFG che approssimi tutte le esecuzioni possibili per 'eval'.
]
