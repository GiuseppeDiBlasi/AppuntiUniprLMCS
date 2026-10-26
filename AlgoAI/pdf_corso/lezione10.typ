#import "../../Template typst/template.typ": c-border, definition, exam, example, note, separator, theorem, warning
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

= Lezione 10 del 26 ottobre 2026

Riprendiamo dalla regressione che abbiamo introdotto nella scorsa lezione, @regressione.

#figure(image("img/lezione10/regressione_vs_pca.svg", width: 70%), caption: [Regressione lineare e PCA.])

La regressione lineare least square minimizza le distanze verticali dall'iperpiano che vogliamo tracciare, invece la PCA minimizza le distanze euclidee.
Cio è dovuto al fatto che le variabili dipendenti e indipendenti non hanno un ruolo simmetrico, questo perché consideriamo la variabile indipendente come esatta, mentre quella dipendente è affetta da errore.

== Accuratezza della predizione

Abbiamo diversi indicatori di predizione che ci permettono di stabile l'accuratezza di una predizione.

#definition(name: "Root Mean Square Error")[
  È un indicatore di accuratezza di predizione. È la radice quadrata della differenza tra predizione e valore reale (MSE, Mean Square Error).

  $ "MSE" = 1/N sum_(i = 1, dots, N) (hat(y)_i - y_i)^2 $

  Attenzione con questo indicatore perché con è sensibile agli outlier.
]

#definition(name: "Mean Absolute Error")[
  È lo stesso concetto di MSE, misurare la differenza tra predizione e risultato reale, ma invece di elevare al quadrato prendiamo in considerazione il valore assoluto.

  $ "MAE" = 1/N sum_(i = 1, dots, N) |hat(y)_i - y_i| $

  MAE risulta essere più stabile in presenza di outlier, a differenza di MSE, e soprattutto ci permette di mantere l'unità di misura.
]

#definition(name: "Mean Absolute Percentage Error")[
  Definita come:

  $ "MAPE" = 1/N sum_(i = 1, dots, N) |(hat(y)_i - y_i)/y_i| $

  È una variante del MAE, ma la penalizzazione dipende dallo scostamento percentuale  rispetto alla grandezza dei dati.
]

#definition(name: [Coefficiente di determinazione $R^2$])[
  È definito come:

  $ 1 - frac(sum_(i = 1, dots, N) (y_i - hat(y)_i)^2, sum_(i = 1, dots, N) (y_i - macron(y)_i)^2)) $

  È un indicatore statistico tra 0 e 1, indica quanto il modello lineare riesce a fittare sui dati.
  Ovvero spiega la varianza della variabile dipendente.

  Non è valido per modelli *NON* lineari.
]

== Regressione polinomiale

Nella regressione polinomiale invece di tracciare una retta dobbiamo trovare i parametri per tracciare un polinomio.

Se abbiamo $d = 1$ e il modello quadratico $y = beta_1 x^2 + beta_2 x + beta_3$ scriviamo $X$ come:

$
  X = mat(
    x_1^2, x_1, 1;
    x_2^2, x_2, 1;
    dots.v, dots.v, dots.v;
    x_n^2, x_n, 1;
  )
$

#figure(
  image("img/lezione10/regressione_polinomiale_2d_3d.svg", width: 70%),
  caption: [Regressione polinomiale 2D e 3D.],
)

#exam[
  *NON* ci sarà una domanda aperta sulla parte di regressione.
  Potrebbe comparire una domanda sulla regressione nella parte a crocette, ma non sarà qualcosa di altamente specifico.

  Come detto nella scorsa lezione, è importante capire i concetti della regressione.
]

== Inferenza statistica e selezione del modello

#note[
  Allora, qui adesso inizierebbe una parte di inferenza statistica e metodi per poter scegliere un modello.
  Il prof a lezione ha fatto un richiamo sul p-value e cosa calcola.

  Il *p-value* è la probabilità di osservare dati almeno così estremi di quelli ottenuti, _supponendo vera l'ipotesi nulla_ (nessun effetto, ad esempio $beta_j = 0$).

  Si fissa una soglia, di solito $alpha = 0.05$:

  - se $p < alpha$ si rifiuta l'ipotesi nulla: il risultato è *statisticamente significativo*, cioè è improbabile che sia dovuto solo al caso;
  - se $p >= alpha$ non si rifiuta l'ipotesi nulla: i dati non bastano per affermare che l'effetto esista.

  Nella regressione si usa per capire se una variabile (o l'intero modello, con il test $F$) contribuisce davvero a spiegare il fenomeno.


  Attenzione perché è facile "truccare" i risultati per ottenere un risultato significativamente statistico.
]

#note[
  L'idea di base di questa parte è capirne i concetti fondamentali, senza doversi imparare le formule a memoria.

  Le slide su questa parte sono: "AIALGO_2627_5-regressione.pdf", da slide 16 a 58.
]

Fino ad ora $hat(beta)$ era una stima puntuale, il training set però è un campione, se ripetiamo l'esperimento otterremo nuovi errori e di conseguenza una stima puntuale $hat(beta)$ diversa.

Vedendo $hat(beta)$ come una variabile aleatoria possiamo cheiderci:

- Il coefficiente $beta_j$ è davvero diverso da 0? La variabile $x_j$ ci serve? $arrow$ *test t*.
- Il modello nel suo complesso ci spiega qualcosa? $arrow$ test *F / ANOVA*.
- Tra due modelli annidati, quello più complesso è significativamente migliore? $arrow$ *F parziale, likelihood ratio test $(chi^2)$*.
- Tra modelli qualsiasi, quale conviene scegliere? $arrow$ *AIC, BIC* e cross-validation.
- I dati rispettano le ipotesi del modello? $arrow$ *diagostica dei residui*.

=== Ipotesi del modello lineare classico

$ y = X beta + epsilon, quad X in RR^(n times p), quad p = d + 1 $

Il modello lineare classico assume:

+ Linearità nei parametri.
+ Errori a media nulla: $italic(E)[epsilon_i] = 0$
+ Varianza costante: $italic("Var")(epsilon_i) = sigma^2$
+ Errori non correlati tra loro: $italic("Cov")(epsilon_i, epsilon_j) = 0$, per $i != j$
+ $X$ a rango pieno, le feature sono indipendenti tra loro
+ Per l'inferenza: $epsilon tilde italic(N)(0, sigma^2 I)$

=== Intervalli di confidenza e di predizione

Prendiamo un nuovo punto $x_0$, la predizione è definita come: $hat(y)_0 = x^T_0 hat(beta)$. Possiamo farci due domande sul punto $x_0$:

- Dove si trova la media $italic(E)[y | x_0] arrow$ *intervallo di confidenza.*
- Dove cadrà una nuova osservazione $y_0 arrow$ *intervallo di predizione.*

L'intervallo di predizione è sempre più ampio.

=== Decomposizione della varianza (slide 26)

Possiamo decomporre la varianza nel seguente modo:

- $"TSS" = sum_i (y_i - macron(y))^2$, è la variabilità *totale*.
- $"ESS" = sum_i (hat(y)_i - macron(y))$, è la variabilità *spiegata* dal modello.
- $"RSS" = sum_i (y_i - hat(y)_i)^2$, è la variabilità *residua*.

=== $R^2$ aggiustato (slide 27)

Un problema dell'indicatore $R^2$ è che non diminuisce mai aggiungendo variabili al modello, non può essere usato per confrontare modelli con un numero diverso di parametri.

=== ANOVA, Analisi della varianza (slide 28)

Detta in maniera altamente sintetica, l'analisi della varianza, tramite la scomposizione della variabilità dei dati in parte spiegata dal modello e parte d'errore, serve a verificare se il modello spieghi effettivamente qualcosa o se basterebbe semplicemente la media.

#note[Esempio slide 34.]
#note[Slide 35, test del chi quadro.]

=== Verosimiglianza del modello lineare (slide 38)

Con $epsilon_i tilde italic(N)(0, sigma^2)$ indipendenti:

$ cal(l) (beta, sigma^2) = log(L) = - frac(n, 2) log(2 pi sigma^2) - frac("RSS"(beta), 2 sigma^2) $

Questo ci dice quant'è probabile che il modello descriva i dati.

=== AIC e BIC (slide 40)

- AIC, stima la distanza di Kullback-Leibler (@kullback-leibler) dal modello vero: orientato alla *predizione*.
- BIC è consistente, se il modello vero è tra i candidati, viene selezionato con probabilità 1 per $n arrow infinity$.

#note[Esempio slide 42.]

=== Regressione non lineare - dipendenza nota e sconosciuta

Nel caso di dipendenza non lineare del modello dai parametri, non esiste soluzione least square in forma-chiusa.

Se la *dipendenza è nota*, si possono applicare tecniche iterative di ottimizzazione numerica:

- *Discesa del gradiente.*
- *Algorito di Gauss-Newton.*

Nel caso in cui invece la dipendenza *non dovesse essere nota*, possiamo usare delle varianti di alcune tecniche di classificazione per problemi di regressione:

- *Random Forest Regressor.*
- *Support Vector Regressor.*
- *Gradient Boosting Regressor.*
- *Reti neurali.*

I vantaggi di un modello non lineare sono:

- Maggiore flessibilità.
- Controllo della complessità della soluzione.
- Possibilità di utilizzare funzioni loss alternative rispetto a MSE, come MAE, MAPE etc...

== Riepilogo

Per problemi di regressione di piccole-medie dimensioni:

- Modello lineare risolto tramite least square è l'approccio più semplice.
- Un modello non lineare rispetto alla variabile indipendente può essere un'ottima seconda scelta perché  coniuga semplicità e flessibilità.
- Quando ci servono modelli più potenti possiamo usare *Random Forest Regressor* come alternativa valida.
- Se la dipendenza tra variabile dipedente e indipendente è nota, ma non lineare, l'ottimizzazione numerica con *Gauss-Newton* è la scelta migliore.

#separator()

Invece per problemi di grandi dimensioni, l'approccio iterativo tramite discesa del gradiente con reti neurali è preferibile per motivi di trattabilità numerica e di complessità computazionale.

Nell'ambito del deep learning, reti nearuali addestrate con la discesa del gradiente sono state utilizzate con successo per risolvere problemi di regressione di *enormi* dimensioni, come la stima della posizione di un oggetto in un'immagine a partire da milioni di esempi.
- La variabile indipendente è un'immagine
- La variabile dipendente è la bounding box dell'oggetto, in questo caso si tratta di un vettore. Quindi multivariate multiple regression.

Per concludere un'altra possibile domanda d'esame, può comparire nelle crocette:

#exam(
  [Come viene deciso il valore del p-value, perché è 0.05?],
  answer: [Il valore è deciso arbitrariamente; a volte ci torna utile perché con un p-value di 0.05 possiamo dire se il nostro modello ricade nel 95% di tutti i modelli possibili, o nel migliore 5% dei modelli possibili.],
)
