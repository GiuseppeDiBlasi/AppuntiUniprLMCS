= Lezione 1 del 21 settembre 2026

== Introduzione del corso 

L'obiettivo del corso è fornire basi teoriche per modellare e risolvere problemi di intelligenza artificiale tramite tecniche di apprendimento automatico e della ricerca di soluzioni da un punto di vista algoritmico.

Un approccio critico sull'utilizzo e comprensione degli algoritmi di intelligenza artificiale è tra gli obiettivi principali del corso, sopratutto identificare la corretta metodologia e valutarne l'impatto sul caso di applicazione specifico.

Detto dal prof, nel campo dell'informatica molti algoritmi e strutture dati prendono spunto dalla natura, per esempio le reti neurali cercano di rappresentare il più possibile la struttura di un cervello umano.

== Apprendimento automatico 

Per apprendimento automatico, o machine learning, si intende la capacità di una macchina di poter imparare qualcosa da un insieme di dati di partenza ( di solito un dataset ) per poter riconoscere dati simili che non ha mai visto durante la fase di training. 

Ci sono 3 tipi di apprendimento automatico:
- Supervisionato
- Semi-supervisionato
- Non supervisionato 
- Apprendimento per rinforzo (non verrà trattato a lezione)

La differenza principale tra queste 3 metodologie è la disponibilità dei dati di verità di base, o *ground truth*, ovvero prove empiriche che sono conoscenze preliminari di ciò che l'output del modello dovrebbe generare in base a un determinato input.

L'apprendimento automatico viene usato nei seguenti contesti:
  - Classificazione: Quando vogliamo mappare l'input alle etichette di output 
  - Regressione: Quando vogliamo mappare l'input a un output continuo

#figure(
  image("./img/classificazione_regressione.svg", width: 90%),
  caption: [Classificazione vs Regressione: nella classificazione l'output è una classe discreta, nella regressione un valore continuo.]
)

Nel caso della classificazione abbiamo classi linearmente separabili. 
Il problema più importante che accomuna i due contesti è capire come disegnare al meglio la retta, o la curva, per poter approssimare al meglio i dati che ci interessano. 

Nella classificazione vogliamo separare le classi di dati, nella regressione vogliamo una retta che si avvicini al più possibile a tutti i dati che ci interessano.
Dobbiamo prestare attenzione all'overfitting, ovvero evitare modelli troppo precisi perché ciò comporterebbe la perdità della capacità di poter riconoscere outlier, ovvero dati che appaiono di rado.
Si dice che in questo caso la rete non *generalizzi*, ma impari a riprodurre i dati di training senza apprendere la tendenza o la struttura effettiva nei dati che porta all'output.

#figure(
  image("./img/overfitting.svg", width: 95%),
  caption: [Overfitting in regressione (sinistra) e in classificazione (destra): il modello si adatta al rumore invece che al pattern sottostante.]
)

Per poter approssimare i punti possiamo scegliere una qualunque curva aggiungendo quanta complessità vogliamo.
Nel caso del grafico a sinistra, vediamo la parabola e la curva più complessa in colore verde. 
In questo caso ci conviene scegliere la parabola anche se commette errori per la classificazione, questo ci permette di evitare overfitting.

Per la generalizzazione del modello si parla anche di *compromesso bias-varianza*, ovvero cercare un equilibrio tra la distorsione (bias) e la varianza: 

- Distorsione (bias): termine di errore costante
- Varianza: Quantità in base alla quale l'errore può variare tra diversi set di dati

Il problema è quello di creare un modello che riesca a catturare la regolarità dei dati di addestramento, ma che allo stesso tempo riesca a genarlizzare sui dati non usati nella fase di training.

Questo verrà visto più avanti.

== Apprendimento Semi-supervisionato

Con l'apprendiemnto Semi-supervisionato si parla di metodi per poter lavorare su grandi quantità di dati dato che cercare di classificare ogni singola informazione sarebbe troppo dispendioso.
Alcune tecniche che si utilizzano sono macchine vettoriali di supporto trasversali e metodi basati su grafi come la propagazione delle etichette.
Per esempio se vogliamo filtrare determinati commenti su un social network, non possiamo etichettare tutti i commenti presenti sul sito, ma possiamo lavorare su un sottoinsieme etichettato.

I metodi semi-supervisionati devono fare alcune ipotesi sui dati al fine di giustificare l'utilizzo di una piccola serie di dati etichettati per trarre conclusioni sui punti non etichettati: 

- Continuità: si presume che i punti vicini tra loro abbiano maggiori probabilità di avere un'etichetta in comune

- Ipotesi del cluster: si presume che i dati formino naturalmente cluster discreti e che i punti dello stesso cluster abbiano maggiori probabilità di condividere un'etichetta 

- Presupposto molteplice: si presume che i dati si trovino approssimativamente in uno spazio di dimensioni inferiori (collettore) rispetto allo spazio di input. È  uno scenario rilevante quando un sistema non osservabile o difficile da osservare con un numero ridotto di parametri produce output osservabili ad alta dimensione.

== Apprendimento non supervisionato

L'apprendimento non supervisionato è utile per trovare modelli intrinseci nei dati che vogliamo studiare.
Per esempio l'attività più comune per l'apprendimento non supervisionato è il clustering (raggruppamento), l'apprendimento della rappresentazione e la stima della densità.

Questo ci permette di conoscere la struttura intrinseca dei nostri dati senza utilizzare etichette. 
Alcuni algoritmi includono il clustering, l'analisi dei componenti principali e gli autocodificatori (autoencoders).

Abbiamo due tecniche per affrontare problemi di apprendimento non supervisionato:

- clustering
- riduzione della dimensionalità dei dati 

=== Clustering 

Il clustering è una tecnica esplorativa che consente di aggregare all'interno di gruppi, detti cluster, dei dati su cui non abbiamo una conoscenza preliminare di appartenenza a gruppi.

#figure(
  image("./img/cluster.svg", width: 95%),
  caption: [Rappresentazione dei cluster nel piano delle feature $X_1$ e $X_2$]
)

Il clustering ci torna molto utile quando vogliamo trovare relazioni tra i dati di cui non abbiamo conoscenze pregresse.

=== Riduzione della dimensionalità 

La riduzione della dimensionalità senza supervisione è un approccio molto utilizzato nella pre-elaborazione delle features (caratteristiche), con l'obiettivo di eliminare il rumore dai dati.

Questo può ridurre le prestazioni ma permette di rendere lo spazio dimensionale più compatto mantenendo le informazioni più rilevanti.

Questa tecnica è usata anche per dati ad elevata dimensionalità che possono essere proiettati su uno spazio 1D, 2D o 3D

=== Analisi esplorativa 

L'apprendimento senza supervisione è utile per analisi esplorative perché permette di identificare automaticamente strutture all'interno dei dati. 

In situazioni in cui è impossibile o impraticabile per un essere umano proporre tendeze nei dati, dovuta all'enorme mole su cui si lavora, l'apprendimento non supervisionato può fornire informazioni iniziali che possono essere utilizzate per testare o verificare singole ipotesi. 
