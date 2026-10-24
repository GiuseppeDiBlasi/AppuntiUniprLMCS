#import "../../Template typst/template.typ": c-border, definition, example, note, sqglb, sqle, sqlub, theorem
#import "@preview/fletcher:0.5.8": diagram, edge, node, shapes
#import "@preview/lovelace:0.3.1": *

= Lezione 5 del 1 ottobre 2026

Nella scorsa lezione abbiamo introdotto i punti fissi per una funzione $f$, *least fixed point* e *greatest fixed point*, teorema di Knaster-Tarski e di Kleene.

Adesso possiamo introdurre un linguaggio toy per modellare la semantica dei nostri programmi, chiameremo questo linguaggio *Imp*

== Imp, linguaggio toy <lang-imp>

Definiamo il linguaggio *imp* come una grammatica libera da contesto (cfg).
Definiamo le regole per espressioni aritmetiche, booleane e statement.

$e := x | n | e_1 "op"_a e_2 quad n in ZZ, "op"_a in {+, -, *, "/"}$

$b := "true" | "false" | not b | b_1 "op"_b b_2 | e_1 "op"_c e_2 quad "op"_b in {"||", "&&"}, thick "op"_c in {"==", "!=", "<", ">"}$

$s := x = e | "skip" | s_1 s_2| "if" b "then" s_1 "else" s_2 | "while" b thick s$

Questa è la nostra grammatica per il linguaggio *imp*.
Perché definire un linguaggio toy per rappresentare la semantica dei programmi che vogliamo analizzare? Perché il calcolo del punto fisso per una funzione $f$ risulta molto utile per studiare la semantica dei programmi.

Ora passiamo a definire la semantica, per questo linguaggio *imp*. Ovvero spieghiamo in modo dettagliato cosa succede quando valutiamo i simboli della grammatica.

#note[
  _Piccola digressione_

  Alcuni linguaggi di programmazione moderni hanno dei manuali dove viene spiegata la sintassi del linguaggio, ma
  la descrizione della *semantica* avviene sempre con un linguaggio naturale, questo comporta libere interpretazioni da parte di chi vuole implementare un compilatore o un interprete per un determinato linguaggio. Il problema di queste libere interpretazioni è che alcuni compilatori valutano le stesse espressioni in maniera completamente differente.

  Ad esempio l'interprete _Javascript_ varia tra Firefox, Chrome e Safari.
]

Torniamo a noi, definiamo in modo preciso la nostra semantica per *imp*.
Prendiamo una funzione $M: X -> ZZ$, chiamiamo questa funzione $M$ per memoria.
Un esempio d'uso di questa funzione è: $[x -> 5; thick y -> 9; thick z -> 11]$.

Formalizziamo la semantica per le produzioni per il simbolo delle espressioni aritmetiche $e$:

#set list(spacing: 2em)
#let lbs = $bracket.l.stroked$
#let rbs = $bracket.r.stroked$

- $lbs quad rbs_e : e times M -> ZZ$
- $lbs x rbs^m_e = m(x)$
- $lbs n rbs^m_e = n$
- $lbs e_1 "op"_a e_2 rbs^m_e = lbs e_1 rbs^m "op"_a lbs e_2 rbs^m$

Definiamo ora la semantica per le produzioni per il simbolo delle espressioni booleane $b$:

- $lbs quad rbs_b : b times M -> {"TT", "FF"}$
- $lbs "true" rbs^m_b = "TT" quad lbs "false" rbs^m_b = "FF"$
- $lbs not b rbs^m_b = ! lbs b rbs^m_b$
- $lbs b_1 "&&" b_2 rbs^m_b = lbs b_1 rbs^m_b vec(and, or, delim: #none) lbs b_2 rbs^m_e$
- $lbs e_1 "op"_c e_2 rbs^m_b = lbs e_1 rbs^m_b "op"_c lbs e_2 rbs^m_e$

Definiamo infine la semantica per il simbolo degli statement $s$:

- $lbs quad rbs: s times M -> M ->$  questa semantica *produce* side effect.
- $lbs x = e rbs^m = m [x <- lbs e rbs^m_e] ->$  viene valutata $e$, il suo risultato viene salvato nella memoria di $x$.
- $lbs "skip" rbs^m = m ->$ non altera lo stato della memoria, è un *nop* (No Operation).
- $lbs s_1 s_2 rbs^m = lbs s_2 rbs (lbs s_1 rbs^m)$
- $lbs "if" b s_1 "else" s_2 rbs^m = cases(
    lbs s_1 rbs^m & quad "se" lbs b rbs^m_b = "TT",
    lbs s_2 rbs^m & quad "altrimenti",
  )$
- $lbs "while" thick b thick s rbs^m = cases(
    lbs s thick "while" thick b thick s rbs^m & quad "se" lbs b rbs^m_b = "TT",
    m & quad "altrimenti"
  )$

Esistono diversi tipi di semantiche, abbiamo la big-step che calcola direttamente il risultato di un programma o espressione. Ci sono le semantiche small-step, che mostrano gli step intermedi per arrivare al risultato e semantiche notazionali.

// _Aggiungere esempi sulle slide fatte a lezione._
