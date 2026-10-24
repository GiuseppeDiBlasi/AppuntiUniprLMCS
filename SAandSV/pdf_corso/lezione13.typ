#import "../../Template typst/template.typ": (
  c-border, definition, example, lbs, lps, note, rbs, recall, rps, sleq, slt, sqglb, sqle, sqlub, supqle, theorem,
)
#import "@preview/fletcher:0.5.8": diagram, edge, node, shapes

= Lezione 13 del 21 ottobre 2026

Nella lezione 13 è stato presentato il seminario sullo split operator. Un modo per migliorare l'efficienza di tool di analisi statica.

C'è anche il paper su cui è basato il seminario al seguente link: #link("https://air.unipr.it/retrieve/0e5eea3e-21aa-4e1b-bff3-485069e7d0b5/s10009-024-00761-2.pdf")[Speeding up Static Analysis with the Split Operator.]

== Problemi con l'operatore di filtro

L'operatore filtro, che può essere definito con la seguente funzione:

$ italic("filter"): A times "Pred" arrow A $

Questa funzione prende in input un elemento astratto $A$ e un predicato *Pred*, e restitusce un elemento astratto $A$ dopo la valutazione dell'espressione del predicato.

Questo operatore ci permette di modellare il flusso d'esecuzione del programma.

Vediamo un esempio d'uso per l'operatore di filtro:

#example(name: "Operatore di filtro")[
  #figure(image("img/lezione13/operatore_filtro.svg", width: 70%), caption: [Operatore di filtro.])

  L'operatore di filtro ci permette di modellare correttamente i possibili flussi d'esecuzione del programma, però presentiamo parecchio overhead, in questo caso abbiamo 2 copie e 2 invocazioni per la funzione filtro.
  Con programmi più complessi questo comporta un maggior uso della memoria.
]

Per risolvere questo overhead si consiglia l'uso dell'operatore di split.

== Operatore di split

L'operatore di split sostanzialmente ha lo stesso comportamento dell'operatore di filtro, ma risulta molto più efficiente perché evitiamo l'overhead dell'operatore di filtro.

L'operatore di split è una funzione definita come:

$ italic("split"): A times "Pred" arrow A times A $

Abbiamo lo stesso dominio dell'operatore di filtro, ma in output diamo l'elemento filtrato per il predicato e il suo complemento.

L'obiettivo dello split è quello di ridurre l'overhead che si introduce utilizzando l'operatore di filtro.

#example(name: "Operatore di split")[
  #figure(image("img/lezione13/split.svg", width: 70%), caption: [Esempio con operatore split.])

  Con l'operatore split abbiamo una sola invocazione, e non dobbiamo copiare i valori per ogni diramazione che possiamo incontrare durante l'esecuzione del programma.

]

Guardiamo ora un esempio con lo split sui poliedri.

#example(name: "Split su poliedro con vincoli interi")[
  #figure(image("img/lezione13/poliedro_intero.svg", width: 70%), caption: [Split su un poliedro intero.])

  In questo esempio abbiamo uno split su un poliedro $P$ con vincoli *interi*, quindi le soluzioni ammesse sono i punti con i pallini neri. Quando splittiamo il poliedro non possiamo accettare valori che non siano interi, quindi dopo lo split, la figura più a destra, dobbiamo "ridisegnare" il poliedro seguento i punti interi lungo e all'interno del poliedro $P$.

]

#example(name: [Split su poliedro con $x_0 = 2$])[
  #figure(image("img/lezione13/split_vertical.svg", width: 70%), caption: [Split verticale su un poliedro intero.])

  In questo caso abbiamo il vincolo $x_0 = 2$, questo ci fa splittare il poliedro $P$ lungo "l'asse" $x = 2$.
  Questo esempio è simile al raffinare gli intervalli, per esempio:

  Se avessi una variabile $x = 5$, che può assumere valori tra l'intervallo $[0:10]$, io devo dire che $x = [5:5]$, e non posso unire le altre due informazioni $[0:4];[6:10]$ perché sono due set di intervalli diversi.
  Questo è sempre sound ma non esattamente preciso come vorremmo. Questa imprecisione è dovuta anche al dominio in ci stiamo lavorando.

]

#pagebreak()

#example(name: [Poliedro in $RR$.])[
  #figure(image("img/lezione13/split_then.svg", width: 70%), caption: [Poliedro then.])

  In questo esempio abbiamo un poliedro con dominio $RR$. Qui prendiamo l'intero poliedro che rispetti il vincolo senza escludere valori decimali, nel caso $P_"else"$ è più evidente.

  #figure(image("img/lezione13/split_else.svg", width: 70%), caption: [Poliedro else.])

  In questo caso vediamo come il poliedro prenda anche valori non decimali rispetto agli esempi precedenti dove il dominio era quello dei numeri interi.

  Questo secondo poliedro $P_"else"$ è la negazione, o complemento, di $P_"then"$.
]

== Implementazione operatore split

Durante il seminario si è parlato di come sia stato implementato l'operatore di split, partendo da librerie di analisi statica per C++ come *Crab* e *Clam*. Crab è la libreria di analisi statica, mentre Crab è il front-end per Crab. Un programma C++ viene compilato in rappresentazione intermedia LLVM.

Per implementare l'operatore di split in Crab si è dovuto modificare il dominio d'astrazione che Crab usa con modifiche anche all'engine per l'approssimazione del fixpoint.
Questo ha permesso anche di semplificare i CFG utilizzati dall'IR.

#figure(
  image("img/lezione13/cfg_split.svg", width: 70%),
  caption: [CFG pre e post implementazione dell'operatore di split.],
)

== Risultati ottenuti

Questa implementazione permette di ridurre drasticamente l'utilizzo della memoria e il numero di nodi utilizzati all'interno del CFG.

#figure(
  image("img/lezione13/grafici_confronto.svg", width: 70%),
  caption: [Confronto memoria utilizzata e numero nodi del CFG.],
)

Qui finisce la prima parte del seminario, la seconda e ultima parte sarà nella lezione 14 del 22 ottobre 2026.
