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

Esiste una versione per dataset di grandi dimensioni, $"BIRCH"^"*"$, che è sulle slide '_AIALGO_2627_6-clustering-algoritmi.pdf_' da slide 75 a 84.

=== Dynamic tree cut

Sono tecniche poco comuni ma utilizzate per tagliare rami per rilevare cluster in un dendrogramma a seconda della loro forma.
Rispetto ai metodi di taglio ad altezza costante le tecniche dinamiche offrono:

- Possibilità di identificare cluster nidificati.
- Sono flessibili.
- Sono adatti all'automazione.
- Possono facoltativamente combinare i vantaggi del clustering gerarchico e del partizionamento attorno ai medoidi, fornendo migliori rilevamenti degli outlier.

=== Metodologia ROCK

La metodologia ROCK (RObust Clustering using linKs) è una metodologia di clustering per dati *categoriali*.

È composta da 3 fasi:

- *Campionamento casuale*: Viene utilizzato per garantire scalabilità su dataset molto grandi. Il campione iniziale viene utilizzato per formare cluster, quindi i dati rimanenti sul disco vengono poi assegnati a questi cluster.

- *Clustering*: Esegue un algoritmo di clustering agglomerativo gerarchico con una particolare definizione di similarità, tramite link.

- *Etichetta i dati su disco*: Infine, i punti generati nel disco vengono assegnati ai cluster generati. Questo viene fatto selezionando un campione casuale $L_i$ da ciascun cluster $C_i$, quindi assegniamo ogni punto $p$ al cluster per il quale ha il link più forte con $L_i$.

==== Calcolo del link

Il calcolo del link si basa sulla *vicinanza*, ovvero se la somiglianza, di solito il coefficiente di Jaccard, tra due punti supera una certa soglia di somiglianza $theta$, sono considerati vicini.

Il *link* per una coppia di punti è: il numero dei loro vicini comuni.

==== Criterio

L'obiettivo della metodologia ROCK è massimizzare il seguente criterio:

#formula(name: "Criterio metodo ROCK")[
  $ E_l = sum_(i = 1)^k n_i times sum_(p_q, p_r in C_i) frac("link"(p_q, p_r), n_i^(1 + 2f(theta))) $

]
- $C_i$, cluster attuale.
- $n_i$, cardinalità del cluster.
- $k$, numero finale di cluster che si vuole ottenere.

Tipicamente $f(theta)$ viene posto uguale a $(1 - theta) / (1 + theta)$

Per massimizzare la funzione criterio si usa la seguente misura di goodness:

#formula(name: "Misura di goodness")[
  $ g(C_i, C_j) = frac("link"[C_i, C_j], (n_i + n_j)^(1 + 2f(theta)) - n_i^(1 + 2f(theta)) - n_j^(1 + 2f(theta))) $
]

=== Metodologia CURE

La metodologia CURE (Clustering Using REpresentatives) risolve il clustering in spazi euclidei quando i cluster non hanno una distribuzione gaussiana attorno a un centroide.

Le fasi della metodologia CURE sono:

+ Inizia con la main memory piena di punti random. Questi punti vengono clusterizzati utilizzando un approccio gerarchico.
+ Per ogni cluster scegli un campione di $c$ punti per qualche costante c. Questi punti sono scelti più distante possibile l'uno dall'altro, dopo di che essi si spostano leggermente nella direzione del centroide nel seguente modo:
  - Scegli il primo come il più lontano dal centroide.
  - Ripetutamente scegli il punto del cluster che massimizzi la minima distanza da quelli già scelti.
  - Quando si sono completati i $c$ punti allora spostali tutti leggermente, circa del 20%, verso il centroide.
+ Partiziona l'insieme secondo tutti questi $c$ punti.

#figure(image("img/lezione13/cure_clustering.svg", width: 65%), caption: [CURE clustering.])
