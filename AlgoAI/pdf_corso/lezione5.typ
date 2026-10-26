#import "../../Template typst/template.typ": c-border, definition, exam, example, note, theorem, warning

= Lezione 5 del 5 ottobre 2026

Riprendiamo il discorso su come confrontare due distribuzioni di probabilità.
Abbiamo visto che abbiamo diversi modi per misuarne la differenza come:
- Similarità tra gli insiemi
- Vicinanza o prossimità per spazi vettoriali
- Correlazione tra variabili
- Divirgenza tra distribuzioni di probabilità

Qui andiamo avanti con le divergenze tra distribuzioni di probabilità.

Partiamo definendo la *divergenza di Kullback-Leibler* che ci permette di misurare più informazioni per due distribuzioni.

#definition(name: "Divergenza Kullback-Leibler")[
  Prese due distribuzioni di probabilità, $P$ e $Q$, *definite sullo stesso dominio $D$*, la divergenza di Kullback-Leibler di $P$ da $Q$ ci informa sul guadagno di informazione nell'utilizzare $P$ piuttosto che $Q$.

  #align(center)[
    $"KL"(P||Q) = sum_(x in D) P(x) log(frac(P(X), Q(X)))$

  ]
  #v(1cm)
  - $(P||Q)$, si legge da $P$ a $Q$.
  - Non è simmetrica: $"KL"(P||Q) != "KL"(Q||P)$.
  - $"KL" >= 0$, questo vale sempre.
] <kullback-leibler>

Possiamo avere una nozione di divergenza simmetrica con *Jensen-Shannon*.

#definition(name: "Divergenza di Jensen-Shannon")[
  È una nozione di divergenza *simmetrica* basata sulla distribuzione media $A = frac(P + Q, 2)$ e non sulla media delle divergenze.

  #align(center)[
    $"JSD"(P, Q) = frac("KL"(P||A) + "KL"(Q||A), 2)$
  ]

  Ha un valore massimo di 1 se la base del logaritmo è 2.
]

Queste divergenze che abbiamo appena visto fanno parte di una famiglia di misure chiamate *f-divergenze*, il cuo scopo è quello di rappresentare la divergenza come media dell'odds ratio (rapporti di probabilità) ponderata da una funzione $f$.

#pagebreak()

#definition(name: "Divergenza di Hellinger")[
  È una importante _f_-divergenza definita come:

  #align(center)[
    $"HE"(P, Q) = frac(1, sqrt(2)) sqrt(sum_(x in D) (sqrt(P(x)) - sqrt(Q(x)) )^2)$
  ]

  Può essere riscritta anche come:

  #align(center)[
    $"HE"^2 (P, Q) = 1 - sum_(x in D) sqrt(P(x) Q(x))$
  ]

  I valori di essa sono compresi tra $[0 dots 1]$
]

#note[

  _A questo punto il prof si è lasciato andare su una digressione  filosofica su cosa sia l'entropia.
  Non so se metterla in questa appunti oppure lasciare solo questa nota che rompe la quarta parete._

  Una cosa fondamentale della digressione del prof, è che se misuro l'entropia su 3 sistemi *diversi* non posso confrontare le entropie tra di loro.

  _Alla fine, da come si può vedere, ho messo un sunto del discorso. Torniamo ai nostri appunti..._
]

Dopo la digressione sull'entropia, servita per introdurre la cross-entropy che vedremo definita tra poco. Abbiamo iniziato a parlare di distribuzioni di probabilità congiunte, entropia congiunta e cross-entropy.

Iniziamo definendo cos'è una distribuzione di probabilità congiunta.

#definition(name: "Distribuzione di probabilità congiunta")[
  Siano $X$ e $Y$, due variabili aleatorie, e sia $p(x, y)$ la loro *probabilità congiunta* dei due eventi $x in hat(X)$ e $y in hat(Y)$.

  La distribuzione di probabilità congiuntia di $X$ e $Y$ è data da:

  #align(center)[
    $p_(X, Y) = (p(x, y) | x in hat(X), y in hat(Y))$
  ]

  è definita sul prodotto cartesiano $hat(X) times hat(Y)$.
]

Possiamo definire l'entropia congiunta per una sorgente informativa.

#definition(name: "Entropia congiunta")[
  Data la sorgente informativa $(X times Y, p_(X, Y))$ definiamo *entropia congiunta* come l'entropia di tale sorgente informativa:

  #align(center)[
    $H((X times Y, p_(X,Y))) = - sum-(x in hat(X), y in hat(Y)) p(x, y)log_2(p(x, y))$
  ]
]

#definition(name: "Informazione mutua")[
  L'informazione mutua $I(X, Y)$ è data dalla divergenza entropica delle distribuzioni $p_x$ e $p_y$.
]

Arriviamo in fine alla definizione di cross-entropy.

#definition(name: "Cross-entropia")[
  Data una variabile aleatoria $X$ e due distribuzioni di probabilità discrete, $P$ e $Q$, definite su di essa, la cross-entropy è definita come:

  #align(center)[
    $H(P||Q) = - E_p[log_2(Q)] = - sum_(x in hat(X)) P(x) log_2(Q(x)) = H(P) + "KL"(P||Q)$
  ]

  misura il numero medio di bit necessari per identificare un evento estratto da $hat(X)$ nel caso sia utilizzato uno schema ottimizzato per uan distribuzione di probabilità $Q$ piuttosto che per la distribuzione $P$.
]

== Classificazione: tecniche di validazione

Ora iniziamo a dare un'occhiata alle verie tecniche di validazione per i nostri modelli di intelligenza artificiale.

Noi possiamo costruire due modelli per "classificare" i dati secondo due tecniche principali:
- *Regressione*: si costruisce un modello per predirre un determianto valore in output partendo da input numerici, si cerca di predirre se l'output stia sotto o sopra a una certa curva.
- *Classificazione*: Prendiamo un oggetto in input e cerchiamo di capire a quale classe appartiene tra le classi che ci interessano.

#align(center)[
  #figure(
    image("img/schema_regressione_classificazione.svg", width: 100%),
    caption: [Schema regressione e classificazione.],
  )
]

A seconda del modello che abbiamo realizzato, uno che lavora tramite regressione o uno che lavora tramite classificazione, avremo diversi metodi per valutarne le prestazioni.

La tecnica di base per valutare le prestazioni di un modello di classificazione è quello di prendere il nostro dataset e dividerlo in due dataset diversi, uno di *training*, utilizzato per la fase di addestramento, e uno di *test* per testare le prestazioni del modello una volta terminata la fase di addestramento. La divisione avviene secondo una certa *percentuale*. Di solito si fa un 70% training e 30% test, o anche 80% training e 20% test.
Però le domande più importanti da chiedersi è come suddividere questo dataset? Che dati metto nel training set e test set? Ho la stessa distribuzione delle classi da classificare in entrambi i dataset?

Altre domande che dobbiamo porci sono: Il classificatore valuta in maniera bilanciata tutte le label? Ha delle preferenze per una certa classe? Se le ha da cosa dipendono?

Per valutare i nostri modelli utilizzeremo, _ovviamente_, degli indici matematici, per esempio:
- *Accuratezza*: la proporzione di predizioni corrette rispetto al totale delle osservazioni analizzate.
- *Robustezza*: capacità del modello di manipolare dati con rumore o informazioni mancanti.
- *Velocità*:
  - Tempo necessario per costruire il modello, durata del training, è la fase più dispendiosa.
  - Tempo necessario per usare il modello.
- *Scalabilità*: efficienza su dati presenti in memoria secondaria.
- *Interpretabilità* dei risultati.

Prendiamo in esempio questo grafico che ci mostra le prestazioni di un classificatore per due classi $A$ e $B$.

#align(center)[
  #figure(image("img/precision_recall.svg", width: 60%), caption: [Precision e recall tra due classi.])
]

A sinistra abbiamo gli elementi della classe $A$ e a destra quelli della classe $B$, ipotizziamo di assegnare alla classe $A$ il valore di verità *_true_*.
A sinsitra abbiamo gli elementi rilevanti, ovvero gli elementi che abbiamo deciso che saranno i *true positive (TP)* nel caso in cui il classificatore li classifichi correttamente, abbiamo poi i *false negative (FN)*, dove il classificatore ha classificato erroneamente elementi di $A$ come elementi di $B$.

Nella parte destra del diagramma abbiamo i *false positive (FP)*, elementi di $B$ che il classificatore ha riconosciuto come tali. Abbiamo poi i *true negative (TN)*, elementi di $B$ dove il classificatore li ha erroneamente classificati come elementi di $A$.

Definiamo formalmente *precision* e *recall*:

#definition(name: "Precision e recall")[
  Definiamo come *precision* la frazione di elementi rilevanti tra tutti gli elementi classificati come classe $A$:

  #align(center)[
    _Precision_ $= frac("TP", "TP" + "FP")$
  ]

  Definiamo, invece, come *recall* la frazione di elementi classificati come classe $A$ tra tutti gli elementi rilevanti.

  #align(center)[
    _Recall_ $= frac("TP", + "TP" + "FN")$
  ]

  #align(center)[
    #figure(image("img/precision_recall_formulas.svg", width: 100%), caption: [Precision e recall.])
  ]

  Entrambi hanno valori tra 0 e 1.
]

Più alti saranno i valori di *precision* e *recall* e più sarà accurato il nostro classificatore. In certi contesti ci conviene utilizzare un solo indicatore, evitando di doverne utilizzare due.
Per questo si usa l'*$F_1$-score*.

#definition(name: [$F_1$-score])[
  L' *F_1*-score è una misura che combina precision e recall facendone una media armonica, è definita come:

  #align(center)[
    $F_1 = 2 frac("Precision" dot "Recall", "Precision" + "Recall") = frac(2 "TP", 2"TP" + "FP" + "FN")$

  ]

  Come *precision* e *recall*, l'$F_1$-score ha valori tra 0 e 1.
  Più è alto il valore e più la bontà del modello è alta, occhio però a valori troppo vicini ad 1, potrebbero indicare un potenziale *overfitting*.
]

Parliamo ora nello specifico dell'*accuracy* del modello. _Accuratezza e accuracy vengono usati in modo intercambiabile._

#definition(name: "Accuracy (Accuratezza)")[
  L'*accuratezza*, in inglese *accuracy*, misura la quantità di oggetti correttamente classificati rispetto al totale degli oggetti da classificare, ovvero:

  #align(center)[
    _Accuracy_ $= frac("TP" + "TN", "TP" + "TN" + "FP" + "FN")$
  ]

  #note[
    Occhio a chi decidiamo chi è *true positive* e chi è *true negative*, potremmo ottenere risultati   completamente diversi. Dobbiamo sempre tenere sempre in considerazione *cosa* vogliamo misurare come valore *true*.
    Magari per me il valore *true* è se un paziente è malato, per un'altra implementazione sullo stesso problema di classificazione può rappresentare il paziente sano.

    L'accuratezza di per se non cambia, dato che *TP* e *TN* vengono sommate entrambe a numeratore, ma concenttualmente, se prediamo in considerazione l'esempio di paziente malato o sano, sono cose completamete diverse.
  ]
]

Questo vale se abbiamo dataset bilanciati, nel caso in cui dovessimo avere dataset *sbilanciati* dobbiamo usare un altro tipo di accuratezza per valutare il nostro classificatore.

#definition(name: "Accuracy per dataset sbilanciati")[
  Se abbiamo un dasaet con 95 campioni negativi, e 5 positivi, un classificatore che assegna la classe negativa avrà come accuracy il 95%. Vediamo come calcolare l'accuracy per dataset sbilanciati.

  #align(center)[
    _Balanced accuracy_ $= frac("TPR" + "TNR", 2)$
  ]


  - *TPR (True Positive Rate)*: è dato da _TPR_ $= frac("TP", "TP" + "FN")$, è detta anche sensitività, perché cattura quanto il classificatore è sensibile nel riconoscere una classe.
  - *TNR (True Negative Rate)*: è dato da _TNR_ $= frac("TN", "TN" + "FP")$ detta anche specificità perché cattura quanto il classificatore è specifico nel distinguere la classe dalle altre.

]

Un altro modo grafico per rappresentare i risultati ottenuti dal classificatore è quello di usare una matrice di confusione. Per esempio:

#align(center)[
  #figure(image("img/confusion_matrix_lec5.svg", width: 80%), caption: [Matrice di confusione.])
]

Precisiamo che: sensitività, precisione, specificità e NPR sono specifiche della classe presa in considerazione, mentre l'accuracy è invariate rispetto alla classe come già detto.

Domanda, se avessimo 3 o più classi? In tal caso faremo una matrice di confusione $n times n$, dove $n$ è il numero di classi. Poi per ogni classe calcoliamo i valori *TP*, *FP* e *FN*.

Un'altra metrica utile è la *AUC* (Area Under the Curve)

#definition(name: "AUC (Area Under the Curve")[
  Prendiamo in esame il seguente grafico:

  #align(center)[

    #figure(image("img/roc_curve.svg", width: 80%), caption: [Area Under the Curve.])

  ]

  Prendiamo una curva di riferimento, in questo caso la retta passante per l'origine e indichiamo con la curva verde le prestazioni del nostro classificatore.
  Più la curva verde è vicina alla curva di riferimento è più indica che il modello classifica casualmente i valori che gli diamo in input.

  Vogliamo che la curva verde vada quasi a formare un angolo retto, ovviamente evitado di andare in overfitting.
]

#note[
  Nel caso in cui dovessimo ottenere un modello con un indice delle prestazioni del 0.95 al primo colpo, siamo tutti felici e contenti.
  Ma nel caso in cui dovessimo ottenere un modello con prestazioni discrete, circa dello 0.70, non vuol dire che sia necessariamente un modello orrendo, _ovviamente il risultato non è bellissimo_, ma adando a studiare i dati di partenza possiamo capire come migliorare il modello per aumentarne le prestazioni.

  Molto probabilmente ci sarà qualche errore nostro a monte durante la fase di design, o abbiamo interpretato male i dati, che con un cambio implementativo sul modello non ci permetterà di ottenere risultati migliori.
]

Altri indicatori per misurare le pretazioni del nostro modello sono:

#definition(name: "Micro average")[
  La *micro average* prende il nome dal fatto che riassume le prestazioni per *ogni campione* del dataset.
  Quindi formalmente è definita come:

  #align(center)[
    $italic("Precision")_("micro") = frac(sum_(i = 1)^(|G|) "TP"_i, sum_(i = 1)^(|G|) ("TP"_i + "FP"_i))$
    #v(1cm)
    $italic("Recall")_("micro") = frac(sum_(i = 1)^(|G|) "TP"_i, sum_(i = 1)^(|G|) ("TP"_i + "FN"_i))$
    #v(1cm)
    $F_1_("micro") = 2 frac("P"_("micro") dot "R"_("micro"), "P"_("micro") plus "R"_("micro"))$
  ]

  Questi indicatori posso risultare fuorvianti per dataset con classi sbilanciate, quindi tenere sempre in considerazione il dataset su cui stiamo lavorando.
]

#definition(name: "Macro average")[
  La *macro average* prende il nome dal fatto che fa la media su gruppi più grandi, ovvero *valuta le prestazioni per le singole classi* invece che sui singoli campioni:

  #align(center)[

    $italic("Precision")_("micro") = frac(1, |G|) sum_(i = 1)^(|G|) frac("TP"_i, sum_(i = 1)^(|G|) ("TP"_i + "FP"_i)) = frac(sum_(i = 1)^(|G|) "P"_i, |G|)$

    #v(1cm)

    $italic("Precision")_("micro") = frac(1, |G|) sum_(i = 1)^(|G|) frac("TP"_i, sum_(i = 1)^(|G|) ("TP"_i + "FN"_i)) = frac(sum_(i = 1)^(|G|) "R"_i, |G|)$
    #v(1cm)

    $F_1_("micro") = 2 frac("P"_("micro") dot "R"_("micro"), "P"_("micro") plus "R"_("micro"))$

  ]

  Se otteniamo dei valori alti vuol dire che il nostro classificatore funziona bene, in media, per ogni singola classe. La macro media si addice di più per dati con una distribuzione per classi sbilanciata.

]

== Cross-validation

Una tecnica importante per validare modelli statistici è la *cross-validation*, ci permette di capire come i risultati di un'analisi statistica si generalizzeranno a un insieme di dati indipendente.

Ha come obiettivo pricipale di testare le capacità del modello di prevedere nuovi dati che non sono stati utilizzati durante la fase di addestramento o durante la sua creazione.

Ci aiuta anche a valutare eventuali problemi di *overfitting* o di *selection bias*.

Il selection bias avviene quando il dataset che prendiamo in considerazione è viziata da fattori non ogettivi, per esempio se chi crea un dataset vuole fare in modo di discriminare una determinata classe da classificare può farlo manipolando i dati.

La *cross-validation* si suddivide in:
- *Esaustiva*: addestra e verifica il modello su tutti i possibili modi di dividere il dataset in training set e test set.
- *Non esaustiva*: solo un sotto insieme dei possibili modi di divisione viene preso in considerazione. Generalmente vengono scelti casualmente dal dataset di partenza.

#definition(name: "Cross-validation non esaustiva")[
  La tecnica di cross-validation non esaustiva più usata è la *k-fold cross-validation*. In questa tecnica il dataset viene diviso i $k$ parti di dimensioni uguali. A turno ogni parte viene usata come test set metnre il resto come training set.

  #align(center)[
    #figure(
      image("img/cross_validation.svg", width: 100%),
      caption: [Esempio di cross-validation k-fold.],
    )
  ]
]

#definition(name: "Cross-validation non esaustiva -- Stratified k-folding")[
  È  una variante del k-fold che restituisce fold stratificati.
  I fold vengono creati *preservando* la percentuale di campioni per ciascuna classe presente nel dataset, in un contesto di classificazione binaria o multiclasse.

  Se il dataset è sbilanciato, è *fondametale rispettare lo sbilanciamento anche nel test e training set* infatti questa tecnica è particolarmente indicata per dataset sbilanciati.

  #align(center)[
    #figure(image("img/stratified_kfold.svg", width: 100%), caption: [Esempio di stratified k-fold.])
  ]
]
