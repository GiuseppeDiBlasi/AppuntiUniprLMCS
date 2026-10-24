#import "../../Template typst/template.typ": c-border, definition, exam, example, note, theorem, warning
#import "@preview/fletcher:0.5.8": diagram, edge, node

#note[
  Piccola nota da parte dell'autore, seguendo il corso fino in data 06/10/2026, non so se abbia molto senso
  riassumere qui i concetti presentati sulle slide su python e sui notebook jupyter.
  Quindi questo pdf diventerà più una linea guida su come realizzare il progetto in base alle indicazioni date dal prof durante la lezione. Magari più avanti quando ci saranno collegamenti con argomenti di teoria potrei aggiungere altre lezioni. Ma l'idea principale adesso è quella di racchiudere le indicazioni del prof su come realizzare il progetto.

  Quindi il capitolo principale saranno le linee guida estratte dai consigli del prof detti durante la lezione e l'aggiunta di lezioni interessanti su questo documento.

]

= Linee guida per lo sviluppo

Come già detto nella nota principale, questo documento si concentrerà per lo più su come realizzare il progetto per il corso di Laboratorio di Algoritmi per Intelligenza Artificiale.

Questo documento cerca di raccogliere tutte le richieste, e i dettagli che il prof vorrebbe nel progetto finale. Per esempio come interpretare il dataset, come pulirlo, trovare correlazioni tra i dati, sfruttare i grafici, rapportare i dati sulla stessa scala et cetera..

== Metriche di valutazione del prof

Prima di inziare con le linee guida per il progetto, pensiamo all'elefante nella stanza, _su cosa si basano le metriche di valutazione del prof?_

Al momento, sono principalmete due punti:

- Visualizzazione dei risultati ottenuti.
- Qualità del benchmark per il modello.

Per i benchmark è fondamentale che sia controllato.

== Ambiente Python

Il prof a lezione ha consigliato di utilizzare un container docker per sviluppare il progetto per evitare problemi di compatiblità, sinceramente non so se possa funzionare anche l'ambiete virtuale di python.

== Linee guida per il dataset

Il dataset è l'aspetto principale del nostro modello, se abbiamo un dataset di scarsa qualità, il nostro modello imparerà a lavorare su dati di scarsa qualità producendo prestazioni non eccellenti.
Attenzione anche a dataset sbilanciati, richiedono un approccio per l'addestramento diverso rispetto a dataset bilanciati, se possibile conviene sempre avere un dataset bilanciato, altrimenti si possono vedere altre tecniche di addestrametno per dataset sbilanciati; _nella lezione di teoria numero 5 c'è cross-validation stratifying k-fold come tecnica per dataset sbilanciati._

Le righe del dataset rappresentano per noi i *sample* o *campioni*, mentre le colonne rappresentano le *feature*.

== Pulire il dataset

La prima cosa che possiamo fare e pulire il dataset da righe, o record, inutili.

_In questo caso righe o record si riferiscono alle righe dell'oggetto DataFrame su cui lavoriamo in python._

Come facciamo a dire se una riga è inutile? Per esempio se abbiamo righe con valori completamente nulli possiamo toglierli dal nostro dataset.

#pagebreak()

#warning[
  - *EVITARE* di modificare il dataset che abbiamo deciso di utilizzare, ma è meglio effettuare le operazioni di  modifica su una copia. Se il dataset risulta troppo grande per tenere 2 copie dello stesso in esecuzione sullo stesso script o notebook jupyter, conviene fare uno script che lo modifichi *CREANDO* una nuova copia lasciando il dataset di partenza intatto.

  - *EVITARE* anche di modificare il dataset manualmente, meglio utilizzare funzioni già offerte da pandas.
]

Questa operazione di pulizia del dataset prende il nome di *data cleaning*.

=== Scelta delle feature

Una volta pulito il dataset possiamo scegliere quali feature scartare. Su dataset reali potremmo ritrovarci ad avere migliaia di feature quindi diventa importante capire quali caratteristiche possono aiutare il classificatore, scartando magari feature che tra loro non sono *correlate*. Questo concetto verrà visto più nel dettaglio nel sottocapitolo "_Sfruttare i grafici_".

== Capire il dataset

Dopo la pulizia, il passo successivo è *comprendere* i dati con cui stiamo lavorando: come sono *distribuiti*, se contengono *outlier* e come possiamo sfruttare queste informazioni a nostro vantaggio.

_Mettere esempi dei dataset mostrati dal prof a lezione e anche dei grafici._

== Workflow generale

Diamo un'occhiata al workflow generale per addestrare un modello.

#align(center)[
  #figure(
    scale(70%, reflow: true, diagram(
      node-stroke: 1pt,
      spacing: (14mm, 10mm),

      // Dataset
      node((1, -1), [Dataset], stroke: none),
      node((0, 0), [Training Set], width: 60mm),
      node((2, 0), [Validaiton Set], width: 30mm),

      // Pipeline sul training set
      node((0, 1), [Data imputation], stroke: none),
      node((0, 2), [Standardizzazione], stroke: none),
      node((0, 3), [Feature selection], stroke: none),
      node((0, 4), [Feature projection], stroke: none),
      edge((0, 0), (0, 1), "->"),
      edge((0, 1), (0, 2), "->"),
      edge((0, 2), (0, 3), "->"),
      edge((0, 3), (0, 4), "->"),
      edge((1, -1), (0, 0), "->"),
      edge((1, -1), (2, 0), "->"),

      // Training e modello
      node((1, 5), [Training], stroke: none),
      node((2, 5), [Model], stroke: none),
      edge((0, 4), (0, 5), (1, 5), "->"),
      edge((1, 5), (2, 5), "->"),

      // Validation set direttamente al modello
      edge((2, 0), (2, 5), "->", bend: 15deg),
    )),
    caption: [Workflow addestramento modello],
  )
]

Possiamo vedere che il nostro dataset viene diviso in *Training set* e *Validaiton set*.
Tutte le fasi di pre processamento dei dati vanno fatte sul *Training set*.

#warning[
  Nel caso in cui lavorassimo con un dataset *sbilanciato*, il metodo k-folding stratified va applicato *ALL'INIZIO DEL WORKFLOW*, si parte dal dataset di partenza, si applica k-folding stratified e di conseguenza si suddivide in training set e validation set e infine si applicano tutti le fasi di pre processamento dei dati e infine inizia la fase di training.
]

=== Sfruttare i grafici



