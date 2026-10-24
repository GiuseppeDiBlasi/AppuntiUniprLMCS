# Introduzione

Il progetto è incentrato sulla Super Resolution, ovvero una tecnica per migliorare la risoluzioni di immagini a bassa qualità. Vengono mostrati diversi approcci come le reti CNN e le reti residuali.
Il dataset utilizzato per la fase di test e di validazione è stato preso da DIV2K.
Per il dataset di test è stato utilizzato Set5.

Il progetto ha preso in considerazioni lavori già pubblicati in precedenza nel contesto della super resolution, cercando di ottenere gli stessi risultati anche con approcci diversi.

# 1. Approccio con rete convoluzionale

Il primo approccio al super resolution che abbiamo provato è quello basato su una rete CNN (Convolutional Neural Network).
Ci siamo basati sul paper SRCNN(2014) che ottiene ottimi risultati rispetto ad algoritmi di interpolazione per le immagini come Bicubic.

Come dataset di training abbiamo scelto DIV2K che contiene 800 immagini in risoluzione 2k.

Come dataset di validazione abbiamo usato sempre DIV2K, mentre per la fase di test abbiamo usato Set5.

Come indice di valutazione inizialmente si è usato il valore della loss, successivamente siamo passati all'indice PSNR, usata per valutare la qualità dell'immagine interpolata da Bicubic e dalla rete con la ground truth.
Come loss function abbiamo usato inzialmente la MSE loss e successivamente la L1 loss per vedere se ci fossero miglioramenti nella fase di addestramento.

Un aspetto importante è che la rete non si occupa di fare pre-upsampling, ma questo viene fatto fuori dalla rete; quindi la rete impara semplicemente a migliorare la definizione dell'immagine senza preoccuparsi di portare l'immagine LR alle dimensioni dell'immagine HR.

## Architettura paper SRCNN(2014)

La fase di training è stata strutturata nel seguente modo: 800 immagini da cui vengono estratte casualmente 20 patch, di grandezza 64x64, per ogni immagine, ottenendo così circa 16.000 patch per la fase di addestramento.
A diffrenza del paper SRCNN(2014) abbiamo scelto di provare a passare i 3 canali RGB come input alla rete invece del canale di luminanza, ottenendo dei risultati per niente soddisfacenti, la rete generava un output che presentava parecchi artefatti (inserire immagine).

Dopo gli scarsi risultati ottenuti si è deciso di passare solo il canale della luminanza (Y) alla rete, seguendo quello che è stato fatto nel paper SRCNN(2014).

Andando a riprodurre l'architettura con 3 layer, con kernel di grandezza, rispettivamente 9x9, 5x5, 5x5; con 64 canali in outuput dal primo layer, con un learning rate di 1e-4 per i primi 2 layer e per l'ultimo 1e-5.
Abbiamo ottenuto dei risultati migliori rispetto all'approccio RGB, ma non riuscivamo a superare il PSNR dell'algoritmo di interpolazione Bicubic.
(mostrare dati, e grafico PSNR della rete)

La fase di validazione è stata fatta estraendo una patch centrale delle stesse dimensioni delle patch usate per il training, sfruttando il dataset di validation di DIV2K.
In questo modo siamo stati in grado di stabilire come le prestazioni reali della rete si evolvessero durante la fase di training.

Per la fase di test la rete lavora sull'immagine intera invece delle patch

Con l'architettura del paper non siamo riusciti a superare bicubic in nessuna istanza del test set, forse dovuto anche al fatto che abbiamo utilizzato un dataset di training diverso.

## Architettura finale

Non soddisfatti dei risultati abbiamo cambiato l'architettura della rete, passando a 7 layer di convoluzione, lavorando sempre sul canale Y.
Siamo passati da 20 patch a 40 patch per immagine durante la fase di training, ottenendo così 32 mila campioni per la fase di training.
La grandezza delle patch è stata aumentata da 64 a 128, in modo di permettere alla rete di vedere più informazioni.
Il primo layer di convoluzione ha un kernel di 9x9 mentre i restanti hanno kernel con grandezza 3x3.
Come loss function abbiamo mantenuto la MSE tra l'immagine di output dalla rete e la ground truth, ovvero l'immagine ad alta risolzione.
Il learning rate è stato fissato a 1e-4 per tutti i layer stavolta.

Abbiamo inserito anche un early stopping per evitare di sprecare tempo durante la fase di training, se la rete non migliora il proprio PSNR globale per 120 epoche consecutive il training si ferma.

Con questa nuova architettura ci siamo avvicinati ai valori PSNR dell'algoritmo bicubic ma ancora non abbastanza da poter superarlo.

Abbiamo provate varie scelte, la prima era quella del residual learning, invece di far imparare alla rete di migliorare l'immagine LR per raggiungere l'HR, facciamo in modo che la rete impari la differenza tra l'immagine LR e HR e cerchi di avvicinarsi il più possibile alla foto HR; ovviamente questo non rende la rete una ResNet, ma cambia semplicemente cosa impara a fare la rete.
Questa idea è stata presa dal paper VDSR (Kim et al. 2016).

Con questa architettura abbiamo ottenuto dei risultati migliori rispetto alla nostra architettura precedente, ma ancora non riuscivamo a superare l'algoritmo di interpolazione Bicubic.

Con questa architettura abbiamo osservato che il valore del PSNR oscillava costantemente durante il training, per questo motivo abbiamo introdotto la batch normalization dopo ogni layer convoluzionale in modo da normalizzare l'output di ogni layer, così facendo siamo riusciti a ridurre le oscillazioni dell'indice PSNR durante la fase di training.
(foto prima e dopo batch normalization)

Come ultimo tentativo abbiamo provato a passare da MSE come funzione di loss ad L1. La MSE eleva al quadrato la differenza penalizzando di più errori grandi rispetto a quelli piccoli, L1 invece prende il valore assoluto, danto lo stesso peso a tutti gli errori commessi dalla rete.

Grazie alla loss L1 siamo riusciti a superare l'algoritmo Bicubic in una istanza del test set, ottenendo anche un miglioramento  sui dettagli dell'immagine visibile ad occhio nudo.
(inserire immagine)