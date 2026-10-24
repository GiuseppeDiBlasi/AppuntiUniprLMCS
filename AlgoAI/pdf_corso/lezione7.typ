#import "../../Template typst/template.typ": c-border, definition, exam, example, note, separator, theorem, warning
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node


= Lezione 7 del 16 ottobre 2026

La scorsa lezione abbiamo introdotto i metodi di classificazione, lazy o eager, e siamo andati più nel dettaglio per quanto riguarda gli alberi di decisione, modelli di classificazione eager.

Riprendiamo dall'indice di Gini per gli alberi di decisione.

== Indice di Gini

A differenza dell'information gain, che lavora con valori categoriali, l'indice di Gini lavora con valori continui.

Diamo una definizione per l'indice di Gini:

#definition(name: "Indice di Gini")[
  Dato un insieme di oggetti $S$ contenente $n$ classi, l'indice di Gini è definito come:

  $ italic("gini")(S) = 1 - sum_(j - 1)^n p^2_j $

  dove $p_j$ è la frequenza della classe j-esima di $S$.
]

#example[
  Date due classi $P$ ed $N$, tale che $S = P union N$ contenenti rispettivamente $p$ ed $n$ elementi, possiamo calcolare:

  $ p_P = frac(p, p + n) $
  $ p_N = frac(n, n + p) $
  $ italic("gini")(S) = 1 - p_P^2 - p_N^2 $
]

Possiamo anche definire l'indice di Gini nel caso in cui $S$ sia suddiviso in due sottoinsiemi $S_1$ e $S_2$:

#definition(name: "Indice di Gini dello split")[
  L'indice di Gini dello split di $S$ possiamo definirlo come:

  $ italic("gini")_("split") (S, a) = frac(N_1, N) italic("gini")(S_1) + frac(N_2, N) italic("gini")(S_2) $

  Dove $a$ è l'attributo che divied $S$ in due insiemi.

  Generalizzando, se l'attributo $a$ divide $S$ in $m$ sottoinsiemi, ognuno di dimensione $N_i$, l'indice di impurità dello split è calcolato come:

  $ italic("gini")_("split") (S, a) = sum_(i = 1)^m frac(N_i, N) italic("gini")(S_i) $

  L'attributo con il minor valore è selezionato coem attributo dello split.

]

Guardiamo un esempio di indice di Gini:

#example[
  Prendiamo in considerazione i seguenti dati:

  #align(center)[
    #table(
      columns: 4,
      table.header[*RID*][*Age*][*Car Type*][*Risk*],
      [0], [23], [family], [high],
      [1], [17], [sport], [high],
      [2], [43], [sport], [high],
      [3], [68], [family], [low],
      [4], [32], [truck], [low],
      [5], [20], [family], [high],
    )
  ]

  #v(1em)

  #grid(
    columns: (1fr, 1fr),
    column-gutter: 2em,
    align: top,

    [
      Attribute list for 'Age'
      #v(0.3em)
      #table(
        columns: 3,
        table.header[*Age*][*RID*][*Risk*],
        [17], [1], [high],
        [20], [5], [high],
        [23], [0], [high],
        [32], [4], [low],
        [43], [2], [high],
        [68], [3], [low],
      )
    ],

    align(right)[
      Attribute list for 'Car Type'
      #v(0.3em)
      #table(
        columns: 3,
        table.header[*Car Type*][*RID*][*Risk*],
        [family], [0], [high],
        [sport], [1], [high],
        [sport], [2], [high],
        [family], [3], [low],
        [truck], [4], [low],
        [family], [5], [high],
      )
    ],
  )

  Possiamo avere vari possibili valori di split per l'attributo _Age_:

  _Age_ $=<$ 17, _Age_ $=<$ 20, _Age_ $=<$ 23, _Age_ $=<$ 32, _Age_ $=<$ 43, _Age_ $=<$ 68.

  #separator()

  Iniziamo con il valore 17.

  #align(center)[
    #table(
      columns: 3,
      align: center + horizon,
      table.header[*Tuple count*][*High*][*Low*],
      [$"Age" <= 17$], [1], [0],
      [$"Age" > 17$], [3], [2],
    )
  ]

  Calcoliamo sia per valori minori o uguali a 17 e maggiori di 17:

  $ G(italic("Age") =< 17) = 1 - (1^2 + 0^2) = 0 $
  $ G(italic("Age") > 17) = 1 - ((frac(3, 5))^2 + (frac(2, 5))^2 ) = 1 - frac(13, 25)^2 = 12/25 $

]

Un albero di decisione separa i dati in maniera diversa rispetto a un modello di machine learning. Con un modello di ML possiamo decidere se
separare i dati secondo varie curve: retta, parabola o curve più complesse.
Un albero di decisione invece cerca di separare i dati con più rette per la classificazione.

#figure(image("img/lezione7/decision_tree.svg"), caption: [Modello di ML vs Albero di decisione.])

== Pruning degli alberi di decisione

Un problema che può sorgere con gli alberi di decisione, è la presenza di un elevato numero di attributi all'interno del training set, questo comporta la crescita dell'albero decisionale.

Dato che un albero di decisione porta ad avere sempre delle foglie pure, gli alberi decisionali tendono ad andare in overfitting sul training set.

Una soluzione è quella di rimuovere rami dall'albero che non portano ad una corretta classificazione, questa tecnica si chiama potatura e abbiamo due modalità:

- *Pre-pruning*: Viene effettuata durante la costruzione dell'albero, si effettua una previsione sulla presunta precisione che il ramo potrebbe avere se decidessimo di costruirlo per intero.
- *Post-pruning*: Viene effettuata una volta che l'albero è stato costruito.

Useremo *post-pruning*, anche se più dispendioso, perché dobbiamo costruire l'albero per intero e poi lavorarci nuovamente sopra, ci permette di essere più precisi rispetto al *pre-pruning*.
Per il *post-pruning* l'algoritmo più usato è l'algoritmo C4.5:

#let decisione(pos, testo, name) = node(
  pos,
  testo,
  name: name,
  shape: fletcher.shapes.rect,
  corner-radius: 4pt,
  stroke: 0.6pt,
  inset: 6pt,
)
#let foglia(pos, testo, name) = node(
  pos,
  testo,
  name: name,
  shape: fletcher.shapes.circle,
  stroke: 0.6pt,
  inset: 6pt,
)
// Archi con etichetta yes/no
#let si(a, b) = edge(a, b, "-", label: [yes], label-side: right)
#let no(a, b) = edge(a, b, "-", label: [no], label-side: left)

#let albero-completo = scale(70%, reflow: true, diagram(
  spacing: (1.4em, 3.2em),
  node-inset: 0pt,

  decisione((2.75, 0), [$A_1$?], <a1>),
  decisione((1.25, 1), [$A_2$?], <a2>),
  decisione((4.25, 1), [$A_3$?], <a3>),
  decisione((0.5, 2), [$A_4$?], <a4>),
  decisione((3.5, 2), [$A_5$?], <a5>),

  foglia((2, 2), [class A], <fa1>),
  foglia((5, 2), [class B], <fb1>),
  foglia((0, 3), [class A], <fa2>),
  foglia((1, 3), [class B], <fb2>),
  foglia((3, 3), [class B], <fb3>),
  foglia((4, 3), [class A], <fa3>),

  si(<a1>, <a2>),
  no(<a1>, <a3>),
  si(<a2>, <a4>),
  no(<a2>, <fa1>),
  si(<a3>, <a5>),
  no(<a3>, <fb1>),
  si(<a4>, <fa2>),
  no(<a4>, <fb2>),
  si(<a5>, <fb3>),
  no(<a5>, <fa3>),
))

#let albero-potato = scale(70%, reflow: true, diagram(
  spacing: (1.4em, 3.2em),
  node-inset: 0pt,

  decisione((1.25, 0), [$A_1$?], <a1>),
  decisione((0.5, 1), [$A_2$?], <a2>),
  decisione((0, 2), [$A_4$?], <a4>),

  foglia((2, 1), [class B], <fb1>),
  foglia((1, 2), [class A], <fa1>),
  foglia((-0.5, 3), [class A], <fa2>),
  foglia((0.5, 3), [class B], <fb2>),

  si(<a1>, <a2>),
  no(<a1>, <fb1>),
  si(<a2>, <a4>),
  no(<a2>, <fa1>),
  si(<a4>, <fa2>),
  no(<a4>, <fb2>),
))

#align(center)[
  #grid(
    columns: 2,
    column-gutter: 3em,
    align: horizon,
    figure(albero-completo, caption: [Albero completo]), figure(albero-potato, caption: [Albero potato con C4.5]),
  )
]


Dobbiamo anche stabilere con quale criterio scartare rami dell'albero, altrimenti alcuni casi verranno classificati erroneamente. Una soluzione è quella di specificare una classe di distribuzione, per ogni classe presente nel training set, e la probabilità che un caso appartenga a quella classe.
Questo ci permette di, commettere leggermente più errori in generale, ma possiamo generalizzare meglio il nostro modello.

Con l'algoritmo C4.5, quando l'errore medio di un sottoalbero, dopo aver potato uno specifico nodo interno, è minore di quello che riserva il test stesso, il nodo corrispondente al test viene potato insieme a tutto il suo sottoalbero.

== Minimal cost-complexity pruning

Esiste anche l'algoritmo di *minimal cost-complexity pruning* che è un algoritmo di pruning parametrizzato tramite un parametro $alpha >= 0$ detto anche *parametro di complessità*.

#definition(name: "Minimal cost-complexity pruning")[
  Dato un parametro $alpha$ per definire una misura di costo di complessità $R_alpha (T)$ per un dato albero $T$ definiamo:

  $ R_alpha (T) = R(T) + alpha|tilde(T)| $

  Dove $alpha|tilde(T)|$ è il numero di nodi terminali nell'albero $T$ e $R(T)$ è il tasso di errore sui nodi terminali dell'albero $T$.

  L'algoritmo ha come obiettivo trovare un sottoalbero di $T$ che minimizzi $R_alpha (T)$.
]

Il costo di un singolo nodo è dato da $R_alpha (t) = R(t)$.
Il ramo $T_t$ è un albero avente $t$ come radice.

In generale l'impurità di un nodo radice è maggiore della somma dell'impurità dei nodi terminali, ovvero $R(T_t) < R(t)$.

Possiamo definire un valore effettivo per $alpha$ che ci permette di decidere come tagliare l'albero:

$ alpha_"eff" = frac(R(t) - R(T_t), |T| - 1) $

L'algoritmo termina quadno l'$alpha_"eff"$  minimale del sottoalbero potato è maggiore del valore soglia.

Aumentando il parametro $alpha$ verrà potata sempre una porzione più grande dell'albero, il che aumenta l'impurità totale delle sue foglie.

#figure(image("img/lezione7/impurity_vs_alpha.svg"), caption: [Grafico per alpha effettivo.])

Ovviamente, aumentando il valore del parametro $alpha$, il numero di nodi e la profondità dell'albero diminuiscono.

#figure(
  image("img/lezione7/nodes_depth_vs_alpha.svg"),
  caption: [Andamento dei nodi e della profondità dell'albero all'aumentare di alpha.],
)

Un altro aspetto importante è come incide il parametro $alpha$ sulle prestazioni del modello. Valori bassi tenderanno a mandare il classificatore in overfitting, peggiorando le prestazioni sul test set.
Mentre valori più alti tenderanno ad abbassare la precisione durante la fase di training, ma aumentandola nella fase di test. Attenzione che dopo una certa soglia $alpha$ il modello perde prestazioni sia in training che test set.

#figure(image("img/lezione7/accuracy_vs_alpha.svg"), caption: [Accuratezza del modello al variare di alpha.])

#note[
  Se nel proprio progetto per _Laboratorio di Algoritmi per l'intelligenza artificiale_ si decide di usare un albero di decisione, è obbligatorio fare il grafico riportato sopra.
]

Gli alberi di decisione sono modelli semplici da realizzare, hanno anche un'ottima efficienza computazionale e i risultati sono interpretabili.
Non sono esenti da difetti, non sono stabili; dei cambiamenti nel training set comportano cambiamenti anche nella struttura dell'albero, di conseguenza i risultati che si ottengono hanno inoltre un'elevata varianza.

#pagebreak()


== Metodi di consenso

Per risolvere le problematiche degli alberi di decisione ci sono diverse strategie basate sui metodi di consenso.
Abbiamo *bagging*, *random forests* e *boosting*.

Queste tecniche ci permettono di guadagnare in accuratezza ma con lo svantaggio di perdere parzialmente l'interpretabilità del modello.

I metodi di consenso impiegano una combinazione di modelli $M^*$, ottenuta come combinazione di $k$ modelli addestrati separatamente per incrementare l'accuratezza.

#figure(image("img/lezione7/ensemble_voting.svg"), caption: [Struttura metodi di consenso.])

I metodo più usati sono:
- *Bagging*: si media la predizione su un insieme omogeneo di classificatori.
- *Boosting*: si impiega una collezione di classificatori tramite un *voto pesato*.
- *Ensemble*: si combina un insieme eterogeneo di classificatori.

#pagebreak()

=== Bagging

Il *boostrap aggregation*, o *bagging*, è una tecnica utilizzata prevelatemente per ridurre la varianza di un metodo di apprendimento statistico o per stimare l'accuratezza di un modello di machine learning.

La tecnica di *bagging* è particolarmente utile per gli alberi di decisione.

L'idea del boostrap è di estrarre casualmente $B$ diversi sottoinsiemi di osservazioni dall'unico training set per simulare la variabilità dei dati.
Addestrare un classificatore $f_i$ per ogni sottoinsieme $i$ separatamente e infine aggregare le predizioni sulle nuove istanze $x$ del test:

$ f_"bag" (x) = 1/B sum_(i = 1)^B f_i (x) $

#v(2cm)

#figure(image("img/lezione7/bagging.svg"), caption: [Schema della tecnica di bagging.])


#pagebreak()

=== Random forest

È un metodo di consenso costituito da un bagging di *alberi di decisione non potati* e complessi, con una scelta casuale di un sottoinsieme delle feature ad ogni split.
È un metodo non lineare, ha una bassa varianza grazie all'elevata quantità di alberi dentro la foresta.

#figure(image("img/lezione7/random_forest.svg"), caption: [Metodo random forest.])

Il metodo random forest è utile anche per feature selection. Gli attributi che sono più significativi per la classificazione tendono a comparire più vicini alla radice degli alberi, questo perché i primi split dalla radice permettono di ottenere maggiori guadagni secondo l'indice di Gini o l'information gain.

Il metodo random forest perde facilmente interpretabilità, dovuta alla presenza di molti alberi di decisione, ma ci permette di *scalare* molto bene permettendo l'esecuzione in parallelo di tutti gli alberi della foresta.

=== Addestramento della foresta

Fissiamo un numero a piacere $n_"tree"$ e il numero delle feature $m_"try"$ da scegliere casualmente tra quelle disponibili. Di solito $m_"try"$ è posto a $m/3$ per problemi di regressione, e $sqrt(m)$ per problemi di classificazione, dove $m$ rappresenta il numero totale delle feature.

Per $n_"tree"$ volte ripetiamo la procedura:


#definition(name: "Algoritmo random forest")[
  + Scegliere un sottoinsieme di boostrap $S$ dai dati di training.

  + Addestrare un albero di decisione su $S$ con _minsplit_ = 1, in cui ad ogni split solo $m_"try"$ preditorri sono scelti casualmente coem candidati per lo split tra tutte le feature.

  + Non potare l'albero.

  + Salvare l'albero ottenuto.

]

Per la predizione di nuove istanze si aggregano le predizioni di tutti gli alberi, come nel bagging, e si stabilisce la classificazione di una nuova istanza in base alla maggioranza delle predizione fatte dagli $n_"tree"$ (classificazione) alberi o mediante una media delle stesse (regressione).

Random forest non presenta problemi di *overfitting*, dovuto al fatto che facciamo bagging, all'aumentare del numero di alberi.
Gli alberi addestrati dentro random forest sono indipendenti, rendendolo parallelizzabile come già detto precedentemente.

L'idea del bagging è quella di calcolare la media di molti modelli contenenti errore ma approssimativamente non distorti, in modo da ridurre la varianza.
Gli alberi sono perfetti per il bagging, perché permettono di catturare strutture di interazioni complesse all'interno dei dati, e se fatti crescere con abbastanza profondità, presentano una distorsione relativamente bassa.

Gli alberi di decisione hanno un'elevata varianza, e il bagging la
riduce in modo efficace: mediando le previsioni di molti alberi della
foresta, gli errori commessi dai singoli alberi tendono a compensarsi.

È importante anche stabilire il numero di alberi all'interno della random forest, un numero basso di alberi aumenterà il livello di errore della RF, mentre un numero più alto tenderà ad abbassarlo come già visto in precedenza. Generalmente si usa un numero intorno al 100 per $n_"tree"$.

#pagebreak()

#note[
  Se si usa il metodo random forest per il progetto di laboratorio questo grafico qui sotto è essenziale.

  #figure(image("img/lezione7/error_trees.svg"), caption: [Random forest con diversi $n_"tree"$.])
]

Le random forest forniscono anche una stima dell'errore di test, chiamato *Out Of Bag (OOB) error*, che è la media degli errori di predizione su ogni istanza di training $x_i$ mediante l'aggregazione delle predizioni dei soli alberi che non contenevano $x_i$ tra le istanze di training.

Per calcolare l'importanza di goni feature si possono applicare le seguenti strategie:

- *Mean decrease in accuracy*: Viene calcolata l'accuratezza della RF sui dati out of bag, quindi per ogni variabile si permuta una colonna alla volta dei dati in modo da individuare quali attributi/feature siano rilevanti per la classificazione. Si calcola la differenza dell'accuratezza per ogni albero sui dati OOB prima e dopo la permutazione per stabilire se una feature è rilevante oppure no; si calcola poi la media sulla differenza calcolata per ogni albero della RF.

- *Mean decrease in the Gini index*: per ogni albero e per ogni variabile $i$, si considerano tutti i nodi in cui lo split è fatto sulla variabile $i$. Per ciascuno si calcola la diminuzione dell’indice di Gini (impurità), cioè la differenza tra l’impurità del nodo padre e la media pesata delle impurità dei nodi figli, pesandola per il numero di istanze che arrivano nel nodo. Queste diminuzioni si sommano su tutti i nodi dell’albero che usano la variabile $i$, e si fa poi la media su tutti gli alberi della RF. Più la diminuzione media è grande, più la variabile è importante.

=== Riepilogo random forest

Non sempre conviene utilizzare le random forest. In problemi di regressione possono essere poco adatte, perché le previsioni sono medie dei valori osservati nel training: il modello non è in grado di estrapolare oltre l’intervallo dei dati e produce previsioni a gradini. Nei problemi di classificazione questo limite non c’è.

Inoltre, quando i dati sono scarsi, la random forest ha poco senso: il bootstrap e la selezione casuale delle variabili lavorano su pochi campioni, e gli alberi risultano troppo instabili o troppo simili tra loro perché la media riduca davvero la varianza.

*Vantaggi*:

- Può eseguire sia attività di regressione che classificazione.
- Una foresta casuale produce buone predizioni che possono essere comprese facilmente.
- Può gestire in modo efficiente set di dati di grandi dimensioni.
- L'algoritmo della foresta casuale fornisce un livello di precisione più elevato nella previsione dei risultati rispetto all'algoritmo dell'albero decisionale.

*Svantaggi*:
- Quando si usa una random forest, sono necessarie più risorse per il calcolo.
- Consuma più tempo rispetto ad un algoritmo di albero decisionale.

== Boosting

Il boosting prevede l'utilizzo di un insieme di classificatori con voto pesato.

Per esempio è come consultare diversi medici per una diagnosi sulla base di una combinazione di diagnosi pesate, il peso viene assegnato in base all'accuratezza della diagnosi precedente.

Procedimento:

+ Vengono assegnati dei pesi ad ogni tupla del training set.
+ Si addestra una serie di $k$ classificatori
  - Ogni volta che l'$i$-esimo classificatore $M_i$ viene addestrato, i pesi sono aggiornati in modo da consentire al successivo classificatore, $M_(i+1)$ di porre più attenzione alle tuple che sono state classificate erroneamente dal classificatore $M_i$.

+ Il classificatore finale $M^*$ combina i voti di ogni classificatore intermedio, tale che il peso assegnato ad ogni voto è proporzionale all'accuratezza dello specifico classificatore.

=== Boosting: Adaboost

#definition(name: "Adaboost")[
  Prendiamo in considerazione un insieme $D$ di $d$ tuple etichettate, $(X_1, y_1), dots, (X, y_d)$, dove $X_i$ è l'$i$-esima tupla e $y_i$ è l'etichetta ad essa assegnata.

  Settiamo inizialmente tutti i pesi allo stesso valore di $1/d$.

  Generiamo i $k$ classificatori in $k$ passi. Ad ogni passo $i$:

  + Le tuple nell'insieme $D$ vengono campionate con replacement, ovvero rimettendone uan copia in $D$ dopo l'estrazione, per formare un training set $D_i$ della stessa dimensione di $D$.

  + Le probabilità di ogni tupla di essere selezionata è proporzionale al suo peso.

  + Viene addestrato un classificatore $M_i$ da $D_i$.

  + Viene calcolato il tasso di errore $M_i$ utilizzando $D_i$ come test set.

  + Se una tupla viene classificata erroneamente, il suo peso viene incrementato, altrimenti viene decrementato.
]

#definition(name: "Adaboost, calcolo errore")[
  Sia _err_($X_j$) l'errore nel classificatore la tupla $X_j$ ({0, 1} se si parla di classificatori e non di regressori).

  L'errore del classificatore $M_i$ è dato da:

  $ italic("error")(M_i) = sum_(j = 1)^d w_j times italic("err")(X_j) $

  - $w_j$, peso corrente per la tupla $X_j$.

  Il peso del classificatore $M_i$ nella votazione consenso sarà:

  $ log(frac(1 - italic("error")(M_i), italic("error")(M_i))) $
]
