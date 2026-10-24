#import "../../Template typst/template.typ": (
  c-border, definition, example, lbs, note, rbs, recall, sqglb, sqle, sqlub, theorem,
)

= Lezione 2 del 28 settembre 2026

Questa lezione si concentrerà su richiami di logica, utile per lo studio della programmazione dichiarativa.
Verranno introdotti i concetti di predicati, costanti e verranno definiti anche formalmente.

== Richiami di logica del primo ordine

Partiamo con un'introduzione formale:

#definition(name: "Sintassi logica del primo ordine")[
  Un linguaggio del primo ordine è caratterizzato in maneira univica da un alfabeto $Sigma$ costituito da:
  - Un insieme $product$ di _*simboli di predicato*_.
  - Un insieme $cal(F)$ di _*simboli di funzionee di costante*_.
  - Un insieme infinito numerabile $cal(V)$ di simboli di variabile.

  Ai simboli di $Sigma$ si associa la funzione di *_arità_* $"ar": Sigma -> NN$ tale che:
  - $"ar"(X) = 0$ per ogni $X in cal(V)$
  - $"ar"(f) >= 0$ per ogni $f in cal(F)$
  - $"ar"(p) >= 0$ per ogni $p in product$

  Un simbolo $c in cal(F)$ è un simbolo costante se $"ar"(c) = 0$.
]
