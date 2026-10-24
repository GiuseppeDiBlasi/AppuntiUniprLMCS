# Lezione 2 del 28 settembre 2026

Da pag 7 del pdf fino a pag 15 compresa. prima della definizione 2.10 

Per questo corso è fondamentale cercare di cambiare approccio quando dobbiamo scrivere i nostri programmi.
Siamo sempre stati abituati all'approccio imperativo anche perché è quello più naturale dal punto di vista
del ragionamento umano, una sequenza di istruzioni da eseguire.

# Introduzione 

_Introduzione pdf_

Una buona capacità di un informatico è quella di capire le caratteristiche di un altro dominio (risolvere il problema del cliente) in modo tale 
da poterlo tradurre in ambito informatico. Fondamentale per la fase dell'analisi dei requisiti.

Dobbiamo imparare a scindere tra specifiche e implementazione.
Le specifiche mi dicono cosa mi serve per ottenere il risultato; per esempio pre e post condizioni.
L'implementazione dice come si ottiene effettivamente il risultato.

La programmazione dichiarativa non rispechcai questo modello di sviluppo del software.

IL classico modello cerca di capire qual è il problema da risolvere nella prima fase, quindi COSA risolvere.
Nella seconda fase invece ci si concentra su COME risolvere il problema.

In questo corso ci concentriamo su COSA fare, anche erhcè nel amagigor parte delel volte quando un cliente 
ci spiega un problema andiamo direttamente a COME risolverlo, per esempio mentre leggiamo le specifiche abbiamo già in mente come risolverlo.
DOvremmo teenere in considerazione tutte le possibili modellazioni per risolvere il problema.

è importante formalizzare cosa fare, utilizzando un linguaggio formale rispetto al linguaggio naturale che presenta ambiguità.
COme linguaggio possiamo usare quello della logica; il signficiato di uan proposizione nel linguaggio logico è chiaro e NON ambiguo.

L'obiettivo della programmazioen dichariativa è:

- usare un linguaggio logico per modellare le specifiche.
- Usare un compialtore/interprete per _eseguire_ le specifiche.

Con ProgDich possiamo ottenere risultati come la programmazione imperativa, oppure possiamo anche verificare la correttezza delle specifiche.

Con questo approccio ci concentriamo esclusivamente sul COSA risolvere.
Non sempre l'approccio dichiaritva è più veloce, in alcune casistiche, come problemi combinatori, risulta l'approccio migliore.

Volendo possiamo anche utilizzare la prog dic per una fase iniziale della prototipazione di un approccio imperativo, in modo da 
verificare la correttezza con le specifiche, permettendoci di evitare di andare direttamente all'implementazione che richiede una grande parte dello sviluppo software.

Precisiamo che l'approccio dichiaritivo non si oppone a quello imperativo, a volte magari l'approccio migliore è quello dichiartivo, ma sicuramente 
usarle etnrambe durante la fase di sviluppo è un grande vantaggio sulle prototipazioni veloci come detto precedentemente.

Un grande vantaggio della prog dic è che la soluzione è corretta al 100%, fornendo un certificato di correttezza della soluzione.
Nel caso in cui ci dovesse essere un errore, è un errore delle specifiche, non della soluzione.

Nel caso imperativo si aggiunge anche la possiblità di errore nella fase implementativa, oltre a quella delle specifiche.

In un contesto critico, la prog dic torna molto utile per garantire la correttezza.

# Richiami di logica 

Logica dei predicati, lavoriamo su oggetti e proprietà per esprimere concetti in modo rigoroso.

Fare esempi 

Fondamentale per il corso.

Possiamo usare le funzioni per semplificare alcuni predicati che sarebbero piuttosto complessi da descrivere.

predicato e funzioni sono cose diverse.

Le funzioni creano termini, i predicati non hanno una definizione ricorsiva, dovuto al fatto che i predicati generano una formula atomica (proprietà).

# Sintassi

arità, misura di quanti argomenti ha un certo simbolo che usiamo.

DObbiamo cercare di avere più enunciati possibili ed evitare variabili libere.

# Semantica 

(A, non calligrafica, idnica un oggetto del mondo che stiamo rappresentando; dominio)
