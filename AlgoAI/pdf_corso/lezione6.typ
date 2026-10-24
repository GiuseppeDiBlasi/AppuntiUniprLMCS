#import "../../Template typst/template.typ": c-border, definition, exam, example, note, theorem, warning
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

= Lezione 6 del 9 ottobre 2026

La lezione 6 si concentra sugli algoritmi di classificazione.

== Algoritmi di classificazione

I modelli di classificazione possono essere divisi in due tipologie principali:

- _*Eager*_: costruiscono un modello generale ed indipendente dall'input partendo dai dati di addestramento.
- _*Lazy*_: memorizzano i dati di addetramento in forma grezza, il processo di classificazione è rimandato all'arrivo di una nuova istanza da classificare.

I modelli lazy richiedono meno tempo in fase di addestramento, ma aumenta il tempo durante la fase di classificazione.
I modelli lazy però hanno uno spazio delle ipotesi molto più ricco. Possono usare in modo più diretto funzioni locali di classificazione che forniscono delle approssimazioni a livello globale.

I modelli eager invece fanno riferimento a una sola ipotesi per coprire l'universo delle osservazioni.

Vedremo il modello K-nearest neighbor come approccio di classificazione lazy.

=== K-NN, K-nearest neighbors (Lazy)
È un algoritmo di classificazione lazy.

I data point sono rappresentati in uno spazio $n$ dimensionale.
Ogni dimensione può avere valori reali o discreti.

Su questo spazio calcoliamo le distanze tra i vari punti cercando di stabilire a quale classe appartiene il punto che ci interessa calcolando la distanza dai suoi k vicini.

#align(center)[
  #figure(image("img/lezione6/knn.svg", width: 60%), caption: [Esempio di K-NN.])
]

Ricapitolando, dato un training set e un'istanza da classificare, l'algoritmo assegna a tale istanza la classe che più è rappresentata tra i suoi $k$ vicini più prossimi.
L'algoritmo dipende molto dal parametro $k$, di solito si usano valori dispari.

#align(center)[
  #figure(image("img/lezione6/knn_classes.svg", width: 60%), caption: [K-NN al variare di k.])
]

K-NN non fa alcuna ipotesi sulla possibile distribuzione dei dati che vengono analizzati, di conseguenza è una delle prime scelte quando c'è poca o nessuna conoscenza preliminare sulla distribuzione dei dati.

Nel caso di dataset sbilanciati K-NN tende a favorire la classe più numerosa, dato che ha più occorrenze nel dataset che stiamo studiando. Se dovessimo avere un dataset con 1000 campioni, 800 di classe A e 200 di classe B, è altamente probabile che un elemento venga classificato come elemento di classe A.

=== K-NN pesato

Per migliorare le prestazioni di K-NN con dataset sbilanciati si può utilizzare una versione dove le classi dei vicini sono pesate in base alla loro distanza.

#align(center)[
  #figure(image("img/lezione6/knn_weighted.svg", width: 60%), caption: [K-NN pesato.])
]

Nei dataset sbilanciati si può pensare di pesare anche l'apporto di ogni vicino con l'inverso del numero totale di punti presenti nel dataset ed aventi al stessa classe del vicino in questione.


=== Alberi di decisione (Eager)

Un albero di decisione descrive un albero di ricerca n-ario dove i nodi foglia rappresentano le classificazioni e le ramificazioni l'insieme delle proprietà che portano a quelle classificazioni.
Ogni nodo interno contiene un test che stabilisce quale sotto-albero esplorare.

Un test valuta una feature o una combinazione di feature.

#align(center)[
  #figure(image("img/lezione6/decision_tree.svg", width: 80%), caption: [Albero di decisione.])
]

==== Costruzione dell'albero

Vediamo come costruire un albero di decisione:

Partiamo da un nodo radice che racchiude la totalità dei dati di addestramento e si segue l'algoritmo:

+ Se tutti i dati di training che sono all'interno di un nodo $t$ assumono lo stesso valore sull'attributo classificatore, creare un nodo foglia contenente tutti i dati.
+ Altrimenti, mediante una misura di goodness effettuare una partizione $S$ degli elementi rappresentati dal nodo
+ Si sceglie la partizione $S^*$ che ad esempio massimizza la misura di goodness.
+ Si creano tanti figli del nodo $t$ quante sono le classi presenti in $S^*$.
+ Un nodo figlio è detto puro se tutti i suoi elementi assumono lo stesso valore sull'attributo classificatore.
+ Si applicano ricorsivamente i passi precedenti sui nodi impuri o che non rappresentano una singola classe secondo una soglia di maggioranza.

Il nostro obiettivo è trovare l'albero più semplice a parità di prestazioni, ottenendo un albero più compatto possibile.

Teniamo in considerazione che la ricerca dell'albero migliore è un problema *NP-Hard*.
Per trovare una soluzione che si avvicini il più possiible a quella ottimale si usano delle euristiche.
Questo algoritmo per trovare una soluzione accettabile è di tipo greedy e non ci garantisce che la soluzione sia ottimale, il punto principale è scegliere l'attributo su cui biforcare in modo da:
- Dividere in insiemi che sono il più possibile puri.
- Porti più rapidamente a dei nodi foglia.

Vogliamo ricondurci ad alberi binari perché sono i più semplici a livello di complessità computazionale quando dobbiamo attraversarli, ed è anche più facile trovare alberi completi.

Guardiamo un esempio di costruzione:

#example[
  Prendiamo in considerazione una tabella con informazioni sul meteo per stabilire se è possibile giocare:

  #align(center)[
    #table(
      columns: 5,
      align: (left, left, left, left, center),
      inset: (x: 6pt, y: 5pt),
      stroke: 1pt + rgb("#c0c0c0"),
      fill: (x, y) => if y == 0 { rgb("#ffff00") } else { rgb("#ccff99") },

      table.header[Outlook][Tempreature][Humidity][Windy][Class],

      [sunny], [hot], [high], [false], [N],
      [sunny], [hot], [high], [true], [N],
      [overcast], [hot], [high], [false], [P],
      [rain], [mild], [high], [false], [P],
      [rain], [cool], [normal], [false], [P],
      [rain], [cool], [normal], [true], [N],
      [overcast], [cool], [normal], [true], [P],
      [sunny], [mild], [high], [false], [N],
      [sunny], [cool], [normal], [false], [P],
      [rain], [mild], [normal], [false], [P],
      [sunny], [mild], [normal], [true], [P],
      [overcast], [mild], [high], [true], [P],
      [overcast], [hot], [normal], [false], [P],
      [rain], [mild], [high], [true], [N],
    )
  ]

  #let azzurro = rgb("#00ccff")
  #let giallo = rgb("#ffff00")
  #let chiaro = rgb("#ccff99")
  #let verde = rgb("#00ff00")
  #let arancio = rgb("#ffcc99")

  // nodo-domanda a forma di rombo
  #let dec(pos, body, col, name) = node(
    pos,
    body,
    shape: fletcher.shapes.diamond,
    fill: col,
    stroke: 0.6pt,
    inset: 3pt,
    name: name,
  )

  // foglia P / N
  #let leaf(pos, v, name) = node(
    pos,
    text(size: 16pt, v),
    shape: fletcher.shapes.rect,
    fill: if v == "P" { verde } else { arancio },
    stroke: none,
    inset: 8pt,
    name: name,
  )

  #scale(60%, reflow: true, diagram(
    spacing: (48pt, 42pt),
    edge-stroke: 0.7pt,
    node-stroke: 0.6pt,

    // --- radice ---
    dec((5.5, 0), [temperature \ =?], azzurro, <t>),

    // --- livello 1 ---
    dec((2.5, 1), [outlook \ =?], giallo, <o1>),
    dec((5.5, 1), [outlook \ =?], giallo, <o2>),
    node((9, 1.4), [], shape: fletcher.shapes.triangle, fill: rgb("#b0dde0"), width: 30pt, height: 45pt, name: <tri>),

    // --- sotto cool/outlook ---
    leaf((1, 2), "P", <p1>),
    dec((2.5, 3), [windy \ =?], azzurro, <w1>),
    leaf((4, 2.3), "P", <p2>),
    leaf((1.9, 4.2), "N", <n1>),
    leaf((3.1, 4.2), "P", <p3>),

    // --- sotto mild/outlook ---
    leaf((4.6, 2.2), "P", <p4>),
    dec((5.5, 3), [windy \ =?], azzurro, <w2>),
    dec((7.5, 2), [humidity \ =?], chiaro, <h>),
    leaf((4.9, 4.2), "P", <p5>),
    leaf((6.1, 4.2), "N", <n2>),

    // --- sotto humidity ---
    leaf((6.8, 3), "P", <p6>),
    dec((8.4, 3), [windy \ =?], azzurro, <w3>),
    leaf((7.7, 4.2), "N", <n3>),
    leaf((9.1, 4.2), "P", <p7>),

    // --- archi ---
    edge(<t>, <o1>, "->", label: [cool], label-side: right),
    edge(<t>, <o2>, "->", label: [mild], label-side: right),
    edge(<t>, <tri>, "->", label: [hot], label-side: left),

    edge(<o1>, <p1>, "->", label: [overcast], label-side: right),
    edge(<o1>, <w1>, "->", label: [rain], label-side: left),
    edge(<o1>, <p2>, "->", label: [sunny], label-side: left),

    edge(<w1>, <n1>, "->", label: [true], label-side: right),
    edge(<w1>, <p3>, "->", label: [false], label-side: left),

    edge(<o2>, <p4>, "->", label: [overcast], label-side: right),
    edge(<o2>, <w2>, "->", label: [sunny], label-side: left),
    edge(<o2>, <h>, "->", label: [rain], label-side: left),

    edge(<w2>, <p5>, "->", label: [true], label-side: right),
    edge(<w2>, <n2>, "->", label: [false], label-side: left),

    edge(<h>, <p6>, "->", label: [normal], label-side: right),
    edge(<h>, <w3>, "->", label: [high], label-side: left),

    edge(<w3>, <n3>, "->", label: [true], label-side: right),
    edge(<w3>, <p7>, "->", label: [false], label-side: left),
  ))


  #align(center, block(
    fill: rgb("#333399"),
    inset: 8pt,
    text(fill: white, size: 14pt)[
      IF (temperature = cool AND outlook = rain AND windy = false) THEN play
    ],
  ))

  L'esempio qui sopra è un albero decisionale per il problema, ma non è la soluzione migliore.
  Per esempio possiamo avere un albero equivalente:

  // nodo-domanda a forma di rombo
  #let dec(pos, body, col, name) = node(
    pos,
    body,
    shape: fletcher.shapes.diamond,
    fill: col,
    stroke: 0.6pt,
    inset: 4pt,
    name: name,
  )

  // foglia P / N
  #let leaf(pos, v, name) = node(
    pos,
    text(size: 16pt, v),
    shape: fletcher.shapes.rect,
    fill: if v == "P" { verde } else { arancio },
    stroke: none,
    inset: 8pt,
    name: name,
  )

  #scale(80%, reflow: true, diagram(
    spacing: (50pt, 50pt),
    edge-stroke: 0.7pt,

    // --- nodi ---
    dec((3, 0), [Outlook \ =?], giallo, <o>),

    dec((1, 1), [humidity \ =?], chiaro, <h>),
    leaf((3, 1), "P", <p0>),
    dec((5.2, 1), [windy \ =?], azzurro, <w>),

    leaf((0, 2), "N", <n1>),
    leaf((2, 2), "P", <p1>),
    leaf((4.4, 2), "N", <n2>),
    leaf((6, 2), "P", <p2>),

    // --- archi ---
    edge(<o>, <h>, "-", label: [sunny], label-side: right),
    edge(<o>, <p0>, "-", label: [overcast], label-side: left),
    edge(<o>, <w>, "-", label: [rain], label-side: left),

    edge(<h>, <n1>, "-", label: [high], label-side: right),
    edge(<h>, <p1>, "-", label: [normal], label-side: left),

    edge(<w>, <n2>, "-", label: [true], label-side: right),
    edge(<w>, <p2>, "-", label: [false], label-side: left),
  ))
]

==== Goodness function

Come funzione di goodness possiamo avere:

- _*Information gain*_: lavora su attributi *categoriali*.
- _*Indice di Gini*_: lavora su attributi con *valori continui*.

==== Information Gain

Guardiamo più nel dettaglio l'information gain: l'algoritmo ha l'obiettivo di ridurre progressivamente l'entropia. La purezza è definita in base a quanto un insieme di istanze è prossimo alla situazione ideale, ovvero ad una sola etichetta. Avremo quindi come nodi foglia finali insiemi dove l'entropia è bassa.


#example[
  #let colori = (rgb("#4e79a7"), rgb("#f28e2b"))

  // entropia in base 2 a partire dai conteggi delle classi (A, B)
  #let ent(c) = {
    let n = c.sum()
    let s = c.filter(x => x > 0).map(x => (x / n) * calc.log(x / n, base: 2)).sum()
    -s
  }

  #let r2(x) = calc.round(x, digits: 2)

  // istogramma delle frequenze relative di A, B
  #let hist(c, h: 60pt, w: 14pt) = {
    let n = c.sum()
    let g = 5pt
    stack(
      dir: ttb,
      spacing: 3pt,
      box(stroke: (left: 0.8pt, bottom: 0.8pt), inset: (x: 4pt), grid(
        columns: (w,) * 2, column-gutter: g, rows: h, align: bottom,
        ..c.enumerate().map(((i, x)) => rect(width: w, height: h * x / n, fill: colori.at(i), stroke: 0.5pt))
      )),
      pad(left: 4pt, grid(
        columns: (w,) * 2, column-gutter: g, align: center,
        ..("P", "N").map(t => text(size: 8pt, t))
      )),
    )
  }

  // istogramma + valore di entropia
  #let con-h(c) = stack(dir: ttb, spacing: 5pt, hist(c), text(size: 9pt)[$H = #r2(ent(c))$])

  // ---------- 1) Entropia alta vs bassa ----------
  #align(center)[
    #scale(100%, reflow: true, grid(
      columns: 3,
      column-gutter: 28pt,
      align: top + center,
      [#text(weight: "bold")[Entropia alta] \ eventi equiprobabili \ #con-h((10, 10))],
      [#text(fill: red, weight: "bold")[Entropia bassa] \ un evento domina \ #con-h((18, 2))],
      [#text(fill: red, weight: "bold")[Entropia bassa] \ un evento domina \ #con-h((2, 18))],
    ))
  ]

  #v(18pt)

  // ---------- 2) Split: padre -> due figli ----------
  #let split(titolo, parent, sx, dx) = {
    let n = parent.sum()
    let hp = ent(parent)
    let hm = sx.sum() / n * ent(sx) + dx.sum() / n * ent(dx)
    let ig = hp - hm
    stack(
      dir: ttb,
      spacing: 8pt,
      text(weight: "bold", titolo),
      diagram(
        spacing: (70pt, 55pt),
        edge-stroke: 0.8pt,
        node((0, 0), con-h(parent), stroke: 0.7pt, corner-radius: 5pt, inset: 6pt),
        node((-1, 1), con-h(sx), stroke: 0.7pt, corner-radius: 5pt, inset: 6pt),
        node((1, 1), con-h(dx), stroke: 0.7pt, corner-radius: 5pt, inset: 6pt),
        edge((0, 0), (-1, 1), "->", label: text(size: 9pt)[#sx.sum()/#n], label-side: right),
        edge((0, 0), (1, 1), "->", label: text(size: 9pt)[#dx.sum()/#n], label-side: left),
      ),
      text(size: 10pt)[
        $H_"dopo" = #r2(hm)$ #h(8pt)
        $"IG" = #r2(hp) - #r2(hm) = #r2(ig)$
      ],
    )
  }

  #figure(
    scale(60%, reflow: true, grid(
      columns: 2,
      column-gutter: 40pt,
      align: top + center,
      split([Split buono: figli quasi puri], (10, 10), (9, 1), (1, 9)),
      split([Split inutile: figli ancora misti], (10, 10), (6, 4), (4, 6)),
    )),
    caption: [Esempio di calcolo entropia per albero di decisione.],
  )
  #warning[
    In questo modo stiamo confrontando entropie di sistemi diversi.

    Ricordiamo che *NON* si possono confrontare entropie di sistemi diversi. In questo caso è un eccezione, ma *NON* è la norma.
  ]

]

Guardiamo l'esempio qui sopra con 2 classi per la nostra classificazione.

Prendiamo $S$ come un insieme contenente $p$ elementi della classe $P$ ed $n$ elementi della classe $N$.

Possiamo calcolare la quantità di informazione necessaria per decidere se un esempio arbitrario nell'insieme $S$ stia in $P$ o $N$ è definita come:

$ italic("Info")(p, n) = - (frac(p, p + n) log_2 frac(p, p + n)) - (frac(n, p + n) log_2 frac(n, p + n)) $

Ipotizziamo ora di utilizzare l'attributo $A$ come radice dell'albero con valori ${a_1, a_2, ..., a_v}$, allora $S$ sarà partizionato in $S_1, S_2, ..., S_v$ insiemi. I valori di $A$ e le partizioni di $S$ sono collegate tra loro seguendo l'indice a pedice: $a_1$ con $S_1$ e così via.

L'informazione richiesta per l'albero con radice A è ottenuta da una media pesata della quantità di informazione secondo le partizioni che $A$ impone su $S$:

$ italic("Info")_A (S) = sum_(i = 1)^v frac(p_i + n_i, p + n) italic("Info")(p_i, n_i) $

_Slide 20 de: "AIALGO_2627_5-classificazione-modelli.pdf" ha la formula con più di due classi._

#pagebreak()

Se partizioniamo $S$ nei vari $S_i$ a seguito del test $A$, l'entropia di $S$ sarà la *media ponderata delle entropie* dei singoli sottoinsiemi, ovvero:

$ italic("Info")_A (S) = sum_(i = i)^n frac(|S_i|, |S|) italic("S")_i $

La quantità di informazione guadagnata dal partizionamento di $S$ secondo l'attributo $A$ sarà:

$ italic("Gain") (A) = italic("Info") (S) - italic("Info")_A (S) $

L'attributo $A$ è selezionato se l'information gain è massimo.

Tutto questo funziona se il dataset è bilanciato, nel caso di un dataset sbilanciato (ovvero la maggior parte dei casi reali) l'information gain favorisce i test che hanno molti esiti.
La soluzione è *normalizzare* il gain in base alla quantità di informazione di $S$ stesso.

Consideriamo l'informazione contenuta da un messaggio sulla probabile divisione dell'insieme $S$ negli insiemi $S_i$.

Tale informazione sarà data da:
$ - log_2 frac(|S_i|, |S|) $

E per analogia con la definizione di $italic("Info")(S)$ si ha:
$ italic("SplitInfo")(A) = - sum_(i = 1)^n frac(|S_i|, |S|) log_2 frac(|S_i|, |S|) $

Che rappresenta la potenziale informazione generata dalla divisione di $S$.
Da qui, il *gain normalizzato* secondo $italic("SplitInfo")(A)$.

$ italic("GainRatio")(A) = frac(italic("Gain") (A), italic("SplitInfo") (A)) $

Torniamo all'esempio del meteo:
#pagebreak()
#example[
  #let box-node(pos, col, p, n) = node(
    pos,
    align(center)[#p P \ #n N],
    width: 95pt,
    height: 70pt,
    stroke: (paint: col, thickness: 1.5pt, dash: "dashed"),
    fill: gradient.linear(col.lighten(45%), white, angle: 90deg),
    inset: 8pt,
  )

  #let free(pos, body) = node(pos, body, stroke: none, fill: none)

  #let cyan = rgb("#1ec3f0")
  #let green = rgb("#7dd070")
  #let purple = rgb("#8a4fe0")

  #figure(
    scale(60%, reflow: true, diagram(
      spacing: (150pt, 130pt),
      node-inset: 0pt,
      edge-stroke: 0.9pt,
      mark-scale: 70%,

      // titolo sopra la radice
      free((0, -0.5), text(size: 12pt)[Go out to play?]),

      // nodi
      box-node((0, 0), cyan, 30, 70),
      box-node((-1, 1), green, 25, 10),
      box-node((1, 1), purple, 5, 60),

      // archi ad angolo retto: giù, orizzontale, giù
      edge((0, 0), (0, 0.5), "-"),
      edge((0, 0.5), (-1, 0.5), (-1, 1), "->"),
      edge((0, 0.5), (1, 0.5), (1, 1), "->"),

      // etichette degli archi
      free((-0.42, 0.38), text(size: 10pt)[Weather = _Sunny_]),
      free((0.42, 0.38), text(size: 10pt)[Weather = _Rainy_]),
      free((0, 0.64), text(size: 15pt)[SplitInfo(S)]),

      // etichette laterali
      free((0.68, 0), text(size: 16pt)[Info(S)]),
      free((-0.32, 1), text(size: 16pt)[$"Info"_A (S)$]),
    )),
    caption: [Calcolo di Info(S), SplitInfo(S) e $"Info"_A (S)$ per lo split su _Weather_.],
  )
]

Purtroppo _GainRatio_ non ci permette di risolvere tutti i problemi. Potrebbe capitare che alcuni attributi significativi, che assumono qualche valore in più rispetto agli altri, vengano penalizzati.

Per ovviare si segue questa strategia:
- Si calcola il guadagno per ogni attributo.
- Si calcola la media dei guadagni calcolati.
- Si selezionano *SOLO* gli attributi che hanno guadagno al di sopra della media.
- Si scelgono tra gli attribui selezionati, quelli con _GainRatio_ maggiore.

#note[
  - Nel caso di attributi di tipo continuo si utilizza un valore soglia $Z$ per stabilire se l'attributo è sopra o sotto al valore di soglia $Z$.

  - Nel caso di attributi con valori mancanti ci sono due approcci:
    - Assegnare il valore più comune al valore nullo.
    - Assegnare la probabilità ad ognuno dei possibili valori.

    Possiamo riscrivere $italic("Gain")(A)$ può essere riscritto come:

    $ italic("Gain")(A) = F dot (italic("Info")(S) - italic("Info")_A (S)) $

    - $F$, percentuale di casi nel training set per cui $A$ è noto.

    Questo ha effetti anche sul partizionamento, dato che dobbiamo ricalcolare $italic("SplitInfo")(S)$ e anche $italic("GainRatio")$.
]

#exam[
  Una possibile domanda aperta all'esame può essere quella di descrivere i metodi di partizionamento.
]


// ================= DATI E FUNZIONI =================
#let attrs = ("Outlook", "Temperature", "Humidity", "Windy")

#let dati = (
  ("sunny", "hot", "high", "false", "N"),
  ("sunny", "hot", "high", "true", "N"),
  ("overcast", "hot", "high", "false", "P"),
  ("rain", "mild", "high", "false", "P"),
  ("rain", "cool", "normal", "false", "P"),
  ("rain", "cool", "normal", "true", "N"),
  ("overcast", "cool", "normal", "true", "P"),
  ("sunny", "mild", "high", "false", "N"),
  ("sunny", "cool", "normal", "false", "P"),
  ("rain", "mild", "normal", "false", "P"),
  ("sunny", "mild", "normal", "true", "P"),
  ("overcast", "mild", "high", "true", "P"),
  ("overcast", "hot", "normal", "false", "P"),
  ("rain", "mild", "high", "true", "N"),
)

#let r3(x) = calc.round(x, digits: 3)

// conteggi (p, n) di un insieme di righe
#let conta(rows) = (
  rows.filter(r => r.last() == "P").len(),
  rows.filter(r => r.last() == "N").len(),
)

// entropia (base 2) dai conteggi
#let ent(c) = {
  let tot = c.sum()
  if tot == 0 { return 0 }
  -c.filter(x => x > 0).map(x => x / tot * calc.log(x / tot, base: 2)).sum()
}

// entropia scritta con i numeri sostituiti (contenuto math)
#let ent-es(c) = {
  let tot = c.sum()
  let termini = c.filter(x => x > 0).map(x => $frac(#[#x], #[#tot]) log_2 frac(#[#x], #[#tot])$)
  $-(#termini.join($+$))$
}

// partiziona le righe secondo l'attributo a: ((valore, righe), ...)
#let parti(rows, a) = (
  rows.map(r => r.at(a)).dedup().map(val => (val, rows.filter(r => r.at(a) == val)))
)

#let info-a(rows, a) = (
  parti(rows, a).map(((val, s)) => s.len() / rows.len() * ent(conta(s))).sum()
)

#let gain(rows, a) = ent(conta(rows)) - info-a(rows, a)

#let split-info(rows, a) = ent(parti(rows, a).map(((val, s)) => s.len()))

#let gain-ratio(rows, a) = {
  let si = split-info(rows, a)
  if si == 0 { 0 } else { gain(rows, a) / si }
}

// indice (in cand) dell'attributo scelto: gain >= media, poi GainRatio massimo
#let miglior(rows, cand) = {
  let g = cand.map(a => gain(rows, a))
  let gr = cand.map(a => gain-ratio(rows, a))
  let media = g.sum() / g.len()
  let ok = range(cand.len()).filter(i => g.at(i) >= media)
  ok.sorted(key: i => -gr.at(i)).first()
}

// ---------- dettaglio di UN attributo, con tutti i passaggi ----------
#let dettaglio(rows, a) = {
  let N = rows.len()
  let ps = parti(rows, a)
  let hi = ent(conta(rows))
  let ia = info-a(rows, a)
  let g = gain(rows, a)
  let si = split-info(rows, a)

  let t-ia = ps.map(((v, s)) => {
    let k = s.len()
    $frac(#[#k], #[#N]) dot #r3(ent(conta(s)))$
  })
  let t-si = ps.map(((v, s)) => {
    let k = s.len()
    $frac(#[#k], #[#N]) log_2 frac(#[#k], #[#N])$
  })
  [
    *Attributo #attrs.at(a)*

    #align(center, table(
      columns: 5,
      align: center,
      table.header[*Valore*][*P*][*N*][*Righe*][*$H$*],
      ..ps
        .map(((v, s)) => {
          let (p, n) = conta(s)
          ([#v], [#p], [#n], [#s.len()], [#r3(ent((p, n)))])
        })
        .flatten(),
    ))

    - $"Info"_A (S) = #t-ia.join($+$) = #r3(ia)$
    - $"Gain" = #r3(hi) - #r3(ia) = #r3(g)$
    - $"SplitInfo" = -(#t-si.join($+$)) = #r3(si)$
    - $"GainRatio" = #r3(g) / #r3(si) = #r3(gain-ratio(rows, a))$
  ]
}

// ---------- un passo completo: tutti gli attributi candidati + scelta ----------
#let passo(rows, cand) = {
  let (p, n) = conta(rows)
  let g = cand.map(a => gain(rows, a))
  let media = g.sum() / g.len()
  let best = miglior(rows, cand)

  [
    Il nodo contiene $#p$ P e $#n$ N, quindi
    $"Info"(S) = #ent-es((p, n)) = #r3(ent((p, n)))$.

    #for a in cand [
      #dettaglio(rows, a)
      #v(4pt)
    ]

    *Riepilogo e scelta*

    #align(center, table(
      columns: 5,
      align: (left, center, center, center, center),
      fill: (x, y) => if y == best + 1 { rgb("#ccff99") },
      table.header[*Attributo*][*Gain*][*SplitInfo*][*GainRatio*][*Gain $>=$ media?*],
      ..range(cand.len())
        .map(i => {
          let a = cand.at(i)
          (
            [#attrs.at(a)],
            [#r3(g.at(i))],
            [#r3(split-info(rows, a))],
            [#r3(gain-ratio(rows, a))],
            [#if g.at(i) >= media [sì] else [no]],
          )
        })
        .flatten(),
    ))

    Media dei gain: $(#g.map(x => str(r3(x))).join(" + ")) / #g.len() = #r3(media)$.
    Passano il filtro solo gli attributi con gain $>=$ media; tra questi vince il
    GainRatio maggiore. Si sceglie quindi *#attrs.at(cand.at(best))*.
  ]
}

// ================= ESEMPIO =================
#example[
  Costruiamo l'albero sul dataset del meteo (14 esempi: 9 P e 5 N) con
  *information gain* e *gain ratio*.

  === Passo 1: nodo radice

  #passo(dati, (0, 1, 2, 3))

  === Passo 2: figli di #attrs.at(miglior(dati, (0, 1, 2, 3)))

  Un figlio per ogni valore dell'attributo scelto:

  #let sunny = dati.filter(r => r.at(0) == "sunny")
  #let over = dati.filter(r => r.at(0) == "overcast")
  #let rain = dati.filter(r => r.at(0) == "rain")

  - *overcast*: #conta(over).at(0) P e #conta(over).at(1) N, $H = #r3(ent(conta(over)))$.
    Nodo *puro*: diventa una foglia P.
  - *sunny*: #conta(sunny).at(0) P e #conta(sunny).at(1) N, $H = #r3(ent(conta(sunny)))$.
    Impuro: si riapplica l'algoritmo.
  - *rain*: #conta(rain).at(0) P e #conta(rain).at(1) N, $H = #r3(ent(conta(rain)))$.
    Impuro: si riapplica l'algoritmo.

  === Passo 3: ramo sunny

  Outlook è già stato usato: restano Temperature, Humidity e Windy.

  #passo(sunny, (1, 2, 3))

  === Passo 4: ramo rain

  #passo(rain, (1, 2, 3))

  Tutti i nodi sono ora puri: l'algoritmo termina.

  === Albero finale

  #let nodo(pos, body, col, name) = node(
    pos,
    body,
    shape: fletcher.shapes.diamond,
    fill: col,
    stroke: 0.6pt,
    inset: 4pt,
    name: name,
  )
  #let foglia(pos, v, name) = node(
    pos,
    text(size: 14pt, v),
    shape: fletcher.shapes.rect,
    fill: if v == "P" { rgb("#00ff00") } else { rgb("#ffcc99") },
    stroke: none,
    inset: 8pt,
    name: name,
  )

  #align(center, scale(80%, reflow: true, diagram(
    spacing: (50pt, 50pt),
    edge-stroke: 0.7pt,

    nodo((2, 0), [Outlook \ =?], rgb("#ffff00"), <o>),
    nodo((0.5, 1), [Humidity \ =?], rgb("#ccff99"), <h>),
    foglia((2, 1), "P", <p0>),
    nodo((3.5, 1), [Windy \ =?], rgb("#00ccff"), <w>),
    foglia((0, 2), "N", <n1>),
    foglia((1, 2), "P", <p1>),
    foglia((3, 2), "N", <n2>),
    foglia((4, 2), "P", <p2>),

    edge(<o>, <h>, "->", label: [sunny], label-side: right),
    edge(<o>, <p0>, "->", label: [overcast], label-side: left),
    edge(<o>, <w>, "->", label: [rain], label-side: left),
    edge(<h>, <n1>, "->", label: [high], label-side: right),
    edge(<h>, <p1>, "->", label: [normal], label-side: left),
    edge(<w>, <n2>, "->", label: [true], label-side: right),
    edge(<w>, <p2>, "->", label: [false], label-side: left),
  )))
]
