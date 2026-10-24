# Cap. 1

## 1 

Per Internet of Things si intende l'estensione di internet con dispositivi (nodi) che comunicano tra di loro scambiandosi dati rilevati dall'ambiente circostante.

## 2

Le principali sfide a livello di nodo sono il consumo elettrico e le dimensioni contenute. Visto che ogni nodo ha una fonte di energia limtitata (batteria) è importante che durante il suo ciclo di vita il dispositivo consumi il minor numero di energia possibile. Dato che i nodi hanno microcontrollori economici e di dimensioni contenute anche i nodi avranno dimensioni contenute.

## 3 
Per lossyness si intende la natura delle comunicazioni nei sistemi IoT, dovuta al fatto che la comunicazione avviene tramite segnali wi-fi, è influenzata da interferenze elettromagnetiche, congestione all'interno della rete, interferenze da altri nodi.

## 4 

Per vertical fragmentation nel campo M2M (Machine-to-Machine) si parla che ogni azienda sviluppa il proprio sistema IoT con i propri requisiti, senza seguire una convenzione utilizzata da tutti. Questo porta ad una frammentazione perché ogni sistema ha le proprie implementazioni proprietarie che non possono essere utilizzate in altri sistemi. Questo rende difficoltoso anche la diffusione dei sistemi IoT.


# Cap 2

## 1 

I 4 componenti hardware di uno smart object sono:
- Microcontrollore
- Sensori e attuatori
- Batteria 
- Ricetrasmittente 

La ricetrasmittente è il componente che consuma più energia di tutti, deve modulare e demodulare il segnale per la trasmissione e ricezione dei dati.

Il microcontrollore si occupa di elaborare i dati

I sensori permettono allo smart object di "percepire" il mondo esterno, mentre gli attuatori gli permettono di interagire con il mondo esterno.

La batteria invece fornisce energia allo smart object.

## 2

La differenza principale è la comunicazione, un sistema embedded non comunica con altri sistemi all'interno della rete, mentre uno smart object comunica costantemente dati con altri dispositivi o li riceve.

## 3 
---- 


# Cap 3

## 1 

UDP ha un header composto da 8 byte, 2 per sorgente, 2 destinazione, 2 lunghezza del datagramma, 2 checksum.

UDP è un protocollo stateless, non orientato alla connessione, non garantisce la consegna e non esegue il riordino dei pacchetti e non supporta ritrasmissioni.

Per i sistemi IoT, perdere qualche pacchetto non è così rilevante, data la natura lossy delle comunicazioni. 
UDP permette ad un nodo di invia un pacchetto senza prima stabilire una connessione esplicita tra i due nodi, questo permetet di risparmiare energia durante la comunicazione.

## 2 

Gli svantaggi sono quelli già citati precedentemente, nessun ordine nella consegna e consegna non garantita. Queste problematiche vengono risolte a livello applicativo

# Cap 4

## 1

TCP garantisce affidabilità tramite i sequence number, che garantisce l'ordinamento dei pacchetti, ritrasmissioni nel caso in cui un pacchetto vada perso, garantisce la consegna tramite ACK, e i due nodi che devono comunicare devono prima stabilire una connessione tra loro 2 tramite un three way handshake.

Il nodo A manda al nodo B un pacchetto di sincronizzazione con il sequence number di partenza
B invia un ACK con il suo sequnce number
A invia un ACK e inzia la trasmissione


## 2 

Il TCP stima il timeout in modo dinamico, controlla il tempo di risposta medio di ogni ACK e in base a quel valore stabilisce il tempo di timeout. Non si puo usare un tiemout fisso perché il tempo di risposta di un ACK può dipende da vari fattori, congestione della rete, distnaza tra i due host

## 3 

Il fast retransmit permette di velocizzare le ritrasmissioni durante le comunicazioni con sliding window.
Se il mittente riceve 3 ACK consecutivi per lo stesso pacchetto vuol dire che il destinatario non ha ricevuto quel pacchetto, quindi il mittente lo ritrasmette senza aspettare che scada il timeout.

## 4

Il TCP è utile per i sistemi IoT perché è un protocollo affidabile, risolve il problema delle comunicazioni lossy tramite: consegna garantita, ritrasmissioni, connection-oriented

# Cap 5

## 1

IPv6 permette un indirizzamento a 128 bit contro l'indirizzamento a 32 di IPv4, questo permette di risolvere il problema dell'esaurimento degli indirizzi di IPv4. 
L'header Ipv4 è formato da 20 byte mentre IPv6 è formato da 40 byte.

## 2

IPv6 offre la possibilità ai nodi di autoconfigurarsi assegnandosi in autonomia un indirizzo link-local, questo aspetto risulta fondamentale per i dispositivi IoT, visto che le reti devono essere facilmente scalabili e di conseguenza autoconfiguranti.

## 3

Dato che molti dispositivi usano ancora IPv4 e non possono essere "portati" ad IPv6, vengono utilizzate diverse tecniche per poter permettere la comunicazione tra dispositivi IPv4 e IPv6.

- Double stack: un dispositivo supporta sia IPv4 che IPv6 e usa l'interfaccia corretta in base alla comunicazione.
- Tunneling: i pacchetti IPv6 vengono incapsulati in pacchetti IPv4 per poter raggiungere reti che usano solo IPv4
- Trasnlation: I pacchetti IPv6 o IPv4 vengono tradotti nell'altro protocollo in base alla necessità

## 4 

Gli extension header sono una funzionalità di IPv6 che permette di aggiungere ulteriori informazioni all'header, oltre a quelle obbligatorie (source, destination, version, payload length). Questo permette di contenere le dimensioni dell'header e di aggiungere nuovi header in base al bisogno.

## Cap 6

## 1

I sistemi IoT usano lo standard 802.15.4, che supporta un MTU MASSIMO di 127 byte, mentre IPv6 richiede un MTU MINIMO di 1280 byte. 

## 2 

Lo standard 802.15.4 offre anche la funzionalità CCA (Clear Channel Assessment), dove ogni nodo prima di trasmettere controlla se il canale è libero, nel caso in cui lo sia trasmette i dati altrimenti si mette in attesa per poi ricontrollare nuovamente se il canale si è liberato.

Ci sono diverse modalità per stabilire se il canale è libero: energy detection: se l'energia nel canale supera una certa soglia allora il canale è in uso, altrimenti è libero
Carrier sense: controlla se ci sono segnali in arrivo, se non ce ne sono allora il canale è libero

## 3 
---

## 4

802.15.4:
- Funzionalità CCA, energy detection o carrier sense
- CSMA/CA
- rischio di sovrapposizione con 802.11 ( wifi)
- basso consumo energetico
- veloctia di trasmissione ridotta
- Usato per reti PAN (personal area network)
- Per un nodo stare in ricezione equivale a consumare la stessa quantità di energia come se fosse in trasmissione (idle listening)

802.11 (wifi):
- bassa latenza
- alto throughput
- consumo energetico elevato
- rischio di sovrapposizione con 802.15.4

PLC (Power Line connection):
- una sola rete LAN
- la rete elettrica è presente ovunque
- nessun bisogno di routing
- le comunicazioni possono essere soggette al rumore dovuto dal passaggio di corrente
- CSMA/CA


# 7

## 1

Le principali cause di consumo energetico sono:

- Overhearing: un nodo riceve ed elabora pacchetti destinati ad un altro nodo
- Idle listening: un nodo rimane in ascolto per controllare se ci siano pacchetti destinati a lui
- Collisioni: comportano una ritrasmissione del pacchetto


## 2

B-MAC cerca di risolvere il problema dell'idle listening, ogni nodo passa la maggior parte del tempo in sleep, e si risveglia periodicamente per controllare il canale di comunicazione nel caso in cui ci siano pacchetti da ricevere.
Per far capire ad un nodo che deve ricevere un pacchetto si usano pacchetti di preambolo, con una durata uguale o maggiore al periodo di sleep, così il nodo destinatario "leggerà" sicuramente il preambolo e sarà pronto a ricevere i dati.
Il problema è che tutti i nodi nel raggio del pacchetto di preambolo rimangono in ascolto finché non capiscono che non sono loro il mittente (overhearing)

X-MAC è un evoluzione di B-MAC, dove il pacchetto di preambolo è strobed (ovvero vengono inviati più pacchetti nelal fase di preambolo) e contiene anche l'indirizzo del destinatario, così se un nodo si accorge di non essere il destinatario può tornare immediatamente in modalità sleep.
Se il destinatario si sveglia durante la fase di preambolo e riceve il pacchetto strobe può inviare un ACK in anticipo e inziare immediatamente la comunicazione

## 3
S-MAC, è una versione schedulata, ogni nodo annuncia la propria routine di listen e sleep ai nodi vicini, e i vicini cercano di sincronizzarsi sulla stessa schedule. questo permette di ridurre l'idle listening perché i nodi passano la maggior parte del tempo in sleep.
Un probleam è dato se due nodi adiacenti hanno schedule diversi, dovranno rimanere svegli entrambi per la durata di entrambe gli schedule in modo da poter comunicare. lo scheduling non si adatta bene ad un traffico variabile.

# Cap 8

## 1

- Frammentazione e riassemblaggio dei datagrammi, risolve il problema tra l'MTU di 802.15.4 da 127byte e IPv6 che chiede un MTU minimo di 1280
- Compressione dell'header, permette di comprire l'header IPv6, di 40 byte, a 2-3 byte, questo permetet di risparmiare molto spazio, vengono usate due tecniche principali HC1, e IPHC
- Routing mesh-under, utile per l'inoltro di pacchetti da parte di nodi intermedi.

## 2

HC1 permette di ridurre l'header IPv6 a 3 byte circa, dato che lavora su indirizzi link-local, l'indirizzo può essere ricavato dagli indirizzi MAC, in modo da omettere le informazioni sull'header

## 3

Il fragment header è composto dai seguenti campi:

- datagram_size: grandezza del datagramma
- datagram_offset: non è presente nel primo datagramma, ma in quelli successivi per potere tenere traccia dalla porzione di datagramma ricevuto
- datagram_tag: identifica il gruppo di appartenenza dei datagrammi

Il ricevente sfrutat questi campi per poter ricostruire il datagramma originale, size per la grandezza del datagramma, offset per assicurasi che abbia ricevuto tutti i pacchetti dal primo all'ultimo, e tag per scegliere i pacchetti che appartengono allo stesso gruppo.

## 4

HC1 funziona per indirizzi link-local, quindi non esposti ad internet
Per indirizzi esposti ad internet si usa la tecnica IPHC, che permette di comprimire l'header tramite lo shared context 

# Cap 9

## 1 

Il DODAG (Destination Oriented Directed Acyclic Graph) è usato nel protocollo RPL per costruire l'instradamento tra i nodi all'interno di una rete LLN( Low-power and Lossy Network )
La radice tipicamente è il gateway della rete. Ogni nodo ha un rank che rappresenta la distanza dalla radice in termini di qualità del percorso. Il rank viene calcolato tramite una funzione obiettivo che tiene conto di varie matriche, distanza tra i nodi, energia richiesta per la comunicazione etc...

RPL supporta trasmissioni many-to-many, many-to-one e one-to-one

## 2

I messaggi DIO e DAO vengono usati per costruire e mantenere il DODAG.
I messaggi DIO (DODAG Information Object) fluiscono sia verso l'alto che verso il basso e contengono informazioni riguardanti il DODAG.
I messaggi DAO fluiscono solo verso l'alto, e portano informazioni sui prefissi raggiungibili verso il basso. I DAO incudono anche il meccanismo Reverse Routing STack, quando un nodo intemredio non puo memorizzare lo stato del routing aggiunge il proprio indirizzo al RRS permettendo il routing in discesa.


## 3

Una rete può avere più objective function ognuna con metriche diverse (consumo di energia per la trasmissione, distanza di due nodi...) e ogni rete può avere più DODAG, un nuodo può far parte di più di un DODAG.
Una objective function può minimizzare il consumo di energia, mentre un altra può massimizzare la velocità di trasmissione a fronte di un maggior consumo energetico.

## 4
