#import "../../Template typst/template.typ": c-border, definition, exam, example, note, separator, theorem, warning
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

= Lezione 11 del 30 ottobre 2026

In questa lezione iniziamo a parlare di algoritmi di clustering.
Il clustering è una tecnica di machine learning non supervisionata.

== Clustering, introduzione

Nei modelli di regressione e classificazione, abbiamo un modo oggettivo per poter *validare* le prestazioni dei modelli, per esempio se un punto appartiene alla classe corretta etc...
Nel caso del clustering si parla di *valutazione* e non più di *validazione*, questo perché gli algoritmi di clustering non hanno dei metodi oggettivi per poter valutare le prestazioni, ma seguono dei criteri soggettivi.

Con il termine clustering si identificano una serie di metodi *non supervisionati* in grado di individuare raggrupamenti intrinseci, detti cluster, di punti nello spazio multidimensioanle e di definire in corrispondenza di tali raggrupamenti le classi di appartenenza.

#figure(image("img/lezione11/scatter_clusters.svg", width: 70%), caption: [Esempio di clustering.])

Un cluster è una raccolta di punti dove:
- I punti sono simili tra loro all'interno dello stesso cluster.
- I punti sono diversi da punti appartenenti ad altri cluster.

L'obiettivo del clustering è trovare somiglianze tra questi punti e raggrupparli in gruppi, o cluster.

Il clustering viene applicato per:
- Ottenere informazioni sulla distribuzione dei dati.
- Fase di pre-elaborazione per altri algoritmi.

Nella fase di pre-elaborazione, se ho dei dati che formano un cluster C1, e degli outlier che stanno fuori, conviene creare un modello di classificazione per il cluster C1, e poi creare un altro modello per gli outlier del cluster C1. Questo argomento era saltato fuori anche in una delle prime lezioni di laboratorio di algoritmi.

=== Qualità del metodo di clustering

Un metodo di clustering produce cluster di alta qualità se:
- C'è un' elevata somiglianza tra i punti della stessa classe, o cluster.
- C'è una bassa somiglianza tra punti di classi, o cluster, diversi.

La qualità di un metodo di clustering si misura anche dalla sua capacità di trovare pattern o regolarità nascoste all'interno dei dati.

Altre metriche di valutazione possono essere:
- Scalabilità.
- Gestire diversi tipi di attributi, categoriali o numerici.
- Poter gestire dati dinamici.
- Requisiti minimi per la conoscenza del dominio per determinare i parametri di input.
- Alta dimensionalità.
- Poter gestire rumore e/o valori anomali.
- Insensibile all'ordine dei record di input.
- Interpretabilità ed usabilità.

Per riassumere, i cluster devono formare delle nuvole dense di punti, dove queste nuvole sono separate da zone in cui i punti sono scarsi.

#exam(
  answer: [I cluster devono formare delle nuvole dense di punti, dove queste nuvole sono separate da zone in cui i punti sono scarsi.],
  [
    Una possibile domanda nella parte delle crocette può essere:

    Qual è la definizione di ipotesi di cluster?
  ],
)

=== Clustering, complessità

Il problema del clustering è un problema molto complesso, è  NP-Hard.
Determinare una soluzione ottima con una ricerca esaustiva è possibile solo se stiamo lavorando con pochi dati.

Dati $n$ oggetti, assumendo di conoscere il numero di classi $s$, il numero di soluzioni distinte è definito da: $s^n / s!$, ipotizzando di avere $n = 100$ e $s = 5$, lo spazio di ricerca delle soluzioni sarà di circa $10^67$ soluzioni possibili.

Ovviamente ci conviene sfruttare delle euristiche che ci permettono di trovare delle soluzioni quasi ottimali.

#pagebreak()

== Algoritmi di clustering

Le principali categorie di clustering sono:

- *Clustering basato su partizionamento*: utilizza metodi euristici per individuare i cluster, minimizzando la distanza dei punti dai centroidi dei cluster. Alcuni algoritmi di questo tipo sono:
  - K-means.
  - Fuzzy k-means.
  - Expectation-Maximization.

- *Clustering gerarchico*: attraverso operazioni bottom-up, aggregano punti in base a una misura di distanza, si organizzano i dati in una struttura ad albero.

- *Clustering basato sulla densità*: i cluster individuati sono regioni connesse in aree ad alta densità. Un approccio noto è DBSCAN.

I cluster basati su partizionamento cercano cluster di forma ipersferica.

Abbiamo anche due tipoligie di clustering:
- *Clustering hard*: ogni punto dello spazio è assegnato *esclusivamente* ad un solo cluster.
- *Clustering soft, o fuzzy*: i punti appartengono a diveri cluster con un certo grado di appartenenza, per esempio con valori tra 0 e 1.

=== Criteri di clustering

I criteri e algoritmi di clustering sono due cose ben distinte:
- *criteri*: descrivere cosa si vuole ottenere specificando il grado di ottimalità di ogni soluzione ammissibile.
- *algoritmi*: dato un criterio di clustering, forniscono una procedura algoritmica per determinare soluzioni che lo ottimizzino.

Un problema con i metodi di clustering è stabilire come determinare se un insieme di punti formano un cluster.
Questo risulta difficile poiché i cretire secondo cui dei punti formano un cluster è totalmente soggettivo.

Ci sono diversi criteri che vengono usati spesso per stabilire la presenza di un cluster.
- I punti all'interno dello stesso cluster devono essere tra loro più simili rispetto a punti che appartengono a cluster diversi.
- I cluster sono costituiti da nuvole di punti ad elevata densità separate da zone con una bassa densità di punti.

=== Partizionamento

Hanno come obiettivo quello di costruire una partizione di un dataset D di $n$ oggetti in un insieme di $k$ cluster.
Per il partizionamento abbiamo metodi *ottimali* ed *euristici*.

- *Ottimali*: enumerano esaustivamente tutte le possibili partizioni.
- *Euristici*:
  - k-means: ogni cluster è rappresentato dal suo baricentro.
  - k-medoids: ogni cluster è rappresentato da un punto più centrale degli oggetti del cluster.

==== Minimizzazione delle distanze tra centroidi, (inter-classe)

Uno dei criteri più utilizzati è quello di minimizzare la distanza dai centroidi, che minimizza la somma dei quadrati delle distanze dai punti $x$ dai centroidi $hat(x)$.

$ J_e = sum_(i = 1,dots,k) sum_(x in C_i) ||x - hat(x)_i||^2 quad "con" hat(x)_i = 1/n sum_(x in C_i) x $

#figure(
  image("img/lezione11/kmeans_clusters.svg", width: 70%),
  caption: [Metodo di clustering minimizzando i centroidi.],
)

Questo è un buon criterio per cluster a simmetria radiale, ovvero di forma circolare, ma forme allungate dei cluster o cluster innestate sono penalizzate.

#figure(
  image("img/lezione11/forme_cluster.svg", width: 70%),
  caption: [Varie forme che possono assumere i cluster, le ultime due in basso a destra sono quelle penalizzate dalla minimizzazione delle distanze dai centroidi.],
)

==== Metodo intra-classe

Un altro criterio è quello di minimizzare le distanze intra-classe:

$ J_e = sum_(i = 1,dots,k) n_i dot hat(s)_i quad "con" hat(s)_i = 1/n_i sum_(x in C_i) f_s(x, C_i) $

#figure(
  image("img/lezione11/overlapping_circles.svg", width: 70%),
  caption: [Usando un criterio inter-classe si favorirebbe la formazione dei cluster tratteggiati, mentre con un metodo intra-classe si favorirebbe quello dei colori rossi e blu.],
)

=== K-means

K-means è un metodo computazionalmente molto semplice ed è anche semplice da implementare per questo è spesso la prima scelta per risolvere problemi di clustering.

L'obiettivo di k-means è quello di minimizzare le distanze dai centroidi.

Lo pseudocodice per k-means è:

```
inizializzare n, k

scegliere casualmente k punti da utilizzare come centroidi iniziali 

do 

  assegna ogni punto  al cluster per cui è minima la distanza dal centroide
  calcolare i centroidi dei cluster come media dei rispettivi punti 

while(i cluster sono stati modificati AND iterazioni < MAX_ITER)

```

I cluster vengono modificati in seguito al ricalcolo del loro centroide. L'algoritmo termina quando i centroidi dei cluster sono stabili o se si supera il numero massimo di iterazioni.

#figure(image("img/lezione11/kmeans_iterations.svg", width: 70%), caption: [Iterazioni algoritmo k-means.])

Un problema fondamentale è capire come distribuire i punti inizali e soprattutto fare in modo che i punti iniziali siano equidistribuiti.

==== Vantaggi e svantaggi di k-means

I vantaggi dell'algoritmo k-means sono:

È efficiente, con una complessità computazionale di $O(t dot k dot n)$, $t$ è il numero di iterazioni, $k$ il numero di cluster e $n$ è il numero di punti da assegnare ai cluster.
È semplice e intuitivo.

Gli svantaggi invece:

- Spesso termina in ottimi locali.
- Non è robusto al rumore e outliers.
- Non è in grado di trovare cluster di forma non convessa.
- Non direttamente applicabile a dati categoriali.


==== Soluzione iniziale per k-means

Per minimizzare il rischio di convergenza a minimi locali l'algoritmo può essere eseguito più volte partendo da diverse soluzioni iniziali:

- Randomiche.
- Euristiche.
- Metodi evoluzionistici.

Un problema di k-means è capire anche quanti cluster devono essere creati per la nostra soluzione. Più sarà alto il numero di cluster $k$ e più le distanze dai centroidi saranno minori.

Una possibile soluzione per evitare la formazione di molti cluster è quella di utilizzare una penalità per ogni nuovo cluster:

$ J_e^* = J_e + "penalty" dot k $

Il problema adesso diventa trovare un valore ottimale per penalty.

Esiste un metodo più efficcace per determinare il valore ottimo dei cluster ed è quello di cercare punti di *inflessione* nel valore di $J_e$ variando i valori per il parametro $k$.

#figure(
  image("img/lezione11/elbow_method.svg", width: 70%),
  caption: [Andamento di $J_e$ al variare del parametro $k$. In questo caso $k = 4$ è il punto di inflessione.],
)
