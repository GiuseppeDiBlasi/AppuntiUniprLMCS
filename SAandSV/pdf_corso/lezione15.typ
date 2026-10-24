#import "../../Template typst/template.typ": (
  c-border, definition, example, lbs, lps, note, rbs, recall, rps, separator, sleq, slt, sqglb, sqle, sqlub, supqle,
  theorem,
)
#import "@preview/fletcher:0.5.8": diagram, edge, node, shapes

= Lezione 15 del 23 ottobre 2026

Riprendiamo dalla lezione 12, dove parlavamo di calcolare il punto fisso passando per un dominio astratto.
Abbiamo visto un esempio di come calcolare il punto fisso su un programma concreto @ex-lfp-concreto, che in linea generale non è decidibile, abbiamo poi definito
la semantica astratta @ex-sem-abstr con le valutazioni degli statement, espressioni booleane e operatori aritmetici @table-piu-astratto e booleani astratti.

Abbiamo visto la definizione di una funzione astratta $f^"#"$ e  la condizione per cui questa funzione astratta sia sound @soundness-abstr.

== Completeness di $f^"#"$

Abbiamo visto la definizione di soundness per $f^"#"$, che ricordiamo essere:

$ forall c in C . alpha(f(c)) sqle(A) f^"#" (alpha(c)) $

Esiste anche l'altra definizione in formula equivalente, ma lavoriamo su questa.

Da questa definizione di soundness possiamo anche definire la condizione di completeness:

$ forall c in C . alpha(f(c)) = f^"#" (alpha(c)) $

La differenza con la soundness è che con la completeness forziamo l'uguaglianza tra l'astrazione di $f(c)$ e l'applicazione di $f^"#"$ all'elemento astratto $alpha(c)$.
Guardiamo un esempio:

#example(name: "Esempio di completeness")[
  Abbiamo visto l'operatore aritmetico astratto @table-piu-astratto, prendiamo in considerazione la seguente operazione concreta:

  $ {1} + {-1} = {0} attach(arrow, t: alpha) 0 $

  In questo caso l'operazione concreta tra ${1}$ e ${-1}$ porta al risultato concreto ${0}$, andando ad astrarre il risultato otteniamo 0 nel dominio astratto.

  Questa è la prima parte dell'uguaglianza $alpha(f(c))$, guardiamo ora l'altra parte, $f^"#" (alpha(c))$, andiamo ad applicare la funzione $alpha$ a ${1}$ e ${-1}$ e otteniamo:

  $ + quad +^"#" quad - quad = top $

  In questo caso l'operatore di addizione astratto non è completo, otteniamo $0 subset.sq.eq top$ che è sound, ma non è completo.
  Questa approssimazione è anche la bca, best correct approximation.

  #separator()

  Consideriamo ora invece l'operazione di moltiplicazione astratta,
  calcoliamo l'espressione nel concreto e poi andiamo ad astrarre il risultato:

  $ {1} * {-1} = {0} attach(arrow, t: alpha) - $

  Andando ad astrarre gli elementi e poi applicare $f^"#"$ otteniamo:

  $ + quad *^"#" quad - quad = - $

  In questo caso l'operazione di moltiplicazione astratta per il dominio dei segni è completa. Otteniamo lo stesso risultato in entrambe le parti dell'equazione.

  #separator()

  Se avessimo invece un dominio che restituisce sempre $top$ o sempre $bot$? In tal caso è sempre completo, è una sovrapprossimazione ma è completa.

]

#note[
  - La completezza è una proprietà del dominio.
  - Il fatto che un'analisi sia completa, non garantisce che sia anche precisa.
]

== Calcolo lfp su dominio astratto

Riprendiamo il CFG dell'esempio @ex-fixpt-cfg, possiamo calcolare il punto fisso per $F^"#"$ come abbiamo fatto per la $F$ concreta.

#example(name: [Punto fisso di $F^"#"$])[
  Definiamo ora $x_1, x_2, dots x_6$ per lavorare con la semantica astratta.

  $
    x_1 & = alpha(I) \
    x_2 & = lbs x = 0 rbs^"#" x_1 union.sq lbs x = x + 2 rbs^"#" x_4 union.sq lbs x = x + 10 rbs^"#" x_5 \
    x_3 & = lbs x < 100 rbs^"#" x_2 \
    x_4 & = lbs x < 50 rbs^"#" x_3 \
    x_5 & = lbs x >= rbs^"#" x_3 \
    x_6 & = lbs x >= 100 rbs^"#" x_2
  $

  Calcoliamo ora l'lfp per $F^"#"$, l'andamento è identico a quello della $F$ concreta, guardiamo le equazioni a ogni passo e calcoliamo i valori in base ai valori dell'iterazione precedente:

  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 1em,
    align: horizon,
    $
      F^"#"_0 = cases(
        delim: "{",
        gap: #1em,
        x_1 = bot,
        x_2 = bot,
        x_3 = bot,
        x_4 = bot,
        x_5 = bot,
        x_6 = bot,
      )
    $,
    $
      F^"#"_1 = cases(
        delim: "{",
        gap: #1em,
        x_1 = top,
        x_2 = 0 union.sq bot union.sq bot = 0,
        x_3 = 0,
        x_4 = 0,
        x_5 = 0,
        x_6 = 0,
      )
    $,
    $
      F^"#"_2 = cases(
        delim: "{",
        gap: #1em,
        x_1 = top,
        x_2 = 0 union.sq + union.sq bot = top,
        x_3 = top,
        x_4 = top,
        x_5 = +,
        x_6 = +,
      )
    $,
  )

  Alla terza iterazione troviamo il least fixpoint:

  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1em,
    align: horizon,
    $
      F^"#"_3 = cases(
        delim: "{",
        gap: #1em,
        x_1 = top,
        x_2 = 0 union.sq top union.sq + = top,
        x_3 = top,
        x_4 = top,
        x_5 = +,
        x_6 = +,
      )
    $,
    $
      F_"lfp" = cases(
        delim: "{",
        gap: #1em,
        x_1 = ZZ,
        x_2 = {0, 2, 4, dots 50, 60, 70, dots, 100},
        x_3 = x_2 backslash {100},
        x_4 = {0, 2, dots , 48},
        x_5 = {50, dots, 90},
        x_6 = {100},
      )
    $,
  )

  Possiamo vedere come $F_"lfp"$ corrisponda all'astrazione $F^"#"_3$.

]

=== Introduzione operatore di widening e narrowing

Introduciamo gli operatori di *widening* e *narrowing* con un esempio; verranno visti nel dettaglio nelle prossime lezioni.

Prendiamo in considerazione un esempio sull'analisi degli intervalli:

#example(name: "Esempio widening e narrowing")[
  Consideriamo il seguente pseudocodice:


  ```
  i = 0;
  while(file.exists(f))
    i++;

  ```
  Se appliccassimo l'analisi degli intervalli su questo snippet di codice, per la variabile $i$ otterremmo in sequenza:

  $ i = [0;0], i = [0;1], i = [0;2], dots i =[0; +infinity] $


  Il fixpoint esiste, e lo troviamo dopo un infinito tempo, ovviamente non possiamo passare una quantità infinita di tempo ad analizzare questo codice
  per risolvere questo problema si definisce l'operatore di widening.
  Il motivo per cui questo fixpoint lo troviamo dopo un'infinita quantità di tempo è dovuto al fatto che il dominio degli intervalli non è ACC, @catene.

  Alcuni esempi d'uso possono essere:

  $ [0, 1] gradient [0, 2] = [0, +infinity] $
  $ [0, 1] gradient [-1, 1] = [-infinity, 1] $

]

L'operatore di widening ci permette di approssimare il lub, ci torna utile in casi come questo, dove il dominio non è ACC e il fixpoint lo troviamo dopo una quantità infinita di tempo.
Attenzione che il widening per definizione non è un operatore monotono.

#figure(image("img/lezione15/widening_narrowing.svg", width: 70%), caption: [Uso operatore di widening.])

Esiste anche l'operatore di narrowing, che è l'opposto dell'operatore di widening, utilizzato per approssimare il glb. L'operatore di narrowing si usa per recuperare informazioni che possono essere state perse dopo aver applicato l'operatore di widening.

Come già detto, questi due operatori saranno formalizzati e visti nel dettaglio nelle prossime lezioni.

== Trasferimento del fixpoint

Cosa ci garantisce che il least fixpoint di $F^"#"$ sia un'approssimazione sound di $F$ concreta?
Nel caso in cui sia esatta, avremo: $alpha("lfp"(F)) = "lfp" F^"#"$
Nel caso in cui sia un'approssimazione, avremo: $alpha("lfp"(F)) subset.sq.eq "lfp" F^"#"$

Abbiamo due teoremi che possono tornarci utili:

#theorem(name: "Approssimazione del fixpoint di Kleene")[
  Se $f: C arrow C$ è continua in un complete lattice: $chevron.l C, sqle(c), sqlub(C), sqglb(C), bot_C, top_C chevron.r$ e
  $f^"#": A arrow A$ è un'astrazione sound di $f$ in un dominio astratto $chevron.l A, sqle(A), sqlub(A), sqglb(A), bot_A, top_A chevron.r$, e
  la sequenza ${f^"#"_i (bot_A) | i in NN}$ ha un limite $x in A$, allora è un'approssimazione sound del $"lfp"(f)$, quindi $"lfp"(f) sqle(C) gamma(x)$

  - In particolare a ogni step $i$ di $f^"#"_i (bot_a)$ è un approssimazione sound di $f_i (bot_C)$

]

#note[
  Il teorema ci garantisce la soundness del calcolo dell'lfp nel dominio astratto, non la sua ottimalità.
]

#theorem(name: "Approssimazione del fixpoint di Tarski")[
  Dato un complete lattice $chevron.l C, sqle(C), sqlub(C), sqglb(C), bot_c, top_c chevron.r$, una funzione monotona $f: C arrow C$ e una sua astrazione sound $f^"#": A arrow A$ in un dominio astratto $chevron.l A, sqle(A), sqlub(A), sqglb(A), bot_A, top_A chevron.r$ allora qualunque post-fixpoint $a$ di $f^"#"$, tale che $f^"#"(a) sqle(A) a$, è un'astrazione sound di $"lfp"(f)$, quindi $"lfp"(f) sqle(C) gamma(a)$

  Il teorema sfrutta due concetti:

  - La definizione del teorema di Tarski che lfp($f$) è il più piccolo post-fixpoint.
  - Un qualunque post-fixpoint astratto di un'astrazione sound rappresentato tramite $gamma$, un post-fixpoint concreto, è una sovrapprossimazione del lfp($f$)
]

#figure(image("img/lezione15/fixpoint_concreto_astratto.svg", width: 70%), caption: [Fixpoint da astratto a concreto.])

Nella figura qui sopra possiamo vedere che non sempre un fixpoint che calcoliamo nel dominio astratto corrisponde con un fixpoint del dominio
concreto.
Concretizzando tramite $gamma$ otteniamo sempre un post-fixpoint nel concreto.
Come sempre, perdiamo precisione ma l'analisi è sempre sound, perché  il post-fixpoint concreto sovrapprossima il lfp($f$) dopo che si concretizza dal dominio astratto a quello concreto tramite $gamma$.
