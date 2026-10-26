#import "../../Template typst/template.typ": c-border, definition, exam, example, note, separator, theorem, warning
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

= Lezione 9 del 23 ottobre 2026

La scorsa lezione abbiamo visto le support vector machine per la classificazione ad una e più classi.
In questa lezione vedremo le analisi discrimanti, LDA e un'introduzione alla regressione lineare.

== Analisi discriminante

Ipotizziamo di voler stimare la probabilità di default dei debitori per una società creditizia.
Possiamo avere varie feature che descrivono ogni debitore, per esempio:

- $Y$ default: variabile binaria, se il debitore è in default oppure no.
- $X_1$, studente: variabile binaria, se il debitore è uno studente oppure no.
- $X_2$, saldo, importo medio residuo sulla carta di credito dopo i versamenti mensili.
- $X_3$, reddito del debitore.

Possiamo fare un analisi esplorativa dei dati per farci un'idea della struttura del dataset.

#figure(image("img/lezione9/default_balance_income.svg", width: 70%), caption: [Analisi esplorativa dei dati.])

Prendiamo in considerazione _Default_ come classe e supponiamo di utilizzare solo la feature _student_ per determinare la probabilità di un debitore di andare in default:

$ P("default" = "Yes" | "student" = "Yes") $

Incrociando i dati otteniamo la seguente tabella:

#align(center)[
  #figure(
    table(
      columns: (2.6cm, 2cm, 2cm, 2cm),
      align: center + horizon,
      inset: 9pt,
      stroke: 0.6pt + luma(160),
      fill: (x, y) => if x == 0 or y == 0 { luma(225) } else if x == 3 or y == 3 { luma(245) },

      // Intestazione: colonne = student
      [#text(size: 9pt)[*student* → \ *default* ↓ ]], [*No*], [*Yes*], [*Sum*],

      // Righe: default
      [*No*], [6850], [2817], [*9667*],
      [*Yes*], [206], [127], [*333*],
      [*Sum*], [*7056*], [*2944*], [*10000*],
    ),
    caption: [Tabella per classe default con feature student.],
  )<tbl-default-student>
]

Dalla tabella possiamo stimare:

$ hat(P) = ("default" = "Yes" | "student" = "Yes") = frac(127, 2944) = 0.043 $

Guardando i risultati potremmo dire che le persone che non sono state studenti hanno più probabilità di andare in default rispetto a chi lo è stato.
Questo è vero in numeri assoluti, ma guardando le percentuali è più probabile che uno studente vada in default rispetto a uno che non lo è.

Questa conclusione è vera per questo dataset, dobbiamo tenere in considerazione se il campione sia rappresentativo dello scenario reale. Se il dataset
fosse stato scelto in modo da alterare la percentuale di studenti in default, o di non studenti in default, allora la conclusione non è generalizabile.

Per calcolare la probabilità di essere in default per uno studente abbiamo usato la *probabilità condizionata*.

=== Probabilità condizionata

Possiamo definire la probabilità condizionata come:

#definition(name: "Probabilità condizionata")[
  La probabilità condizionata di un evento $A$ dato un evento $B$, $P(A | B)$, esprime la probabilità che si verifichi l'evento $A$ con l'evento $B$  già avvenuto.

  $ P(A | B) = frac(P(A and B), P(B)) $

  - Se gli eventi $A$ e $B$ sono indipendenti allora $P(A | B) = P(A)$, e lo indichiamo come $A || B$.
  - Se $A$ e $B$ sono disgiunti allora $P(A and B) = 0$

]

#pagebreak()

=== Teorema di Bayes

Per calcolare le probabilità condizionate utilizziamo il teorema di Bayes:

#definition(name: "Teorema di Bayes")[
  $ P(A | B) = frac(P(A) P(B | A), P(B)) $
]

Possiamo dimostrare la definizione del teorema di Bayes partendo dalla definizione di probabilità condizionata:

$ P(A and B) = P(A | B) P(B) $
$ P(A and B) = P(B and A) = P(B | A) P(A) $
$ P(A | B) P(B) = P(B | A) P(A) $


#example(name: "Approccio bayesiano")[
  Tornando al caso dei debitori e della probabilità di andare in default, possiamo definire con $pi = P("default" = "Yes")$, di conseguenza $(1 - pi) = P("default" = "No")$

  Possiamo definire anche:
  $ P(S | D) = P("student" = "Yes" | "default" = "Yes") $
  $ P(S | macron(D)) = P("student" = "Yes" | "default" = "No") $

  Utilizzando il teorema di Bayes otteniamo:

  $ P("default" = "Yes" | "student" = "Yes") = frac(pi dot P(S | D), pi P(S | D) + (1 - pi) dot P(S | macron(D))) $

  Utilizzando la tabella @tbl-default-student, possiamo stimare:

  $
                  hat(pi) & = frac(333, 1000) = 0.333 \
            hat(P)(S | D) & = hat(P)("student" = "Yes" | "default" = "Yes") = frac(127, 333) = 0.38 \
    hat(P)(S | macron(D)) & = hat(P)("student" = "Yes" | "default" = "No") = frac(2817, 9667) \
  $

  Mettendo questi valori nella formula di Bayes otteniamo:

  $ hat(P) ("default" = "Yes" | "student" = "Yes") = frac(0.0333 dot 0.38, 0.0333 dot 0.38 + 0.9667 dot 0.29) = 0.043 $

]

L'analisi discriminante sfrutta il teorema di Bayes per produrre stime per una risposta qualitativa $Y$ appartenga ad una certa categoria $k = 1, 2, dots, K$, sulla base di informazioni fornite dalle feature qualitative e quantitative.

#note[
  Quando lavoriamo con probabilità condizionate, dobbiamo prestare molta attenzione al verso in cui stiamo studiando il fenomeno d'interesse.
  Per esempio $P(A | B)$ non è uguale a $P(B | A)$.

  C'è differenza tra dire:
  - _la percentuale di studenti tra chi va in default_, cioè
    $P(S | D) = 127/333 approx 0.38$;
  - _la percentuale di chi va in default tra gli studenti_, cioè
    $P(D | S) = 127/2944 approx 0.043$.
]

Se dovessimo averre più di due classi da classificare ci conviene utilizzare l'analisi discriminante lineare (LDA).

#example(name: "Bayes con più classi k")[
  Ipotizziamo che la risposta per la variabile qualitativa $Y$ possa assumere $K >= 2$ valori.

  Indichiamo con $pi_k, k = 1, 2, dots, K$ la probabilità a priori che un'osservazione scelta a caso appartenga alla classe $k$.

  Indichiamo la funzione di densità di probabilità di $X$, condizionata a $Y = k$ con:

  $ f_k (x) = "Pr"(X = x | Y = k) $

  Ci serve una funzione di densità perché $X$ può essere di carattere continuo.

  Sfruttando il teorema di Bayes otteniamo:

  $ P (Y = k | X = x) = frac(pi_k f_k (x), sum_(j = 1)^K pi_j f_j (x)) $

  Definiamo poi la probabilità a posteriori che l'unità appartenga alla classe $k$ dato il valore delle feature $X = x$:

  $ p_k (x) = P(Y = k | X = x) $

  Siccome le probabilità a priori possono essere facilmente stimate ricorrendo alle frequenze relative per ogni classe di $Y$, il problema si riduce alla determinazione di una buona stima di $f_k (x)$.
]

== Analisi discriminante lineare (LDA), p = 1

#figure(image("img/lezione9/LDA_p1.svg", width: 70%), caption: [Analisi discriminante lineare.])

L'analisi discriminante lineare, LDA, ci permette di stimare $f_k (x)$, dove $f_k$  è una normale o guassiana:

$ f_k (x) = frac(1, sigma_k sqrt(2 pi)) exp(- frac(1, 2 sigma^2_k (x - mu_k)^2)) $

Dove $mu_k$ e $sigma^2$ sono rispettivamente la media e la deviazione standard della classe $k$.

Nell'LDA assumiamo che tutte le deviazioni standard di ogni classe  \ siano uguali, quindi $sigma^2_1 = dots = sigma^2_k = sigma^2$.

Per implementare il metodo è necessario stimare i parametri per ogni classe $k$, $mu_1, dots, mu_k$, $sigma^2$, $pi_1, dots, pi_k$.

Se $n_k$ indica la numerosità di osservazioni training nel gruppo $k$, gli stimatori usati sono:

$ hat(mu)_k = frac(1, n_k) sum_(i: y_i = k) x_i $

$ hat(sigma)^2 = frac(1, n - K) sum_(k = 1)^K sum_(i: y_i = k) (x_i - mu_k)^2 $

$ hat(pi)_k = frac(n_k, n) $

#pagebreak()

#example(name: "Esempio grafico LDA")[
  #figure(
    image("img/lezione9/lda_p1.svg", width: 70%),
    caption: [A sinistra: frontiera di decisione con Bayes; A destra: frontiera di decisione con LDA.],
  )

  La LDA ci sposta la linea di separazione, LDA stima gaussiane.
  Ovviamente, dato che LDA presuppone che deviazione standard siano uguali su tutte le classi $k$, dobbiamo prestare attenzione se stiamo lavorando con un dataset sbilanciato.
]

=== LDA con più predittori, p > 1

Nel caso in cui avessimo più preditorri $X = (X_1, X_2, dots, X_p)$, l'assunzione tipica dell'LDA è che le osservazioni del gruppo $k$, provengono da una distribuzione normale multivariata $X tilde N(mu_k, Sigma)$.

#note[
  Nella LDA, il vettore $mu_k$ è specifico di ciascuna classe mentre $Sigma$ è comune a tutte le classi.
]

Un volta effettuata la stima dei parametri $(mu_k, Sigma)$, $k = 1, 2, dots, K$, le probabilità $P(Y = k | X = x)$ sono stimate ricorrendo al teorema di Bayes.

#example(name: "Esempio LDA con 3 classi")[
  Vediamo un esempio di LDA con 3 classi da classificare, di conseugenza tre frontiere di decisione.

  #figure(image("img/lezione9/lda_p2_tre_classi.svg", width: 70%), caption: [LDA con 3 classi da classificare.])

  A sinistra abbiamo la popolazione che stiamo studiando, a destra il nostro campione.

  Con la linea tratteggiata indichiamo la frontiera di decisione che otteniamo con Bayes, mentre con la linea continua la frontiera di decisione di LDA.
]

=== Analisi discriminante quadratica (QDA)

Uno dei limiti dell'analisi LDA è che otteniamo frontiere di decisioni *lineari*. Se invece avessimo bisogno di tracciare frontiere di decisione non lineari?

In questo caso usiamo l'analisi discriminante quadratica, QDA, dove per ogni classe $k$, $X tilde N(mu_k, Sigma_k)$, ovvero si presuppone che ogni gruppo abbia variabilità diversa. Questo ci torna utile per dataset sbilanciati.

#figure(image("img/lezione9/lda_qda_confronto.svg", width: 70%), caption: [Analisi QDA.])

=== Confronto LDA e QDA

Riassumendo, l'analisi LDA tende ad essere la scelta migliore se ci sono relativamente poche osservazioni di training e ridurre la variabilità è fondamentale.

Invece QDA, è consigliata se il dataset è molto grande, o se l'assunzione di una matrice di covarianza comune per le $K$ classi è chiaramente insostenibile.

=== Mixture discriminant analysis (MDA)

Per MDA si presume che ogni classe sia una miscela gaussiana di sottoclassi, in cui ogni punto ha una probabilità di appartenere a ciascuna classe.

Si assume ancora l'uguaglianza della matrice di covarianza tra le classi.

#figure(image("img/lezione9/lda_qda_mda.svg", width: 70%), caption: [Differenze LDA, QDA e MDA.])

== Regressione <regressione>

#note[
  Piccola nota, il prof vuole che si capiscano i concetti della regressione, non è necessario impararsi a memoria tutte le formule matematiche, magari capire cosa comportano e cosa rappresentano sì.
]

Fino ad ora abbiamo visto la classificazione che tramite etichette $y_i$ per che rappresentano la classe d'appartenenza di un pattern $x_i$ del dataset. L'obiettivo della classificazione è quello di apprendere un mapping dallo spazio dei pattern a quello delle etichette.

Nella *regressione* invece, non abbiamo più le etichette ma $y_i$ assume valore numerici e continui, in $RR$, qui l'obiettivo del training è quello di apprendere una funzione $f(x) arrow y$

- La funzione $f$ è controllata da un insieme di parametri. Se la dipendenza dai parametri è lineare, la regressione si definisce *lineare*.
- Nella regressione, $x$ è detta variabile *indipendente*, mentre $y$ è la variabile dipendente.
- Si assume che la variabile *indipendente* sia *esatta* mentre la variabile *dipendente* sia affetta da errore.

Il fatto che la variabile indipendente sia esatta, è una semplificazione. Esistono modelli di regressione che tengono conto dell'errore anche per la variabile $x$.

=== Regressione lineare semplice

Se la variabile dipendente $x$ è uno scalare, si parla di *simple linear regression*, ovvero *retta di regressione*.
Definiamo ora la regressione lineare semplice:

#definition(name: "Regressione lineare semplice")[
  Dato un training set *_TS_* contenente $n$ dati $(x_1, y_1), dots (x_n, y_n)$ e la seguente dipendenza tra variabile dipendente e indipendente:

  $ y_i = alpha + beta dot x_i + epsilon_i $

  - $epsilon_i$ è l'errore incognito i misura del punto $x_i$.
  - $alpha, beta$ sono parametri da determinare.
]

L'obiettivo è minimizzare l'errore $epsilon_i$, per questo esiste la soluzione ai *minimi quadrati*, least square, del problema che consiste nel determinare l'equazione della retta che minimizza la somma dei quadrati dei residui.

#figure(image("img/lezione9/regressione_residui.svg", width: 70%), caption: [Soluzione ai minimi quadrati.])

Formalmente si può definire la soluzione come:

$
  alpha^*, beta^* = italic("argmin")_(alpha,beta) sum_(i = 1, dots, n) (f(x_i) - y_i)^2 = italic("argmin")_(alpha, beta) sum_(i = 1, dots, n) epsilon_i^2
$

Per ottenere i parametri dobbiamo risolvere il sistema a due equazioni:

$
  beta^* = frac(sum_(i = 1, dots, n) (x_i - hat(x)) (y_i - hat(y)), sum_(i = 1, dots, n) (x_i - hat(x))^2)
$

$ alpha^* = hat(y) - beta^* hat(x) $

#example(name: "Regressione lineare per stimare l'altezza dal peso")[
  #figure(
    image("img/lezione9/predizione_altezza_peso.svg", width: 70%),
    caption: [Predizione dell'altezza in base al peso.],
  )
]

=== Regressione lineare multipla

Nel caso in cui la variabile indipendente $x$ sia un vettore, si parla di *multiple linear regression*, cerchiamo quindi un iperpiano di regressione.

#figure(image("img/lezione9/piano_regressione_3d.svg", width: 70%), caption: [Iperpiano di regressione.])

Generalizziamo a iperpiani $x in RR^d$, dove $d$ indica la dimensione dello spazio.
Poniamo $X$ come una matrice rettangolare di dimensioni $(n times (d + 1))$, dove $n$ è il numero di punti del training set e inserendo a destra una colonna con valori tutti a 1 per il vettore dei termini noti.

$
  X = mat(
    x_11, dots.h, x_(1d), 1;
    x_21, dots.h, x_(2d), 1;
    dots.v, dots.down, dots.v, dots.v;
    x_(n 1), dots.h, x_(n d), 1;
  )
$

E siano

#align(center)[
  $y = vec(y_1, y_2, dots.v, y_n)$ e $beta = vec(beta_1, beta_2, dots.v, beta_(d + 1))$

]

- $y$, vettore degli scalari per ogni pattern.
- $beta$, vettore dei termini noti.

Le relazioni tra variabili indipendenti e dipendenti possono essere scritte attraverso le equazioni:

$ y_i = sum_(j = 1, dots, d + 1) x_("ij") dot beta_j quad "per" i = 1, dots, n $

Oppure possiamo vedere le relazioni in forma matriciale:

$ y = X beta $

Questo con $n > (d + 1)$, $X$ è una matrice rettangolare, quindi abbiamo un sistema di equazioni sovradeterminato.
Possiamo scrivere in forma matriciale la minimizzazione del least square come:

$ ||y - X beta ||^2 $

