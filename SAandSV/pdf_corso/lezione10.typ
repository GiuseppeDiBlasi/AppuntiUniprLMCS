#import "../../Template typst/template.typ": (
  c-border, definition, example, lbs, note, rbs, recall, sqglb, sqle, sqlub, supqle, theorem,
)
#import "@preview/fletcher:0.5.8": diagram, edge, node, shapes

= Lezione 10 del 14 ottobre 2026

Nella scorsa lezione abbiamo parlato di approssimazioni e accennato alle connessioni di Galois.
In questa lezione entriamo nel dettaglio per quanto riguarda le connessioni di Galois e funzioni di astrazione e concretizzazione.

== Dominio concreto

Prima di definire le connessioni di Galois, definiamo cos'è un dominio concreto:

#definition(name: "Dominio concreto")[
  Un dominio concreto possiamo vederlo come un complete lattice:

  $ chevron.l cal(P)(ZZ), subset.eq, inter, union, ZZ, emptyset chevron.r $

  - $S_1 subset S_2$ : $S_1$ è più preciso di $S_2$.
  - $S_1 subset.eq.not S_2 and S_2 subset.eq.not S_1$: non sono comparabili.
  - $S_1 union S_2$: $x$ deve essere in $S_1$ o $S_2$.
  - $S_1 inter S_2$: $x$ deve essere in $S_1$ o $S_2$.
  - $ZZ$, l'elemento top, $x$ può essere qualunque valore.
  - $emptyset$, nessun valore possibile, o errore.
]

Il dominio concreto rappresenta i valori reali che assume il programma, lo vedremo come il mondo concreto da astrarre.

== Dominio astratto

I domini astratti invece sono un'astrazione del dominio concreto che prendiamo in considerazione.
Ci sono infiniti domini astratti che rappresentano diversi tipi di informazioni, per esempio insieme dei segni, intervalli etc.
Non tutti i domini però sono confrontabili, per esempio non ha senso confrontare il dominio degli intervalli con quello dei segni dato che uno contiene più informazioni dell'altro. Di conseguenza esiste una gerarchia tra i vari domini che verrà vista più avanti nel corso.

I domini non confrontabili possiamo sfruttarli per combinarli tramite prodotto cartesiano o prodotto ridotto.

Esiste una relazione formale tra il dominio concreto $C$ e il dominio astratto $A$ definita come:

#definition(name: "Dominio astratto")[
  Abbiamo una funzione d'astrazione $alpha$ che prende elementi dal mondo concreto $C$ e li mappa nel mondo astratto $A$.

  $ alpha: C arrow A $

  Abbiamo anche una funzione di concretizzazione, che ci permette di passare dal mondo astratto $A$ al mondo concreto $C$.

  $ gamma : A arrow C $
]

#let reticolo-cp = diagram(
  spacing: (1.5cm, 1.5cm),
  node-stroke: none,

  node((1, 0), $ZZ$, name: <Z>),

  node((0, 1), ${-1, 0}$, name: <a>),
  node((1, 1), ${0, 1}$, name: <b>),
  node((2, 1), ${-1, 1}$, name: <c>),

  node((0, 2), ${-1}$, name: <m1>),
  node((1, 2), ${0}$, name: <z0>),
  node((2, 2), ${1}$, name: <p1>),

  node((1, 3), $emptyset$, name: <e>),

  edge(<e>, <m1>, "-"),
  edge(<e>, <z0>, "-"),
  edge(<e>, <p1>, "-"),

  edge(<m1>, <a>, "-"),
  edge(<m1>, <c>, "-"),
  edge(<z0>, <a>, "-"),
  edge(<z0>, <b>, "-"),
  edge(<p1>, <b>, "-"),
  edge(<p1>, <c>, "-"),

  edge(<a>, <Z>, "-", stroke: (dash: "dotted")),
  edge(<b>, <Z>, "-", stroke: (dash: "dotted")),
  edge(<c>, <Z>, "-", stroke: (dash: "dotted")),
)

#let reticolo-astratto-cp = diagram(
  spacing: (.5cm, 2cm),
  node-stroke: none,

  node((0, 0), $top$, name: <top>),
  node((0, 2), $bot$, name: <bot>),

  for i in range(-2, 3) {
    node((i, 1), $#i$)
    edge((0, 0), (i, 1), "-")
    edge((0, 2), (i, 1), "-")
  },

  node((-3, 1), $dots.c$),
  node((3, 1), $dots.c$),
)


Guardiamo ora alcuni esempi di astrazione da un dominio concreto a uno astratto.

#example[
  Riprendiamo la constant propagation e ridefiniamo il lattice: $ chevron.l cal(P)(ZZ) union {top, bot}, sqle("CP"), sqlub("CP"), sqglb("CP"), top, bot chevron.r $

  Vediamo una porzione del reticolo  della constant propagation e del suo dominio astratto:

  #grid(
    columns: (1fr, 1fr),
    gutter: 1cm,
    align: center + horizon,
    [#figure(reticolo-cp, caption: [Reticolo Constant propagation]) <ret-cp-concreto>],
    [#figure(reticolo-astratto-cp, caption: [Reticolo dominio astratto]) <ret-cp-astratto>],
  )

  Ipotizziamo di star analizzando un programma e a un certo punto otteniamo \
  la memoria $[x arrow 1, y arrow 0]$ e abbiamo il seguente snippet di codice da analizzare:

  ```
  z = x / y;

  // ...

  x++;

  ```

  Valutando questo snippet con la memoria di partenza otteniamo una nuova memoria \
  $[x arrow 1, y arrow 0, z arrow bot]$, da questa memoria posso generare direttamente $bot$, dato che il programma è andato in errore è inutile portarsi dietro anche il resto delle informazioni, è ovviamente una semplificazione rispetto all'informazioni che mi fornisce la memoria.

  Proviamo ora a definire le funzioni $alpha$ e $gamma$ per il reticolo concreto e il reticolo del dominio astratto.
  Partiamo dalla funzione di astrazione:  $alpha_("CP") : cal(P)(ZZ) arrow "CP"$

  Se abbiamo come argomento di $alpha_("CP")$ un singoletto dell'insieme $cal(P)(ZZ)$ ci basta resituire il valore di quel singoletto e mapparlo nel dominio astratto, quindi l'argomento ha cardinalità 1.
  Nel caso in cui dovessimo avere più elementi dentro all'argomento allora restituiremo l'elemento $top$.
  In tutti gli altri casi verrà restituito l'elemento $bot$.

  $ alpha_("CP") (I) = cases(gap: #1em, v &quad |I| = 1 and I = {v}, top &quad |I| > 1, bot &quad "altrimenti") $

  Come dicevamo nella scorsa lezione, quando facciamo un astrazione sul mondo concreto perdiamo informazioni, qui perdiamo la possiblità di tenere traccia se una determinata variabile può assumere più valori. Passiamo ora a definire la funzione $gamma_("CP")$.
  Dobbiamo partire dal reticolo astratto e tornare al reticolo concreto. Nel caso in cui l'argomento della funzione $gamma_("CP")$ dovesse essere l'elemento $top$, dobbiamo restituire il $top$ del reticolo concreto, in questo caso $ZZ$.
  Nel caso in cui l'argomento sia vuoto, allora restituiremo $emptyset$.
  Nel caso in cui $a$ sia un valore $v$, restituiremo $v$.

  $ gamma_("CP") (a) = cases(gap: #1em, ZZ &quad a = top, emptyset &quad a = bot, {v} &quad a = v) $

  Naturalmente dopo aver astratto, quando torniamo nel mondo concreto le informazioni perse non possono essere recuperate.

  #note[
    Piccola digressione...

    #align(center)[
      #diagram(
        spacing: (1.9cm, 2cm),
        node-stroke: none,

        // ℤ in cima
        node((0, 0), $ZZ$, name: <Z>, stroke: red, shape: circle),

        // riga delle coppie
        node((-1.7, 1), $dots.c$, name: <dl1>),
        node((-0.5, 1), ${-2, -1}$, name: <a>),
        node((0.5, 1), ${-1, 0}$, name: <b>),
        node((1.7, 1), $dots.c$, name: <dr1>),

        // riga dei singoletti
        node((-2, 2), $dots.c$, name: <dl2>),
        node((-1, 2), ${-2}$, name: <m2>, stroke: red, shape: circle),
        node((0, 2), ${-1}$, name: <m1>, stroke: red, shape: circle),
        node((1, 2), ${0}$, name: <z0>, stroke: red, shape: circle),
        node((2, 2), $dots.c$, name: <dr2>),

        // ∅ in basso
        node((0, 3), $emptyset$, name: <e>, stroke: red, shape: circle),

        // ∅ -> singoletti
        edge(<e>, <m2>, "-"),
        edge(<e>, <m1>, "-"),
        edge(<e>, <z0>, "-"),

        // singoletti -> coppie
        edge(<m2>, <a>, "-"),
        edge(<m1>, <a>, "-"),
        edge(<m1>, <b>, "-"),
        edge(<z0>, <b>, "-"),

        // singoletti -> coppie successive (tratteggiato, speculare)
        edge(<m2>, <dl1>, "-", stroke: (dash: "dotted")),
        edge(<z0>, <dr1>, "-", stroke: (dash: "dotted")),

        // coppie -> ℤ (tratteggiato)
        edge(<a>, <Z>, "-", stroke: (dash: "dotted")),
        edge(<b>, <Z>, "-", stroke: (dash: "dotted")),

        // puntini di continuazione sulle righe
        edge(<dl1>, <a>, "-", stroke: (dash: "dotted")),
        edge(<b>, <dr1>, "-", stroke: (dash: "dotted")),
        edge(<dl2>, <m2>, "-", stroke: (dash: "dotted")),
        edge(<z0>, <dr2>, "-", stroke: (dash: "dotted")),

        // annotazione rossa
        node((2.4, 1), text(fill: red)[$gamma compose alpha$]),
      )
    ]

    Volendo possiamo fare astrazione direttamente sul reticolo concreto come in questo caso.
  ]

]

Guardiamo anche un esempio per l'analisi dei segni:

#example[
  Partiamo definendo il dominio dei segni: $chevron.l {0, +, -, top, bot}, subset.sq.eq, union.sq, inter.sq, top, bot chevron.r$

  #let reticolo-segni = diagram(
    spacing: (1.3cm, 1.6cm),
    node-stroke: none,

    node((0, 0), $top$, name: <top>),
    node((-1, 1), $-$, name: <neg>),
    node((0, 1), $0$, name: <zero>),
    node((1, 1), $+$, name: <pos>),
    node((0, 2), $bot$, name: <bot>),

    edge(<bot>, <neg>, "-"),
    edge(<bot>, <zero>, "-"),
    edge(<bot>, <pos>, "-"),

    edge(<neg>, <top>, "-"),
    edge(<zero>, <top>, "-"),
    edge(<pos>, <top>, "-"),
  )
  #align(center)[

    #grid(
      columns: (auto, 1fr),
      gutter: 2cm,
      align: horizon,
      reticolo-segni,
      stack(
        spacing: 1.5cm,
        $ alpha_"sign" : cal(P)(ZZ) -> "Segno" $,
        $ gamma_"sign" : "Segno" -> cal(P)(ZZ) $,
      ),
    )

  ]

  Anche in questo caso abbiamo le funzioni di astrazione e di concretizzazione. Passiamo a definire quella di astrazione:

  $
    alpha_("Sign")(I) = cases(
      gap: #0.8em,
      + & quad forall i in I quad i > 0,
      - & quad forall i in I quad i < 0,
      0 & quad I = {0},
      bot & quad I = emptyset,
      top & quad "altrimenti",
    )
  $

  Mentre la funzione di concretizzazione $gamma_"Sign"$ è definita:

  $
    gamma_"Sign"(s) = cases(
      gap: #0.8em, {0} &quad S = 0,
      {z | z > 0} & quad S = +,
      {z | z < 0} & quad S = -,
      emptyset & quad S = bot,
      ZZ & quad S = top
    )
  $

]


Questra astrazione in intervallo dei segni è *sound*, ovvero:
- Partiamo da un valore astratto.
- Concretizziamo sfruttando $gamma$.
- Torniamo all'astrazione con la funzione $alpha$.
- È sound se e solo se il risultato è $supqle(A)$, o in generale uguale.

=== Monotonicità

Entrambe le funzioni $alpha$ e $gamma$ sono monotone, $alpha$ è monotona perché:
- $I_1 subset.eq I_2 arrow.double alpha (I_1) sqle(A) alpha (I_2)$
- Quindi se astraiamo qualcosa otteniamo un livello di informazione inferiore o uguale.

Mentre $gamma$ è monotona perché:
- $a_1 sqle(A) a_2 arrow.double gamma (a_1) subset.eq gamma (a_2)$
- Se concretizziamo qualcosa che rappresenta un quantitativo di informazione minore otteniamo qualcosa con meno o la stessa quantità di informazione.


== Connessioni di Galois

Definiamo una connessione di Galois come:

#definition(name: "Connessione di Galois")[
  Presi due poset: $chevron.l C, sqle(C) chevron.r$ e $chevron.l A, sqle(A) chevron.r$, $alpha : C arrow A$ e $gamma : A arrow C$ due funzioni monotone, formano una connessione di Galois se:

  $ forall c in C, forall a in A. alpha (c) sqle(A) a <=> c sqle(C) gamma(a) $
]

#let reticolo-parti = diagram(
  spacing: (1.6cm, 1.8cm),
  node-stroke: none,

  node((0.5, 0), $ZZ$, name: <Z>),

  node((-0.5, 1), ${-1, 0}$, name: <a>),
  node((0.5, 1), ${0, 1}$, name: <b>),
  node((1.5, 1), ${1, 2}$, name: <c>),

  node((-1, 2), ${-1}$, name: <m1>),
  node((0, 2), ${0}$, name: <z0>),
  node((1, 2), ${1}$, name: <p1>),

  node((0, 3), $emptyset$, name: <e>),

  // ∅ -> singoletti
  edge(<e>, <m1>, "-"),
  edge(<e>, <z0>, "-"),
  edge(<e>, <p1>, "-"),

  // singoletti -> coppie
  edge(<m1>, <a>, "-"),
  edge(<z0>, <a>, "-"),
  edge(<z0>, <b>, "-"),
  edge(<p1>, <b>, "-"),
  edge(<p1>, <c>, "-"),

  // coppie -> ℤ (tratteggiato)
  edge(<a>, <Z>, "-", stroke: (dash: "dotted")),
  edge(<b>, <Z>, "-", stroke: (dash: "dotted")),
  edge(<c>, <Z>, "-", stroke: (dash: "dotted")),
)

#let reticolo-segni = diagram(
  spacing: (1.3cm, 1.8cm),
  node-stroke: none,

  node((0, 0), $top$, name: <top>),
  node((-1, 1), $-$, name: <neg>),
  node((0, 1), $0$, name: <zero>),
  node((1, 1), $+$, name: <pos>),
  node((0, 2), $bot$, name: <bot>),

  edge(<bot>, <neg>, "-"),
  edge(<bot>, <zero>, "-"),
  edge(<bot>, <pos>, "-"),

  edge(<neg>, <top>, "-"),
  edge(<zero>, <top>, "-"),
  edge(<pos>, <top>, "-"),
)


- La prima parte ci garantisce la *soundness*: $alpha (c) sqle(A) a arrow.double c sqle(C) gamma (a)$
- La seconda parte invece ci garantisce la *best abstraction*: $c sqle(C) gamma (a) arrow.double alpha (c) sqle(A) a$

Abbiamo anche una definizione alternativa per la connessione di Galois:

#definition(name: "Connessione di Galois, alternativa")[
  Presi due poset: $chevron.l C, sqle(C) chevron.r$ e $chevron.l A, sqle(A) chevron.r$, $alpha : C arrow A$ e $gamma : A arrow C$ abbiamo una connessione di Galois se sono rispettate le seguenti proprietà:

  - $alpha$ e $gamma$ sono monotone.
  - $gamma compose alpha$ è estensiva; $forall c in C. c sqle(C) gamma (alpha (c))$ (quando facciamo astrazione perdiamo informazioni)
  - $alpha compose gamma$ è riduttiva; $forall a in A. alpha (gamma (a) ) sqle(A) a$ (quando concretizziamo non perdiamo informazioni)
] <CG-alt>

#example[
  Riprendiamo l'esempio dei segni, ricordando le definizioni delle funzioni $alpha$ e $gamma$ dell'esempio precedente; prendiamo in considerazione il seguente scenario:

  #grid(
    columns: (1fr, 1fr),
    gutter: 1cm,
    align: center + horizon,
    figure(reticolo-parti, caption: [Reticolo concreto.]), figure(reticolo-segni, caption: [Reticolo dell'astrazione.]),
  )

  Adesso possiamo leggere la definizione di connessione di Galois,
  $alpha (c) sqle(A) a <=> c sqle(C) gamma (a)$, spezzandola nelle due implicazioni.

  1. $alpha (c) sqle(A) a arrow.double c sqle(C) gamma (a)$

    *Soundness*: se l'astrazione di $c$ sta sotto $a$, allora $a$ descrive
    davvero $c$, cioè $c$ è contenuto in ciò che $a$ rappresenta.
    Esempio: $c = {1, 2}$ e $a = +$. Abbiamo $alpha(c) = + sqle(A) +$
    e infatti $c subset.eq gamma(+) = {1, 2, 3, dots}$.

  2. $c sqle(C) gamma (a) arrow.double alpha (c) sqle(A) a$

    *Best astraction*: se $a$ descrive $c$, allora $alpha(c)$ è almeno
    altrettanto preciso di $a$, cioè $alpha(c)$ è la migliore astrazione di $c$.
    Esempio: $c = {1, 2}$ e $a = top$. Abbiamo $c subset.eq gamma(top) = ZZ$
    e infatti $alpha(c) = + sqle(A) top$.

    Se invece avessimo (per assurdo) $alpha({1, 2}) = top$, allora
    $c subset.eq gamma(+)$ sarebbe vero ma $alpha(c) = top
    cancel(sqle(A)) +$, e la 2 fallirebbe: $alpha$ non sarebbe la migliore astrazione.

]

