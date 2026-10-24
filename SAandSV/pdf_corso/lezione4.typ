#import "../../Template typst/template.typ": c-border, definition, example, note, sqglb, sqle, sqlub, theorem
#import "@preview/fletcher:0.5.8": diagram, edge, node, shapes
#import "@preview/lovelace:0.3.1": *


= Lezione 4 del 30 settembre 2026

In questa lezione vedremo i punti fissi (fix points), iterazioni e teoremi legati a questi argomenti.

== Punti fissi (Fixed points)

Iniziamo dando una definizione di punto fisso per una funzione $f$.

#definition(name: "Punti fissi")[
  Data una $f: X -> X, x in X$ è un punto fisso se $f(x) = x$

  Possono esserci più punti fissi all'interno di una funzione.

  Indichiamo con $"Fix"(f)$ l'insieme dei punti fissi per la funzione $f$, definiamo:

  $"Fix"(f)$ = ${x | f(x) = x}$

  Possiamo definire anche i *least* e *greatest* fix points per una funzione $f$:
  - $x in "Fix"(f)$ è il *least fixed point (lfp)* se, $forall y in "Fix"(f) x subset.sq.eq y$
  - $x in "Fix"(f)$ è il *greatest fixed point (gfp)* se, $forall y in "Fix"(f) x supset.sq.eq y$
]

Per i nostri scopi di analisi statica siamo interessati a trovare *lfp* e *gfp*.
Possono non esistere, ma nel caso in cui dovessero esserci sono unici sotto determinate condizioni.

Diamo un'occhiata a un esempio con un reticolo:

#example[
  Prendiamo in considerazione il PoSet $chevron.l cal(P)({-1, 0, 1}), subset.eq chevron.r$, indichiamo con $X = {-1, 0, 1}$

  E definiamo una funzione $f(x)$ che lavora sull'insieme delle parti del PoSet:

  $
    f(x) = cases(
      x without {1} & "se" 1 in X,
      x union {-1} & "altrimenti"
    )
  $

  Prendiamo in considerazione il reticolo per $cal(P)(X)$

  #align(center)[

    #diagram(
      spacing: (2cm, 1.5cm),
      node-stroke: none, // Rimuove i bordi dai nodi per avere solo il testo

      // Livello 3 (In alto): Insieme completo
      node((0, 0), [$\{-1, 0, 1\}$], name: <top>),

      // Livello 2: Sottoinsiemi di 2 elementi
      node((-1.5, 1), [$\{-1, 0\}$], name: <m1_0>),
      node((0, 1), [$\{-1, 1\}$], name: <m1_1>),
      node((1.5, 1), [$\{0, 1\}$], name: <0_1>),

      // Livello 1: Sottoinsiemi di 1 elemento
      node((-1.5, 2), [$\{-1\}$], name: <m1>),
      node((0, 2), [$\{0\}$], name: <0>),
      node((1.5, 2), [$\{1\}$], name: <1>),

      // Livello 0 (In basso): Insieme vuoto
      node((0, 3), [$emptyset$], name: <bot>),

      // --- Collegamenti (dall'insieme vuoto ai singoli) ---
      edge(<bot>, <m1>, "-"),
      edge(<bot>, <0>, "-"),
      edge(<bot>, <1>, "-"),

      // --- Collegamenti dai singoli alle coppie ---
      edge(<m1>, <m1_0>, "-"),
      edge(<m1>, <m1_1>, "-"),
      edge(<0>, <m1_0>, "-"),
      edge(<0>, <0_1>, "-"),
      edge(<1>, <m1_1>, "-"),
      edge(<1>, <0_1>, "-"),

      // --- Collegamenti dalle coppie al massimo ---
      edge(<m1_0>, <top>, "-"),
      edge(<m1_1>, <top>, "-"),
      edge(<0_1>, <top>, "-"),
    )
  ]

  Dobbiamo trovare i *punti fissi* di questo reticolo, ovvero insiemi dove vale $f(x) = x$.
  Guardiamo la definizione di $f(x)$, dobbiamo trovare degli insiemi all'interno del reticolo che dati alla funzione restituiscano lo stesso insieme.

  Prendendo ogni singolo insieme abbiamo:

  - $f({emptyset})$ = ${-1}$
  - $f({-1})$ = ${-1} ->$ *punto fisso*.
  - $f({0})$ = ${-1, 0}$
  - $f({1})$ = ${-1, 1}$
  - $f({-1, 0})$ = ${-1, 0} ->$ *punto fisso*.
  - $f({-1, 1})$ = ${-1}$
  - $f({0, 1})$ = ${0}$
  - $f({-1, 0, 1})$ = ${-1, 0}$

  Abbiamo trovato ${-1, 0}$ e ${-1}$ come punti fissi della funzione $f(x)$. Questo concetto tornerà utile per analisi statica.
]

Un altro concetto fondamentale sono le iterazioni per una funzione $f(x)$.
Possiamo definire le iterazioni su $f(x)$ nel seguente modo:

#definition(name: "Iterazioni")[
  Le iterazioni di $f$ su $x in X$ sono definite come:
  - $f^0(x) = x$
  - $f^(n + 1)(x) = f(f^n (x))$
]

Anche queste iterazioni ci permettono di trovare punti fissi per i nostri scopi di analisi statica.

Introduciamo il teorema fix-point di Knaster-Tarski.

#theorem(name: "Teorema di Knaster-Tarski sui punti fissi")[
  Prendiamo un reticolo: $chevron.l X, subset.sq.eq, union.sq, inter.sq chevron.r,$ e una funzione  $f: X -> X$, monotona

  Allora, $chevron.l "Fix"(f), subset.eq.sq, union.sq, inter.sq chevron.r$ è un reticolo completo.

  Possiamo definire anche *lfp* e *gfp*:
  - $"lfp"(f)$ = $inter {l | l supset.sq.eq f(l)}$
  - $"gfp"(f)$ = $union {l | f(l) supset.sq.eq l}$

] <thm-knaster-tarski>

Questo ci dice che esiste un fix point per il reticolo.

Abbiamo anche il teorema di Kleene che ci dice che possiamo trovare un punto fisso all'interno di un complete lattice.

#theorem(name: "Teorema di Kleene")[
  Sia $chevron.l X, subset.sq.eq, union.sq, inter.sq, bot, top chevron.r$ un complete lattice, e sia $f: X -> X$ continua.

  La funzione $f$ ha un punto fisso, e può essere calcolato come:

  #align(center)[
    *$union.sq_(n >= 0) thick f^n (bot)$*

  ]
] <thm-kleene>

In poche parole possiamo trovare sempre un punto fisso all'interno di un reticolo (o lattice) completo dopo un numero finito di iterazioni sulla funzione $f$.

//_Aggiungere esempi fatti a lezione sul codice._
