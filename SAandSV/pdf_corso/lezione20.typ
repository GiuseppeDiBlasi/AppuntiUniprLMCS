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
