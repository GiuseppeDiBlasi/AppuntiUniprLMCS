#import "../../Template typst/template.typ": (
  c-border, definition, example, lbs, note, rbs, separator, sqglb, sqle, sqlub, theorem,
)
#import "@preview/fletcher:0.5.8": diagram, edge, node, shapes
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

= Lezione 20 del 6 novembre 2026

Nella lezione 15 (@int-wid-nar) era stato introdotto l'operatore di widening e di narrowing.
Brevemente, il widening ci permetteva di approssimare il lub nel caso di calcoli di least fixpoint che non corvergevano mai, mentre il narrowing ci permette di approssimare il glb cercando di avvicinarsi il più possibile al least fixpoint.

Riprendiamo questi due concetti e li gaurdiamo nel dettaglio.

== Operatore di widening

Abbiamo detto che ci permette di approssimare l'operatore di lub quando il calcolo del least fixpoint non converge.
Applicando l'operatore di widening ($nabla$), non sempre otteniamo il least fixpoint, ma nella maggior parte troviamo un post-fixpoint, che è una *sovra-approssimazione* del least fixpoint.
Questa sovra-approssimazione ci garantisce la *convergenza*.

L'operatore di widening è da utilizzare solo per domini che *NON* rispettano la ACC.

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1.5em,
  align: bottom,
  figure(
    image("img/lezione20/divergence.svg", width: 70%),
    caption: [Iterazione che diverge: la sequenza non raggiunge mai il $"lfp"(f)$ in un tempo finito.],
  ),
  figure(
    image("img/lezione20/widening.svg", width: 70%),
    caption: [Con il widening si sovra-approssima il $"lfp"(f)$ ma si garantisce la convergenza.],
  ),
)

Definendo formalmente l'operatore di widening:

#definition(name: "Operatore di widening")[
  Un operatore binario, $nabla : A times A arrow A$ è un operatore di widening in un dominio astratto $chevron.l A, subset.sq chevron.r$ se:

  - Ci permette di calcolare upper bound: $forall x, y in A: x subset.sq x nabla y and forall x,y in A: y subset.sq x nabla y$
  - Garantisce la convergenza, per una qualunque sequenza finita o infinita $(y^i)_(i in NN)$ nel dominio $A$, la sequenza $(x^i)_(i in NN)$ viene calcolata come $x^0 = y^0, quad x^(i + 1) = x^i nabla y^i + 1$ si stabilizza in un tempo finito, ovvero: $exists k >= 0. x^(k + 1) = x^k$
]

Se consideriamo la sequenza:
$ (y^i)_(i in NN) = [0, 0] union.sq [0, 1] union.sq [0, 2] union.sq [0, 3] union.sq [0, 4] dots $

Questa sequenza diverge, non otterremmo un risultato in un tempo finito. Con l'operatore di widening possiamo fare una sovra-approssimazione definita nel seguente modo:

$
  cases(
    x_0 = y_0,
    x^(i + 1) = x^i nabla y^(i + 1), gap: #1em
  )
$

Un esempio di definizione di widening può essere:

$ x nabla y = cases(x & quad "se" y subset.sq x, top & quad "altrimenti", gap: #1em) $

È una definizione naive, per gli intervalli invece possiamo l'operatore di widening nel seguente modo:

$
  [a, b] nabla [c, d] = lr(
    [
      cases(a & "if" a <= c, -oo & "otherwise"),
      cases(b & "if" b >= d, +oo & "otherwise")
    ]
  )
$

- Questa definizione non è commutativa: $[2, 3] nabla [1, 4] = [- infinity, + infinity]; quad [1, 4] nabla [2, 3] = [1 ,4]$
- Non è nemmeno monotona: sia $[0, 1] subset.sq [0, 3]; [0, 1] nabla [0, 2] = [0, + infinity]; [0, 3] nabla [0, 2] = [0, 3]$

Guardiamo alcuni esempi di uso per l'operatore di widening:

#example()[
  Prendiamo in considerazione il seguente pseudocodice con il suo CFG corrispondente:

  ```
  x = 0 

  while(x < 40)
    x = x + 1
  ```
  #align(center)[
    #diagram(
      node-stroke: 1pt,
      node-inset: 8pt,
      spacing: (60pt, 40pt),

      // nodi
      node((0, 0), [`x = 0`], name: <n1>),
      node((0, 1), [`x < 40`], name: <n2>),
      node((0, 2), [`x = x + 1`], name: <n3>),
      node((1, 1), [`exit`], name: <n4>),

      // numerazione dei nodi
      node((-0.6, 0), [1], stroke: none),
      node((-0.6, 1), [2], stroke: none),
      node((-0.6, 2), [3], stroke: none),
      node((1, 1.45), [4], stroke: none),

      // archi
      edge(<n1>, <n2>, "->"),
      edge(<n2>, <n3>, "->", label: [true], label-side: left),
      edge(<n2>, <n4>, "->", label: [false], label-side: left),

      // ciclo di ritorno 3 -> 2
      edge(<n3>, <n2>, "->", bend: -60deg),
    )
  ]
  Calcoliamo il punto fisso di questo questo programma, partiamo con le equazioni dei singoli program point:

  $
    F = cases(
      x_1 = [- infinity, + infinity],
      x_2 = lbs x = x + 1 rbs^"#" x_3 union.sq lbs x = 0 rbs^"#" x_1,
      x_3 = lbs x < 40 rbs^"#" x_2,
      x_4 = lbs x >= 40 rbs^"#" x_2, gap: #1em
    )
  $

  #separator()

  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1em,
    align: horizon,
    $
      F_0 = cases(
        delim: "{",
        gap: #1em,
        x_1 = bot,
        x_2 = bot,
        x_3 = bot,
        x_4 = bot,
      )
    $,
    $
      F_1 = cases(
        delim: "{",
        gap: #1em,
        x_1 = [- infinity, + infinity],
        x_2 = lbs x = x + 1 rbs^"#" bot union.sq [0, 0] = [0, 0],
        x_3 = lbs x < 40 rbs^"#" [0, 0] = [0, 0],
        x_4 = lbs x >= 40 rbs^"#" [0, 0] = bot,
      )
    $,
  )

  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1em,
    align: horizon,

    $
      F_2 = cases(
        delim: "{",
        gap: #1em,
        x_1 = [- infinity, + infinity],
        x_2 = [1, 1] union.sq [0, 0] = [0, 1],
        x_3 = [0, 1],
        x_4 = bot,
      )
    $,

    $
      F_"lfp" = cases(
        delim: "{",
        gap: #1em,
        x_1 = [- infinity, + infinity],
        x_2 = [0, 40],
        x_3 = [0, 39],
        x_4 = [40, 40],
      )
    $,
  )

  Dopo un tot numero di iterazioni troviamo il fix point $F_"lfp"$; nel caso in cui avessimo avuto una guardia del loop non nota, per esempio una funzione 'fileExists()' la nostra analisi non sarebbe mai terminata. In quel caso avremmo potuto usare l'operatore di widening per convergere a un fixpoint.

]



Guardiamo un caso in cui applicare l'operatore di widening, prendiamo l'esempio della lezione 12 (@ex-lfp-concreto) con le equazioni per lo stesso CFG.
In questo esempio calcoliamo il fix point per il dominio degli intervalli.

In questo caso l'equazione per $x_3$ è il nostro *widening point*, dove applichiamo l'operatore di widening, anche se il programma è costante e la guardia è nota possiamo applicare l'operatore di widening.

#example(name: "Calcolo fixpoint con operatore di widening")[

  $
    F_0^nabla = cases(
      delim: "{",
      gap: #1em,
      x_1 = bot,
      x_2 = bot,
      x_3 = bot,
      x_4 = bot,
      x_5 = bot,
      x_6 = bot,
    )
  $
  $
    F_1^nabla = cases(
      delim: "{",
      gap: #1em,
      x_1 = [- infinity, + infinity],
      x_2 = [0, 0] union.sq bot union.sq bot = [0, 0],
      x_3 = lbs x < 100 rbs^"#" [0, 0] = [0, 0],
      x_4 = lbs x < 50 rbs^"#" [0, 0] = bot,
      x_5 = bot,
      x_6 = bot,
    )
  $

  $
    F_2^nabla = cases(
      delim: "{",
      gap: #1em,
      x_1 = [- infinity, + infinity],
      x_2 = [0, 0] union.sq [2, 2] union.sq bot = [0, 2],
      x_3 = [0, 0] nabla [0, 2] = [0, + infinity],
      x_4 = lbs x < 50 rbs^"#" [0, + infinity] = [0, 49],
      x_5 = lbs x >= 50 rbs^"#" [0, + infinity] = [50, + infinity],
      x_6 = lbs x >= 100 rbs^"#" [0, 2] = bot,
    )
  $

  $
    F_3^nabla = cases(
      delim: "{",
      gap: #1em,
      x_1 = [- infinity, + infinity],
      x_2 = [0, 0] union.sq [2, 51] union.sq [60, + infinity] = [0, + infinity],
      x_3 = [0, 0] nabla [0, + infinity] = [0, + infinity],
      x_4 = lbs x < 50 rbs^"#" [0, + infinity] = [0, 49],
      x_5 = lbs x >= 50 rbs^"#" [0, + infinity] = [50, + infinity],
      x_6 = lbs x >= 100 rbs^"#" [0, +infinity] = [100, + infinity],
    )
  $

  In questo caso applicando l'operatore di widening all'equazione $x_3$ abbiamo ottenuto un fixpoint che non è il least fix point, ma l'applicazione dell'operatore di widening ci ha garantito convergenza per il calcolo del fixpoint.

]

Siccome l'operaore di widening sovra-approssima il least-fixpoint perdiamo abbastanza informazione sopratutto nelle equazioni $x_3, x_4, x_6$.
Per cercare di avvicinarci al least fixpoint possiamo usare l'operatore di narrowing, che approssima il glb.

Volendo potremmo applicare l'operatore di widening a tutte le equazioni per $F$, comportando ovviamente un'enorme perdita di precisione.

== Operatore di narrowing

Dato che l'operatore di widening può portarci in un post-fixpoint facendoci perdere precisione possiamo applicare l'operatore di narrowing per avvicinarci al least-fixpoint.

#figure(
  image("img/lezione20/widening_narrowing_ref.svg", width: 45%),
  caption: [Operatore di narrowing dopo aver applicato il widening.],
)
Definiamo formalmente l'operatore di narrowing:

#definition(name: "Operatore di narrowing")[
  Un operatore binario $Delta : A times A arrow A$ è un operatore di narrowing in un dominio astratto $chevron.l A, subset.sq chevron.r$ se:

  - $forall x,y in A: quad x inter.sq y subset.eq.sq x Delta y subset.eq.sq x$
  - Garantisce convergenza per una qualnque sequenza $(y^i)_(i in NN)$ in $A$, la sequenza $(x^i)_(i in NN)$ calcolata come $x^0 = y^0$, $x^(i + 1) = x^i Delta y^(i + 1)$, si stabilizza in un tempo finito, ovvero: $exists k >= 0. x^(k + 1) = x^k$
]

#let cap(n, body) = text(size: 0.9em)[*Operatore #n.* #body]
#let blank = $x #h(2em) y$

#grid(
  columns: (1fr, 1fr),
  column-gutter: 2em,
  row-gutter: (0.5em, 2em, 0.5em, 2em, 0.5em),
  align: center + top,

  // riga 1: formule
  $x nabla y$, blank,
  // riga 1: caption
  cap(1)[Widening: sovra-approssima il $"lfp"(f)$ e garantisce la convergenza], [],

  // riga 2: formule
  $x union.sq y$, $x Delta y$,
  // riga 2: caption
  cap(2)[Operatore Lub], cap(3)[Narrowing: raffina il risultato scendendo verso il $"lfp"(f)$],

  // riga 3: formule
  blank, $x inter.sq y$,
  // riga 3: caption
  [], cap(4)[Operatore glb.],
)

#note[
  Applicando il narrowing *NON* possiamo superare il least-fixpoint.
]
#pagebreak()
Il narrowing per gli intervalli possiamo definirlo nel seguente modo:

$
  [a, b] Delta [c, d] = lr(
    [
      cases(c & "if" a = -oo, a & "otherwise"),
      cases(d & "if" b = +oo, b & "otherwise")
    ]
  )
$

L'operatore di narrowing viene applicato nei widening points, dopo aver calcolato il fix point con il widening. Vediamo un'applicazione di narrowing sull'esempio precedente dopo aver calcolato il fixpoint tramite widening.

$
  F^sharp = cases(
    x_i = x_i triangle.stroked.t f_i^sharp (x_1, ..., x_m) & "if" i in W P,
    x_i = x_i inter.sq f_i^sharp (x_1, ..., x_m) & "otherwise"
  )
$

#example(name: "Calcolo fixpoint con narrowing dopo l'applicazione del widening")[
  Partiamo da $F_3^nabla$ dell'esempio precedente e applichiamo l'operatore di narrowing:

  $
    F_1^Delta = cases(
      delim: "{",
      gap: #1em,
      x_1 = [- infinity, + infinity],
      x_2 = [0, 0] union.sq [2, 51] union.sq [60, + infinity] = [0, + infinity],
      x_3 = [0, 0] Delta [0, 99] = [0, 99],
      x_4 = lbs x < 50 rbs^"#" [0, + infinity] = [0, 49],
      x_5 = lbs x >= 50 rbs^"#" [0, 99] = [50, 99],
      x_6 = lbs x >= 100 rbs^"#" [0, +infinity] = [100, + infinity],
    )
  $

  Per l'equazione $x_2$ dobbiamo fare il lub con la valutazione corrente e la valutazione precedete, quindi $[0, +infinity] inter.sq [0, + infinity] = [0, + infinity]$.


  $
    F_2^Delta = cases(
      delim: "{",
      gap: #1em,
      x_1 = [- infinity, + infinity],
      x_2 = [0, 0] union.sq [2, 51] union.sq [60, 109] = [0, 109],
      x_3 = [0, 0] Delta [0, 109] = [0, 99],
      x_4 = lbs x < 50 rbs^"#" [0, 99] = [0, 49],
      x_5 = lbs x >= 50 rbs^"#" [0, 99] = [50, 99],
      x_6 = lbs x >= 100 rbs^"#" [0, +infinity] = [100, 109],
    )
  $


  Iterando nuovamente troveremmo $F_3^Delta = F_2^Delta$ come fix point.

  Applicando il narrowing siamo riusciti a migliorare l'approssimazione del widening ma non abbiamo ottenuto il least fixpoint del programma che ci interessava. Ma abbiamo garantito la convergenza, cosa molto utile se avessimo avuto una guardia non nota.
]

#note[
  Volendo potremmo usare anche il glb al posto dell'operatore di narrowing, questo ci permette di ottenere sempre un'approssimazione verso il least-fixpoint seppur peggiore rispetto all'operatore di narrowing.
]

#figure(
  image("img/lezione20/widening_narrowing_glb.svg", width: 45%),
  caption: [Differenza tra widening, narrowing e glb. Il glb ci restituisce un risultato meno preciso rispetto al narrowing. Con il narrowing invece, se siamo fortunati, possiamo arrivare al least-fixpoint.],
)
