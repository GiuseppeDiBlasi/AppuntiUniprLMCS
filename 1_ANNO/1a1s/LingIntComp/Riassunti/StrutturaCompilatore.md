# Struttura di un compilatore

Consideriamo la struttura di un compilatore :

Codice sorgente in L                              Codice macchina in M 
-------------------->      Compilatore    -------------->


Il compilatore ci permette di tradurre partendo da del codice sorgente in L a un codice macchina M, detto anche target.
Il compilatore inoltre puo' mandare dei warning o errori. In caso di errori il compilatore si rifiuta di generare il codice M.
I warning invece sono degli avvisi mandati dal compilatore che potrebbero far insorgere errori.

Il compilatore deve rispettare i seguenti requisiti:
- Riconoscere programmi validi e non validi
- Generare codice corretto rispettando la semantica del codice sorgente
- Gestire le risorse (allocazione e deallocazione della memoria)
- Interagire col sistema operativo (es. linking dinamico)

# Compilatore a 2 passi:

Prendiamo in considerazione un tradizionale compilatore a 2 passi:

Codice in L ---->  | Front-end | --- IR ---> | Back-end | ---> Codice per M

IR: Rappresentazione Intermedia

Front-end: si occupa delle dipendenze per il linguaggio L

Back-end: si occupa delle dipendenze per il target M

E' possibile avere piu' front-end e/o piu' back-end.

IR: Il linguaggio IR serve a rendere indipendente il front-end dal back-end, rendere indipendente back-end e front-end tra loro permette di poter lavorare con piu' back-end. Esistono varie tipologie di Linguaggi IR; l' IR deve poter rappresentare le informazioni raccolte dal compilatore.

Tipologie di IR:
- Strutturali: Alberi, Grafi, DAG
- Lineari: 3-address code, stack-machine code
- Ibridi: CFG (Control Flow Graph) per BB (Basic Block)

Le soluzioni ibride uniscono i pro delle prime due.

Esempi di IR: 
- GCC ---> RTL (Register Transfer Language)
- LLVM ---> LLVM bitcode.

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

# Front-end (non c'entra nulla con l' IDE)

Deve prendere in input un linguaggio L e produrre il codice IR corrispondente.

Il front-end e' composto da:

codice L ---->  | Lexer | -- tokens --> | Parser | -- IR --> | Checker | ----> IR


- Lexer
Si occupa dell' analisi lessicale, prende in input un file scritto in codice L e legge il file intero carattere per carattere. Per questo motivo il lexer deve essere efficiente. In output produce una sequenza di tokens.

-  Parser
Esegue l'analisi sintattica, libera da contesto) prende la sequenza di token e genera il codice IR.

-  Checker
Controlla le frasi scritte siano sintatticamente corrette e semanticamente corrette. (dipendenze dal contesto)


## Lexer
Prende in input una sequenza di caratteri e produce in output una sequenza di "tokens". produce quindi una coppia formata da:

< part of speech, lexema >

Esempi:

< FLOAT,  3.1415  >,  < KWD,  while > 

- "FLOAT" e' la classificazione della sequenza di caratteri
- "3.1415" e' la sequenza di caratteri
  

### Specifica vs Implementazione

Per quanto riguarda la specifica occorre definire in modo rigoroso la validita' dei token, per questo motivo si usano le espressione regolari che sono meglio comprensibili dall' essere umano.

Per quanto riguarda l' implementazione il fattore critico e' l' efficienza visto che bisogna analizzare una sequenza di caratteri, infatti i lexer vengono chiamati anche scanner.
Si utilizzano dei DFSA (Automi a stati finiti deterministici) spesso vengono generati automaticamente partendo dalla specifica.

------ ------   ------  ------

## Parser

Il parser puo' lanciare errori/warning. 
Prende in input la sequenza di token generata dal Lexer, genera in output il codice IR della struttura sintattica.
L'output deve essere adegueto per le fasi successive:
- Parse tree (Concrete Syntax Tree), usata raramente perche' contiene troppi dettagli per quello che vogliamo rappresentare
- AST (Abstract Syntax Tree)

### Specifica vs Implementazione
Anche qui abbiamo il problema della rappresentazione delle specifiche e dell' implementazione.
Come linguaggi di specifica si usano le CFG (Context Free Grammar) che sono comprensibili dal progettista.
Bisogna risolvere problemi non banali tra cui (determinismo, efficienza e ambiguita')

Per la parte di implementazione si usa un PDA (Automa a pila non deterministico), ovviamente si cerca di ottenere uno stato deterministico.
A volte per evitare di gestire uno stack come struttura dati si sfruttano anche funzioni ricorsive.

## Checker

Il Checker si occupa della fase di analisi semantica statica (context-sensitive analysis), vuol dire che possiamo risolvere solamente problemi decidibili.
Prende in input l'AST dal parser e lo arricchisce con le informazioni riguardanti il contesto (tipi di dato, conversioni implicite, risoluzioni di overloading...). Spesso Parser e Checker sono fortemente integrati tra loro per motivi di efficienza. in questi casi si genera direttamente l'AST arricchito dal parse tree.

### Specifiche vs Implementazione 

Un problema fondamentale e' stabilire in modo rigoroso le regole del linguaggio per definire programmi validi.
Si usa il linguaggio naturale, per esempio: standard del linguaggio, manualistica, documentazione del compilatore.

Quando si passa all'implementazione un fattore importante da tenere in considerazione e' la correttezza. In passato si usavano grammatiche arricchite da attributi calcolati.
Piu' frequentemente si usano i SDT (Syntax Directed Translation) utilizzando specifici algoritmi di visita (Visitor).


-------------------------------------------------------------------------------------------------------------------------------

# Back-end

codice L ----> | Front-end | -- IR --> | Back-end | ----> codice M

Il back-end si occupa delle dipendenze del target M: i requisit per un back-end sono:

- Prende in input l' IR e produce in output codice M. 
- Deve scegliere quali istruzioni per implementare le operazioni.
- Decidere quali valori mantenere nei registri.
- Rispettare interfacce di sistema

## Decomposizione del back-end

IR ----> | INSTRUCTION SELECTION | ----> | REGISTER ALLOCATION | ----> | INSTRUCTION SCHEDULING | ----> codice M

N.B: durante queste fasi sono ancora possibili errori e warning.

Queste operazioni si occupano di:

- Selezione di istruzioni
- Allocazione di registri
- Scheduling istruzioni
- Problemi inerentemnte complicati
- Applicazione di tecniche euristiche

## Instruction selection

La fase di instruction selecton produce il codice M che deve essere veloce in esecuzione e compatto in spazio sfruttando a pieno l'architettura hardware.
Spesso viene visto come un problema di pattern matching. 
Si sfrutta la ricerca di ottimi locali (approssimazioni).

## Register allocation

Deve gestire un insieme finito di risorse, ovvero i registri della CPU.
Spilling dei registri: sfruttare istruzioni di LOAD e STORE per poter eseguire calcoli quando non si hanno abbastanza registri spostando in memoria valori che al momento non sono necessari.
Si sfruttano algoritmi per la colorazione dei grafi.

## Instruction scheduling

Deve gestire le dipendenze delle istruzioni, quindi evitare attese inutili. Ottimizza l'uso delle unita' funzionali della CPU. Puo' modificare il tempo di vita dei vari registri, quindi influenzarne la loro allocazione).

# Middle-end
A volte si puo' avere un middle-end che risiede tra front-end e back-end

codice L ----> | Front-end | -- IR --> | Middle-end | -- IR --> | Back-end | ----> codice M

Ha come obiettivo quello di analizzare il codice e migliorarlo.
Come metriche di miglioramento abbiamo:
- Classiche: tempo di esecuzione, spazio di memoria
- Recenti: consumo energetico, risorse hardware (ridurre al minimo l' utilizzo di unita' funzionali della CPU)

Deve preservare la semantica del programma, ovvero il significato delle istruzioni.

Il middle-end puo essere composto da piu' passaggi

IR ----> | P1 -- IR --> P2 -- IR --> ... --> Pn | -- IR -->

- Il middle-end e' suddiviso possibilmente ripetuti, per esempio da Pn posso tornare a P1.
- Ogni passo mantiene la semantica del programma
- Un singolo passo implementa una analisi o trasformazione IR
- Un passo puo' dipendere e/o invalidare altri passi
- La sequenza dei passi dipende dal compilatore e dalle opzioni utilizzate.

Esempi di passi del middle-end:
- Passi di analisi, dove vengono identificati valori costanti, codice o valori inutili e analisi di aliasing
- Passi di trasformazione, propagazione di lavori costanti, rimozione di codice inutile, inlining di chiamate a fuznione e loop unrolling.

Questa separazione dei componenti permette di:
- Riutilizzare gran parte del Front-end per implementare interpreti.
- Compilazione JIT (Just In Time): passi del middle-end scelti a run-time
- Semplificaizone dello sviluppo di analisi ad hoc (clang-tidy)
- Integrazione con IDE (editori, debugger, ...)

---------------------------------------------------------------------------------------------------------------------------------------------------------

# Riassunto 
Per riassumere:

Struttura di un compilatore

Codice in L ----> | Front-end | -- IR --> | Middle-end | -- IR --> | Back-end | ----> Codice in M

## Front-end 
Si occupa di analizzare una sequenza di caratteri prendendo in input un linguaggio L e producendo in output una rappresentazione intermedia (IR), la IR serve a rendere front-end e back-end indipendenti tra loro.
Si divide in:
- Lexer: analisi lessicale, prende in input una sequenza di caratteri e produce in output una sequenza di tokens < part of speech, lexema >, l' efficienza e' cruciale per il lexer.
- Parser: analisi sintattica, prende in input la sequenza di token dal Lexer, e produce in output un AST.
- Checker: analisi semantica statica, prende in input l' AST dal parser e produce in output un AST arrichitto con informazioni basate sul contesto.
Spesso Parser e Checker sono fortemente integrati per motivi di efficienza.

## Back-end 
 Si occupa delle dipendenze del target M, deve tradurre l' IR in codice per il target M (nella maggior parte dei casi linguaggio macchina M).
 Deve scegliere quali istruzioni scegliere per implementare le operazioni. Decidere quali valori mantenere nei registri e deve rispettare le interfacce di sistema. Il back-end puo' essere visto come:

 - Instruction Selection: produrre il codice M veloce in esecuzione con minor spazio occupato possibile, sfruttando l' architettura hardware. Spesso viene visto come un problema di pattern matching. Si sfrutta lar icerca di ottimi locali (approssimazioni).

 - Register Allocation: Deve gestire un insieme finito di risorse, ovvero i registri della CPU. Si sfrutta lo spilling dei registri per spostare in memoria dati che al momento non necessari sfruttando istruzioni di LOAD e STORE.
Si sfruttano algoritmi per la risoluzione della colorazione dei grafi.

 - Instruction Scheduling: Deve occuparsi della gestione delle dipendenze tra le istruzioni, ottimizzare l' uso delle unita' funzionali della CPU (ALU...)
 Puo' modificare il tempo di vita dei valori nei registri (quindi influenzare la loro allocazione).

## Middle-end
 Posto tra il fron-end e il back-end, ha come obiettivo analizzare il code IR e migliorarlo riducendo i tempi di esecuzione, uso della memoria, consumo energetico e utilizzare minor risorse hardware possibili.
 E' suddiviso in n passi che possono essere passi di analisi o di trasformazione. I passi di analisi individuano le parti del codice da ottimizzare, mentre i passi di trasformazione ottimizzano il codice mantenendo la semantica delle istruzioni.
 Un passo puo dipendere e/o invalidare altri passi. La sequenza dei passi del middle-end dipende dal compilatore e dalle opzioni di compilazione.

 La strutturazione del compilatore permette di ottenere notevoli vantaggi:
 - I front-end possono essere riutilizzati per implementare interpreti.
 - Compilazione JIT (Just In Time): passi del middle-end scelti a run-time.
 - Semplificazioen sviluppo di anlisi ad hoc (clang-tidy)
 - Integrazione con IDE (editori, debugger, ...)
