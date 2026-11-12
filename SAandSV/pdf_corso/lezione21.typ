#import "../../Template typst/template.typ": (
  c-border, definition, example, lbs, note, rbs, separator, sqglb, sqle, sqlub, theorem,
)
#import "@preview/fletcher:0.5.8": diagram, edge, node, shapes
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

= Lezione 21 del 12 novembre 2026

In questa lezione estendiamo il linguaggio Imp ad utilizzare le stringhe definendo la semantica concreta e introduciamo anche varie analisi per le stringhe.

Partiamo con definire la semantica concreta per le stringhe.

== Semantica concreta per le stringhe in Imp

Possiamo definire le stringhe in Imp come:

- $Sigma$, alfabeto finito.
- $Sigma^*$, stringa che appartiene all'alfabeto.
- '', stringa vuota.
- 'abc', esempio di stringa.
- $sigma in Sigma^*$, stringa.
- $|sigma|$, lunghezza della stringa.
- $sigma_i$, carattere i-esimo della stringa $sigma$, $i in [0, sigma_(i -1)]$
- $sigma_1, sigma_2$, concatenazione tra due stringhe.
- $sigma[i, j]$, sottostringa tra i e j, i è incluso mentre j è escluso.

Possiamo estendere la grammatica del linguaggio Imp per accettare le stringhe nel seguente modo:

Per le produzioni per le stringhe abbiamo:

- $s := \'sigma\' | s_1 + s_2 | "substring"_i^j (s)$

Mentre estendendo le produzioni per gli statement:

- $"st" := dots | x = a | x = s$

Estendiamo anche le produzioni delle espressioni booleane:

- $b := dots | s_1 == s_2 | "contains"_c (s), c in Sigma$

#note[
  Per motivi di semplicità definiamo la funzione substring con unico argomento la stringa s, altrimenti durante l'analisi dovremmo tenere conto anche dei due indici come argometo.

  Questo ci permette di concentrarci esclusivamente sull'analisi delle stringhe.
]

Definiamo ora la valutazione della semantica concreta definendo la funzione memoria per solamente le stringhe, questa volta avremo una funzione $MM$ che prende in input variabili $VV$, e ci restituisce in output una stringa dell'alfabeto, $Sigma^*$.

$ MM: VV arrow Sigma^* $

definiamo ora la semantica concreta:

- $lbs dot rbs_s : MM arrow Sigma^*$

- $lbs \' sigma \' rbs_s m arrow sigma$

- $lbs s_1 + s_2 rbs_s m arrow lbs s_1 rbs m quad lbs s_2 rbs m$

- $lbs "substring"_i^j (s) rbs_s m arrow (lbs s rbs_s m) [i : j] quad "se" j <= |sigma|$

Definiamo la semantica per le espressioni booleane per accettare le stringhe:

- $lbs dot rbs_b MM arrow {"TT", "FF"}$

- $lbs s_1 = s_2 rbs_b m = cases(
    "TT" & quad lbs s_1 rbs_s m == lbs s_2 rbs_s m,
    "FF" &quad "altrimenti"
  )$

- $lbs "contains"_c (s) rbs_b m = exists i in [0; |lbs s rbs_s m - 1] (lbs s rbs_s m)_i = c$

#v(0.5cm)

Abbiamo diversi tipi di analisi che possiamo fare sulle stringhe, per esempio possiamo fare la *prefix domain*, *suffix domain* e la *char inclusion domain*.

In questa lezione guardaremo la *prefix domain*, partiamo definendo il reticolo astratto, come insieme di elementi del reticolo avremo parti di $Sigma^*$, come operatore di ordinamento $subset.eq$, lub e glb rispettivamente: $union, inter$.
L'elemento top, è l'elemento che è prefisso di qualunque stringa, quindi la stringa vuota: $emptyset$.
Mentre come bottom avremo la stringa $Sigma^*$.

Questo è il dominio concreto:
$ chevron.l cal(P)(Sigma^*), subset.eq, union, inter, emptyset, Sigma^* chevron.r $


== Analisi del prefisso

Iniziamo a definire l'analisi del prefisso, partiamo da un esempio:

$ {"ab", "abc", "abcd"} attach(arrow, t: alpha) ? $

Prendiamo in considerazione il seguente insieme di stringhe, applicando una funzione di astrazione $alpha$, qual è il prefisso astratto che otteniamo?
In questo caso applicando $alpha$ otteniamo ${"ab*"}$.

In questo contesto usiamo '\*' dopo il prefisso per indicare che non sappiamo cosa viene dopo. Indica una stringa che inizia per 'ab', e dopo il prefisso ho un determinato numero di caratteri di cui non sono a conoscenza.

Possiamo definire il reticolo dell'analisi del prefisso come:

$ chevron.l Sigma^* union {bot_"PR"}, sqle("PR"), union.sq_"PR", inter.sq_"PR", epsilon, bot_"PR" chevron.r $

Possiamo notare che questo è un dominio infinito, ma è anche un dominio ACC, dato che una catena ascendente tende a stabilizzarsi nella stringa vuota $epsilon$.

#align(center)[


  #scale(70%, reflow: true)[
    #figure(
      diagram(
        node-stroke: none,
        spacing: (3cm, 1.6cm),

        // nodi
        node((1, 0), $epsilon$, name: <eps>),
        node((1, 1), $"ab"^*$, name: <ab>),
        node((0, 2), $"acc"^*$, name: <acc>),
        node((1, 2), $"abc"^*$, name: <abc>),
        node((2, 2), $"abb"^*$, name: <abb>),
        node((1, 3), $"abcd"^*$, name: <abcd>),
        node((1, 4), $bot$, name: <bot>),

        // archi
        edge(<eps>, <ab>, "-", stroke: (dash: "dotted")),
        edge(<ab>, <abc>, "-"),
        edge(<abc>, <abcd>, "-"),
        edge(<abcd>, <bot>, "-"),

        // archi tratteggiati
        edge(<abb>, <bot>, "-", stroke: (dash: "dashed")),
        edge(<eps>, <acc>, "-", stroke: (dash: "dashed")),
        edge(<acc>, <bot>, stroke: (dash: "dashed")),
        edge(<ab>, <abb>, "-"),

        edge(<abb>, <eps>, "-", stroke: (dash: "dashed")),
      ),
      caption: [Reticolo parziale dell'analisi del prefisso.],
    ) <ret-pref>
  ]
]

Dal reticolo possiamo definire la relazione d'ordine tra due prefissi $P_1$ e $P_2$:

$ P_1 sqle("PR") P_2 <=> P_1 = bot_"PR" or (|P_2| =< |P_1| and forall i in [0, |P_2| - 1]: P_2_i = P_1_i) $

Possiamo anche leggerla come: il prefisso $P_1$ è più preciso del prefisso $P_2$, esempio: $"ab*" sqle("PR") "c*"$.

Tra il reticolo concreto e quello astratto abbiamo una connessione di Galois:

$
  cal(P)(Sigma^*) #box(baseline: 30%, stack(
    dir: ttb,
    spacing: 6pt,
    $attach(arrow.r.long, t: alpha_"PR")$,
    $attach(arrow.l.long, b: gamma_"PR")$,
  )) "PR"
$

Quando abbiamo una connessione di Galois, possiamo indurre la funzione $alpha$ partendo dalla funzione $gamma$ per qualunque dominio.
In questo contesto possiamo definire la funzione di concretizzazione $gamma_"PR"$ come:

$
  gamma_"PR" (P) = cases(
    emptyset & P = bot_"PR",
    {sigma in Sigma^* | |sigma| >= |P| and forall i in [0, |P| - 1 ], sigma_i = P_i} & "altrimenti"
  )
$

La funzione gamma ci restituisce tutte le stringhe che iniziano per il prefisso $P$ quando l'argomento della funzione è un prefisso valido, altrimenti ci restituisce l'insieme vuoto.

La funzione $alpha_"PR"$ invece è definita nel seguente modo:

$ alpha_"PR" (S) = inter.sq {p in "PR" | S subset.eq gamma_"PR" (S)} $

#pagebreak()

#example(name: [Esempio con $alpha_"PR"$.])[
  Facciamo un esempio per la funzione $alpha_"PR"$, prendiamo in considerazione il reticolo dei prefissi (@ret-pref).

  Prendiamo come set di stringhe $S = {"abcd", "abb"}$.

  Per questo set di stringhe dobbiamo trovare tutti i prefissi comuni per ogni elemento di $S$.
  In questo caso possiamo vedere che le due stringhe 'abcd' e 'abb', condividono il prefisso *'ab'*, e banalmente anche il prefisso '$epsilon$'.

  Guardando la definizione di $alpha_"PR"$, dobbiamo controllare che l'insieme delle stringhe $S$ sia contenuto nell'insieme ${p in "PR" | gamma_"PR" (p)}$:

  - $epsilon^*: S subset.eq gamma_"PR" (epsilon^*)$.
  - $"ab"^* : S subset.eq gamma_"PR" ("ab"^*)$.

  Quindi applicando $alpha_"PR" (S) = inter.sq {"ab", epsilon}$, dobbiamo fare il glb tra questi due elementi, che è *'ab'*.

  #separator()

  Prendiamo un altro caso dove il set di stringhe è $S = {"abcd", "abb", "amz"}$.

  Prendiamo come prefissi per $S$, ${epsilon^*, a^*, "ab"^*}$ e controlliamo che sia rispettata la condizione di inclusione.

  - $epsilon^*: S subset.eq gamma_"PR" (epsilon^*)$.
  - $a^*: S subset.eq gamma_"PR" (a^*)$.
  - $"ab"^*: S cancel(subset.eq) gamma_"PR" ("ab"^*)$.

  In questo caso i prefissi astratti su cui dobbiamo fare il glb sono: ${epsilon^*, a^*}$.

  Quindi troviamo: $alpha_"PR" (S) = inter.sq {epsilon^*, a^*} = a^*$
]

== Semantica astratta per prefix domain

Come per gli altri domini astratti che abbiamo visto nelle lezioni precedenti, dobbiamo definire la semantica astratta per il prefix domain.

- $lbs dot rbs^"#" MM^"#" arrow "PR"$

- $lbs 'sigma' rbs^"#" m^"#" = sigma *$

- $lbs s_1 + s_2 rbs^"#" m^"#" = lbs s_1 rbs^"#" m^"#"$; concatenare due stringhe vuol dire che cerco sempre il prefisso di $s_1$.

- $lbs "substring"_i^j (s) rbs^"#" m^"#"= cases(p[i : j] &quad j <= |P|, p[i : |P| - 1] &quad i < |P| and thick j > |P|, epsilon^* &quad "altrimenti")$

Nel caso della sottostringa, la valutazione di 'substring(s)' restituisce un prefisso $p$: $lbs s rbs^"#" m^"#" = p$.

Guardiamo degli esempi per 'substring':

#pagebreak()

#example(name: "Esempi substring astratta.")[
  Prendiamo un prefisso $p = "abcde"^*$ e consideriamo le seguenti applicazioni di 'substring' nel contesto astratto:
  Ricordiamo che le stringhe partono da 0, e che l'estremo j per 'substring' è escluso.


  - $"substring"_0^3(p) = "abc"^*$

  - $"substring"_2^3(p) = "c"^*$

  - $"substring"_7^12(p) = epsilon^*$

  - $"substring"_2^5(p) = "cde"^*$

  - $"substring"_0^10 (p) = "abcde"^*$

]
