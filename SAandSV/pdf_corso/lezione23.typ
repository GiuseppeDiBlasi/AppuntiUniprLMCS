#import "../../Template typst/template.typ": (
  c-border, definition, example, lbs, note, rbs, separator, sqglb, sqle, sqlub, theorem,
)
#import "@preview/fletcher:0.5.8": diagram, edge, node, shapes
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

= Lezione 23 del 19 novembre 2026

In questa lezione vediamo l'analisi char inclusion per le stringhe.
Le scorse lezioni abbiamo visto post e suffix come analisi.

== Char inclusion

Partiamo definendo il dominio di char inclusion: abbiamo una coppia definita da: $(C, M C)$, con $C subset.eq M C$.

- $C$: sono i char che *sicuramente* compariranno nella stringa almeno una volta.
- $M C$: sono i char che *potrebbero* comparire nella stringa.

La coppia $(C, M C)$ è un sotto insieme dell'alfabeto $Sigma$.

Guardiamo un esempio con uno snippet di codice:

#example(name: "Esempio di char inclusion")[
  ```
  if (?)
    x = "abc";
  else
    x = "abd";
  ```

  I char che sicuramente compariranno nella stringa sono {a, b}, mentre quelli che potrebbero comparire sono: {a, b, c, d}.
  Quindi avremo $x arrow ({a, b}, {a, b, c, d})$.

]

=== Dominio astratto

Passiamo a definire formalmente il dominio astratto di char inclusion, avremo:
$ "CI" = {(C, M C) | C, M subset.eq Sigma, C subset.eq M C} union {bot_"CI"} $.

Mentre il reticolo lo definiamo come:

$ chevron.l "CI", sqle("CI"), union.sq_"CI", inter.sq_"CI", bot_"CI", (emptyset, Sigma) chevron.r $

- Elemento top: $(emptyset, Sigma)$.
- Stringa vuota: $(emptyset, emptyset)$.

=== Operatore d'ordinamento

Definiamo l'ordinamento tra due char inclusion, dobbiamo definire  la relazione:
$ (C_1, M C_1) sqle("CI") (C_2, M C_2) $

Guardiamo alcuni esempi:

#example(name: "Relazione d'ordinamento")[
  Prendiamo il caso:

  $ ({a}, {a, b}) sqle("CI") ({a}, {a, b, c}) $

  In questo caso abbiamo il primo operando dell'ordinamento che è più preciso del secondo operando, questo perché abbiamo meno char probabili e quindi più precisione.

  Vediamo un altro caso:

  $ ({a, b}, {a, b}) sqle("CI") ({a}, {a, b, c}) $

  Anche in questo caso il primo operando è più preciso, e quindi la relazione d'ordinamento è corretta.
]

Generalizziamo adesso l'operatore d'ordinamento, dobbiamo controllare che i due insiemi dei char che sicuramente compaiono nella stringa siano uno il contenuto dell'altro, stessa cosa per l'insieme dei char probabili. Otteniamo così:

$ (C_1, M C_1) sqle("CI") (C_2, M C_2) arrow C_2 subset.eq C_1 and M C_1 subset.eq M C_2 $

=== Operatore lub

Definiamo l'opreatore di lub tra due elementi del dominio, dobbiamo definire la seguente operazione:

$ (C_1, M C_1) union.sq_"CI" (C_2, M C_2) $

Guardiamo prima un esempio e poi generalizziamo:

#example(name: "Esempio lub per char inclusion")[

  Riprendiamo un altro esempio sempre su uno snippet di codice:

  ```
  if(?)
    x = "bca";
  else
    x = "efg"
  ```
  Dal primo branch otteniamo: $x arrow ({b, c, a}, {b, c, a})$, dal secondo invece $x arrow ({e, f, g}, {e, f, g})$.
  La domanda che dobbiamo farci è: qual è l'insieme dei char che sicuramente compariranno indipendentemente da quale branch viene eseguito? E quello dei char probabili?

  Per il primo insieme dobbiamo fare l'intersezione tra $C_1$ e $C_2$ che darà insieme vuoto, mentre per il secondo ci basta l'unione. Alla fine otteniamo:

  $ x arrow (emptyset, {b, c, a, e, f, g}) $

]

Generalizzando l'operatore lub abbiamo:

$ (C_1, M C_1) union.sq_"CI" (C_2, M C_2) = (C_1 inter C_2, M C_1 union M C_2) $

=== Operatore glb

L'operatore glb è il duale del lub, però solo in un determinato caso, se: $C_1 subset.eq M C_2 and C_2 subset.eq M C_1$. In tutti gli altri casi il glb restituisce bottom.

$
  (C_1, M C_1) inter.sq_"CI" (C_2, M C_2) = cases(
    (C_1 union C_2, M C_1 inter M C_2) & quad "se" C_1 subset.eq M C_2 and C_2 subset.eq M C_1,
    bot_"CI" & quad "altrimenti", gap: #1em
  )
$

Guardiamo un esempio:

#example(name: "Esempio di glb per char inclusion")[
  Prendiamo il caso:

  $ ({a}, {a, b}) inter.sq ({b}, b) $

  Applicando il glb dobbiamo controllare se:
  - ${a} subset.eq M C_2$
  - ${b} subset.eq M C_1$

  Possiamo vedere che in questo caso il risultato sarà bottom.

]

=== Funzione di concretizzazione

La funzione di concretizzazione parte dalla coppia $(C, M C)$ e ci deve restituire tutte le stringhe che hanno sicuramente i caratteri contenuti in $C$ e le stringhe che possono contenere i caratteri contenuti in $M C$.

Possiamo definire formalmente la funzione di concretizzazione come segue:

$ gamma: "CI" arrow cal(P)(Sigma^*) $

$
  gamma((C, M C)) = {sigma in Sigma^* | cases(c in C arrow c in sigma &quad "DEF", and, c in C arrow c in M C &quad "MAYBE")}
$

Riprendendo l'esempio precedente:

- $({a}, {a, b})$, genera le stringhe: ${a, b}^* a^+ {a, b}^*$
- $({b}, b)$, genera le stringhe: $b^+$
