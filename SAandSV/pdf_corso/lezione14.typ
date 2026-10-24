#import "../../Template typst/template.typ": (
  c-border, definition, example, lbs, lps, note, rbs, recall, rps, sleq, slt, sqglb, sqle, sqlub, supqle, theorem,
)
#import "@preview/fletcher:0.5.8": diagram, edge, node, shapes

= Lezione 14 del 22 ottobre 2026

Questa è la seconda e ultima parte del primo seminario del corso.
La scorsa lezione abbiamo visto operatore filter e una versione migliorata con l'operatore di split.

In questa seconda parte parleremo di oracoli per variabili likely unconstrained per velocizzare le analisi numeriche.

== Unconstrained variable oracles for faster numeric static analyses

Stiamo lavroando sempre nel contesto dell'interpretazione astratta.
Ricordiamo che il processo di analisi di un progamma tramite interpretazione astratta può introdurre inefficienze.

Abbiamo anche tecniche di *compilazione astratta*, che consistono nel riscrivere l'IR utilizzata dall'analizzatore.
L'obiettivo di queste tecniche è quello di ottimizzare l'esecuzione astratta, sempre con un compromesso tra accuratezza ed efficienza.

== Likely unconstrained variable

Parliamo ora di likely unconstrained variable. Durante la fase di analisi possiamo dedurri quali valori può assumere una variabile in un determinato program point, per esempio se possiamo stabilire con esattezza un solo valore oppure un intervallo di valori possibili.

Prendiamo in considerazione il seguente caso:

#figure(image("img/lezione14/diagramma.svg", width: 70%), caption: [Esempio calcolo di likely unconstrained variable.])

Nella figura qui sopra possiamo vedere che abbiamo inizialmente _expr_ con valori compresi tra 1 e 12, mentre $y$ assume valori tra meno e più infinito perché  non abbiamo abbastanza informazioni sulla variabile y.

Proseguendo con l'analisi troviamo l'espressione $x = y + "expr"$, dato che all'interno dell'espressione abbiamo $y$ di cui non sappiamo nulla, quello che possiamo dire su $x$ è che può assumere lo stesso intervallo di valori di $y$. _In questo caso l'intervallo $[ + infinity, - infinity]$ corrisponde a $top$._

L'obiettivo è quello di individuare queste likely unconstrained variable e propagare questa mancanza di informazione migliorando l'efficienza e semplificando l'analisi.

#pagebreak()

=== Step per LUV

È un'analisi dataflow che può essere tipo *relazionale* o *non relazionale*.
La propagazione dei valori può essere *esistenziale* o *universale*.

L'analisi LUV è definita come una funzione:

$ lbs dot rbs : "Stmt" times cal(P)("Var") arrow cal(P)("Var") $

Definiamo ora l'oracolo per l'analisi DFA non relazionale:

#let lu = math.italic("lu")
$
       lbs x arrow.l ? rbs ("lu") & = lu union {x} \
  lbs x arrow.l y "op" z rbs (lu) & = cases(
                                      lu without {x} & "se" y in.not lu "e" z in.not lu",",
                                      & "oppure se" "op" = "%" "e" z in.not lu",",
                                      & "oppure se" "op" = - "e" y = z";",
                                      lu union {x} & "altrimenti"
                                    ) \
  lbs x arrow.l y "op" k rbs (lu) & = cases(
                                      lu without {x} & "se" y in.not lu "," "oppure se" "op" = "%" ",",
                                      & "oppure se" "op" = "*" "e" k = 0";",
                                      lu union {x} & "altrimenti"
                                    ) \
    lbs (x bowtie.big y) rbs (lu) & = cases(
                                      lu without {x} & "se" y in.not lu";",
                                      lu without {y} & "se" x in.not lu";",
                                      lu & "altrimenti"
                                    )
$

Definiamo ora anche l'oracolo per l'analisi relazionale:

$
               lbs x arrow.l ? rbs (lu) & = lu union {x} \
                                        \
  lbs x arrow.l y "op" z rbs^"rel" (lu) & cases(
                                            lu without {x, y, z} & "se" "op" in {"+", minus}";",
                                            lbs x arrow.l y "op" z rbs (lu) & "altrimenti"
                                          ) \
                                        \
  lbs x arrow.l y "op" k rbs^"rel" (lu) & cases(
                                            lu without {x} & "se" "op" = "%"";",
                                            lu without {x, y} & "altrimenti."
                                          )
$

=== Esempi di falsi positivi e falsi negativi

Guardiamo alcuni esempi di falsi positivi e falsi negativi per questo tipo di analisi:

#example(name: "LU, Falso positivo")[
  Prendiamo in considerazione il seguente pseudocodice:
  $
    y arrow.l 0 \
    x arrow.l y * z
  $

  Siccome $z$ è LU, anche $x$ è LU, anche se l'analisi degli intervalli ci restituirebbe $x in [0, 0]$
]

#example(name: "LU, Falso negativo")[
  Prendiamo in considerazione il seguente pseudocodice:

  $
    y >= 0 quad "and" quad z =< 0 \
    x arrow.l y + z
  $
]

== Esistenziale vs Universale

L'analisi di tipo *esistenziale* ci dice che una variabile è dell'insieme LU se all'inizio del basic block c'è almeno un arco in entrata dove quella variabile è LU.

Invece l'analisi di tipo *universale* ci dice che una variabile è all'interno dell'insieme LU se all'inizio di un basic block, la variabile è LU su tutti gli archi in entrata al basic block.

#example(name: "Oracolo non relazionale e propagazione esistenziale")[
  #figure(image("img/lezione14/existential_propagation.svg", width: 70%), caption: [Propagazione esistenziale.])

  Nel caso della propagazione esistenziale dobbiamo fare l'unione di tutti gli insiemi LU degli archi entranti nel basic block b3.
]

#example(name: "Oracolo non relazionale e propagazione universale")[
  #figure(image("img/lezione14/universal_propagation.svg", width: 70%), caption: [Propagazione universale.])

  In questo caso nel basic block b3, dobbiamo fare l'interesezione di tutti gli insiemi LU degli archi entranti.
]

#figure(image("img/lezione14/tre_cfg.svg", width: 70%), caption: [Entrambe le propagazioni.])

== Conclusioni

Con questo tipo di analisi si è velocizzata l'analisi numerica limitando la perdita di precisione dell'analisi.
Anche in questo caso si può trovare il paper del seminario al seguente link:

#link("https://cliplab.org/jd1mOkw/SAS2023/142840062/142840062.pdf")[Unconstrained Variable Oracles
  for Faster Numeric Static Analyses.]
