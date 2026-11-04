#import "../../Template typst/template.typ": (
  c-border, definition, exam, example, formula, note, separator, theorem, warning,
)
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

= Lezione 13 del 4 novembre 2026

La scorsa lezione abbiamo visto il clustering e un'introduzione al clustering gerarchico, parleremo adesso delle diverse metodologie di clustering gerarchico.

== Metodologie di clustering gerarchico

Un problema del clustering gerarchico è la complessità computazionale, che è $O(n^2)$, dove $n$ è il numero di oggetti da clusterizzare, dove ogni decisione sul merge o sullo split richeidere di conoscere un numero elevato di dati.

Esistono diverse metodologie che ci permettono di fare clsuterign gerarchico su dataset anche con un elevato numero di punti.

- *BIRCH*: aggiusta in modo incrementale la qualità dei sottocluster, esiste una variante che funziona su dataset con un elevato numero di campioni.
- *ROCK*: clustering di dati categoriali utilizzando la distanza minima tra cluster.
- *CURE*: minimizzare la distanza media dei punti dal proprio centroide.
- *Chameleon*: modellazione dinamica per determinare la similarità tra coppie cluster.

=== Metodologia BIRCH

La metodologia BIRCH: Balanced Iterative Reducing and Clustering using Hierarchies è una metodologia di clustering gerarchico basata su due concetti: *Clustering Feature (CF)* e *Cluster Feature Tree (CF-tree)*.

#figure(image("img/lezione13/bplus_tree.svg", width: 65%), caption: [Esempio di metodologia BIRCH.])

Una *cluster feature* è una tupla $"CF" = (N, arrow("LS"), arrow("SS"))$ dove:
- $N$, è il numero di punti del cluster.
- $"LS" = sum_(i=1)^N arrow(X)_i$
- $"SS" = sum_(i=1)^N arrow(X)^2_i$

#figure(image("img/lezione13/cf_clusters.svg", width: 65%), caption: [Esempio di cluster feature.])

Il CF serve a rappresentare il cluster, o i sottocluster, con delle statistiche e permette di utilizzare un sistema di immagazzinamento efficiente.

Inoltre possiamo definire anche la media del cluster con $mu_c = "LS" / N$ ed il raggio $= sqrt(("SS"/N) - ("LS"/N)^2)$

Con un cluster $C$ composto da $N$ elementi $[arrow(X)_1, dots, arrow(X)_n]$, per calcolare il centroide
possiamo sfruttare la media del cluster: $arrow(X)_0 = frac(sum_(i = 1)^N arrow(X)_i, N)$.

Possiamo calcolarne anche il raggio: $R = sqrt(frac(sum_(i = 1)^N (arrow(X)_i - arrow(X)_0)^2, N))$

#theorem(name: "Teorema di additività")[
  Prendendo in considerazione due cluster $C_1$ e $C_2$ e le loro clustering feature, $"CF"_C_1$ e $"CF"_C_2$ è possibile rappresentare la clustering feature del cluster $C_3$ nato dalla fusione di $C_1$ e $C_2$ come:

  $ "CF"_C_3 = quad <n C_1 + n C_2, "LS"_C_1 + "LS"_C_2, "SS"_C_1 + "SS"_C_2> $
]

==== BIRCH: CF-tree

Il *CF-tree* è un albero *bilanciato* costruito tenendo in considerazione due parametri:
- *branching factor B*: numero massimo di elementi in un nodo non foglia.
- *threshold T*: il diametro massimo dei sottocluster immagazzinati nei nodi foglia.

Il contenuto di un nodo non foglia è del tipo $["CF"_i, "child"_i]$, dove:
- $"child"_i$ è un puntatore all'$i$-esimo figlio del nodo in considerazione.
- $"CF"_i$ è la cluster feature relativa al sottocluster rappresentata da tale figlio.

Il contenuto di un nodo foglia è nella forma $["CF"_j, dots, "CF"_(j + L)]$. Inoltre per ogni nodo foglia manteniamo i puntatori al nodo foglia che precede (prev) e che succede (next) il nodo.

#figure(
  image("img/lezione13/cf_tree_B7_L5.svg", width: 65%),
  caption: [Esempio di CF-tree con branching factor 5 e L = 7.],
)

==== BIRCH: fasi

#figure(image("img/lezione13/birch_fasi.svg", width: 65%), caption: [Fasi del metodo BIRCH.])

La metodologia BIRCH si divide in 2 fasi:

+ Scan del dataset per costruire in-memory un CF-tree iniziale.
+ Utilizza un algoritmo di clustering per clusterizzare le foglie del CF-tree.

Per inserire un elemento nel CF-tree:

+ Identifichiamo la foglia più appropriata tramite una misura di closeness.
+ Si modifica la foglia:
  - Se $D < T$ allora la foglia può assorbire il punto, quindi inseriamo l'elemento e aggiorniamo le CF.
  - Altrimenti si crea una nuova entry e gestiano lo split del nodo.
+ Modifichiamo il path per raggiungere la foglia.
  - Aggiornamento dei CF.
  - Gestione dei nodi parent fino alla root per possibili divisioni degli stessi.

Per rifinire l'albero si segue il procedimento:
- Le entry nelle foglie del CF-tree con pochi elementi possono essere considerati degli *outlier* ed eliminati dall'albero.
- La threshold e il branching factor possono portare alla divisione di cluste reali, cioè ad un risultato che poco riflette come i dati dovrebbero essere realmente clusterizzati.
  - Nella fase 2: Un algoritmo di clustering agglomerativo viene applicato ai sottocluster delle foglie, considerando ognuno di essi come un singolo punto con valore il suo CF.

*Vantaggi*:
- Scala linearmente
- Trova un buon clustering con una sola lettura dei dati e migliora la qualità con le altre letture.

*Svantaggi*:
- Manipola solo dati numerici.
- *È sensibile all'ordine in cui si leggono i dati*.
- Trova solo cluster di forma sferica in quanto il metodo si basa sul raggio.
