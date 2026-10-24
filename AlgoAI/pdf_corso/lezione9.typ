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
