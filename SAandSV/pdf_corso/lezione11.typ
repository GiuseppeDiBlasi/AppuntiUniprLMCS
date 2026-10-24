#import "../../Template typst/template.typ": (
  c-border, definition, example, lbs, note, rbs, recall, sleq, slt, sqglb, sqle, sqlub, supqle, theorem,
)
#import "@preview/fletcher:0.5.8": diagram, edge, node, shapes

= Lezione 11 del 15 ottobre 2026

Riprendiamo dagli argomenti della lezione 10 e proviamo a dimostrare per la constant propagation le seguenti proprietà:

- $alpha$ e $gamma$ sono monotone
- $alpha compose gamma$ è estensiva, $forall c in C . c sqle(C) gamma(alpha(c))$
- $gamma compose alpha$ è riduttiva, $forall a in A . alpha(gamma(a)) sqle(A) a$

#example[
  I reticoli presi in considerazione sono quelli dell'esempio della scorsa lezione, @ret-cp-concreto e @ret-cp-astratto.

  Partiamo col dimostrare se $alpha$ e $gamma$ sono monotone:

  + $alpha$ è monotona, $forall X, Y in cal(P)(ZZ), X subset.eq Y arrow.double alpha(X) subset.eq alpha(Y)$
    - $X = emptyset$, per def. di $alpha$, $alpha(emptyset) = bot$, per def. di $sqle("CP")$  $alpha(X) = bot sqle("CP") alpha(Y)$, per qualunque Y.

    - $|X| = 1, X = {v}$, per def. di $alpha$, $alpha({v}) = v$
      - $X = Y = {v}$, banale.

      - $X subset Y$, per def. di $sleq("CP") |Y| > |X| = 1$, per def. di $alpha$, $alpha(Y) = top$; quindi \ $alpha(X) = v sqle("CP") alpha(Y) = T$

    - $|X| > 1, X subset.eq Y arrow.double |Y| > 1$, per def. di $sqle("CP")$: $alpha(X) = top sqle("CP") alpha(Y) = top$

  + $gamma$ è monotona, $forall x, y in "CP"$, se $x sqle("CP") y arrow.double gamma(x) sqle("CP") gamma(y)$
    - $x = bot$, per def. di $gamma(bot) = emptyset$, e per def. di $subset.eq$, $gamma(x) = emptyset subset.eq gamma(y)$, per qualunque $y in "CP"$.

    - $y = top$, per def. di $gamma(T) = ZZ$, per def. di $subset.eq$, $gamma(x) subset ZZ = gamma(y)$, per qualunque $y in "CP"$.

    - $x = y = v$, per def. di $gamma$, $gamma(x) = gamma(y) = {v}$

  + $gamma compose alpha$ è estensiva: $forall I in cal(P)(ZZ) . I subset.eq gamma(alpha(I))$

    - $I = emptyset$, per def. di $alpha$, $alpha(I) = bot$, def. $gamma$, $gamma(bot) = emptyset arrow.double emptyset subset.eq gamma(alpha(emptyset))$.

    - $I = {v}$, def. $alpha$,  $alpha({v}) = v$, def. $gamma$, $gamma(v) = v arrow.double {v} subset.eq gamma(alpha({v}))$.

    - $|I| > 1$, def. $alpha$, $alpha(I) = top$, def $gamma$, $gamma(T) = ZZ arrow.double I subset.eq gamma(alpha(I))$.

  // Fare caso riduttivo
]

#note[Per indicare le connessioni di Galois useremo la seguente notazione
  $
    C #box(baseline: 30%, stack(
      dir: ttb,
      spacing: 6pt,
      $attach(arrow.r.long, t: alpha)$,
      $attach(arrow.l.long, b: gamma)$,
    )) A
  $
]

== Inserzioni di Galois

Dalle connessioni di Galois possiamo derivare le inserzioni di Galois.

Diamo una definizione formale di inserzione di Galois.

#definition(name: "Inserzione di Galois")[
  Presi due poset $chevron.l C, sqle(C) chevron.r$ e $chevron.l A, sqle(A) chevron.r$ con $alpha: C arrow A$ e $gamma: A arrow C$, supponendo di avere una connessione di Galois tra $C$ ed $A$ tramite $alpha$ e $gamma$, se $alpha compose gamma$ è l'identità allora è chiamata *inserzione di Galois*.

  In questo caso l'astrazione è suriettiva, mentre la croncretizzazione è iniettiva.

  #recall[
    *Suriettiva*: Ogni elemento del codominio è associato ad almeno un elemento del dominio.
    *Iniettiva*: Ogni elemento del codominio ha al più un elemento del dominio.
  ]

  Ogni connessione di Galois può essere ridotta ad una inserzione di Galois.

  Quando non abbiamo una inserzione di Galois, abbiamo almeno due elementi astratti che rappresentano la stessa informazione, di conseguenza elementi ridondanti, possiamo rimuoverli con una riduzione del dominio astratto.
]

#example[
  Se abbiamo elementi ridondanti nella nostra astrazione, possiamo rimuoverli, per esempio prendiamo in considerazione il seguente reticolo per l'analisi dei segni:

  #align(center)[

    #diagram(
      spacing: (1.3cm, 1.6cm),
      node-stroke: none,

      node((0, 0), $top$, name: <top>),
      node((-1, 1), $-$, name: <neg>),
      node((0, 1), $0$, name: <zero>),
      node((1, 1), $+$, name: <pos>),
      node((1, .5), $"più"$, name: <piu>),
      node((0, 2), $bot$, name: <bot>),

      edge(<bot>, <neg>, "-"),
      edge(<bot>, <zero>, "-"),
      edge(<bot>, <pos>, "-"),

      edge(<neg>, <top>, "-"),
      edge(<zero>, <top>, "-"),
      edge(<pos>, <piu>, "-"),
      edge(<piu>, <top>, "-"),
    )
  ]

  In questo caso "più" è "+" rappresentano la stessa informazione, quindi possiamo ridurre tutto ad utilizzare un solo simbolo dei due. Così facendo otteniamo un'inserzione di Galois.

]

Per l'inserzione di Galois vogliamo che l'identità sia definita da $alpha compose gamma$, ma nel caso in cui dovessimo avere l'identità definita da $gamma compose alpha$?

Vuol dire che abbiamo creato un isomorfismo, di conseguenza i problemi di decidibilità del contesto concreto si spostano nella nostra astrazione.
Significa anche che non abbiamo perso informazioni dal passaggio dal concreto all'astratto, noi vogliamo perdere informazioni per poter guadagnare in decidibilità.

Se riprendiamo la definizione alternativa di connessione di Galois @CG-alt, vogliamo sempre rispettare la condizione di *soundness*, mentre se possibile ottenere la *best abstraction*.

È anche possibile che non esista una connessione di Galois tra $C$ ed $A$, dovuta alla non esistenza della miglior astrazione, per esempio un poliedro convesso.

Vediamo un esempio sulla best abstraction:

#example[
  Consideriamo di voler approssimare una circonferenza: $P = {(x, y) | x^2 + y^2 <= 1}$

  Possiamo usare un poliedro convesso: $a * x + b * y <= c$

  Possiamo trovare molte sovra-approssimazioni per la circonferenza.

  #align(center)[
    #figure(
      image("img/lezione11/best_abstraction.svg", width: 80%),
      caption: [Approssimazione circonferenza con poliedro convesso.],
    )
  ]
]


Un altro esempio fatto a lezione è quello sul trovare la minima astrazione per i DFA.

#example[
  *Obiettivo.* Vogliamo mostrare che sul reticolo dei DFA *non esiste una best abstraction* $alpha$: cioè non possiamo definire una funzione di astrazione $alpha$ tale che $(alpha, gamma)$ sia una connessione di Galois.

  === Passo 0: i due domini

  - *Dominio concreto.* Fissiamo un alfabeto, ad esempio $Sigma = {a, b}$. Gli elementi concreti sono i *linguaggi*, cioè insiemi di stringhe, quindi il dominio è $ chevron.l cal(P)(Sigma^*), subset.eq chevron.r $ Un linguaggio qualsiasi è permesso, anche uno molto complicato.

  - *Dominio astratto.* Sono i DFA, dove due automi che riconoscono lo stesso linguaggio sono considerati lo stesso elemento: $ chevron.l "DFA"slash(equiv), sqle("DFA"), sqglb("DFA"), sqlub("DFA"), top_("DFA"), bot_("DFA") chevron.r $ con $A equiv B$ se $L(A) = L(B)$ e $A sqle("DFA") B$ se $L(A) subset.eq L(B)$. In pratica gli elementi astratti sono i *linguaggi regolari* (quelli riconosciuti da un DFA).

  #note[
    Prendiamo in considerazione le classi di equivalenza dei DFA con $"DFA"slash(equiv)$, in modo da considerare un solo DFA per automi che riconoscono lo stesso linguaggio. Quindi per $L(A) equiv L(B)$ avranno lo stesso DFA che li rappresenta.
  ]

  - *Concretizzazione.* È la funzione più naturale: dato un DFA, restituisci il linguaggio che riconosce $ gamma_("DFA") (A) = L(A) $

  === Passo 1: cosa dovrebbe fare $alpha$

  Una connessione di Galois richiede, per ogni linguaggio $L$ e ogni DFA $R$: $ alpha(L) sqle("DFA") R quad <==> quad L subset.eq gamma_("DFA")(R) $ Leggiamola in italiano: "$alpha(L)$ è più piccolo di $R$ se e solo se $R$ contiene tutte le stringhe di $L$". Ne seguono due fatti:

  + Prendendo $R = alpha(L)$ nella formula otteniamo $L subset.eq gamma_("DFA")(alpha(L))$. Quindi $alpha(L)$ è una *sovra-approssimazione* di $L$: riconosce tutte le stringhe di $L$ (ed eventualmente altre).
  + Per ogni altra sovra-approssimazione $R$ di $L$ vale $alpha(L) sqle("DFA") R$. Quindi $alpha(L)$ è la *più piccola* tra tutte le sovra-approssimazioni regolari di $L$.

  Riassumendo: $alpha(L)$, se esiste, deve essere il *minimo* tra tutti i linguaggi regolari che contengono $L$. Questa è proprio la best abstraction. Quindi: per far fallire $alpha$ ci basta trovare un $L$ per cui questo minimo *non esiste*.

  === Passo 2: scegliamo il linguaggio "cattivo"

  Prendiamo $ L = {a^n b^n : n >= 0} = {epsilon, a b, a a b b, a a a b b b, dots} $ cioè le stringhe formate da un po' di $a$ seguite da *esattamente lo stesso numero* di $b$.

  Questo linguaggio *non è regolare*: per riconoscerlo un automa dovrebbe contare quante $a$ ha letto, ma un DFA ha un numero finito di stati e quindi non può contare fino a un numero arbitrario (lo si dimostra col pumping lemma). Quindi nessun DFA riconosce esattamente $L$. In compenso $L$ è un elemento perfettamente valido del dominio concreto $cal(P)(Sigma^*)$.

  === Passo 3: dimostrazione per assurdo

  Supponiamo per assurdo che $alpha(L)$ esista. Per il Passo 1 sarebbe un linguaggio regolare $R$ con due proprietà: $R$ contiene $L$ e $R$ è il più piccolo linguaggio regolare che contiene $L$.

  + *$R eq.not L$.* Sappiamo che $R$ è regolare e che $L$ non lo è, quindi non possono essere lo stesso insieme. Siccome $L subset.eq R$, ne segue che $R$ ha *strettamente più stringhe* di $L$.
  + *Esiste una stringa "in più".* Per il punto precedente c'è almeno una stringa $w$ con $w in R$ e $w in.not L$.
  + *Togliamo $w$.* Definiamo $R' = R without {w}$, cioè $R$ senza quella sola stringa.
  + *$R'$ è ancora regolare.* Togliere una stringa (o un numero finito di stringhe) a un linguaggio regolare lo lascia regolare. Infatti $R' = R inter overline({w})$, e i linguaggi regolari sono chiusi per intersezione e complemento (basta modificare l'automa di $R$ in modo che rifiuti $w$).
  + *$R'$ contiene ancora $L$.* Abbiamo tolto solo $w$, e $w in.not L$, quindi tutte le stringhe di $L$ sono ancora in $R'$.
  + *$R'$ è strettamente più piccolo di $R$:* $R' subset R$.

  Allora $R'$ è un linguaggio regolare che contiene $L$ ed è *più piccolo* di $R$. Questo contraddice il fatto che $R$ fosse il più piccolo. L'assurdo nasce dall'aver supposto che $alpha(L)$ esistesse. #h(1fr) $square$

  #note[
    Il ragionamento in una frase: *qualunque sovra-approssimazione regolare di $L$ possiamo scegliere, ce n'è sempre una più precisa*, perché basta togliere una stringa che non sta in $L$. Quindi non c'è mai una "migliore".
  ]

  === Passo 4: l'intuizione con una catena infinita

  Possiamo vederlo anche in modo concreto. Per ogni $k >= 0$ sia $ R_k = {a^n b^n : n <= k} union {a^n b^m : n > k " oppure " m > k} $ Cioè: teniamo esattamente le stringhe di $L$ con $n <= k$, e poi accettiamo "alla rinfusa" tutte le stringhe del tipo $a^n b^m$ con almeno uno dei due esponenti oltre $k$. Ogni $R_k$ è regolare (la prima parte è finita, la seconda richiede solo di contare fino a $k$) e contiene $L$. Inoltre diventano sempre più precisi: $ R_0 supset.eq R_1 supset.eq R_2 supset.eq dots $ e la loro intersezione è proprio $L$, che non è regolare. Abbiamo quindi *approssimazioni sempre migliori che non arrivano mai a una migliore*: ci si avvicina a $L$ senza poterlo raggiungere.

  === Conclusione

  - L'insieme dei linguaggi regolari è un reticolo (unioni e intersezioni *finite* di regolari sono regolari), ma *non è un reticolo completo*: l'intersezione di infiniti regolari può non essere regolare, come nella catena sopra.
  - Per questo la funzione $alpha$ *non è definibile* su tutto $cal(P)(Sigma^*)$ e non abbiamo una connessione di Galois tra $cal(P)(Sigma^*)$ e i DFA.
  - Si può comunque usare questo dominio rinunciando alla best abstraction: si richiede solo la *soundness* (ogni astrazione scelta è una sovra-approssimazione corretta, cioè $L subset.eq gamma_("DFA")(A)$). È il punto di vista della definizione alternativa di connessione di Galois vista a lezione.

]

Anche se non abbiamo una connessione di Galois tra concreto e astratto, possiamo comunque fare interpretazione astratta.

== Semantica concreta

Nelle prime lezioni abbiamo introdotto la semantica concreta e la collecting semantics per il linguaggio IMP @lang-imp e @col-sem.
La collecting semantics ci torna utile quando lavoriamo direttamente su CFG, noi faremo interpretazione astratta basandoci sui CFG di un programma.

#let kw(s) = text(fill: blue, raw(s))
#let r(s) = raw(s)

// ---- Codice a sinistra (con numeri di riga) ----
#let righe = (
  [#r("x = 0;")],
  [#kw("while") #r("(x < 100)")],
  [#h(1.2em)#kw("if") #r("(x < 50)")],
  [#h(2.4em)#r("x = x + 2;")],
  [#h(1.2em)#kw("else")],
  [#h(2.4em)#r("x = x + 10;")],
)

#let codice = grid(
  columns: (auto, auto),
  column-gutter: 0.9em,
  row-gutter: 0.7em,
  ..righe
    .enumerate(start: 1)
    .map(((i, l)) => (
      text(fill: luma(140), size: 0.85em)[#i],
      l,
    ))
    .flatten(),
)

// ---- CFG a destra ----
#let cfg = scale(60%, reflow: true, diagram(
  spacing: (2.6cm, 1.5cm),
  node-stroke: 0.6pt,
  node-inset: 7pt,
  node-shape: rect,

  // nodi
  node((1, 0), `int x = 0`, name: <n1>),
  node((1, 1), $x < 100$, name: <n2>),
  node((2, 1), `exit`, name: <n6>),
  node((1, 2), $x < 50$, name: <n3>),
  node((0, 3), $x = x + 2$, name: <n4>),
  node((2, 3), $x = x + 10$, name: <n5>),

  // etichette x_i (nodi senza bordo)
  node((0.65, -0.4), $x_1$, stroke: none),
  node((0.65, 0.6), $x_2$, stroke: none),
  node((2.4, 0.6), $x_6$, stroke: none),
  node((0.7, 1.6), $x_3$, stroke: none),
  node((-0.4, 2.6), $x_4$, stroke: none),
  node((2.4, 2.6), $x_5$, stroke: none),

  // freccia di ingresso
  edge((1, -0.8), <n1>, "->"),

  // archi
  edge(<n1>, <n2>, "->"),
  edge(<n2>, <n6>, "->", stroke: red, label: text(size: 0.75em)[false], label-side: left),
  edge(<n2>, <n3>, "->", stroke: green.darken(20%), label: text(size: 0.75em)[true], label-side: right),
  edge(<n3>, <n4>, "->", stroke: green.darken(20%), label: text(size: 0.75em)[true], label-side: right),
  edge(<n3>, <n5>, "->", stroke: red, label: text(size: 0.75em)[false], label-side: left),

  // ritorni al test del while (curvi)
  edge(<n4>, <n2>, "->", bend: 45deg),
  edge(<n5>, <n2>, "->", bend: -45deg),
))

Prendiamo in considerazione il seguente codice e il corrispettivo CFG.

#example[
  // ---- Affiancati ----
  #grid(
    columns: (1fr, 1.4fr),
    gutter: 1cm,
    align: (left + bottom, center + top),
    figure(codice, caption: [Esempio codice.]), figure(cfg, caption: [Control Flow Graph.]),
  )

  #v(0.5cm)

  Il nostro obiettivo è calcolare gli stati entranti e uscenti per ogni program point $x_i$.

  - *Stato entrante*: è l'upper bound degli stati in uscita dai blocchi che puntano a $x_i$. Il blocco $x_1$ sarà lo stato iniziale.
  - *Stato uscente*: è l'applicazione della collecting semantics dello statement applicata allo stato entrante.

  Passiamo a calcolare gli stati entranti per ogni program point $x_i$. Scegliamo un program point e guardiamo tutti gli stati uscenti che puntano a quel program point.

  - $x_1$ = $I$.
  - $x_2$ = $lbs x = 0 rbs x_1 union lbs x = x + 2 rbs x_4 union lbs x = x + 10 rbs x_5$
  - $x_3$ = $lbs x < 100 rbs x_2$, questi sono i valori filtrati per $x < 100$.
  - $x_4$ = $lbs x < 50 rbs x_3$, valori filtrati per $x < 50$.
  - $x_5$ = $lbs x >= 50 rbs x_3$, valori filtrati per $x >= 50$.
  - $x_6$ = $lbs x >= 100 rbs x_2$, valori filtrati per $x >= 100$.


  Dati $m$ nodi di un CFG, vorremmo risolvere il seguente sistema d'equazioni:

  $ F = {x_i = f_i(x_1, dots, x_m) | i = 1, 2, dots, m} $

  Possiamo calcolare la soluzione minima per $F$ come il limite delle iterazioni di *Kleene* @thm-kleene sul poset:

  $ chevron.l cal(P)(ZZ), subset.eq, inter, union, ZZ, emptyset chevron.r $

  Ovvero calcoliamo il least fix point di F su x:

  $ x^("lfp"(F)) = (x^("lfp"(F))_1 , dots, x^("lfp"(F))_m ) $

  Il problema è che il calcolo di questo fix point è *indecidibile*, il fix point esiste @thm-knaster-tarski, ma in generale non è calcolabile.

] <ex-fixpt-cfg>
