#import "../../Template typst/template.typ": c-border, definition, exam, example, note, theorem, warning


= Lezione 3 del 28 settembre 2026

Concetti principali: Teoria dell'informazione, distribuzioni, probabilità.

Quanti alberi di decisione possiamo avere per un determinato problema? potenzialmente infiniti.

L'algoritmo per trovare l'albero migliore è NP-completo. è un problema combinatorio.
Usiamo delle euristiche per aiutarci nel trovare la soluzione ottimale.

Un evento che è raramente probabile, ci fornisce un'elevata quantità di informazioni.

varianza: quanto mi discosto dalla media, in media. attenzione che la varianza è un termine assoluto, evitiamo indici che dipendono dalle grandezze che misuriamo.
Vogliamo indici statistici che ci diano risultati tra $[0;1]$, perché risultano facilmente interpretabili per noi esseri umani.

Iniziamo con qualche definizione.

#definition(name: "Variabili e distribuzioni")[
  Data una *variabile* $X$, indichiamo con $hat(X)$ il suo intervallo di variabilità, ovvero l'insieme dei vlaori che $X$ può assumere.

  Una distribuzione discreta di $n$ occorrenze e $k$ oggetti ci informa su come le $n$ occorrenze si distribuiscano sui $k$ oggetti designati.

  Una distribuzione è detta di probabilità se la somma dei valori ad essa assegnata è uguale ad 1.
]

Ad un possibile evento possiamo associare anche una quantità di informazione:

#definition(name: "Informazione")[
  L'informazione associata ad un possibile elemento $x in hat(X)$ che avviene con probabilità $p(x)$ è data da:

  #align(center)[
    $I(x in hat(X)) = log_2frac(1, p(x)) = - log_2(p(x))$
  ]
]

#definition(name: "Sorgente informativa")[
  Una sorgente informativa è la coppia $(X, p)$, dove $X$ è  una variabile che assume valori in un determinato insieme  e $p$ è una funzione di probabilità che assegna a tutti i suoi possibili valori una determinata probabilità.
]

Ricordiamo che la probabilità esprime un concetto *a priori*, per esempio ogni faccia di un dado a 6 facce ha 1/6 di probabilità di uscire in un lancio, ammesso che il dado non sia truccato.
Mentre la frequenza esprime concetti *a posteriori*, ovvero osserviamo i lanci del dado e vediamo se i risultati rispettano la probabilità teorica.

Un indice statistico che può tornarci utile è l'entropia, definita nel modo seguente:

#pagebreak()

#definition(name: "Entropia")[
  L'entropia di una sorgente informativa, ovvero $(X, p)$ si definisce come:

  #align(center)[
    $H(X, p) = - sum_(x in hat(X)) p(x) log_2(p(x))$
  ]

  - L'entropia raggiunge il valore massimo quando tutti gli elementi sono equiprobabili.
  - Se la base del logaritmo è $n$, allora l'entropia massima è 1.
]

Iniziamo a parlare di stringhe adesso, seguiranno anche esempi di bioinformatica.

#definition(name: "Stringa")[
  Dato un alfabeto $Gamma$, una stringa $alpha$ è una sequenza contigua di caratteri $a_1 a_2 dots a_n$ tale che $a_i in Gamma$.

  La lunghezza della stringa viene indicata con $|alpha| = n$.

  Con $lambda$, indichiamo la stringa vuota.
]

#definition(name: "Sottostringhe")[
  Indichiamo con $alpha[i]$, con $1 <= i <= |alpha|$, il carattere in posizione $i$-esima della stringa $alpha$.

  Indichiamo con $alpha[i, j]$, con $1 <= i <= j <= |alpha|$, la sottostringa di lunghezza $j - i + 1$ di $alpha$ dalla posizione $i$ alla posizione $j$, entrambe incluse.

  - $alpha[1, i]$ con $1 <= i <= |alpha|$ è un prefisso di $alpha$.
  - $alpha[i, |alpha|]$ con $1 <= i <= |alpha|$, è un suffisso di $alpha$
]

Se dovessimo prendere un considerazione un genoma $G in Gamma^*$, che possiamo vedere come una stringa, possiamo definire l'insieme dei fattori, ovvero tutte le possibili sottostringhe di $G$, come:

#definition(name: "Fattori/Dizionario")[
  Prende il nome di dizionario e viene definito come:

  $D(G) = {G[i, j] : 1 <= i <= j <= |G|}$

  - $D(G)$ si dice dizionario di $G$.
]

Possiamo definire anche l'insieme delle posizioni.

#definition(name: "Occorrenze")[
  Data una parola $alpha in D(G)$, l'insieme delle posizioni in cui $alpha$ occorre in $G$ è dato da:

  #align(center)[
    $"pos"_G (alpha) = {i: G[i, j] = alpha}$
  ]

  Invece per il numero di occorrenze ci serve la molteplicità di $alpha$ in $G$.

  #align(center)[
    $"mult"_G (alpha) = |"pos"_G (alpha)|$
  ]

  Possiamo anche definire:
  - *hapax*, una parola che occorre una sola volta, $alpha: "mult"_G(alpha) = 1$
  - *repeat*, una parola che occorre almeno due volte, $alpha: "mult"_G(alpha) > 1$
  - Un repeat è massimale se $forall x in Gamma => "mult"_G (alpha x) = 1$, diventa un hapax.
  - Un hapax $alpha = (a_1, dots, a_(n-1), a_n)$ è *minimale* se $"mult"_G ((a_1, dots, a_(n-1))) > 1$
  - Un *nullomero* è una parola che non occorre in $G$, $alpha : "mult"_G (alpha) = 0 => alpha in.not D(G)$
]

#definition(name: "K-meri")[
  Data una lunghezza di una parola $k$, i fattori di $G$ lunghi $k$ sono anche detti $k$-mer.

  Possiamo definirlo come:

  $D_k (G) = {alpha in D(G) : |alpha| = k}$
]

Passiamo ora a formalizzare le distrubuzioni.

#definition(name: "Distribuzione")[
  Una distribuzione $Phi : A -> B$ è una funzione che mappa elementi di $A$ sugli elementi dell'insieme $B$.

  Una distribuzione è discreta se il suo dominio è un insieme discreto.
]

#definition(name: "Distribuzione di molteplicità")[
  Una distrubuzione è detta di molteplicità se il suo codominio è l'insieme dei numeri naturali e se essa rappresenta una misura di molteplicità, ovvero una quantità.
]

#definition(name: "Distribuzione di frequenza")[
  Una distribuzione si dice di frequenza se il suo codominio è l'insieme dei numeri reali $RR$ e se $sum_(x in A) Phi(A) = 1$

  Da una distribuzione di molteplicità, possiamo otterne una di frequenza, trasformiamo le molteplicità in frequenze (gli elemnti di $B$).
]

#definition(name: "Distribuzione di prboabilità")[
  Uan distribuzione di frequenza è detta di probabilità se gli elementi del suo codominio rappresentano delle probabilità.
]
