#import "../../Template typst/template.typ": (
  c-border, definition, example, lbs, note, rbs, separator, sqglb, sqle, sqlub, theorem,
)
#import "@preview/fletcher:0.5.8": diagram, edge, node, shapes
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

= Lezione 26 del 26 novembre 2026

La lezione di oggi è il seminario su 'What could possibly go right?'
È un eseminario su analisi di terminazione dei programmi.

Ripercorre concetti già visti a lezione, come la maximal trace semantics. Dalla maximal trace semantics vogliamo analizzare le tracce e analizzare se un programma termini.

Per determinare se un programma è determinato, si usa la collecting semantics della maximal trace semantics.
Essere un determinato programma vuol dire possedere la proprietà che lo caratterizza.

== Domini astratti numerici

A lezione sono stati introdotti i poliedri, che veranno visti più nel dettaglio in uno dei prossimi seminari.

Possiamo vedere un insieme di poliedri come un insieme di memorie del programma.

Un'operazione di filter su un poliedro aggiunge vincoli al poliedro.
Il widening dei poliedri aggiunge vincoli non stabili.

Siamo interessati alla terminazione perché codice che non termina può portare a bug nel programma.
Abbiamo due tipi di terminazione:

- Potenziale, almeno un'esecuzione termina.
- Definite, tutte le esecuzioni terminano.

Si usa una ranking function e assegna un valore agli stati ad ogni transizione che fa il programma.

(esempio ranking function)

la ranking function conta quanti step mancano alla terminazione dle programma.

== Semantica concreta

Gerarchia a partire dalla maximal trace semantics, vediamo la semantica della reaching termination.

*Definite termination abstraction*: vogliamo tutte le tracce che terminano,
prendiamo i possibili prefissi di una traccia e togliamo tutte le tracce infinite che condividono il prefisso.

Non c'è una galois connection tra maximal trace semantics e termination trace semantics.

=== Funzione di ranking

A ogni stato che appare in queste tracce assegnamo un valore e contiamo gli step all'indietro che ci servono per terminare il programma.
I punti fissi sono esattamente quello che il programma calcola.

== Widening

Il widening deve predirre una ranking function valida, le predizioni potrebbero essere unsound. possono essere sotto approssimazioni o sovrapprossimazioni.
