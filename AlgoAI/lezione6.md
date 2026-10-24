# Lezione 6 del 9 ottobre 2026

COSA MOLTO IMPORTANTE: tutta la parte di pre processamento dei dati, va fatto sul training set dopo aver fatto lo split.

attenzione alla normalizzazione, possiamo avere problemi quando passiamo da training a test set, nel test set posso avere valori max o min che sforano quelli del training set.
Per ovviare a questo problema possiamo impostare min  e max conoscendo il contesto su cui il modello deve lavorare.
Con la standardizzazione questo prbolema non sussiste perchè abbiamo min e max come infinito.

Controllare che la misura sia di distanza, o vicinanza.


# ALberi di decisione

Un buon albero mi permette di arrivare a delle foglie pure nel minor numero di domande possibili che devo fare.

trovare una soluzione ottimale è un problema NP completo.

Fare alberi binari è più semplice a livello di complessità computazionale, ed è anche più facile trovare un albero completo.

Domanda d'esame: descrivere metodi basati sul partizionamento.

Con il calcolo dell'information gain diventa fortemente sbilanciato  in favore di test che hanno molti esiti, molti rami per un attributo A; stesso problema della distanza euclidea.


