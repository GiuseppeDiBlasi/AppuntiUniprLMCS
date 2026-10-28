#import "../../Template typst/template.typ": (
  c-border, definition, example, lbs, lps, note, rbs, recall, rps, sleq, slt, sqglb, sqle, sqlub, supqle, theorem,
)
#import "@preview/fletcher:0.5.8": diagram, edge, node, shapes

= Lezione 12 del 16 ottobre 2026 <lec-12>

Verso la fine della lezione precedente abbiamo fatto un esempio sul calcolo del punto fisso su un programma rappresentato
da un CFG. Abbiamo stabilito che il punto fisso esiste, ma non è calcolabile.

== Semantica astratta

Possiamo calcolare il punto fisso passando dal contesto concreto ad un contesto astratto, questo ci porta una perdita di informazione ma guadagnamo in decidibilità.

#example(name: "Calcolo punto fisso concreto")[
  Riprendiamo l'esempio @ex-fixpt-cfg della scorsa lezione.

  Vogliamo calcolare il punto fisso del sistema di equazioni per $F$, dato che nel concreto non è calcolabile passiamo ad una astrazione per poter calcolare il punto fisso:

  Riprendiamo il sistema di equazioni nel contesto concreto:

  $
    F = cases(
      delim: "{",
      gap: #1em,
      x_1 = I in cal(P)(ZZ),
      x_2 = lbs x = 0 rbs x_1 union lbs x = x + 2 rbs x_1 union lbs x = x + 10 rbs x_5,
      x_3 = lbs x < 100 rbs x_2,
      x_4 = lbs x < 50 rbs x_3,
      x_5 = lbs x >= 50 rbs x_3,
      x_6 = lbs x >= 100 rbs x_2,
    )
  $

  Il nostro obiettivo sarebbe calcolare $"lfp"_(emptyset)^subset.eq$, il fix point esiste perché è un reticolo completo, ma nel concreto non possiamo calcolarlo.

  Per il teorema di Kleene @thm-kleene, possiamo trovare un punto fisso dopo un determinato numero di iterazioni sulla funzione $F$.

  Partiamo calcolando $F_0$:

  $
    F_0 = cases(
      delim: "{",
      gap: #1em,
      x_1 = emptyset,
      x_2 = emptyset,
      x_3 = emptyset,
      x_4 = emptyset,
      x_5 = emptyset,
      x_6 = emptyset,
    )
  $

  Tutte le equazioni vengono inizializzate a $emptyset$, ora calcoliamo l'iterazione 1 per la funzione $F$, per il passo successivo prendiamo la definizione di F, e applichiamo ad ogni $x_i$ la sua equazione con la valutazione della semantica in base ai valori entranti nei blocchi del CFG e otteniamo:

  $
    F_1 = cases(
      delim: "{",
      gap: #1em,
      x_1 = ZZ,
      x_2 = {0},
      x_3 = {0},
      x_4 = {0},
      x_5 = emptyset,
      x_6 = emptyset,
    )
  $

  Calcoliamo $F_2$ prendendendo i valori di $F_1$ e calcoliamo quelli nuovi; ci sarebbero molte più iterazioni da fare per arrivare al fixpoint ma indichiamo con $F_m$ il fixpoint della funzione $F$.

  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1em,
    align: horizon,
    $
      F_2 = cases(
        delim: "{",
        gap: #1em,
        x_1 = ZZ,
        x_2 = {0, 2},
        x_3 = {0, 2},
        x_4 = {0, 5},
        x_5 = emptyset,
        x_6 = emptyset,
      )
    $,
    $
      F_m = cases(
        delim: "{",
        gap: #1em,
        x_1 = ZZ,
        x_2 = {0, 2, 4, dots 50, 60, 70, dots, 100},
        x_3 = x_2 backslash {100},
        x_4 = {0, 2, dots , 48},
        x_5 = {50, dots, 90},
        x_6 = {100},
      )
    $,
  )
  In questo caso è calcolabile perché il programma è costante, ma in generale il fix point nel concreto è non decidibile.
]<ex-lfp-concreto>

Siccome nel contesto concreto, in generale, non è possibile calcolare il least fixpoint sul dominio $C$, l'idea è quella di passare al calcolo di un fixpoint astratto su un dominio astratto $A$ che approssima correttamente quello concreto.

Quello che vogliamo fare è:

- Calcolare $alpha("lfp"(F))$, $F$ concreta.
- Senza effettivamente calcolare $"lfp"(F)$.

Il primo passo è quello di spostare la computazione dal dominio $C$ al dominio $A$.

Facciamo un esempio di analisi dei segni definendo una semantica astratta per il linguaggio Imp @lang-imp.

#pagebreak()

#example(name: "Semantica astratta")[
  Riprendiamo il reticolo dei segni:


  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1em,
    align: horizon,
    diagram(
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
    ),

    [Riprendiamo anche le funzioni $alpha$ e $gamma$:
      $ alpha: cal(P)(ZZ) arrow "Sign" $
      $ gamma: "Sign" arrow cal(P)(ZZ) $
    ],
  )

  Dobbiamo definire la funzione della memoria astratta per la nostra semantica astratta:

  $ M^"#" : VV arrow "Sign" $

  Abbiamo la funzione $M^"#"$, che prende in input una variabile $v in VV$, $VV$ è l'insieme delle variabili, e restituisce un $"Sign"$.
  Passiamo ora a definire la semantica astratta:

  - $lps dot rps^"#" : M^"#" arrow "Sign"$; questa è la semantica astratta per le espressioni.

  - $lbs dot rbs^"#" : M^"#" arrow M^"#"$; questa è la semantica astratta per gli statement.

  - $lbs x = e rbs^"#" thick m^"#" arrow m^"#" [lps e rps^"#" m^"#"]$

  - $lbs "skip" rbs^"#" thick m^"#" = m^"#"$

  - $lps e_1 + e_2 rps^"#" thick m^"#" = lps e_1 rps^"#" thick m^"#" +^"#" lps e_2 rps^"#" thick m^"#"$

  Notare che nell'ultima regola abbiamo l'operatore $+^"#"$, questo è l'operatore delle addizioni per la nostra semantica astratta, possiamo definire la tabella con tutti i possibili risultati per l'operatore $+^"#"$.

  #let tb = $top$
  #let bt = $bot$

  #align(center)[
    #figure(
      table(
        columns: 6,
        align: center + horizon,
        inset: 8pt,
        stroke: (x, y) => if x > 0 and y > 0 { 0.5pt },
        $+^\#$, tb, $+$, $-$, $0$, bt,

        tb, tb, tb, tb, tb, bt,
        $+$, tb, $+$, tb, $+$, bt,
        $-$, tb, tb, $-$, $-$, bt,
        $0$, tb, $+$, $-$, $0$, bt,
        bt, bt, bt, bt, bt, bt,
      ),
      caption: [Operatore aritmetico di addizione astratto.],
    )<table-piu-astratto>
  ]

  Ci sarebbero da definire anche gli altri operatori astratti per sottrazione, divisione e moltiplicazione. Tutti quanti seguono la stessa struttura dell'operatore $+^"#"$.

  #colbreak()

  Dobbiamo valutare anche le espressioni booleane per la nostra semantica astratta, qui le cose si fanno un po' più articolate rispetto agli operatori aritmetici.
  Supponiamo di avere la seguente memoria con una guardia:

  $ [x arrow top, y arrow +] $
  $ x >= 100; $

  Guardando la memoria in ingresso alla guardia, cosa possiamo dire su $x$?

  Sicuramente $x$ una volta superata la guardia avrà per forza valori positivi, dato che $x$ deve essere maggiore o uguale a 100, quindi da $top$ possiamo raffinare a $+$, di conseguenza in uscita dalla guardia la nuova memoria sarà:

  $ [x arrow +, y arrow +] $

  Prendiamo in considerazione un altro caso:

  $ [x arrow top, y arrow +] $
  $ y < - 100; $

  Qui invece cosa possiamo dire su $y$?

  In ingresso alla guardia ci aspettiamo che $y$ assuma valori positivi, mentre la guardia ci chiede che $y$ minore di -100 e quindi negativa.
  In questo caso in memoria avremo $bot$ per la variabile $y$. Dunque  la nuova memoria sarà:

  $ [x arrow top, y arrow bot] $


  Guardiamo un ultimo esempio, prendiamo in considerazione la memoria e la guardia:

  $ [x arrow +, y arrow -] $
  $ x + y <= z^2 $

  Cosa possiamo dire su $x$, $y$ e $z$?

  In questo caso, quando abbiamo più variabili in relazione con l'operatore di confronto non possiamo raffinare la nostra analisi dei segni, di conseguenza dobbiamo propagare la stessa memoria dopo la guardia.

  Invece per questo esempio:

  $ [x arrow top] $
  $ x < -; $

  Qui cosa possiamo dire su $x$?

  Sicuramente avrà un valore negativo, quindi per nella nuova memoria avremo $[x arrow -]$ per ottenere questa valutazione dobbiamo fare il *glb* tra $top$ e il segno meno. Stessa cosa per il caso :

  $ [x arrow top] $
  $ 0 < x; $

  In questo caso si fa il *glb* tra $top$ e + e nella nuova memoria avremo x con segno positivo.

  Da questi esempi abbiamo visto che possiamo dedurre i valori di $x$ o $y$ in base all'operatore di confronto e al segno dell'altra espressione usata nel confronto, dobbiamo definire gli operatori astratti per le espressioni booleane della nostra semantica astratta.

  Iniziamo definendo l'operatore per le espressioni booleane:

  - $italic("assume"): "Bexp" times M^"#" arrow M^"#"$

  Il modo più semplice per definire l'operatore booleano $<$ è quello di farlo per casi:

  - $italic("assume")_(e_1 < e_2) (m^"#") = cases(
      delim: "{", gap: #1em,
      m^"#" [x arrow.l m^"#"(x) inter.sq -] &quad "se" e_1 = x in VV thick and thick lps e_2 rps^"#" thick m^"#" in {0, -},
      m^"#" [x arrow.l m^"#" (x) inter.sq +] &quad "se" e_2 = x in VV thick or thick lps e_1 rps^"#" thick m^"#" in {0, +},
      bot_(M^"#") &quad "se" lps e_1 rps^"#" thick m^"#" = bot thick or thick lps e_2 rps^"#" m^"#" = bot,
      m^"#" &quad "altrimenti"
    )$

  Possiamo definire anche gli altri operatori booleani per la semantica astratta:

  - $italic("assume")_("true") (m^"#") = m^"#"$

  - $italic("assume")_("false") (m^"#") = bot_(M^"#")$

  - $italic("assume")_(e_1 > e_2 "/" <=, >=, ==, "!=") ->$ questi operatori sono simili a $italic("assume")_(e_1 < e_2)$.

  - $italic("assume")_(e_1 "&&" e_2) (m^"#") = italic("assume")_e_1 (m^"#") inter.sq italic("assume")_e_2 (m^"#")$

  - $italic("assume")_(e_1 "||" e_2) (m^"#") = italic("assume")_e_1 (m^"#") union.sq italic("assume")_e_2 (m^"#")$
] <ex-sem-abstr>

Con questo esempio abbiamo spostato il calcolo della decidibilità dal mondo concreto all'astratto, ma dobbiamo assicurarci che la nostra astrazione sia sound, ovvero che la nostra astrazione copra ogni comportamento reale del programma.
Ritorniamo brevemente all'operatore astratto $+^"#"$.

$ + quad +^"#" quad - = top quad "questo è sound." $
$ + quad +^"#" quad - = - quad "questo NON è sound." $

#pagebreak()

== Soundness di un'astrazione <soundness-abstr>

Supponiamo che $C$ e $A$ formino una connessione di Galois tramite $alpha$ e $gamma$ e sia $f: C arrow C$ un'operazione concreta e $f^"#": A arrow A$ un'astrazione dell'operazione concreta $f$. $f^"#"$ è sound se:

$ forall c in C . alpha(f(c)) sqle(A) f^"#" (alpha(c)) $

#align(center)[
  oppure vale anche:
]

$ forall a in A . f(gamma(a)) sqle(C) gamma(f^"#" (a)) $

Graficamente possiamo vederla cosi:

#let defs = "<defs>
<marker id='mb' markerWidth='8' markerHeight='8' refX='7' refY='4' orient='auto'><path d='M0 0L8 4L0 8z' fill='#1a1aff'/></marker>
<marker id='mg' markerWidth='8' markerHeight='8' refX='7' refY='4' orient='auto'><path d='M0 0L8 4L0 8z' fill='#119911'/></marker>
<path id='L' fill='none' stroke='black' d='M40 20C30 80 10 100 10 150C10 200 30 220 40 280M80 20C90 80 110 100 110 150C110 200 90 220 80 280'/>
</defs><use href='#L'/><use href='#L' x='300'/>"

#let svg-raw(body) = bytes(
  "<svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' viewBox='0 0 440 300'>"
    + defs
    + body
    + "</svg>",
)

#let blu = rgb("#1a1aff")
#let grn = rgb("#119911")

// Disegno + etichette. `labels` = array di (x, y, contenuto) in coordinate viewBox.
#let diagram-with-labels(body, labels) = layout(size => {
  let w = size.width
  let h = w * 300 / 440
  let s = w / 440 // unità viewBox -> lunghezza
  block(width: w, height: h, {
    image(svg-raw(body), format: "svg", width: w)
    for (x, y, c) in labels {
      place(center + horizon, dx: x * s - w / 2, dy: y * s - h / 2, text(size: 11 * s, c))
    }
  })
})

#let backward = diagram-with-labels(
  "
<line x1='60' y1='222' x2='60' y2='85' stroke='#1a1aff' marker-end='url(#mb)'/>
<path d='M90 72C180 100 260 140 335 150' fill='none' stroke='#119911' marker-end='url(#mg)'/>
<path d='M90 230C180 200 260 215 335 230' fill='none' stroke='#119911' marker-end='url(#mg)'/>
<line x1='360' y1='85' x2='360' y2='140' stroke='red'/>
<path d='M385 225C430 190 430 110 385 80' fill='none' stroke='#1a1aff' marker-end='url(#mb)'/>
",
  (
    (60, 68, $f(x)$),
    (60, 238, $x$),
    (40, 155, text(fill: blu, $f$)),
    (212, 98, text(fill: grn, $alpha$)),
    (212, 198, text(fill: grn, $alpha$)),
    (360, 68, $f^sharp (alpha(x))$),
    (360, 155, $alpha(f(x))$),
    (360, 238, $alpha(x)$),
    (420, 175, text(fill: blu, $f^sharp$)),
  ),
)

#let forward = diagram-with-labels(
  "
<line x1='60' y1='222' x2='60' y2='160' stroke='#1a1aff' marker-end='url(#mb)'/>
<line x1='60' y1='85' x2='60' y2='140' stroke='red'/>
<path d='M335 72C250 100 170 100 90 72' fill='none' stroke='#119911' marker-end='url(#mg)'/>
<path d='M335 230C250 200 170 200 90 230' fill='none' stroke='#119911' marker-end='url(#mg)'/>
<line x1='360' y1='222' x2='360' y2='85' stroke='#1a1aff' marker-end='url(#mb)'/>
",
  (
    (60, 68, $gamma(f^sharp (x))$),
    (60, 152, $f(gamma(x))$),
    (60, 238, $gamma(x)$),
    (38, 192, text(fill: blu, $f$)),
    (212, 110, text(fill: grn, $gamma$)),
    (212, 192, text(fill: grn, $gamma$)),
    (360, 68, $f^sharp (x)$),
    (360, 238, $x$),
    (388, 155, text(fill: blu, $f^sharp$)),
  ),
)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 1em,
  align: center + horizon,

  [*Backward*], [*Forward*],
  backward, forward,
  [(a)], [(b)],
  $ forall c in C . alpha(f(c)) sqle(A) f^sharp (alpha(c)) $,
  $ forall a in A . f(gamma(a)) sqle(C) gamma(f^sharp (a)) $,
)

=== Best correct approximation

Per un dominio $C$ possiamo avere molteplici possibili astrazioni, quindi dobbiamo chiederci quale sia la l'astrazione  $f^"#"$ più precisa tra tutte le possibili astrazioni per $f$?

Supponiamo che $C$ ed $A$ formino una connessione di Galois tramite $alpha$ e $gamma$ e sia $f: C arrow C$ un'operazione concreta.
La migliore aprrossimazione corretta (best correct approximation) $f^"bca" : A arrow A$ è definita come:

$ f^"bca" = alpha compose f compose gamma $

La $f^"bca" = alpha(f(gamma(a)))$ è spesso indecidibile, dovremmo concretizzare $a$ ottenendo $gamma(a)$, che di solito è un insieme infinito, per i segni avremmo $gamma(+) = {1, 2, 3, dots}$ e poi applicare la $f$ concreta a tutti gli elementi e astrarre il risultato di $f$ con $alpha$.
