#import "@preview/fletcher:0.5.8": diagram, node, edge
= Lezione 1 del 21 settembre 2026

== Modalità esame 

Esame orale con domande di teoria più presentazione di un progetto.

== Contenuti del corso 

Il corso di Progammazione Dichiarativa si concentra sulla parte di intelligenza artificiale simbolica.

Quindi l'obiettivo è quello di saper modellare al meglio un problema di interesse in modo da farlo 
risolvere a un risolutore, detto *solver* per ottenere una soluzione corretta.


#block(
  fill: rgb("#eef4ff"),
  stroke: 1pt + rgb("#4062bb"),
  radius: 6pt,
  inset: 10pt,
)[
  Il solver è un software che permette di risolvere modelli o problemi che gli vengono forniti.

  Fornisce una soluzione corretta e dimostrabile per il problema da risolvere.
]


Il corso è molto simile a quello di Constraint Programming, infatti l'approccio è quello della programmazione dichiarativa invece di quella imperativa.

= Introduzione al corso

Una delle domande poste a lezione dal prof è come classificare l'intelligenza di un sistema AI moderno, per esempio quello di un LLM. 

Un LLM, attualmente, è in grado di generare codice di media qualità su progetti piuttosto contenuti in termini di complessità e scopo. 
Per progetti molto più complessi che richiedono codice di alta qualità è praticamente impossibile delegare 
ogni attività a un LLM.

Come possiamo dire che l'LLM abbia compreso i concetti per cui è stato addestrato e che non stia semplicemente ripetendo i pattern che è riuscito ad osservare? Stessa domanda può essere posta anche per un essere umano.


== Confronto tra reti neurali e AI simbolica
/ Reti neurali: 
  - Utilizzate dagli anni 90 in poi grazie alle prime GPU.
  - Hanno come scopo quello di simulare la struttura e il comportamento del cervello umano.
  - Hanno un approccio bottom-up, si parte dai neuroni (nodi) e si ottiene una rete.
  - Al giorno d'oggi abbiamo LLM general purpose, con l'aumento delle prestazioni delle GPU aumentano anche le prestazioni della rete.

/ AI Simbolica:
  - Utilizzate fino agli anni 90.
  - Sono dei dimostratori, infatti l'obiettivo è quello di theorem proving.
  - Hanno un approccio top-down.
  - Possiamo modellare la conoscenza del problema tramite *Knowledge representation (KR)*
  - Possiamo parlare anche di *automated reasoning (AR)*
  - È relegata a problemi più di nicchia.

Uno dei motivi per cui non si usa l'AI simbolica è dovuto al fatto che non è possibile parallelizzare la ricerca di soluzini per un dato modello dato che non girano su GPU. Questo è dovuto al fatto che la ricerca della soluzione per un dato modello avviene tramite una *catena di ragionamento* *sequenziale*; non è la stessa catena di ragionamento che usano alcune reti neurali odierne.

= Ragionamento ad alto livello

Con la programmazione dichiarativa possiamo ragionare ad alto livello senza preoccuparci di dettagli implementativi.
La conoscenza per un programma di AI simbolica è esplicita:

- Common Knowledge
- Specifiche
- Mancanza di conoscenza

Invece nel caso di una rete neurale, anche se i pesi sono in chiaro, non sono interpretabili da un essere umano.

Come possiamo vedere dall'albero di ricerca qui sotto, non è possibile parallelizzare la ricerca di una soluzione corretta poiché non siamo a conoscenza dell'intero albero, dato che i rami vengono scoperti man mano che si esplorano i nodi. Questo su un'architettura GPU comporterebbe una continua riallocazione dei worker e di risorse.

#figure(
  diagram(
    node-stroke: 0.8pt + rgb("#1a365d"),
    node-fill: rgb("#f8fafc"),
    node-corner-radius: 4pt,
    spacing: (22mm, 14mm),

    // Radice
    node((0, 0), [Goal: `soluzione(X)`], name: <root>),

    // Primo livello di tentativi
    node((-2, 1), [`X = 1`], name: <t1>),
    node((0, 1), [`X = 2`], name: <t2>),
    node((2, 1), [`X = 3`], name: <t3>),

    // Secondo livello (Esiti del Solver)
    // Ramo 1: Errato/Scartato subito
    node((-2, 2), text(fill: red.darken(20%))[*✗ Scartato* \ (Vincolo $X > 1$ fallito)], name: <f1>, stroke: 0.8pt + red, fill: rgb("#fff5f5")),

    // Ramo 2: Soluzione Corretta
    node((0, 2), text(fill: green.darken(20%))[*✓ Soluzione Corretta* \ `{X = 2}`], name: <s1>, stroke: 1.5pt + green.darken(20%), fill: rgb("#f0fdf4")),

    // Ramo 3: Tentativo che fallisce dopo un passaggio
    node((2, 2), [`verificato(3)`], name: <t3_sub>),
    node((2, 3), text(fill: red.darken(20%))[*✗ Fail* \ (Backtrack)], name: <f2>, stroke: 0.8pt + red, fill: rgb("#fff5f5")),

    // Archi: "->" SEMPRE prima dell'etichetta [Testo]
    edge(<root>, <t1>, "->", [Scelta A]),
    edge(<root>, <t2>, "->", [Scelta B], stroke: green.darken(20%) + 1.2pt),
    edge(<root>, <t3>, "->", [Scelta C]),

    // Connessioni verso i risultati
    edge(<t1>, <f1>, "->", stroke: red + 0.8pt),
    edge(<t2>, <s1>, "->", [Valido], stroke: green.darken(20%) + 1.2pt),
    edge(<t3>, <t3_sub>, "->"),
    edge(<t3_sub>, <f2>, "->", stroke: red + 0.8pt),
  ),
  caption: [Albero di esplorazione del solver: rami scartati (rosso) e soluzione (verde)]
)


== Differenze AI sub simbolica e simbolica 
/ Sub simbolica:
  - Lavora su enormi quantità di dati
  - Poco significato dei dati (dati di basso livello, es. i colori dei pixel)
  - Semantica dei dati: no 
  - Elevata velocità
  - Non molto affidabile dal punto di vista tecnico 
  - Interpretabilità: no 
  - Black box: sì 

/ Simbolica: 
  - Poca quantità di dati
  - Alto significato dei dati 
  - Semantica dei dati: sì 
  - Bassa velocità
  - Altamente affidabile, la soluzione è sempre corretta (se il modello è corretto); il solver fornisce una dimostrazione della correttezza della soluzione.
  - Interpretabilità: sì
  - Black box: no

== Differenze tra Progammazione Imperativa e Dichiarativa

/ Programmazione imperativa: 
  - Specifiche: Spesso informali, e molto vicine all'implemetazione del codice vero e proprio.
  - Modello algoritmico.
  - Implementazione.
  - Manutenzione: bug fixing ed evolutiva.

/ Progammazione dichiarativa: 
  - Specifiche + *KR*: possono essere viste come un contratto matematico. Le specifiche sono praticamente il programma da risolvere.
  - Goal (obiettivo): porta alla soluzione del problema grazie al *solver* che si occupa di *AR*
  - Specifiche e Goal formano quello che si chiama *modello*.
