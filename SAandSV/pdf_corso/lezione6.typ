#import "../../Template typst/template.typ": c-border, definition, example, note, sqglb, sqle, sqlub, theorem

#let cerchiato(n) = box(
  baseline: 20% - 0.10cm,
  circle(
    width: 1em,
    inset: 0pt,
    stroke: red + 0.8pt,
    align(center + horizon, text(fill: red, size: 0.8em)[#n]),
  ),
)

#show raw.where(block: true): it => {
  show raw.line: line => {
    cerchiato(line.number)
    h(0.8em)
    line.body
    // riga vuota in più dopo l'ultima
    if line.number == line.count {
      linebreak()
      cerchiato(line.number + 1)
    }
  }
  it
}


= Lezione 6 del 2 ottobre 2026

La scorsa lezione abbiamo parlato delle tracce d'esecuzione di un programma, siamo interessati alle tracce che  ci permettono di eseguire l'intero programma e di mantenere anche informazioni su tutti i passi intermedi all'interno di ogni traccia.

Prendiamo in considerazione il seguente pezzo di codice:

```
  i = 0;
  while(i < x)
    i = i + 1;
```
Il punto 0 del programma ha come *stato iniziale* $[x -> 2]$, mentre il punto 4 è la terminazione.

Proviamo a scrivere le tracce d'esecuzione per ogni punto del programma:

- #cerchiato(1), avremo: ${[x -> 2]^0 -> [x -> 2; thick i -> 0]^1}$.
- #cerchiato(3), avremo: ${[x -> 2]^0 -> [x -> 2; thick i -> 0]^1 -> [x -> 2; thick i -> 1]^3, med [x -> 2]^0 -> [x -> 2; thick i -> 0]^1 -> [x -> 2; thick i -> 1]^3 -> [x -> 2; thick i -> 2]^3}$

Questa che abbiamo appena descritto è la *semantica delle tracce*, oltre ad avere ogni singolo valore per ogni variabile in un determinato punto del programma, ci permette anche di mettere in evidenza le  relazioni che ci sono tra le varie tracce.

Esistono anche semantiche collective, che però non permettono di rappresentare le relazioni tra le tracce d'esecuzione del programma.
Vediamo un esempio di semantiche collettiva.

#align(center)[
  #example[
    #table(
      columns: 3,
      [], $thick i$, $thick x$,
      [1], $\{0\}$, $\{2\}$,
      [3], $\{1, 2\}$, $\{2\}$,
      [4], $\{2\}$, $\{2\}$,
    )


    Come già detto, da questa tabella non riusciamo a vedere le relazioni tra le varie tracce del progamma.
  ]
]

Ora diamo delle definizioni per la semantica delle tracce:

#let lbs = $bracket.l.stroked$
#let rbs = $bracket.r.stroked$


#definition(name: "Semantica delle tracce o Maximal trace semantics")[
  - Possiamo definire l'insieme delle tracce *finite* come: $X^+$
  - L'insieme delle tracce *infinite* è dato da: $X^omega$
  - L'insieme di *tutte* le tracce è dato da: $X^(infinity): X^+ union X^omega$

  Possiamo vedere una traccia d'esecuzione come il prodotto cartesiano tra la memoria e la label, ovvero il punto di esecuzione del programma: $MM times LL$

  Possiamo definire anche l'insieme degli stati iniziali che sono un sotto insieme di $MM$: $II subset.eq MM$

  Definiamo anche una funzione $F$ che ci permette di collezionare tracce d'esecuzione, la funzione $F$ è definita come:

  #align(center)[
    $F: cal(P)((MM times LL)^*) -> cal(P)((MM times LL)^*)$

    $*$: operatore di Kleene, 0 o più ripetizioni.
  ]

  Su questa funzione $F$ vogliamo calcolare il $"lfp"_(emptyset)^subset.eq F$.
  Calcoliamo il *least fixed point* di $F$ partendo dall'insieme vuoto con operatore di ordinamento $subset.eq$.

  Possiamo definire formalmente $F$ come:

  #let st(lab, idx) = $i^(#lab)_(#idx)$

  #let trNonTerminate1 = $st(l_0, 0) -> st(l_1, 1) -> dots -> st(l_(n-1), n-1) -> st(l_n, n)$
  #let trNonTerminate2 = $st(l_0, 0) -> st(l_1, 1) -> dots -> st(l_(n-1), n-1)$

  #let trBloccanti = $st(l_0, 0) -> st(l_1, 1) -> dots -> st(l_n, n)$

  $
    F = lambda T . & underbrace({ i^0 | i in I }, "Insieme degli stati iniziali") \
                   & union underbrace(
                       { trNonTerminate1 | trNonTerminate2 in T },
                       "Insieme delle tracce non ancora terminate"
                     ) \
                   & union underbrace(
                       { trBloccanti | trBloccanti in T and st(l_n, n) "blocca con" lbs dot rbs },
                       "Insieme delle tracce bloccanti"
                     )
  $

  Per far avanzare una traccia non terminata si prende la traccia interessata e si applica l'operatore: $lbs "next"(l_(n-1))rbs i_(n-1) = i^(l_n)_n$
  Ovvero valutiamo l'espressione corrente al punto $n-1$ per ottenere lo stato nel punto d'esecuzione $n$.
]

Riprendiamo l'esempio di codice che abbiamo visto all'inizio di questa lezione e calcoliamo $"lfp"_(emptyset)^subset.eq F$ su quel programma.

#example[

  ```
  i = 0;
  while(i < x)
  i = i + 1;
  ```

  Abbiamo come stati iniziali $I = {[x -> 2]}$. Partendo da $I$ calcoliamo le tracce d'esecuzione per il programma.

  + $F^1 = F(emptyset) = {[x -> 2]^0}$, per far evolvere questa traccia facciamo $"next"(0) = lbs i -> 0 rbs^1_0$ quindi otteniamo: $lbs i = 0 rbs [x -> 2] = [x -> 2; i -> 0]^1$. Quindi la seconda iterazione avremo:

  + $F^2 = F(F^1) = F({[x->2]^0}) = {[x -> 2]^0, [ x-> 2]^0 -> [x -> 2; i -> 0]^1}$.
  L'operatore $"next"(l)$ applicato a tutte le tracce in input che possono evolvere. Alla terza iterazione avremo:

  3. $F^3 = F(F^2) = F({[x -> 2]^0, [ x-> 2]^0 -> [x -> 2; i -> 0]^1})$; applichiamo il next($n$) a tutte le tracce in input:
  per la traccia $[x -> 2]^0$ otteniamo lo stesso risultato di $F^2$, quindi applichiamo next($1$) sulla nuova traccia $[x -> 2; i -> 0]^1$
  Così facendo abbiamo: next($1$) = $i"++" -> lbs i"++" rbs thick [x -> 2; i -> 0] = [x -> 2; i -> 1]$.
  Infine otteniamo $F^3 ={[x -> 2]^0, [ x-> 2]^0 -> [x -> 2; i -> 0]^1, [x -> 2]^0 -> [x -> 2; i -> 0]^1 -> [x -> 2; i -> 1]^3}$

  #v(0.5cm)
  _Piccola precisazione: Perché  non valutiamo la guardia all'interno del *while* $(i < x)$? Non viene valutata perché l'operatore next($l$) tiene già conto se dovessi rimanere dentro al *while* o uscirne fuori. In poche parole next($l$) gestisce la logica di un CFG (Control Flow Graph)._
  #v(0.5cm)

  Andiamo avanti con la quarta iterazione:

  4. $F^4 = F(F^3) = F({[x -> 2]^0, [ x-> 2]^0 -> [x -> 2; i -> 0]^1, [x -> 2]^0 -> [x -> 2; i -> 0]^1 -> [x -> 2; i -> 1]^3})$
  Stesso discorso di prima, dobbiamo far evolvere tutte le tracce in input, prendiamo l'ultima traccia di $F^3$ che è quella che ci permette di ottenere un nuovo risultato.

  Dobbiamo applicare next($3$) = $i"++" -> lbs i++ rbs [x -> 2; i -> 1]^3 = [x -> 2; i -> 2]^3$
  Così facendo otteniamo $F^4 = {[x -> 2]^0, [ x-> 2]^0 -> [x -> 2; i -> 0]^1, [x -> 2]^0 -> [x -> 2; i -> 0]^1 -> [x -> 2; i -> 1]^3}, [x -> 2]^0, [ x-> 2]^0 -> [x -> 2; i -> 0]^1, [x -> 2]^0 -> [x -> 2; i -> 0]^1 -> [x -> 2; i -> 1]^3} -> [x -> 2; i -> 2]^3}$

  Passiamo alla quinta iterazione.

  5. $F^5 = F(F^4)$, possiamo vedere questa operazione come l'unione di $F^(l-1)$ con la nuova traccia calcolata tramite next($l-1$). Quindi prendiamo l'ultima traccia di $F^4$ e calcoliamo next($3$) = *skip* $-> lbs "skip" rbs [x -> 2; i -> 2]^4$.
  Otteniamo quindi: $F^5 = F^4 union {[x -> 2]^0 -> [x -> 2; i -> 0]^1 -> [x -> 2; i -> 1]^3 -> [x -> 2; i -> 2]^3 -> [x -> 2; i -> 2]^4}$

  Infine alla sesta iterazione troviamo il fix point di $F$.

  6. $F^6 = F(F^5) = F^5$, trovato il *fix point* di $F$.
]

Se guardiamo all'iterazione 5 e 6, possiamo vedere che il fix point era stato trovato all'iterazione numero 5, però tecnicamente non ne eravamo a conoscenza, il teorema di Kleene per trovare i punti fissi ci dice di fermarci finché non troviamo $F^n = F(F^(n-1)) = F^(n-1)$.
Siamo riusciti a trovare un fix point per questo programma perché è un programma costante, se non fossimo stati a conoscenza della guardia dentro il while il problema sarebbe stato indecidibile.

