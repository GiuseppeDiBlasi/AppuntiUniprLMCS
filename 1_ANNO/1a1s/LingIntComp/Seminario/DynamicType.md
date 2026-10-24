# Gestione tipi dinamici

Un sistema di tipi ben formato permette al compilatore di evitare errori a tempo d'esecuzione. Nella realtà è un po' piu' complesso di così, in teoria un buon sistema di tipizzazione permette l'esecuzione di programmi validi, ma il compilatore non è in grado di riconoscere tutti i programmi non validi.
Alcuni errori a run-time non sono così semplici da individuare, per esempio:
- Dereference di un un puntatore out of bounds
- Interpretazione di un valore float in un booleano

Dunque l'obiettivo del compilatore è eliminare quanti più errori a run-time possibili. 
Per riuscire in questa operazione il compilatore deve fare inferenza di tipo su ogni espressione.
Tornando all'esempio della conversione implicita di un float a un booleano, il compilatore vede un numero float utilizzato al posto di un valore booleano e deve controllare cosa le regole del linguaggio gli permettono di fare. Se le regole gli permettono di procedere con una conversione implicita nessun problema, altrimenti il compilatore dichiara il programma non valido e quindi non eseguibile.

- Inferenza del tipo: il processo per cui il compilatore riesce a stabilire il tipo per ogni nome e/o espressione all'interno del codice.


