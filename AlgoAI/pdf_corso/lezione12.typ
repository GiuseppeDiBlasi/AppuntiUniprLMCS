#import "../../Template typst/template.typ": (
  c-border, definition, exam, example, formula, note, separator, theorem, warning,
)
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

= Lezione 12 del 2 novembre 2026

Riprendiamo con gli algoritmi di clustering. Abbiamo visto nella scorsa lezione k-means, un algoritmo semplice e intuitivo da implementare.
Non è stabile rispetto agli outlier, dato che k-means lavora sulla media dei cluster, gli outlier vanno a spostare i centroidi.

== K-medoids, tecniche PAM e CLARA

K-medoids cerca di risolvere il problema degli outlier, invece di prendere il centroide del cluster si prende in considerazione l'oggetto più centrale al cluster, chiamato medoid (medoide).

Ci sono diverse tecniche per K-medoids, una è *PAM (Partitioning Around Medoids)* parte da un insieme iniziale di medoidi e sostituisce iterativamente uno dei medoidi con uno dei non medoidi se migliora la distanaz totale del clustering risultate.

#figure(image("img/lezione12/k_medoids.svg", width: 70%), caption: [K-medoids con tencnica PAM.])

La tecnica PAM funziona in modo efficiente per dataset di piccole dimensioni, dovessi lavorare con dataset di dimensioni elevate diventerebbe del tutto inefficiente. Questo è dovuto alla sua complessità computazionale:

$O(k(n - k)^2)$, dove $n$ è il numero di dati, $k$ è il numero di cluster.

Un'alternativa per dataset molto grandi è usare la tecnica *CLARA*, è un metodo basato sul campionamento.
La tecnica *CLARA* campiona il dataset, applica poi la tecnica PAM su ogni campione e fornisce il miglior clustering come output.

Questa tecnica ci permette di poter lavorare con dataset di dimensioni elevate rispetto a PAM.
Gli svantaggi di CLARA è che l'efficienza dipende dalla dimensione del campione e che il raggruppamento a campioni che si ottiene in output non è detto che sia la soluzione migliore per il nostro dataset se il campione è distorto.

#figure(image("img/lezione12/cluster_plot.svg", width: 70%), caption: [Esempio di K-medoids con CLARA.])

== K-means, algoritmo BFR

Siccome k-means è un algoritmo semplice e intuitivo, ma non scalare, esiste una variante dell'algoritmo che permette di lavorare con grandi dataset.
Questa variante si chiama algoritmo *BFR (Bradley-Fayyad-Reina)*, è un algoritmo di clustering basato su k-means.

L'algoritmo BFR individua *tre regioni* di dati:
- Regioni *scartabili*: oggetti la cui appartenenza ad un cluster è certa.
- Regioni *comprimibili*: oggetti che non sono scartabili ma che appartengono a subcluster ben definiti e densi.
- Regioni che devono essere mantenute in *memoria principale* perché non ancora sono associate a nessun cluster o sottocluster.

L'algoritmo BFR funziona meglio se i punti sono distribuiti secondo una gaussiana attorno a dei punti centrali con delle deviazioni standard diverse su ogni dimensione.

I dati sono separati in 3 regioni nel modo seguente:
- Un nucleo centrale, chiamato *Discard Set*, ogni punto all'interno del discard set è sicuro di appartenerci.
- *Sottocluster*, chiamati *Compression Set*, sono cluster formati da punti che statisticamente possono appartenere al discard set, ma sono abbastanza lontani dai centroidi dei discard set in modo da non sapere a quli associarli.
- *Retained Set*, rappresentano gli outlier del dataset, non possono essere assegnati ad un sottocluster e nemmeno al discard set.

I discard set e i compression set vengono rappresentati da statistiche, mentre i retained set rimangono in memoria perché non sono classificabili in nessuna delle altre due regione di dati.


#figure(image("img/lezione12/bfr_sets.svg", width: 70%), caption: [Rappresentazione dei cluster dell'algoritmo BFR.])

Questo algoritmo, insieme a k-medoids CLARA, può tornare utile quando il nostro dataset supera le dimensioni massime della nostra RAM.
Il problema di caricare a pezzi il dataset in RAM è poi stabilire quali dati caricare per primi.
Per ovviare a questo problema possiamo fare shuffling per la selezione iniziale dei dati.

=== Rappresentazione dei compression set e del discard set

Le due regioni di dati, compression set e discard set, vengono rappresentate tramite le seguenti statistiche:

- Cardinalità $N$, rappresenta il numero di punti.
- Un vettore _SUM_ delle somme $italic("SUM")_i$ delle coordinate in ciascuna dimensione $i$.
  - $x = (x_1, x_2, dots, x_k); y = (y_1, y_2, dots, y_k)$
  - $italic("SUM") = (x_1 + y_1, dots, x_k + y_k)$
- Il vettore _SUMSQ_ delle somme $italic("SUMSQ")_i$ dei quadrati delle coordinate di ciascuna dimensione $i$.
  - SUMSQ $= (x^2_1 + y^2_1, dots, x^2_k + y^2_k)$

Per ottenere media e deviazione standard delle regione di dati, ci basta combinare le statistiche che abbiamo appena descritto.
- Per la media $mu_i$ avremo $italic("SUM")_i / N$
- Per la varianza della dimensione $i = (italic("SUMSQ")_i / N) - (italic("SUM")_i / N)^2$

  - Di conseguenza la deviazione standard sarà, $sigma_i = sqrt((italic("SUMSQ")_i / N) - (italic("SUM")_i / N)^2)$

=== Funzionamento algoritmo BFR

Abbiamo detto che BFR ci permette di lavorare anche con dataset dimensionalmente più grandi della RAM che abbiamo a disposizione, partiamo da un insieme di punti caricato in RAM; l'algoritmo BFR seleziona i $k$ centroidi tramite un algoritmo per ottenere i $k$ centroidi iniziali.

Con il caricamento degli insiemi di punti successivi abbiamo:

- Determinare quali punti sono sufficientemente vicini ad un centroide da essere inseriti nel discard set e le loro statistiche combinati con quelle dle cluster.
- Aggiorna le statistiche del cluster di discard set.
- Prendere i punti il cui *Raggio di Mahalanobis* è al di sotto di una certa soglia, ad esepio 4 volte la deviazione standard del discard set.
- Con i dati caricati in RAM, provare a fare il cluster di punti non contenuti nel discard set incluso quelli di retained set di iterazioni precedenti. Se troviamo un cluster di punti la cui varianza è al di sotto di una soglia, allora assegniamo questi punti al compression set e sostituiamo i punti con le statistiche.
- Fondere un nuovo sottocluster con un vecchio compression set purché la varianza del sottocluster ottenuto sia al di sotto della soglia.
- Se siamo all'ultima iterazione assegniamo elementi di CS e RS al più vicino cluster di DS anche se abbastanza lontano.

#definition(name: "Raggio di Mahalanobis")[
  È la distanza dal centroide scalata mediante $sigma_i$. Se $mu_i$ è la media della i-esima dimensione, allora il raggio di Mahalanobis del punto $[y_1, y_2, dots, y_k]$ è $sqrt(sum_(i = 1)^k (frac(y_i - mu_i, sigma_i))^2)$
]

== Fuzzy k-means

Fino ad ora abbiamo visto algoritmi di cluster di tipo *hard*, ovvero diciamo se un punto appartiene a un determinato cluster oppure no.
Esistono anche algoritmi di clustering *fuzzy*, dove il tipo di clustering è *soft*, in questo ai punti viene assegnata una probabilità di appartenere a un determinato cluster.

#figure(image("img/lezione12/hard_soft_clustering.svg", width: 70%), caption: [Hard e soft clustering.])

La variante fuzzy di k-means consente a un punto di appartenere con un *cenrto grado di probabilità* a diverse classi.
Il criterio di ottimizzazione diventa:

#formula(name: "Criterio ottimizzazione fuzzy k-means")[
  $ J_"fuz" = sum_(i = 1, dots, s) sum_(j = 1, dots, n) [P(C_i | x_j, Theta)]^m dot ||x_j - theta_i||^2 $
]

$P(C_i | x_j, Theta)$, è la probabilità che il dato punto $x_j$ e l'insieme $Theta = {theta_1, dots, theta_2}$ di centroidi che definiscono la soluzione attuale, il cluster di appartenenza sia $C_i$

In fuzzy k-means, invece di calcolare i centroidi come la semplice media dei punti, si calcolano come *media pesata* riseptto alle probabilità di appartenenza:

#formula(name: "Centroidi in fuzzy k-means")[
  $ theta_i = frac(sum_(j = 1, dots, n) P(C_i | x_j, Theta) dot x_j, sum_(j = 1, dots, n) P(C_i | x_j, Theta)) $
]

Le probabilità di appartenenza si calcolano come:

#formula(name: "Probabilità di appartenenza")[
  $ P(C_i | x_j, Theta) = frac(1, sum_(k = 1, dots, s) (frac(||x_j - theta_i||, ||x_j - theta_k||))^frac(2, m - 1)) $
]

Il parametro $m$ definisce quanto l'appartenenza ai diversi cluster debba essere 'sfumata'. Di solito si usa un valore pari a 2.

=== Pseudocodice fuzzy k-means

Lo pseudocodice dell'algoritmo è molto simile a k-means.


+ inizializzare $n, s$
+ inizializzare casualmente $P(C_i | x_j, Theta), i = 1, dots, x; j = 1, dots, n$
+ while(riduzione $J_"fuz"$ AND iteration < max)
+ calcola i centroidi $Theta = {theta_1, dots, theta_s}$
+ calcola i gradi di appartenenza $P(C_i | x_j, Theta), i = 1, dots, x; j = 1, dots, n$

