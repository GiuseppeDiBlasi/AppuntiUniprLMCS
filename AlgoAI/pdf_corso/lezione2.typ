//--------- Import
#import "../../Template typst/template.typ": c-border, definition, exam, example, note, theorem, warning


//----------------------  Inizio documento
= Lezione 2 del 25 settembre 2026

== Classificazione

In questa lezione inzieremo a parlare di *classificazione*.
L'obiettivo della *classificazione* è quello di dividere oggetti, osservando le loro caratteristiche, nelle loro classi di appartenenza.

Un esempio di classificazione è dividere le palle da calcio da quelle di basket, riconosciamo delle
caratteristiche (*feature*) in ognuno degli oggetti che ci permette di dire se un determinato oggetto appartiene a una determinata classe oppure a un'altra.

#definition(name: "Feature (Caratteristica)")[
  Una *feature* è un aspetto *direttamente osservabile* relativo ad un fenomeno per il quale si può registrare uan precisa
  *misura quantitativa* (valore numerico intero o double) o *categoriale* (vero/falso, dolce/salato, festivo/feriale, rosso/verde/blu etcetera.)

  Le feature *categoriali* possono essere divise in:
  - *Ordinali*: possono essere confrontate direttamente
  - *Non-ordinali*: Non possono essere confrontate direttamente; per confrontarle si sfrutta *one-hot encoding*, dobbiamo quindi trovare un modo per rappresentarle e calcolare la loro distanza.
]

Il caso con 2 classi è quello più semplice, che prende il nome di *classificazione binaria*, nella realtà lavoreremo su problemi di classificazione con più di 2 classi.
Modelli che riconosco oggetti tra 2 classi sono detti *modelli semplici*.


Ovviamente non classificheremo gli oggetti manualmente, ma sfrutteremo dei modelli automatizzati per poter risolvere questo problema. Diventa quindi fondamentale la scelta di un determinato modello di classificazione e anche come misurare le sue prestazioni.
Prestazioni e problema da risolvere vanno di pari passo, se dovessimo scegliere un modello poco performante potremmo perdere efficienza nella classificazione.
Anche le metriche o feature, che vogliamo minimizzare o massimizzare influiscono sulla scelta del modello più opportuno.

Il nostro modello, che può essere chiamato anche *classificatore*, partendo dall'osservazione di varie feature giunge alla decisione di *etichettare* (in inglese: *to label*) il dato osservato in una categoria più astratta e generale.

La classe di appartenenza è qualcosa che di solito diamo per scontato, in realtà è molto soggettiva, siamo noi a decidere quali feature riteniamo importanti per poter separare gli oggetti in determinate classi.

#example(name: "Classificazione uomini e donne")[
  Ipotizziamo di voler risolvere il problema di classificazione dovendo distinguere esseri umani tra sesso maschile e femminile.

  Possiamo identificare varie feature che ci permettono di distinguere gli uni dagli altri:
  - Lineamenti del volto
  - Proporzioni corporee
  - Vestiti
  - Timbro di voce  e così via

  Dobbiamo tenere in considerazione che le _misurazioni_ che vengono effettuate sulle feature da noi scelte, sono misurazioni _indirette_.
  Le feature che misuriamo sono in realtà dovute al DNA di una persona, quindi quello che osserviamo è una causa nella struttura del DNA.
  Per esempio potremmo avere degli *outlier* statistici, che vedremo più avanti nel corso, dove possiamo avere uomini che assomigliano a donne o viceversa, ma la possibilità di decidere oggettivamente è contenuta all'interno DNA.

  Nella realtà è più una zona grigia la distinzione netta tra due classi, ovvero esistono delle sfumature tra le due.
]

Diamo ora una definizione di *classificazione*.

#definition(name: "Classificazione")[
  Sia data una collezione di dati, possiamo definirma come l'insieme $P$ di _M_-uple del tipo:

  $m_i = (x_(1i), ... , x_("Mi")) in D_1 times ... times D_M$

  - $x_("ji")$, indichiamo la feature.
  - $D_j$, indichiamo il dominio di valori per la feature.

  L'insieme $P$ può essere aprtizionato in k-classi le cui etichette compongono l'insieme $L = (A_1, ... , A_k)$
  Ciascun dato appartiene ad una ed una sola classe, quindi per ogni dato abbiamo una sola etichetta.
]

#definition(name: "Algoritmo di classificazione")[
  Un *algoritmo di classificazione* è una funzione computabile $f : P -> L$:

  $f(m in P) = f(x_1, ... , x_m) in L$

  Il nostro obiettivo è capire la forma di questa funzione e di conseguenza quali sono i parametri che la definiscono.
]

Un classificatore ha successo (in inglese -> hit) su un dato se $f(m)$ coincide con l'etichetta della classe di cui $m$ appartiene realmente.
In caso contrario abbiamo un fallimento, o miss.

Una domanda importante che dobbiamo farci è: _Che tasso di errore è considerado accettabile per noi?_
- 50%? Il modello ha imparato a predirre a _caso_ i dati che ha imparato.
- 100%? Rientriamo nel caso dell'overfitting che vogliamo sempre evitare.

In linea generale un tasso di errore tra l'1% e il 20% è ritenuto accettabile, tenendo in considerazione anche il contesto in cui stiamo lavorando.
Per applicazioni industriali un tasso di errore del 5% fino al 10% è ritenuto accettabile.
Per applicazioni mediche invece un tasso di errore superiore allo 0.5% è ritenuto *NON* accettabile.

Quindi il tasso di errore è fortemente influenzato dal contesto su cui vogliamo lavorare, e non è una semplice scelta _netta_.

Se dovessimo avere un modello per una classificazione binaria, con un tasso di errore del 100%, possiamo ritenerlo un buon modello per i nostri scopi?
Teoricamente è un modello con un tasso di accuratezza del 100%, ci basta "invertire" il risultato del classificatore.

== Classificazione Iris di Fisher

È un esempio di classificazione fatto dal matematico Fisher nel 1916, raccolse 150 iris, 50 erano di specie setosa, 50 di specie virginica e 50 di specie speciosa.

- 150 fiori iris -> è quello che oggi consideriamo il dataset
- Il dataset è bilanciato -> lo vedremo più avanti nel corso.

Fisher scelse 4 misure (feature) quantitative:
- Lunghezza del petalo
- Larghezza del petalo
- Lunghezza del sepalo
- Larghezza sepalo

Il problema che Fisher voleva studiare e verificare era:
- Son necessarie le 4 misure scelte?
- Le 4 misure scelte, erano *indipendenti* tra loro? Una determinata misura di una implica una determianta dimensione per un'altra?

#exam[
  Una possibile domanda aperta all'esame può essere:

  Perché  non possiamo considerare più attuale il dataset utilizzato da Fisher per la sua classificazione?
]

Esistono modelli descrittivi e predittivi, per esempio quelli predittivi sono usati per prevedere le orbite dei pianeti nello spazio. Gli alberi di decisione sono un tipo di modello descrittivo.

Possiamo avere anche modelli probabilistici che ci restituiscono una percentuale di probabilità sull'appartenenza dell'input a una determinata classe.

#warning[
  Teniamo a mente che la correlazione tra due eventi, non implica che uno sia la causa dell'altro.
  Questo è importante quando realizziamo dei classificatori, occorre studiare il problema che vogliamo affrontare in modo da evitare queste imprecisazioni.
]

== Algoritmi di apprendimento

Se abbiamo un classificatore, vogliamo che _impari_ a riconoscere le feature che abbiamo scelto per determinati oggetti, quindi come fa il classificatore ad imparare cosa deve fare?

Per esempio noi umani impariamo con gli errori, se commettiamo un errore riusciamo a capire che quello che abbiamo fatto è sbagliato e cercheremo di fare qualcosa di diverso la prossima volta. Per esempio un neonato che impara a camminare commeterà molti errori all'inizio finché non riuscirà a stare all'in piedi e a camminare in autonomia.
Stessa cosa i nostri modelli e classificatori, imparano attraverso gli errori.

Commettiamo errori finché non riusciamo a trovare la soluzione corretta al nostro problema.

Non tutti gli algoritmi hanno questa caratteristica, questi che la sfruttano si chiamano algoritmi di addestramento per rinforzo. Per esempio gli alberi di decisione non hanno questa caratteristica.

=== Contare gli errori

Un problema da risolvere è capire come contare gli errori del modello.
Possiamo usare una *matrice di confusione* che riporta in percentuale sulle righeq uanti elementi
della classe corrispondente a quella riga sono stati assegnati alle varie classi presenti nella popolazione.

#align(center)[

  #figure(
    image("img/confusion_matrix_example.svg"),
    caption: [Matrice di confusione],
  )
]

Nell'immagine qui sopra possiamo vedere un esempio di matrice di confusione.
Abbiamo un modello addestramento a riconoscere tra palle da calcio e palle da basket.
Sulle righe abbiamo la classe predetta dal classificatore, mentre sulle colonne la classificazione reale.

Per i palloni da calcio possiamo vedere che il modello ha predetto correttamente 1 volta il pallone da calcio (vero positivo); mentre per i palloni da basket abbiamo 2 falsi positivi: vuol dire che il classificatore ha classificato il pallone da basket come un pallone da calcio per 2 volte.

Per la predizione sui palloni da basket abbiamo 0 falsi positivi per i palloni da calcio, e 7 veri positivi per i palloni da basket; quindi il modello non ha commesso errori per quanto riguarda la predizione sui palloni da basket.

#v(1.5cm)

#warning[
  La matrice di confusione è un concetto fondamentale da apprendere poiché ci indica le prestazioni del
  modello ed è facile fare confusione quando la si legge per la prima volta.

  _Il gioco di parole non è voluto._
]

=== Costruzione di un classificatore

La classificazione è un operazione perfetta per un computer, possiamo elaborare enormi quantità di dati per estrarne informazioni, correlazioni e regolarità.

Vediamo uno schema generale per la costruzione di un modello di classificazione:

#align(center)[

  #figure(
    image("img/costruzione_classificatore.svg"),
    caption: [Schema costruzione di un classificatore],
  )
]

Dallo schema possiamo vedere che partendo da un dataset già etichettato, tramite un algoritmo di apprendimento, riusciamo a creare un classificatore.
Una volta ottenuto il nostro classificatore per verificare le sue prestazioni dobbiamo dargli in input dati non classificati che il classificatore non ha mai visto durante la fase di addestramento e verificare che dia la risposta corretta.

=== Fasi di un sistema di classificazione automatica

Le fasi per un sistema di classificazione automatica sono:

+ *Sensing* o *sampling*: Raccolta dei dati dal mondo fisico e traduzione in informazioni digitali; (fondamentale capire quali misure prendere in considreazione)
+ *Segmentazione*: Partizionamento dei dati in unità significative, miglioramento della qualità dei dati, eliminazione di rumore.
+ *Estrazione delle feature*: partendo dai dati segmentati. È un'ottima idea scegliere feature che siano *INVARIANTI alle trasformazioni*; per esempio cogliere informazioni da un ambiente controllato da cui le rileviamo (temperatura, luce).
+ *Classificazione*: Esecuzione dell'algoritmo di assegnazione delle label o classi.
+ *Post-processing*: Valutazione della qualità della classificazione, costi ed errore di classificazione.
+ Decidere se utilizzare il classificatore in un problema reale.

Durante la progettazione di questi classificatori, tipicamente sono più iterazioni di design, ci sono degli aspetti fondamentali da tenere in ordine:

+ *Raccolta dati*: Scegliere i dati su cui lavorare per addestrare il classificatore e conoscenza dei dati su cui dovrà generalizzare.
+ *Selezione delle feature*: Che devono essere prese in considerazione dal nostro classificatore. Abbiamo scelto troppe feature? Troppe poche? Sono rilevanti?
+ *Scelta del modello matematico*: Riuscire a modellare il problema con il linguaggio matematico ci aiuta nella realizzazione del classificatore. Ci permette di formulare ipotesi su come interagiscono le feature tra loro e come si distribuiscono statisticamente.
+ *Training del classificatore*: Addestramento del classificatore sui dati che abbiamo raccolto.
+ *Valutazione*: Possiamo migliorare ancora il modello o abbiamo raggiunto un risultato soddisfacente?

#note[
  _Piccola digressione fatta dal prof a lezione_.

  == Perché l'informatica è una scienza?

  La domanda del prof a lezione era: _Perché l'informatica è una scienza a differenza della matematica? Che cosa studia l'informatica?_

  L'informatica studia si occupa di studiare l'elaborazione, o il calcolo, delle informazioni e delle sue applicaizoni pratiche.

  _Perché Alan Turing crea la Macchina di Turing?_

  Lo fa per cercare di replicare il ragionamento del cervello umano, un modello molto semplice rispetto alla complessità del nostro cervello, ma l'intento rimane quello.

  _Ma l'essere umano è l'unico essere vivente dotato di intelligenza?_

  Alcuni batteri sono in grado di calcolare; esistono anche altri tipi di intelligenza, come l'intelligenza a sciame

]

