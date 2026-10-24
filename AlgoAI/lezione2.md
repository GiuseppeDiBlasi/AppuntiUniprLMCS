# Lezione del 25  settembre 2026

# Introduzione alla classificazione

Saper dividere oggetti in base alle loro classi di appartenenza, utilizzeremo modelli per ottenere questa classificazione


i modeli che riesocno a distinguere solamente tra due classi sono ciamati modelli semplici

ovviaemnte posisamo avere problemi di classificazine con più classi, questi saranno i casi più comuni

è importante capire come misurare le peformance del modello.


l'obiettivo è sempre ottimizzare le peformance.
questo influisce anche sulla scelta del modello.

il modello è influenzato anche dalle metriche che vogliamo massimizzare o minimizzare 


oggetti -> in inglese sample, sono all'interno di uno spazio, ogni oggeto ha le sue caratteristiche in base a cosa
riteniamo misurabile

in base a queste feature dobbiamo capire come si dividono gli oggetti 

il modello deve poter dire a quale classe appartiene un input tramite label, o etichette.

La classe è qualcosa che di solito diamo per scontato, in realta è una cosa molta soggettiva.
SIamo noi a suddividere un determinato gruppo in più sottoclassificazione. 

# Esempio classificazione uomini e donne

Facciamo inferenza su metriche che non possiamo misurare direttamente a volte.

Per dividere i pesci, le differenze sono nel DNA, con una foto non riusciamo a leggere direttamente il DNA.
Abbiamo quindi delle misurazioni indirette.

BIsogna chiedersi se possiamo sempre dividere direttamente gli oggetti in 2 classi, o se è un effetto indiretto.
(Caratteristiche visibili -> dovute al DNA)

Nella pratica c'è sempre la sfumatura tra due classi.

un problema va definito in termini matematici.


# Classificazione 

come stabilire se il tasso di errore di un modello è accettabile?

50% di errore non è accettabile, perchè il modello non ha imparato nulla dal dataset, il modello è a caso.
100% di accuratezza il modello è in overfitting 

un tasso di errore tra 1 e 20 è accetabile a seconda dell'applicazione  
un modello con tasso di errore del 100% su classi binarie è un buon modello?

il modello RGB permette di rappresentare i possibili colori che può assumere un pixel.

## Classificazione dei fiori Iris 
algoritmo e modello vanno sempre assieme.

# Domanda per esame 

perché il dataset di fisher non puo essere più attuale.

i modelli possono essere sia descrittivi che predittivi -> esempio orbite pianeti.

c'è un modello utilizzato come modello descrittivo, ovvero gli alberi di decisione.

# Come fanno sti algoritmi ad imparare?

L'addestramento è simile a quello di un essere umano, l'apprendimento avviene per errore.
Da piccoli si impara a camminare tramite errori, man mano che si commettono errori più 
si apprende l'abilità di camminare.

Anche il modo in cui si imprenditoria è così, tutti i capi di grnadi aziende hanno una marea 
di aziende e progetti andati in fallimento.

Si sbaglia finché non riusciamo a trovare la giusta soluzione per il problema.

Non tutti gli algoritmi hanno questo stile di apprendimento, quelli che lo hanno sono algoritmi per addestramento con rinforzo.
Gli alberi di decisione non hanno questa caratteristica.

Sample -> campione: lavora su un sottoinsieme dell'intero universo che stiamo osservando.

possiamo avere anche modelli fuzzy o soft, che danno una stima probabilistica sulla classe d'appartenenza di un sample. 

# Come contare gli errori

Si usa di solito una matrice di confusione. DA CAPIRE.

alcune misure sono indipendenti da chi scelgo positivo o negativo, mentre altre sono altamente dipendenti.

Un dataset sbilanciato va a inficiare sulle prestazioni del modello.

# Costruzione di un classificatore 

# Fasi di un sistema di classificazione automatica 

# Perché l'informatica è una scienza? 

Alan Turing, ha creato la macchina di Turing per replicare il ragionamento umano e studiarlo.
è una semplificazione del cacolo.

L'essere umano è l'unico essere vivente in grado di calcolare?
Anche le cellule sono in grado di eseguire calcolare.

Esistono anche intelligenze a sciame.

Quindi gli informatici studiano il cacolo.

il calcolo per il computer deve essere matematico.

Nel campo in cui le feature sono numeri siamo nel campo della matemtica. 
Se siamo nel campo delle feature categoriali sono divisi in: 
- ordinali: possono essere confrontati direttamente 
- non-ordinali: si usa one-hot encoding (mettere un richiamo); non si confrontano direttamente
diventa importante come rappresentare i dati e come calcolare le vicinanze.

ho vari tipi per rappresenare le distanze:
euclidea
bag of words -> simile a one hot encoding

Gli algortimi più potenti sfruttano le probabilità e l'entropia.




