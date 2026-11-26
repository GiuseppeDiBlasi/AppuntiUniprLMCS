# Lezione 26 del 26 novembre 2026 

Seminario: what could dpossibly go right?

Topic: analisi della terminazione 

Maximal trace semantics, insieme delle tracce infinite e finite.

Per verificare il determinismo di un programma si usa la collecting semantincs della maximal trace semantics.
Essere quel determinato programma vuol dire avere quella propreità

# Domini astratti numerici 

- skip ai poliedri 

Un insieme di poliedri corrisponde a un insieme di memorie del programma.
Possiamo confrontarli, convex hull (unione) e l'intersezione è l'unione dei vincoli.

filter -> si aggiunge un vincolo al poliedro

il widening rimuove vincoli non stabili.

 skip a liveness property

# Liveness property 

La terminazione è una proprietà delle tracce

liveness: garantire che qualcosa succeda in un punto del programma.

perchè ci interessa la terminazione? il codice che ci interessa **DEVE** terminare.

due tipi di terminazione: 
- potenziale, almeno un'esecuzioni termini
- definite, tutte le esecuzioni terminano 

Si usa una ranking function e assegna un valore agli stati ad ogni transizione che fa il programma.

(esempio ranking function)

la ranking function conta quanti step mancano alla terminazione dle programma.

# Semantica concreta 

gerarchia a partire dalla maximal trace semantics, vediamo la semantica della reaching termination.

definite termination abstraction: vogliamo tutte le tracce che terminano.
prendiamo i possibili prefissi di una traccia e togliamo tutte le tracce infinite che condividono il prefisso.

non c'è una galois connection tra maximal trace semantics e termination trace semantics 

## funzione di ranking 

a ogni stato che appare in queste tracce assegnamo un valore e contiamo gli step all'indietro che ci servono per terminare il programma. 

i punti fissi sono esattamente quello che il programma calcola.

un programma soddisfa la definite termination soltanto se?


# post pausa

nell'astrazione abbiamo una ranking function piece wise, per ogni pezzo la funzione è lineare o complessa.

## piecewise defined function domain 

possiamo vedere i domini astratti come intervalli o di vincoli, stiamo parlando della stessa cosa.

i vincoli devono essere in forma canonica


## dominio astratto degli operatori

unificazione di un albero: se mancano dei vincoli in un albero sia ggiungono, viconoli ridondanti vengono scartati.

i vincoli sono soddisfatti a sinistra e non soddisfatti a destra.

## join

il join unifica due alberi


skip a filter, slide 134 

# widening
il widening deve predirre una ranking function valida, le predizioni potrebbero essere unsound. possono essere sotto approssimazioni o sovrapprossimazioni.
