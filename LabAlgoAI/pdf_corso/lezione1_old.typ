#import "../../Template typst/template.typ": c-border, definition, exam, example, note, theorem, warning
= Lezione 1 del 23 settembre 2026

== Introduzione Python

La lezione si concentra su una introduzione a python 3.
La parte relativa agli esempi su python sono sulle slide, in questo capitolo che si concentra sulla lezione 1
ci saranno  per lo più accorgimenti sui punti più importanti che riguardano alcune peculiarità del linguaggio.

Il prof ci tiene a sottolineare la perdita di significato che si ha nel tradurre parole dall'inglese all'italiano, per esempio per *script*, che in italiano vuol dire copione; quindi bisogna prestare attenzione a usare termini inglesi o a tradurli senza comprendre a pieno il loro significato semantico/storico.

Una cosa fondamentale a cui prestare attenzione è se un oggetto in python è *immutabile* o *mutabile*.
Per esempio le liste sono mutabili mentre le tuple non lo sono, questo è dovuto principalmente al modo in cui sono implementate dietro le quinte.

#let ptr = "ptr"

Le liste seguono la classica implementazione dove abbiamo $ptr_1 -> ptr_2 -> ... -> ptr_n$.
Mentre le tuple sono implementate tramite array C, che sono immutabili e hanno una dimensione fissa; anche se il C permette di accedere a un array al di fuori del range (undefined behaviour da evitare).

Anche alcune funzioni per oggetti immutabili restituiscono una copia dell'oggetto oppure modificano direttamente l'istanza che invoca il metodo.

Quando lavoriamo in questo ambito la parte più complessa è riuscire ad ottenere il modello matematico per rappresentare il problema che vogliamo risolvere.
Una volta ottenuto il modello la traduzione in codice diventa la parte più semplice.

Un'altra cosa fondamentale è la riproducibilità dei risultati, sopratutto per alcune tecniche di machine learning che prevedono di estrarre dati casuali da un dataset.
I dati verranno estratti casualmente da generatori di numeri casuali.
Per evitare risultati diversi ad ogni esecuzione, si fissa il *seed* del generatore a un numero predefinito in modo da ottenere sempre lo stesso risultato ad ogni esecuzione.

Un altro aspetto importante nei nostri progetti, in generale in qualsiasi tipo di progetto, è riuscire a modellare correttamente la struttura dati per rappresentare al meglio il problema.
Per esempio se abbiamo delle reti neurali che lavorano su immagini, avremo una matrice $W times H$ che contiene i valori di ogni pixel dell'immagine.
Delle strutture dati progettate correttamente permettono anche di scomporre dati complessi in dati più semplici.
