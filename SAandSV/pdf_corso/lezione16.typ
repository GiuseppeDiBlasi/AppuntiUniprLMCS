#import "../../Template typst/template.typ": c-border, definition, example, note, sqglb, sqle, sqlub, theorem
#import "@preview/fletcher:0.5.8": diagram, edge, node, shapes

= Lezione 16 del 28 ottobre 2026

#note[
  Non ha molto senso che io mi metta a trascrivere quello scritto nelle slide, per farla breve è quello che è stato visto nella lezione 12, @lec-12,
  dove abbiamo definito una semantica astratta e operatori astratti per poter calcolare i comportamenti del programma poiché nel concreto non sempre sono decidibili.
  E infine verificare se la nostra astrazione è sound.


  L'idea di questa lezione è più un breve riassunto del seminario.
]

La lezione di oggi era un seminario sull'implementazione di un tool di analisi statica per il linguaggio *R*.

*R* è un linguaggio utilizzato da statistici.
Una caratteristica di *R* è che ha valori *unknown* e *null* per le variabili; qui è fondamentale capire come modellare questi due possibili valori
nella rappresentazione astratta di *R*.

Siccome *R* è un linguaggio piuttosto complesso si è preferito lavorare su un sottoinsieme del linguaggio per semplificare la fase di analisi statica.

Infine la procedura di implementazione segue gli stessi passi visti nella lezione 12, @lec-12, definire la semantica astratta, operatori astratti e fare analisi sul dominio astratto.

Le slide del seminario sono disponibili su elly: _Statically analyzing R vectors_
