#import "../../Template typst/template.typ": c-border, definition, exam, example, note, theorem, warning

= Lezione 4 del 2 ottobre 2026

In questa lezioen si prosegue con richiami di probabilità e statistica.

Abbiamo sempre parlato di sample e di popolazioni, i sample possiamo vederli come dei vettori definiti all'interno di uno spazio vettoriale su cui calcoliamo la distanza tra sample.
Altre reti neurali, per esempio le CNN o gli LLM, lavorano su tensori, cioè array multidimensionali che generalizzano il vettore a più indici (ad esempio un'immagine ha rango 3: altezza, larghezza, canali).

_Questa definizione vale per i nostri scopi, se fossimo in contesto fisico o matematico puro avrebbe una definizione completamente diversa._

== Indici statistici delle distribuzioni

Vediamo ora quali indici statistici possiamo usare per studiare le distribuzioni.
Parleremo di *momenti* di origine $m$ e ordine $k$ di una variabile casuale $X$ è definito come il valore atteso della k-esima potenza dei valori di $X$.

#definition(name: "Primo momento, media o valore atteso")[
  La media, o valore atteso è così definita:

  #align(center)[
    $E[X] = sum_i p_i x_i$
  ]
]

#definition(name: "Secondo momento, varianza")[
  Il secondo momento centrale, chiamato anche varianza, misura la dispersione dei valori della variabile attorno alla media: è il valore atteso del quadrato degli scarti da $mu$.

  #align(center)[
    $"var"(X) = E[ (x - mu )^2] = sum_i p_i(x_i - mu)^2$
  ]

  - $mu$ è la media.

  La varianza possiamo riscriverla anche come:

  #align(center)[
    $"var"(X) = E[X^2] - (E[X])^2$
  ]

  Questo può tornarci molto utile se dovessi lavorare su dataset di dimensioni piuttosto elevate permettendoci in una sola passata di calcolare media e varianza.
]

#definition(name: "Deviazione standard")[
  La deviazione standard misura la dispersione tipica dei valori attorno alla media, espressa nella stessa unità di misura di $X$. È definita come la radice quadrata della varianza:

  #align(center)[
    $sigma = "sd"(X) = sqrt("var"(X))$
  ]
]

#pagebreak()

#note[
  _Qual è la differenza tra varianza e deviazione standard?_

  Guardando le definzioni più o meno raccontano la stessa cosa, quanto ci si discosta dalla media, ma esiste una differenza tra le due.
  Rappresentano la stessa informazione, ma in modo diverso.

  Andando più nel dettaglio:

  *Varianza*:
  - L'unità di misura è il quadrato di quella di $X$.
  - Non è direttamente confrontabile con i valori o la media.
  - È comoda matematicamente: additiva per variabili indipendenti, $"var"(X + Y) = "var"(X) + "var"(Y)$

  *Deviazione standard*:
  - Stessa unità di misura di $X$.
  - Si legge direttamente come: "I valori si disperdono tipicamente di $sigma$ attorno alla media."
  - Non è additiva per variabili indipendenti $"sd"(X + Y) = sqrt("sd"(X) + "sd"(Y))$

  Esempio: Altezze in cm con $sigma = 10$ cm: la varianza vale $100 "cm"^2$. Dire 100 $"cm"^2$ non ti dice subito quanto sono sparse le altezze; dire 10 cm sì, e puoi dire che circa il 68% dei valori sta entro $mu plus.minus 10$ (se la distribuzione è gaussiana).

  Riassumendo, si usa la varianza per fare i calcoli e la deviazione standard per comunicare e interpretare il risultato. Se $sigma$ è grande o piccola dipende solo dal confronto con la scala dei dati (per questo a volte si usa il coefficiente di variazione $frac(sigma, mu)$).
]

#definition(name: "Coefficiente di variazione")[
  È definito come il rapporto tra la deviazione standard e il valore assoluto della media.

  #align(center)[
    $frac("sd"(X), abs(mu))$
  ]

  Ci permette di misurare la dispersione relativa alla scala dei dati.
  Puo tornarci utile per confrontare la variabilità di feature con scale diverse, per esempio per trovare feature costanti o rumorose.
]

#definition(name: "Terzo momento, skewness")[
  La skewness è definita come:

  #align(center)[
    $gamma = E[(frac(X - mu, sigma))^3$
  ]

  Ci permette di dire dove troviamo la coda più lunga:
  - Con skewness > 0 la coda lunga è verso destra, moda < mediana < media
  - Con skewness < 0 la coda lunga è a sinistra, media < mediana < moda
  - Nel caso in cui la skewness sia 0, moda, media e mediana coincidono.

  #figure(
    image("img/skewness.svg", width: 100%),
    caption: [Grafico skewness di una distribuzione],
  )
]

#definition(name: "Quarto momento, indice di Kurtosis")[
  È un indice di allungamento, o appiattimento della coda della distribuzione.

  #align(center)[
    $"Kurt"(X) = E[(frac(X - mu, sigma))^4]$
  ]
]

Ora diamo un'occhiati agli indici di dispersione e di diversità.


Un *indice di dispersione* riassume la misura con la quale i valori di una distrubizione statistica quantitativa sono distanti da un valore centrale (media o mediana).

Se la variabile statistica è di tipo nominale, allora prende il nome di indice di diversità.
Una variabile si dice nominale quando il carattere statistico che stiamo studiando assueme stati discreti non ordinabili.

#definition(name: "Indice di Simpson")[
  L'indice di Simpson è una misura quantitativa che riflette quanti tipi di (specie) diverse ci sono in un dataset (comunità).

  La diversità ha tre aspetti principali, che l'indice sintetizza in un unico valore:
  - Ricchezza (richness): Il numero di specie diverse.
  - Equitabilità: grado di omogeinità con il quale gli individui sono distribuiti nelle varie specie che compongono una comunità.
  - Dominanza: Il grado con cui uan specie è dominante verso le altre specie facenti parte della comunità.

  È definito come:

  #align(center)[
    $lambda = sum_(i = 1)^R thick p_i^2$

    - $R$ è la ricchezza, ovvero il numero di specie distinte nella comunitàe $p_i$ è l'abbondanza della $i$-esima specie.
  ]
]

#pagebreak()

#definition(name: "Indice di Shannon (Entropia di Shannon)")[
  L'indice di Shannon è un indice di diversità basato sulla media pesata dei logaritmi dell'abbondanza proporzionale della specie in una comunità.
  È definito come:

  #align(center)[
    $H = - sum_(i = 1)^R thick p_i ln(p_i)$
  ]
]

#definition(name: "Numeri di Hill")[
  I numeri di Hill sono una generalizzazione delle misure di diversità.

  Dato un ordine q, la diversità è misurata prendendo in considerazione il reciproco della media generalizzata $M_(q - 1)$ dell'abbondanza proporzionale dei tipi nel dataset.

  È definita come:

  #align(center)[
    $attach(D, tl: q) = frac(1, M_(q -1)) = frac(1, root(q-1, sum_(i = 1)^R p_i thick p_i^(q-1))) = (sum_(i = 1)^R p_i^q)^frac(1, 1 - q)$
  ]

  - Per $q = 0$ è la media delle abbondanze.
  - Per $q = 1$ non è definità, tuttavia si può calcolare il limite per $q$ che tende a 1 e si ottiene:

  #align(center)[

    $attach(D, tl: 1) = frac(1, product_(i = 1)^R p_i^(p_i)) = e^( - sum_(i = 1)^R p_i thick ln(p_i))$
  ]

  - Il logaritmo di $attach(D, tl: q)$ è l'*entropia di Rényi* di ordine $q$, che generalizza l'entropia di Shannon (ottenuta per $q != 1$):

  #align(center)[
    $ln(attach(D, tl: q))$
  ]

  - Per $q = 2$ equivale all'inverso dell'indice di Simpson:

  #align(center)[
    $attach(D, tl: 2) = frac(1, lambda)$
  ]
]

#pagebreak()

== Confrontare distribuzioni

Riassumere una distribuzione in un solo indice statistico è svantaggioso se vogliamo confrontare le proprietà di due distribuzioni diverse fra loro.
Potremmo utilizzare misure come:
- Similarità tra gli insiemi.
- Vicinanza/prossimità per spazi vettoriali.
- Correlazione tra variabili.
- Divergenza tra distribuzioni di probabilità.

Un modo per calcolare la similiratà tra due insiemi, che abbiamo visto in laboratorio, è la *similarità di Jaccard*.

#definition(name: "Similarità di Jaccard")[
  Ci dice quanto due insiemi siano simili, ovvero quanti elementi hanno in comune.
  Se prendiamo l'esempio di due dizionari dei k-meri di due genomi $G_1$ e $G_2$ abbiamo:

  #align(center)[
    $J_k (G_1, G_2) = frac(abs(D_k (G_1) inter D_k (G_2)), abs(D_k (G_1) union D_k (G_2)))$
  ]

  #figure(
    image("img/jaccard.svg", width: 100%),
    caption: [Valori possibili per la similarità di Jaccard],
  )
]

#definition(name: "Similarità di Jaccard generalizzata, per multi insiemi")[
  Questo ci permette di dire quanto due multi insiemi siano simili, ovvero ci permette di tenere in considerazione anche le molteplicità degli elementi.
  Sia $D_k (G_1, G_2) = D_k (G_1) union D_k (G_2)$, allora:

  #align(center)[
    $J'_k (G_1, G_2) = frac(sum_(alpha in D_k (G_1, G_2)) min("mult"_(G_1) (alpha), thick "mult"_(G_2)(alpha)), sum_(alpha in D_k (G_1, G_2)) max("mult"_(G_1) (alpha), thick "mult"_(G_2)(alpha)))$
  ]
]

Un altro modo per confrontare distribuzioni è quello di usare le distanze.

#definition(name: "Distanza del coseno")[
  Misura il coseno dell'angolo formato dai due vettori in uno spazio $n$ dimensionale. Questo ci restituisce valori compresi in un intervallo tra $[-1: 1]$.

  Prendiamo in considerazione due vettori $A, B in RR^n$:

  #align(center)[
    $"cos_sim(A, B)" = frac(< A | B >, <A | A> thick <B | B >) = frac(sum_(i = 1)^n A[i]B[i], sqrt(sum_(i = 1)^n A[i]^2) sqrt(sum_(i = 1)^n B[i]^2))$
    - $< | >$, indica il prodotto scalare tra i due vettori.
  ]

]

#definition(name: "Distanza di Minkowski")[
  La distanza di Minkowski è la metrica indotta dalla norma $cal(l)_k$ sullo spazio vettoriale normato $RR^n$ (per $k >= 1$), cioè $d_k(A,B) = |A-B|_k$.
  Uno spazio vettoriale normato è uno spazio vettoriale su cui è definita una norma, ovvero una funzione che assegna a ogni vettore una lunghezza.

  Dato $k in NN^+$ e due vettori $A, B in RR^n$ è definita come:

  #align(center)[
    $ d_k (A, B) = (sum_(i = 1)^n abs(A[i] - B[i])^k)^(1/k) = root(k, sum_(i = 1)^n abs(A[i] - B[i])^k) $
  ]
  È la generalizzazione della distanza euclidea, per $k = 2$ e della distanza di Manhattan quando $k = 1$.
]

#definition(name: "Correlazione di Pearson")[
  La correlazione di Pearson misura il grado di dipendenza *lineare* tra due variabili reali, cioè quanto i loro scostamenti dalla media tendono a concordare.
  Essa è definita come:

  #align(center)[
    $rho (X, Y) = frac("cov"(X, Y), sigma_X thick sigma_Y)$
  ]

  - $rho$ assume valori compresi nell'intervallo $[-1: 1]$.
  - Se $rho = 1$, le due variabili sono correlate in modo crescente.
  - Se $rho = -1$, le due variabili sono correlate in modo decrescente.
  - Se $rho = 0$ , le due variabili non sono in correlazione tra loro.

  dove $"cov"(X,Y)$ è la covarianza tra le due variabili $X$ e $Y$, definita come il valore atteso del prodotto delle deviazioni dalle rispettive medie. Su $n$ osservazioni si stima con la media dei prodotti degli scarti:

  #align(center)[
    $"cov"(X, Y) = E[(X - E[X])(Y - E[Y])] = frac(1, n) sum_(i = 1)^n (x_i - overline(x))(y_i - overline(y))$
  ]

]

#definition(name: "Correlazione di Spearman")[
  È la correlazione di Pearson calcolata sui ranghi anziché sui valori: al posto di $x_i$ si usa $R(x_i)$, la posizione di $x_i$ nell'ordinamento dei valori di $X$. Misura quindi la dipendenza monotòna tra le variabili.
]

#definition(name: "Correlazione di Kendall")[
  Considera tutte le coppie di osservazioni $(i, j)$ e conta quante sono concordanti (le due variabili ordinano i punti nello stesso modo) e quante discordanti (inversioni di rango):

  #align(center)[
    $r = frac(C - D, binom(n, 2)) = frac(C - D, frac(n(n-1), 2))$
  ]

  dove $C$ è il numero di coppie concordanti, $D$ quello delle discordanti e $binom(n, 2) = frac(n(n-1), 2)$ il numero totale di coppie.
]
