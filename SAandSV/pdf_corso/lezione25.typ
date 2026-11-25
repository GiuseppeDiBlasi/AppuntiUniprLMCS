#import "../../Template typst/template.typ": (
  c-border, definition, example, lbs, note, rbs, separator, sqglb, sqle, sqlub, theorem,
)
#import "@preview/fletcher:0.5.8": diagram, edge, node, shapes
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

= Lezione 25 del novembre 2026

Questa è l'ultima lezione di teoria, le lezioni successive copriranno gli argomenti coperti dai seminari.

In una delle scorse lezioni avevamo accennato la possibilità di combinare domini tramite prodotto cartesiano e prodotto ridotto.

== Combinazione di domini astratti

Per combinare due domini astratti $A$ e $B$, che approssimano un dominio concreto $C$, vogliamo ottenere un nuovo dominio astratto che è una *combinazione* del dominio $A$ e del dominio $B$.
Degli esempi di combinazione possono essere:

- Intervalli e parità.
- Parità e segno.

Ipotizziamo di avere il seguente snippet di codice:

```C
read(x)
x = abs(x)
y = x * 2

if (x * y > 0 && y % 2 = 0) 
// ...

```

Con questo snippet di codice l'analisi dei segni può darci informazioni sulla prima condizione dell'if: $(x * y > 0)$; mentre la parità può darci informazioni sulla seconda parte dell'if: $(y thick % thick 2 = 0)$. Dobbiamo trovare un modo di combinare i due domini in modo da poter rappresentare entrambe le informazioni.

=== Prodotto cartesiano

Possiamo combinare due domini astratti $A$ e $B$ tramite prodotto cartesiano: $A times B$.
Le operazioni di ordinamento parziale, lub e glb vengono definite per ogni dominio.

$ (a, b) sqle(A times B) (a', b') <=> a sqle(A) a' and b sqle(B) b' $

Un esempio di dominio combinato, come detto prima è:

$ "Sign" times "Parity" => (+, "Pari") $

#pagebreak()

#example(name: "Combinazione dominio intervalli con dominio parità")[
  Combiniamo il dominio degli intervalli con quello di parity:

  $ "Intv" times "Parity" $

  -$ ([2, 4], "Odd") subset.eq ([1, 5], top) arrow [2, 4] sqle("Intv") [1, 5] or "Odd" sqle("Par") T $

  -$ ([2, 4], "Odd") union.sq ([1, 3], "Even") = ([1, 4], top) $

  -$ ([1, 5], "Odd") inter.sq ([2, 6], top) = ([2, 5], "Odd") $

  Nel caso di operazioni astratte tra due elementi del dominio astratto, l'operatore viene applicato point wise, cioè ad ogni elemento proprio come lub, glb e ordinamento.

]

Guardando agli esempi precedenti, come possiamo definire la funzione di concretizzazione $gamma$? È l'intersezione delle funzioni $gamma$ dei domini.
Nel caso di $([2, 5], "Odd")$, la $gamma$ ci restituisce tutti i numeri compresi nell'intervallo $[2, 5]$ che devono rispettare la condizione di essere dispari. Quindi avremo $gamma (([2, 5], "Odd")) = {3, 5}$.

Notare che il prodotto cartesiano forma una connessione di Galois con il dominio concreto $C$.

- $gamma_(A times B) ((a, b)) = gamma_A (a) inter gamma_B (b)$

- $alpha_(A times B) (S) = (alpha_A (S), alpha_B (S))$


==== Limiti del prodotto cartesiano

Il prodotto cartesiano corrisponde a eseguire le due analisi separatamente e poi unire i risultati, quindi non abbiamo una 'relazione' tra le analisi mentre sono in corso. Non abbiamo alcun guadagno nell'eseguire le analisi simultaneamente rispetto ad eseguirle in sequenza, non abbiamo alcun tipo di comunicazione tra le analisi.

Consideriamo il seguente caso:

- Analisi $"Intv" times "Parity"$

- Consideriamo gli elementi del dominio: $([2, 4], "Odd"), ([2, 3], "Odd"), ([3, 4], "Odd"), ([3, 3], "Odd")$

Tutti questi elementi astratti rappresentano lo stesso elemento concreto ${3}$, questo porta ad imprecisioni e analisi non efficienti.

#pagebreak()

#note[
  Dato che abbiamo elementi ridondanti nel dominio astratto per lo stesso elemento concreto, non abbiamo un'inerzione di Galois, quindi non vale la condizione $alpha compose gamma = "id"$
]

Per risolvere questo problema si usa l'*operatore di riduzione*.

=== Operatore di riduzione

Per risolvere il problema dobbiamo introdurre l'operatore di riduzione $rho: A arrow A$ (rho) che soddisfi queste due proprietà:

- $rho(a) subset.sq_A a$ : il risultato della sua applicazione è un elemento astratto più preciso di quello di partenza.

- $gamma(rho(a)) = gamma(a)$: l'elemento astratto e la sua astrazione rappresentano la stessa proprietà.

Guardiamo un esempio dell'uso dell'operatore di riduzione:

#example(name: "Esempio operatore di riduzione")[
  Prendiamo il dominio $"Intv" times "Parity"$, e lo stesso elemento astratto $([2, 4], "Odd")$.

  Applichiamo l'operatore di riduzione $rho$ e otteniamo:

  $ rho(([2, 4], "Odd")) = ([3, 3], "Odd") $

  Ipotizziamo di avere il dominio $"Sign" times "Intv"$ e l'elemento astratto $(+, [-5, 5])$.

  Applicando l'operatore di riduzione otteniamo:

  $ rho((+, [-5, 5])) = (+, [1, 5]) $
]

== Prodotto ridotto

Possiamo definire il prodotto ridotto tra due insiemi astratti $A$ e $B$ in relazione tramite prodotto cartesiano i cui elementi sono:

$ {rho((a, b)) | (a, b) in A times B} $

Dove l'operatore di riduzione è definito come:

$ rho((a, b)) = inter.sq {(a', b') | gamma_(A times B) (a, b) subset.eq gamma_(A times B) (a', b')} $

=== Limiti del prodotto ridotto

Il prodotto ridotto corrisponde alla complessità del prodotto cartesiano più l'uso dell'operatore di riduzione. In generale il costo di un'operazione di riduzione può essere piuttosto complessa.

L'altezza del reticolo ha un upper bound definito da: $|A| dot |B|$.

Un altro problema è dovuto all'implementazione: dovremmo specificare un prodotto ridotto per ogni dominio che vogliamo raffinare. A differenza del prodotto cartesiano che era un procedimento autoamtico il prodotto ridotto richiede di dover definire e implementare come le informazioni si muovono lungo i due domini.

Per il prodotto ridotto vogliamo poter raffinare sia dal dominio A al dominio B e vicervesa.

#align(center)[
  #diagram(
    spacing: (2.5em, 2em),

    node((0, 0), $A$, name: <a>),
    node((1.2, 0), $inter.sq$, name: <p>),
    node((2, 0), $B$, name: <b>),

    // frecce tra i due domini
    edge(<a>, <b>, "->", bend: 45deg),
    edge(<b>, <a>, "->", bend: 45deg),

    // etichetta
    node((2, 1), text(fill: blue)[Prodotto ridotto], name: <l>),
    edge(<p>, (1, 1), <l>, "->", stroke: blue),
  )
]

In questo caso il simbolo di glb indica il prodotto ridotto tra due domini. Vogliamo che le informazioni passino da un dominio all'altro e vicervesa.


== Prodotto di Granger

Siccome il prodotto ridotto è complesso da implementare possiamo utilizzare il *prodotto di Granger* che ci permette di calcolare una sovrapprossimazione dell'operatore di riduzione.

Il prodotto di Granger definisce due operatori:

- $rho_A$ da $A times B$ ad $A$, che raffina $A$, nel dettaglio:\ $rho_A ((a, b)) sqle(A) and gamma_(A times B) ( (rho((a, b))), b ) = gamma_(A times B ((a, b)))$

#v(1.5em)

- $rho_B$ da $A times B$ a $B$, che raffina $B$, nel dettaglio:\ $rho_B ((a, b)) sqle(B) and gamma_(A times B) ((a, rho_B (a, b)))) = gamma_(A times B) ((a, b))$

L'operatore di riduzione è definito come il fixpoint dell'iterazione decrescente nel seguente modo:

- $(a_0, b_0) = (a, b)$
- $(a_(n + 1), b_(n + 1)) = (rho_A ((a_n, b_n)), rho_B ((a_n, b_n)) ) arrow$ questo ci fa perdere precisione.

Ricapitolando velocemente, il prodotto di Granger è più efficiente del prodotto ridotto ma è meno preciso.
Evitiamo anche di dover definire il prodotto ridotto per ogni dominio e dobbiamo preoccuparci di definire solo $rho_A$ e $rho_B$.

#note[
  Nel caso in cui le informazioni vadano solo dal dominio $A$ al dominio $B$, o vicervesa, quindi non ho un possibile scambio reciproco di informazioni. In quel caso si dice che $A$ è una pre analisi di $B$. Il prodotto ridotto ci conviene solamente quando abbiamo un mutuo scambio di informazione tra i due domini.

]

== Potenza cardinale ridotta

La *potenza cardinale ridotta* ci permette di tenere traccia di informazioni relazionali su valori astratti dell'analisi.

Per esempio, se avessimo il dominio degli intervalli e il dominio di parità, possiamo tenere traccia della relazione: _'Quando $x$ è dispari, y è contenuta in [0, 10].'_

Un elemento $(a, b) in B^A$ significa che che lo stato $a$ implica lo stato $b$.

#pagebreak()

== Smashed sum

Partiamo da uno snippet di codice:

```C
  if (?)
    x = 1
  else 
    x = "hello"

```

Possiamo definire due insiemi astratti, un insieme $A$ per gli interi, magari il dominio degli intervalli, e un insieme $B$ di costant propagation per le stringhe. Dobbiamo capire come combinare questi due domini.

Potremmo usare il prodotto cartesiano, però stiamo rappresentando informazioni diverse tra loro.


In questo caso ci conviene usare la smashed sum, ovvero combiniamo i due domini in modo da crearne uno solo. Avevamo già visto questa "trasformazione", dobbiamo unire i due top e i due bottom dei due domini in uno solo.

#align(center)[
  #figure(
    diagram(
      spacing: (3em, 1.8em),

      // top e bottom della smashed sum
      node((1, 0), text(fill: red, $top_(plus.o)$), name: <top>),
      node((1, 4), text(fill: red, $bot_(plus.o)$), name: <bot>),

      // top dei due domini
      node((0, 1), $[-infinity, +infinity]$, name: <itop>),
      node((2, 1), $top$, name: <ctop>),

      // i due domini
      node((0, 2), $"Intv"$, name: <intv>),
      node((2, 2), $"CP"$, name: <cp>),

      // bottom originali eliminati
      node((0, 3), $cancel(bot, cross: #true)$),
      node((2, 3), $cancel(bot, cross: #true)$),

      // collegamenti
      edge(<top>, <itop>, stroke: red),
      edge(<top>, <ctop>, stroke: red),
      edge(<intv>, <bot>),
      edge(<cp>, <bot>),
      edge(<intv>, <itop>),
      edge(<cp>, <ctop>),

      // annotazioni
      node((-1.1, 2), text(fill: blue)[interi], name: <interi>),
      edge(<intv>, <interi>, "->", stroke: blue),
      node((3.1, 2), text(fill: blue)[per stringhe], name: <str>),
      edge(<cp>, <str>, "->", stroke: blue),
    ),
    caption: [Esempio smashed sum tra intervalli e constant propagation.],
  )
]

La smashed sum ci torna utile per linguaggi fortemente tipati e non per quelli dinamici.
