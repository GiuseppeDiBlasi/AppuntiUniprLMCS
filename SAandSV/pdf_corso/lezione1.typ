#import "../../Template typst/template.typ": definition, theorem

= Lezione 1 del 23 settembre 2026

== Introduzione al corso

Il corso di Analisi statica e verifica del software ha come obiettivo quello di fornire tecniche e metodologie per costruire programmi di analisi statica per poter verificare la correttezza e la validità di un programma.

== Affidabilità del software

Cosa si intende per *affidabilità*?

Una definizione secondo l'IEEE è: _Abilità del sistema, o di un componente, di rispettare i requisiti sotto determinate condizioni._

L'affidabilità di un sistema software è composta da 3 diverse attività:

- Error prevention
- Fault detection
- Rimozione e correzione di bug

Perché l'affidabilità del software è importante?

La correzione di bug è parte integrante del ciclo di sviluppo di un sistema software, e una eventuale correzione dopo che il sistema è stato rilasciato comporta un costo maggiore rispetto a correggerlo prima della messa sul mercato.

Per esempio gli Stati Uniti perdono 2,116 mila miliardi di dollari del loro PIL a causa di bug, falle di sicurezza in software scadenti.

Quindi la presenza di bug non solo comporta problemi d'esecuzione per il programma ma anche costi economici e temporali.

=== Esempi di danni economici

==== Ariane 5 Flight 501 (1996)

Era un test di un razzo spaziale, si è schiantato appena dopo il decollo per un bug all'interno del codice dovuto ad un cast da 64 bit float a 16 bit unsigned.
Sono stati persi 370 milioni di dollari per quell'incidente.

==== Pentium FDIV bug (1994)

Errore nel processore Intel per le divisioni tra float, ha costretto Intel a rimuovere il processore dal mercato e correggere l'errore.
Anche in questo caso il costo economico è piuttosto elevato di circa 475 milioni di dollari.

==== CrowdStrike (2024)

Questo errore nel software ha portato alla cancellazione di 5 mila voli.
Impattando anche sui sistemi informatici di banche, enti governativi e strutture sanitarie, portando a un costo totale di 5 miliardi di dollari.

L'errore era dovuto alla dereferenziazione di un puntatore null.

=== Software immutabile

Nel caso della blockchain Etherium era stato scoperto un bug che comportava la perdita del portafoglio per via dell'ordine d'esecuzione di due istruzioni che dovevano essere invertite.
La blockchain può essere vista come un software immutabile, il che comporta che anche i bug siano immutabili.

Questo ha portato alla creazione di un fork di Etherium per correggere l'errore.

== Validazione vs Verifica

Cosa si intende per validazione del software?
Risponde alla domanda: _Il software rispecchia i bisogni dell'utente?_

Quindi ci chiediamo se stiamo costruendo il software in base alle richieste dell'utente.

Mentre la verifica risponde alla domanda: _Il software soddisfa le specifiche e i requisiti?_

#image("img/lezione1/validazioneVSverifica.svg", width: 100%)

- Validazione: usability testing, feedback da utente e stesura dei requisiti
- Verifica: testing, analisi statica

Ci sono casi in cui alcune specifiche sono validabili, ma non verificabili e viceversa.
Esempio di specifica non verificabile:

_Se l'utente preme il bottone per chiamare l'ascensore a un determinato piano dell'edificio
l'ascensore deve arrivare entro un determinato tempo al piano desiderato_

Esempio di specifica verificabile:

_Se l'utente preme il bottone per chiamare l'ascensore a un determinato piano dell'edificio
l'ascensore deve arrivare entro 30 secondi al piano desiderato_

== Verifica del software

A cosa serve la verifica del software?

Serve a verificare la correttezza di un software rispetto:
- la *correttezza funzionale*, il programma offre i servizi definiti nei requisiti e specifiche
- l'*assenza di errori non-funzionali*, ovvero:
  - rispetto dei vincoli spaziali
  - rispetto dei vincoli temporali
  - soddisfare vincoli di sicurezza

In questo corso per verifica del software si intende ricercare certificati di correttezza.

Purtroppo non esiste un tool di analisi statica che sia:
- *Automatico*: senza interazione umana
- *Potente*: capacità di trovare proprietà non banali, ovvero proprietà semantiche
- *Sound*: Trovare errori evitando falsi negativi.
- *Completo*: Trovare errori e garantire la correttezza se il programma è corretto, evita falsi positivi.

Un tool con tutte queste proprietà non esiste.

#theorem(name: "Teorema di Rice (Rice's Theorem)")[
  Nella teoria della calcolabilità, il *teorema di Rice*  dice che tutte le proprietà *non-banali*
  di un programma in un linguaggio Turing-completo sono *indecidibili*.

  Per proprietà semantica si intende il comportamento del programma, per esempio se l'esecuzione termina per tutti i valori
  presenti nell'insieme di input.
]

Siccome non possiamo avere un tool perfetto siamo costretti a scendere a compromessi, questo è un po' così in tutta l'informatica
ovvero cercare il compromesso migliore per il nostro obiettivo.

Quindi dobbiamo farci la domanda: _A cosa possiamo rinunciare?_

Sicuramente non possiamo rinunciare alla soundness, dato che l'obiettivo del corso è dimostrare la correttezza del software.
Sicuramente avere sia completezza che soundness è molto difficile, saranno le due proprietà su cui dovremo fare più compromessi.

#definition(name: "Analisi dinamica")[

  #image("img/lezione1/analisi_dinamica.svg", width: 100%)

  L'analisi dinamica lavora su un sotto insieme dei possibili valori di input, dunque manca di completezza.
]

#pagebreak()

#definition(name: "Analisi statica")[

  #image("img/lezione1/analisi_statica.svg", width: 100%)

  L'analisi statica ci permette di avere completezza su tutti gli input possibili per il programma, ma a discapito di precisione.
]

Le varie tecniche per l'analisi statica sono:

- Interpretazione astratta
- Model checking
- Symbolic execution
