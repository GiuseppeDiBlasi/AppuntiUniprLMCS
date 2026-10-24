#import "../../Template typst/template.typ": (
  c-border, definition, exam, example, note, recall, sqglb, sqle, sqlub, theorem,
)

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


= Lezione 7 del 7 ottobre 2026

Abbiamo visto nella scorsa lezione la semantica delle tracce che non sempre è calcolabile per tutti i programmi.
Avevamo accennato anche alla *collective semantics*, che ci permette di tenere informazioni sui valori che possono assumere le variabili ad ogni punto d'esecuzione del programma.

Per ottenere i dati per la collective semantics, prendo tutte le memorie al punto $n$ di ogni traccia che ho ottenuto dalla trace semantics e unisco i valori tra loro.

Se prendiamo in esempio il codice che abbiamo visto la scorsa lezione:

#example[

  ```
  i = 0;
  while(i < x)
  i = i + 1;
  ```

  - Per il punto #cerchiato(0) avremo $[x -> 2]$, che era definito come stato iniziale.
  - Per il punto #cerchiato(1) avremo ${[x -> 2, i -> 0]}$.
  - Per il punto #cerchiato(3) avremo ${[x -> 2, i -> 1]; [x -> 2, i -> 2]}$.

]

Come già detto nella scorsa lezione, con la collective semantics perdiamo la relazionalità tra le tracce, dal punto #cerchiato(1) al punto #cerchiato(3) non riusciamo a ricostruire correttamente la traccia originale.

Passiamo ora a definire formalmente la collective semantics.

#set list(spacing: 2em)
#let lbs = $bracket.l.stroked$
#let rbs = $bracket.r.stroked$

== Collective semantics <col-sem>

- $lbs dot rbs_c cal(P) -> cal(P)$; semantica collettiva per gli statement.
- $lbs "skip" rbs_c thick cal(M) = cal(M)$
- $lbs s_0 thick s_1 rbs_c thick cal(M) = lbs s_1 rbs_c (lbs s_0 rbs_c cal(M))$
- $lbs x = e rbs_c thick cal(M) = {m [x <- lbs e rbs^m] | m in M}; quad$ $lbs e rbs^m$ è la semantica dell'interprete e non la collecting.
- $lbs "if" thick b "then" s_0 "else" s_1 rbs_c cal(M) = lbs s_0 rbs_c cal(M) |_b union lbs s_1 rbs_c cal(M) |_(!b)$
- $lbs "while" thick b thick s rbs_c cal(M) = (union_(i >= 0) (lbs s rbs_c dot |_b)^i cal(M)) |_(!b) equiv ("lfp"_(M_0)^subset.eq thick F) |_(!b)$

L'operatore $|_b$ vuol dire filtrare da $b$ positivo (!b vuol dire filtrato da not $b$), definendo formalmente otteniamo: $cal(M) |_b = {m | lbs b rbs^m = "TT"}$

La semantica del *while* è un po' complessa, cerchiamo di spiegarla a parole. La sintassi del *while* restituisce in output il set delle memorie dove $b$ è falso.
Tutti gli insiemi per cui $b$ è positivo rimangono all'interno del ciclo *while*.

Vediamo un esempio per l'*if*:

#example[
  Abbiamo il seguente set di memorie: ${[x -> 3, y -> 1], [x -> 6, y -> 2], [x -> 9]}$

  Prendiamo il seguente codice come esempio:

  ```
  if (x < 5)
    y = 10
  else
    y = 11
  ```
  Applichiamo la *collective semantics* per l'*if* e otteniamo il nuovo set di memorie:

  ${[x -> 3, y -> 10], [x -> 6, y -> 11], [x -> 9, y -> 11]}$
]

#set list(spacing: 1em)


== Analisi Data Flow (Data Flow Analysis, DFA); Slide 04

Il prof ha iniziato a riprendere concetti di Data Flow Analysis, il punto principale non è saper fare DFA ma capire cosa comporta la DFA quando vogliamo fare interpretazione astratta.

#exam[
  Capire cosa comporta l'analisi data flow per l'interpretazione astratta.
]

In interpretazione astratta possiamo fare analisi con domini non ACC (Ascending Chain Condition).

#recall(topic: "Ascending Chain Condition")[
  Come visto in @catene, l'*Ascending Chain Condition* ci dice che possiamo trovare un punto fisso per catene ascendenti infinite perché tendono a stabilizzarsi su un punto fisso.
]

Nell'analisi data flow usiamo i CFG, *Control Flow Graph*, per rappresentare il flusso d'esecuzione di un programma.
L'analisi DFA viene usata dai compilatori per ottimizzare il codice in output.

Per esempio un'ottimizzazione fatta tramite DFA è quella delle *available expression*.

#definition(name: "Available expression")[
  Tipo di ottimizzazione dove il compilatore invece di ricalcolare la stessa espressione controlla se sia
  già salvata in memoria, e soprattutto che *non sia stata modificata* durante l'esecuzione dal punto in cui viene
  calcolata al punto in cui vogliamo usarla, questo su *tutti* i percorsi del programma, evitando di doverla
  ricalcolare in altri punti del programma.

  Utile per:
  - Evitare di valutare la stessa espressione più volte.
  - Salvare il valore in un registro temporaneo.

  - Quando $x$ viene assegnato, tutte le espressioni contenenti $x$ non sono più disponibili (killed).
  - Quando $x$ viene assegnato, tutte le espressioni calcolate diventano available (gen).

]

Noi ci concentreremo su espressioni aritmetiche.

