#import "../../Template typst/template.typ": (
  c-border, definition, example, lbs, note, rbs, separator, sqglb, sqle, sqlub, theorem,
)
#import "@preview/fletcher:0.5.8": diagram, edge, node, shapes
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node



= Lezione 19 del 5 novembre 2026

In questa lezione introduciamo il dominio degli intervalli. Abbiamo visto la constant propagation e il dominio dei segni.
Il dominio degli intervalli lo definiamo sempre sul linguaggio toy Imp, @lang-imp.

== Dominio degli intervalli

Per il dominio degli intervalli consideriamo gli intervalli chiusi, quindi gli estremi sono inclusi.
È un dominio di tipo cheap, ci fornisce una buona precisione risultando leggero dal punto di vista computazionale.
Ovviamente anche se abbiamo una buona precisione possiamo sempre avere del rumore durante la fase di analisi.

Partiamo definendo formalmente il dominio degli intervalli:

#definition(name: "Dominio degli intervalli")[
  $
    "intv" = {[a, b] | a in ZZ union {- infinity}, b in ZZ union {+ infinity}, a < b} union {bot_"intv"} \
    "Top": [-infinity, +infinity] \
    "Bottom": [bot_"intv"]
  $

  Definiamo ora i vari operatori del reticolo:

  *Operatore d'ordinamento*:

  $ [a, b] sqle("intv") [c, d] <=> a >= c and b <= d $

  *Lub*:

  $ [a, b] sqlub("intv") [c, d] <=> [min(a, c), max(b, d)] $

  L'operatore di lub non è perfettamente esatto dal punto di vista della precisione.

  *Glb*:

  $
    [a, b] sqglb("intv") [c, d] <=> cases(
      [max(a, c), min(b, d)] & quad "se" max(a, c) <= min(b, d),
      bot_"inv" & quad "altrimenti"
    )
  $

  L'operatore glb, a differenza del lub, è esatto dal punto di vista della precisione.


]

Guardiamo più nel dettaglio cosa vuol dire che il lub non è esatto mentre il glb sì.
#pagebreak()

#example(name: "Lub e glb nel dominio degli intervalli")[

  Prendiamo in considerazione l'operazione di lub tra l'intervallo [1, 1] e [3, 3]:
  Applicando il lub otteniamo $[1, 1] sqlub("intv") [3, 3] = [1, 3]$.
  Il least upper bound è l'intervallo $[1, 3]$, però dobbiamo tenere in considerazione che abbiamo aggiunto del rumore, in questo caso abbiamo anche il valore 2 che è compreso nell'intervallo [1, 3] che non compare in nessuno dei due operandi.
  Se concretizziamo i due intervalli e facciamo l'unione nel concreto otteniamo, ${1} union {3} = {1, 3}$, nel concreto non abbiamo il valore 2.

  #align(center)[
    #diagram(
      spacing: (5mm, 7mm),
      node-inset: 3pt,

      // riga astratta
      node((0, 0), $[1, 1]$),
      node((1, 0), $union.sq$),
      node((2, 0), $[3, 3]$),
      node((3, 0), $=$),
      node((4, 0), $[1, 3]$),

      // riga concreta
      node((0, 1), $\{1\}$),
      node((1, 1), $union$),
      node((2, 1), $\{3\}$),
      node((3, 1), $=$),
      node((4, 1), $\{1, 3\}$),

      // frecce di concretizzazione
      edge((0, 0), (0, 1), "->", label: $gamma$, label-side: left),
      edge((2, 0), (2, 1), "->", label: $gamma$, label-side: left),
    )
  ]

]

#align(center)[
  #diagram(
    spacing: (18mm, 10mm),
    node-inset: 4pt,

    // --- GC su Z ---
    node((0, 0), $cal(P)(bb(Z))$, name: <pz>),
    node((2, 0), $"Intv"$, name: <iz>),

    edge(<pz>, <iz>, "->", bend: 35deg, label: $alpha$, label-side: left),
    edge(<iz>, <pz>, "->", bend: 35deg, label: $gamma$, label-side: left),

    // --- su Q ---
    node((4, 0), $cal(P)(bb(Q))$, name: <pq>),
    node((6, 0), $"Intv"$, name: <iq>),

    edge(<pq>, <iq>, "-", bend: 35deg, label: $alpha$, label-side: left),
    edge(<iq>, <pq>, "-", bend: 35deg, label: $gamma$, label-side: left),
  )
]

Se prendessimo in considerazione il dominio degli intervalli per l'insieme delle parti di $ZZ$ abbiamo una Galois connection (@galois-conn) tra il concreto e l'astratto, questo però non vale nel caso in cui prendessimo l'insieme delle parti dei numeri razionali $QQ$.

Per l'insieme delle parti intere abbiamo una connessione di Galois perché gli intervalli hanno estremi interi e $ZZ$ è discreto, quindi per ogni sottoinsieme $S subset ZZ$ limitato c'è un intervallo minimo: $alpha(S) = [min(S), max(S)]$.

Questo perché  nel secondo caso non abbiamo la best approximation per la funzione $alpha$. Possiamo sempre trovare un'approssimazione migliore per un numero razionale. È lo stesso caso del reticolo coi DFA che abbiamo visto nelle lezioni precedenti.

=== Semantica astratta del dominio degli intervalli

Definiamo ora la semantica astratta del dominio degli intervalli. La definiamo sul linguaggio toy Imp.

La semantica astratta è una funzione che prende delle memorie astratte e restituisce un intervallo:

$ S: MM^"#" arrow "intv" $

Definiamo la memoria astratta come una funzione che prende delle variabili $VV$ e restituisce degli intervalli:

$ MM^"#": VV arrow "intv" $

Definiamo ora i vari casi della semantica astratta:

- $lbs x = e rbs^"#" m^"#" = m^"#" [x in lbs e rbs^"#" m^"#"]$, questa è la semantica delle espressioni.

- $lbs c rbs^"#" m^"#" = [c, c]$, semantica per una costante $c$.

- $lbs e_1 + e_2 rbs^"#" m^"#" = [a + c, b + d]$, con $lbs e_1 rbs^"#" m^"#" = [a, b]$ e $lbs e_2 rbs^"#" m^"#" = [c, d]$.

- $lbs e_1 - e_2 rbs^"#" m^"#" = [a - d, b - c]$, con $lbs e_1 rbs^"#" m^"#" = [a, b]$ e $lbs e_2 rbs^"#" m^"#" = [c, d]$.

#example(name: "Addizione tra intervalli")[
  Prendiamo due intervalli $[1, 3]$ e $[7, 9]$ e facciamo la somma astratta su questi due intervalli, otteniamo:

  $ [1, 3] quad +^"#" quad [7, 9] = [8, 12] $

  Confrontando l'astratto con il concreto abbiamo:

  #align(center)[
    #diagram(
      spacing: (5mm, 7mm),
      node-inset: 3pt,
      // riga astratta
      node((0, 0), $[1, 3]$),
      node((1, 0), $+^\#$),
      node((2, 0), $[7, 9]$),
      node((3, 0), $=$),
      node((4, 0), $[8, 12]$),

      // riga concreta
      node((0, 1), $\{1, 2, 3\}$),
      node((1, 1), $+$),
      node((2, 1), $\{7, 8, 9\}$),
      node((3, 1), $=$),
      node((4, 1), $\{8, 9, 10, 11, 12\}$),

      // frecce di concretizzazione
      edge((0, 0), (0, 1), "->", label: $gamma$, label-side: left),
      edge((2, 0), (2, 1), "->", label: $gamma$, label-side: left),
    )
  ]

  Con la sottrazione invece:

  #align(center)[
    #diagram(
      spacing: (5mm, 7mm),
      node-inset: 3pt,

      // riga astratta
      node((0, 0), $[5, 8]$),
      node((1, 0), $-^\#$),
      node((2, 0), $[1, 3]$),
      node((3, 0), $=$),
      node((4, 0), $[2, 7]$),

      // riga concreta
      node((0, 1), $\{5, 6, 7, 8\}$),
      node((1, 1), $-$),
      node((2, 1), $\{1, 2, 3\}$),
      node((3, 1), $=$),
      node((4, 1), $\{2, 3, 4, 5, 6, 7\}$),

      // frecce di concretizzazione
      edge((0, 0), (0, 1), "->", label: $gamma$, label-side: left),
      edge((2, 0), (2, 1), "->", label: $gamma$, label-side: left),
    )
  ]
]

Definiamo ora la semantica per le operazioni di moltiplicazione e divisione, qui le cose si fanno un po' più articolate soprattutto per la divisione.

- $lbs e_1 * e_2 rbs^"#" m^"#" = [min(a*c, a*d, b*c, b*d), max(a*c, a*d, b*c, b*d)]$\ \ con $lbs e_1 rbs^"#" m^"#" = [a, b]$ e $lbs e_2 rbs^"#" = [c, d]$

#v(0.8cm)

- $lbs e_1 / e_2 rbs^"#" m^"#" cases(
    [min(a/c, a/d), max(b/c, b/d)] & quad "se" c >= 1,
    [min(b/c, b/d), max(a/c, a/d)] & quad "se" d <= -1,
    frac([a, b], [c, d] inter.sq [1, + infinity]) union.sq frac([a, b], [c, d] inter.sq [- infinity, -1]) & quad "altrimenti", gap: #1em
  )$

  Il glb a denominatore serve a prendere solo i valori negativi nel primo e solo i valori positivi nel secondo operando.

  L'ultimo caso della divisione è ricorsivo, una volta applicato il primo passo si ricade in uno dei due casi scritti sopra ad esso.

#note[
  Nel linguaggio Imp la divisione per zero viene valutata a vuoto.
]

Vediamo alcuni esempi per la moltiplicazione e la divisione:

#example(name: "moltiplicazione e divisione astratta nel dominio degli intervalli")[
  Partiamo dalla moltiplicazione, prendiamo in considerazione i due intervalli $[-1, 1]$ e $[-3, -2]$
  Applicando la definizione della semantica astratta per il prodotto tra due intervalli abbiamo:

  $
    [-1, 1] quad *^"#" quad [-3, -2] = [min(-1 * -3, -1 * -2, 1 * -3, 1 * -2),\ max(-1 * -3, -1 * -2, 1 * -3, 1 * -2)] = [-3, 3]
  $

  Confrontandola con l'operazione concreta abbiamo:

  #align(center)[
    #diagram(
      spacing: (5mm, 7mm),
      node-inset: 3pt,

      // riga astratta
      node((0, 0), $[-1, 1]$),
      node((1, 0), $ast.op^\#$),
      node((2, 0), $[-3, -2]$),
      node((3, 0), $=$),
      node((4, 0), $[-3, 3]$),

      // riga concreta
      node((0, 1), $\{-1, 0, 1\}$),
      node((1, 1), $ast.op$),
      node((2, 1), $\{-3, -2\}$),
      node((3, 1), $=$),
      node((4, 1), $\{-3, -2, 0, 2, 3\}$),

      // frecce di concretizzazione
      edge((0, 0), (0, 1), "->", label: $gamma$, label-side: left),
      edge((2, 0), (2, 1), "->", label: $gamma$, label-side: left),
    )
  ]

  #separator()

  Passiamo ora a degli esempi per la divisione, consideriamo la divisione per interi con troncamento, prendiamo due intervalli $[1, 5]$ e $[0, 0]$ se dividiamo per l'ultimo intervallo otteniamo bottom:

  $ [1, 5] / [0, 0] = bot $

  Nel caso in cui invece dividessimo per l'intervallo $[0, 1]$, in questo caso cosa dobbiamo restituire?
  Dobbiamo restituire sempre un intervallo.

  In questo caso dobbiamo fare il lub tra due risultati:

  $ [1, 5] / [0, 1] = [1, 5] / [0, 0] union.sq [1, 5] / [1, 1] = bot union.sq [1, 5] = [1, 5] $

  Nel caso in cui avessimo un intervallo a divisore che sta tra valori positivi e negativi, per esempio [-1, 1], divideremo per la parte negativa, e la parte positiva, e su i due risultati faremo il lub come prima:

  $ [1, 5] / [-1, 1] = [1, 5] / [-1, -1] union.sq [1,5] / [1, 1] = [-5, 5] union.sq [1, 5] = [-5, 5] $

  _In questo caso la divisione per 0 è stata omessa dato che otterremmo bottom_.

  Vediamo un ultimo esempio, prendiamo come numeratore $[1, 2]$ e divisore $[-2, 3]$:

  $ [1, 2] / [-2, 3] = [1, 2] / [-2, -1] union.sq [1, 2] / [1, 3] = [-2, 0] union.sq [0, 2] = [-2, 2] $

]

#pagebreak()

#note[
  Se il denominatore è un intervallo che contiene lo zero, per esempio $[0, 2]$ dobbiamo tenere in considerazione che in un contesto reale capiti la divisione per zero. Per esempio in Java l'espressione:

  $ x = [1, 1] / [0, 2] $

  Questa espressione per Java possiamo gestirla nel seguente modo: avremo una modalità *normal* dove la divisione per [0, 0] non avviene, e una modalità *exception* dove segnaliamo se è possibile che avvenga una divisione con l'intervallo [0, 0] a denominatore.

  Quindi per l'espressione qui sopra avremo:

  - *normal*: $x arrow.l [0, 0]$.
  - *exception*: DivisionByZero.

  Nel caso di:

  $ x = [1, 1] / [1, 2] $

  avremo:
  - *normal*: $x arrow.l [0, 0]$
  - *exception*: $bot$

  In questo caso il campo exception avrà come valore bottom.
]

=== Filtri per il dominio degli intervalli

Passiamo ora all'assume per il dominio degli intervalli, stessa cosa che abbiamo fatto per il dominio dei segni, l'assume è una funzione che prende in input espressioni booleane e memorie astratte restituendo in output una memoria astratta in base alla valutazione dell'espressione.

$ "assume": "B"_"expr" times MM^"#" arrow MM^"#" $

Consideriamo:

$ x arrow [50, 200] \ x <= 100 $

In questo caso possiamo raffinare la parte superiore dell'intervallo ottenendo così:

$ x arrow [50, 100] $

Definendo formalmente l'assume per il caso $e_1 <= e_2$ abbiamo:

$
  "assume"_(e_1 <= e_2) (m^"#") = cases(
    m^"#" [x arrow.l [a, min(b, v)]] & quad "se" e_1 = x quad e_2 = v quad lbs e_1 rbs^"#" = [a, b] thick a <= v,
    m^"#" vec(
      delim: "[",
      align: #left,
      x arrow.l [a, min(b, d)],
      y arrow.l [max(a, c), d]
    ) & quad "se" e_1 = x quad e_2 = y quad lbs e_1 rbs^"#" m^"#" = [a, b] and lbs e_2 rbs^"#" m^"#" = [c, d] and a <= d,
    bot & quad "se" e_1 = x quad e_2 = y quad lbs e_1 rbs^"#" m^"#" = [a, b] and lbs e_2 rbs^"#" m^"#" = [c, d] and a > d,
    bot & quad "se" e_1 = x quad e_2 = v quad a > v quad lbs e_1 rbs^"#" m^"#" = [a, b],
    m^"#", & quad "altrimenti",
    gap: #1em
  )
$

#note[In questa assume ci sono casi con gestiamo e che andrebbero gestiti in un contesto reale.]

Vediamo alcuni esempi con l'assume:

#example(name: "Esempi con assume su dominio degli intervalli")[

  Prendiamo gli intervalli $x = [30, 40]$ e $y = [25, 35]$ e la guardia $x <= y$.

  In questo caso possiamo raffinare entrambi gli intervalli $x$ e $y$, da entrambi gli intervalli scartiamo i valori per cui la guardia viene valutata a false.
  Quindi otteniamo: $x = [30, 50]$, $y = [30, 35]$.

  #separator()

  Guardiamo un altro esempio prendendo in considerazione gli intervalli $x = [30, 40]$ e $y = [35, 50]$, sempre con la guardia $x <= y$

  In questo caso valutando l'espressione otterremmo gli stessi intervalli di partenza. Questo perchè i valori dell'intervallo x rispettano già la condizione della guardia sui valori dell'intervallo y.

  #note[
    Guardare ogni singolo valore dell'intervallo e confrontandolo con l'altro aiuta a visualizzare al meglio quello che sta succedendo.
  ]

]


