#import "../../Template typst/template.typ": (
  c-border, definition, example, lbs, note, rbs, recall, sqglb, sqle, sqlub, theorem,
)
#import "@preview/fletcher:0.5.8": diagram, edge, node, shapes
#import "@preview/cetz:0.5.2": canvas, draw

= Lezione 9 del 9 ottobre 2026

Abbiamo visto fino ad ora la maximal trace semantics, che in un mondo ideale sarebbe quella che vorremmo calcolare, ma in realtà è infinita e indecidibile.
Abbiamo visto anche la collective semantics, che è un astrazione della maximal trace semantics, dato che perdiamo la relazione tra le tracce.
Di conseguenza ci serve un'approssimazione che ci permette rispondere con certezza a determinate proprietà di un programma che vogliamo studiare.

== Approssimazioni

Ipotizziamo di avere una proprietà $Q$ tale che $lbs P rbs subset.eq Q$, generalmente questo è indecidibile.

Di conseguenza ci serve un'approssimazione $lbs P rbs^"#" "di" lbs P rbs$ in modo da ottenere:
- *Soundness*: $lbs P rbs subset.eq lbs P rbs^"#"$.
- *Decidability*: $lbs P rbs^"#" subset.eq Q$

La soundness per noi è cruciale dato che ci permette di sfruttare la decidibilità di un'approssimazione.
I comportamenti originali del programma *DEVONO* essere contenuti nella nostra approssimazione $lbs P rbs^"#"$ per ottenere la soundness.

- Il caso ideale che ci permette di dimostrare che la proprietà $Q$ vale per il programma che stiamo analizzando è quando la nostra approssimazione è contenuta in $Q$:  $⟦P⟧^\# subset.eq Q$


#align(center)[
  #canvas(length: 1cm, {
    import draw: *

    // Ellisse rossa
    circle((0, 0), radius: (3, 1.9), stroke: 1.5pt + red)
    content((3.1, 1.4), text(fill: red, size: 16pt)[$Q$])

    // Ellisse blu
    circle((-0.73, -0.26), radius: (1.9, 1.2), stroke: 1.2pt + blue)
    content((1.6, 0.8), text(fill: blue, size: 14pt)[$⟦P⟧^\#$])

    // Cerchio nero
    circle((-1.7, -0.03), radius: 0.43, stroke: 1pt + black)
    content((-0.85, 0.1), text(size: 14pt)[$⟦P⟧$])

    // Testo a destra
    content((3.9, -0.4), align(center)[
      _caso_ \ _ideale_ \ $⟦P⟧^\# subset.eq Q$
    ])
  })
]

- Nel caso in cui la nostra approssimazione non sia contenuta in $Q$ non possiamo dimostrare la proprietà $Q$:


#align(center)[
  #canvas(length: 1cm, {
    import draw: *

    // Ellisse rossa (Q), inclinata verso l'alto
    group({
      translate((-0.15, -0.1))
      rotate(17deg)
      circle((0, 0), radius: (3.1, 1.75), stroke: 1.5pt + red)
    })
    content((3.0, 1.9), text(fill: red, size: 16pt)[$Q$])

    // Ellisse blu ([[P]]^#), inclinata leggermente verso il basso
    group({
      translate((0.47, -0.2))
      rotate(-8deg)
      circle((0, 0), radius: (2.85, 1.3), stroke: 1.8pt + blue)
    })
    content((4, 0.45), text(fill: blue, size: 14pt)[$⟦P⟧^\#$])

    // Cerchio nero ([[P]])
    circle((-1.5, -0.1), radius: 0.42, stroke: 1pt + black)
    content((-0.35, 0.1), text(size: 14pt)[$⟦P⟧$])

    // Testo in basso
    content((2.2, -2.5), align(left)[
      _non posso dimostrare_ $Q$ \
      $⟦P⟧^\# subset.not.eq Q$
    ])
  })
]

- Invece nel diagramma qui sotto abbiamo che la nostra approssimazione non rispetta la proprietà di *soundness*:

#align(center)[
  #canvas(length: 1cm, {
    import draw: *

    // Ellisse blu ([[P]]^#), inclinata
    group({
      translate((-1.3, -0.1))
      rotate(40deg)
      circle((0, 0), radius: (2.0, 1.1), stroke: 1.5pt + blue)
    })
    content((-3.0, 1), text(fill: blue, size: 14pt)[$⟦P⟧^\#$])

    // Cerchio nero ([[P]])
    circle((0.2, -0.45), radius: 1.0, stroke: 1.2pt + black)
    content((1.8, 0.5), text(size: 14pt)[$⟦P⟧$])

    // Testo a destra
    content((5.6, -0.5), anchor: "west", align(left)[
      $->$ _non è sound_ \
      _abbiamo falsi negativi_
    ])
  })

]

In queste approssimazioni è normale perdere precisione, soprattutto nell'ultimo caso dove possiamo avere dei falsi positivi, ovvero punti che appartengono all'astrazione $lbs P rbs^"#"$ e si intersecano con la semantica concreta del programma $lbs P rbs$. Quello che non possiamo accettare sono i falsi negativi, in questo caso i punti della semantica concreta che non si intersecano con la semantica astratta, questo ci porta a perdere la proprietà di _*soundness*_.

Ora diamo una definizione di _*astrazione*_.

#definition(name: "Astrazione")[
  L'_*astrazione*_ è il processo di sostituire qualcosa di concreto con una descrizione che riguarda alcune delle sue proprietà.

  L'_*astrazione*_ ci permette di descrivere con precisione alcune proprietà, ma non tutte.

  Un'_*astrazione*_ in $cal(P)(Sigma)$  di oggetti contenuti in $Sigma$ è $A subset.eq cal(P)(Sigma)$ tale che:
  - Gli elementi in $A$ sono quelli descritti in maniera precisa dall'_*astrazione*_, quindi senza perdita di informazioni
  - Gli elementi non presenti in $A$ devono essere rappresentati da altri elementi di $A$, perdendo precisione.
]

Quando analizziamo dei programmi dobbiamo considerare i vari oggetti che possono rappresentare  lo stato della computazione:
- Valori: booleani, interi con segno, etc ...
- Variabili
- Environment
- Stack, etc...

Le proprietà sono un insieme di oggetti, che hanno quella proprietà:
- Numeri naturali dispari = ${1, 3, 5, 2 n + 1, dots}$
- Numeri pari interi = ${2 z | z in ZZ}$

=== Insieme delle proprietà

L'insieme delle proprietà $cal(P)(Sigma)$ di oggetti $Sigma$ è un lattice completo distributivo, possiamo definirlo nel seguente modo:

$ chevron.l cal(P)(Sigma), subset.eq, emptyset, union, inter, not chevron.r $

- $emptyset$, è il valore bottom, se otteniamo $emptyset$ vuol dire che la proprietà non è rispettata da nessun programma.
- $Sigma$, è il valore di top, vuol dire che il programma rispetta tutte le proprietà.
- $subset.eq$, l'operatore di ordinamento ci indica che salendo su per il reticolo avremo proprietà sempre più astratte.
- $not$, è la negazione delle proprietà: $not P = Sigma backslash P$.

Vediamo un esempio veloce per la negazione:

#example[
  Prendiamo l'insieme degli oggetti: $Sigma = {1, 2, 3, 4, 5, 6}$

  Definiamo la proprietà di essere pari come: $ P = {2, 4, 6} $

  La proprietà negata, $not P$ è data da:
  $ not P = Sigma backslash P $
  $ not P = {1, 2, 3, 4, 5, 6} backslash {2, 4, 6} $

  Quindi otteniamo:

  $ not P = {1, 3, 5} $
]

#example[
  Ipotizziamo di voler fare l'analisi di parità su un programma.

  Il complete lattice della parità possiamo definirlo come:

  #align(center)[
    #diagram(
      spacing: (0.8cm, 0.8cm),
      node-stroke: none,

      node((0, 0), $top$, name: <top>),
      node((-1, 1), [_even_], name: <even>),
      node((1, 1), [_odd_], name: <odd>),
      node((0, 2), $bot$, name: <bot>),

      edge(<top>, <even>, "-"),
      edge(<top>, <odd>, "-"),
      edge(<even>, <bot>, "-"),
      edge(<odd>, <bot>, "-"),
    )
  ]

  Prendiamo il caso $x -> ("Even", [1 ; 5])$, sapendo che $x$ deve assumere un valore pari, possiamo ridurre il suo intervallo a: $x -> ("Even", [2 ; 4])$.

  Notare che il 3, anche se è dispari, rimane nell'intervallo, nonostante siamo a conoscenza del fatto che $x$ sia un numero pari. Questa analisi ci permette di ottenere il _*miglior intervallo possibile*_, che ovviamente può contenere del rumore, in questo caso il numero 3.

  Il reticolo rappresenta il dominio dell'analisi.

]

=== Direzione dell'astrazione

Quando vogliamo approssimare una proprietà $P$ che ci interessa con un'astrazione $P^"#"$ possiamo avere due casi:
- Un'approssimazione *dal basso* (from below): dove $P^"#" subset.eq P$
- O un'approssimazione *dall'alto* (from above): dove $P subset.eq P^"#"$

L'approssimazione dal basso è utile per bug detection, però perdiamo alcuni comportamenti concreti del programma nella nostra astrazione.
Le due nozioni sono duali.

Guardiamo alcuni esempi di approssimazioni from below e from above.

#example[
  #align(center)[
    #canvas(length: 1cm, {
      import draw: *

      // Cerchio nero (P)
      circle((0, 0), radius: 1.1, stroke: 1.2pt + black)
      content((1.6, 1.3), text(size: 14pt)[$P$])

      // Cerchio blu piccolo (b#)
      circle((-0.15, 0.1), radius: 0.45, stroke: 1.3pt + blue)
      content((0.65, 0.3), text(fill: blue, size: 11pt)[$P^"#"$])

      // Cerchietto rosso, a cavallo del bordo in basso
      circle((-0.2, -1.1), radius: 0.3, stroke: 1.3pt + red)

      // Freccia ad angolo verso il testo rosso
      line((-0.5, -1.2), (-0.5, -1.9), (0.5, -1.9), stroke: 1.2pt + red, mark: (end: ">"))
      content((0.7, -1.9), anchor: "west", text(fill: red, size: 14pt)[_non è sound_])

      // Testo in alto a destra
      content((3.2, 1.3), anchor: "west", text(size: 14pt)[_bug detection_])
    })
  ]

  Questo tipo di analisi from below è utile per bug detection, attenzione che se dovessimo avere un bug che si trova in $P$, ma non è dentro l'insieme della nostra astrazione $P^"#"$, perdiamo la possibilità di trovare quel bug con la nostra approssimazione.

  Se un determinato comportamento che analizziamo è dentro la nostra approssimazione $P^"#"$ allora il programma avrà quel comportamento, altrimenti non possiamo dirlo con certezza.

  Nel caso in cui $P^"#"$ fosse l'insieme rosso, non sarebbe un'approssimazione che rispetta la soundness.

  #align(center)[
    #canvas(length: 1cm, {
      import draw: *

      let giallo = rgb("#e6a817")

      // Ellisse gialla (P#_II), leggermente inclinata
      group({
        translate((0.2, 0.1))
        rotate(-35deg)
        circle((0, 0), radius: (3.0, 2.3), stroke: 1.5pt + giallo)
      })
      content((3.4, 1.9), text(fill: giallo, size: 14pt)[$P_2^"#"$])

      // Cerchio nero (P)
      circle((-0.4, -0.2), radius: 1.55, stroke: 2pt + black)
      content((0.5, 1.6), text(size: 15pt)[$P$])

      // Cerchio blu piccolo (P#_I)
      circle((-1.0, -0.55), radius: 0.5, stroke: 1.5pt + blue)
      content((-0.2, -0.05), text(fill: blue, size: 12pt)[$P_1^"#"$])

      // Testo in basso a destra
      content((2.6, -2.4), anchor: "west", text(fill: giallo, size: 14pt)[
        _approx._ \ _from above_
      ])
    })
  ]

  In questo caso abbiamo un'astrazione from above, e vediamo che la nostra astrazione $P_2^"#"$ contiene $P$, questo ci porta a perdere precisione ma questo è un compromesso quando facciamo una qualunque tipo di astrazione.

]


#note[
  Possiamo vedere il passaggio da una proprietà concreta a un'approssimazione come una funzione $alpha$ che mappa le proprietà dal concreto alla nostra approssimazione.
  #align(center)[

    #scale(70%, reflow: true, diagram(
      spacing: (1.5cm, 1.5cm),
      node-stroke: none,

      // Titoli
      node((0.5, 0), $cal(P)(ZZ)$),
      node((5, 0), [_Segni_]),

      // Reticolo P(Z)
      node((-0.9, 2), $dots.c$),
      node((0, 2), ${0}$, name: <z0>),
      node((1, 2), ${1}$, name: <z1>),
      node((2, 2), ${2}$, name: <z2>),
      node((0.5, 1), ${0, 1}$, name: <z01>),
      node((1.5, 1), ${1, 2}$, name: <z12>),
      node((1, 3), $bot$, name: <zbot>),

      edge(<z0>, <z01>, "-"),
      edge(<z1>, <z01>, "-"),
      edge(<z1>, <z12>, "-"),
      edge(<z2>, <z12>, "-"),
      edge(<zbot>, <z0>, "-"),
      edge(<zbot>, <z1>, "-"),
      edge(<zbot>, <z2>, "-"),

      // Reticolo dei segni
      node((5, 1), $top$, name: <stop>),
      node((4, 2), $+$, name: <splus>),
      node((5, 2), $0$, name: <szero>),
      node((6, 2), $-$, name: <sminus>),
      node((5, 3), $bot$, name: <sbot>),

      edge(<stop>, <splus>, "-"),
      edge(<stop>, <szero>, "-"),
      edge(<stop>, <sminus>, "-"),
      edge(<splus>, <sbot>, "-"),
      edge(<szero>, <sbot>, "-"),
      edge(<sminus>, <sbot>, "-"),

      // Astrazione α: da P(Z) ai segni
      edge(<z12>, <stop>, "->", bend: 20deg, label: $alpha$, label-side: left),
      node((3.3, 1.35), text(size: 8pt)[più piccolo \ insieme]),

      // Concretizzazione γ: dai segni a P(Z)
      edge(<sbot>, <z2>, "->", bend: 25deg, label: $gamma$, label-side: left),
    ))
  ]

  In questo diagramma abbiamo 2 reticoli, uno per l'insieme delle parti per $ZZ$, dall'altro abbiamo il reticolo dei segni.
  Abbiamo una funzione $alpha$ che mappa dal reticolo delle parti di $ZZ$ nel reticolo dei segni.
  La funzione $alpha$ deve mappare il più piccolo elemento nel reticolo dei segni che può rappresentare l'elemento che scegliamo dal reticolo dell'insieme delle parti di $ZZ$.

  Questo prende il nome di _*connessione di Galois*_.
]

Il nostro obiettivo è ottenere la miglior approssimazione possibile per $P$, lo vedremo più avanti quando inizieremo a parlare di interpretazione astratta.

=== Altri tipi di approssimazioni

Esistono anche altri tipi di approssimazioni, come gli intervalli, ottagoni, poliedri e le simple congruences.

==== Intervalli

#figure(image("img/lezione9/intervals.svg", width: 80%), caption: [Approssimazione con intervalli])

==== Ottagono

#figure(image("img/lezione9/octagons.svg", width: 80%), caption: [Approssimazione con ottagoni])

È un'approssimazione più raffinata rispetto a quella degli intervalli, abbiamo dei vincoli più stringenti.

==== Poliedri

#figure(image("img/lezione9/polyhedra.svg", width: 80%), caption: [Approssimazione con poliedri])

I poliedri hanno un problema, non esiste la funzione di astrazione $alpha$.
Non esiste neanche il miglior poliedro che possa approssimare il dominio della nostra approssimazione, questo perché il dominio dei poliedri convessi non è un reticolo completo.

== Conclusioni

Quando facciamo delle astrazioni, inevitabilmente perdiamo precisione aggiungendo del rumore rispetto alla semantica concreta.
Per esempio con le collective semantics abbiamo delle esecuzioni spurie perché  perdiamo le tracce d'esecuzione originali, se invece collezionassimo proprietà
aggiungiamo degli stati spuri per via dell'approssimazione dei dati.

#grid(
  columns: (1fr, 1fr),
  column-gutter: 2em,
  align: top,
  figure(
    image("img/lezione9/traces.svg", width: 100%, height: 6cm, fit: "contain"),
    caption: [Astrazione in reachable states.],
  ),
  figure(
    image("img/lezione9/traces-intervals.svg", width: 100%, height: 6cm, fit: "contain"),
    caption: [Astrazione in tracce d'intervalli.],
  ),
)
#v(0.5cm)
_Le immagini originali sono nel pacchetto di slide numero 06_.

#v(1cm)

Con le nostre approssimazioni consideriamo un insieme di proprietà degli stati invece di stati concreti; approssimiamo la computazione di un programma
con la collective semantics su tutti i program point.
Attenzione perché anche le nostre astrazioni possono non terminare e quindi essere indecidibili.
