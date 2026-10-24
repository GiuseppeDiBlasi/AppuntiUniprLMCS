Farlo su un argomento di cui il prof non sa niente ?????????

Il seminario deve avere una durata massima di 15 minuti.

- Compilazione JIT (just in time)
- Come vengono gestiti i tipi statici e dinamici (interessante)
- Linking e keyword management
- Come funziona la garbage collection
- Ottimizzazioni del compilatore: come ottimizza le iterazioni, chiamate multiple di funzione, di conseguenza confronto tra codice sorgente e assembly
- Maximal munch scanner (visto nelle slide 06-Building-Scanners, da li si puo fare un approfonditamento)

--------------------------------------------------------------- 
Gli argomenti riportati sopra sono stati chiesti a chatGPT, ovviamente, si parte
dall'idea che uno debba studiarselo per conto proprio.
Quelli riportati qui sotto sono stati proposti dal prof a lezione.

- WebAssembly
- Type inference, e vari altri argomenti di controllo semantico.

Lezione del 14/11/2025:
Idee dette dal prof per un seminario, fare qualcosa ad alto livello tipo:

- Strumento realizzato usando le conoscenze dei compilatori:
  spiegare perché può essere utile, come funziona, e mostrare anche qualche caso d'uso reale
 un esempio può essere clang-tidy, i sanitizer, 
- Un altro argomento possono essere le varie ottimizzazioni a basso livello del middle-end:
  si può scegliere uno dei vari passi di ottimizzazione eseguiti dal middle-end e farci un seminario.

Un altro argomento è l'Interpretazione astratta, il prof dà un articolo e si cerca di fare uno 
studio "critico" riguardante l'argomento.


-----------------------------------------------------------------

Sources worth studying

"Engineering a Compiler" by Keith Cooper & Linda Torczon – covers the theory of compilation, including handling dynamic constructs.

"Modern Compiler Implementation in ML/Java/C" by Andrew Appel – a practical bible.

The Dragon Book ("Compilers: Principles, Techniques, and Tools" by Aho, Lam, Sethi, Ullman) – the classic. It’s heavy, but thorough.

V8 blog & docs (JavaScript engine internals): https://v8.de


