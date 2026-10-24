# Towards conversational diagnostic AI

# Introduzione

L'obiettivo dello studio è quello  realizzare un modello LLM,
in questo caso AMIE (Articulate medical Intelligence Explorer),
ottimizzato per il dialogo diagnostico, raccolta dell'anamnesi,
realizzazione di un piano terapeutico per il paziente.
È basato sul modello PalM-2 di Google.
Per gli autori l'obiettivo è quello di riuscire a creare questo sistema
AI in modo da rendere la sanità più accessibile.

# Dataset utilizzati

Sono stati utilizzati vari dataset per l'addestramento di AMIE
tra cui dataset composti da:

- Risposte a domanda multipla
- Ragionamenti medici estesi
- Riepiloghi di fascicoli sanitari elettronici
- Trascrizioni di interazioni tra il personale medico

Durante la fase di addestramento il modello è stato esposto a una
serie di attività tra cui: Risposte a domande in ambito medico, ragionamento
medico e riassumere cartelle cliniche.

Per l'attività di ragionamento medico è stato utilizzato il dataset MedQA
contenente domande a risposta multipla con 4 o 5 opzioni.

Il dataset utilizzato per i ragionamenti medici estesi è composto a sua volta
da più dataset per un totale di 64 domande prese da:
HealthSearchQA, LiveQA e Medication QA in MultiMedBench.

Mentre per l'attività di sintesi medica è stato utilizzato il dataset
MIMC-III, un database pubblico contenente dati
su pazienti ricoverati in terapia intensiva.
MIMC-III contiene dati su circa 13 specialità mediche, per questo
studio sono stati scelti 5 cartelle cliniche per ogni specialità
con una lunghezza minima di 400 token e almeno una nota infermierista per ogni paziente.

Il dataset con le trascrizioni è stato concesso su licenza e contiene  circa 100k trascrizioni
audio di consultazioni, e dialoghi tra il personale medico.
Le trascrizioni coprono circa 51 ambiti specialistici e 168 condizioni cliniche.
Le discussioni avevano in media 150 turni; ogni conversazione ha permesso di estrapolare
informazioni sui pazienti come la demografica, motivo della visita, storia clinica,
e tipo della diagnosi.
Per questo studio sono stati scelti dialoghi dove erano presenti
solo il medicoe il paziente.
Le trascrizioni audio sono state poi ripulite da annotazioni come "NON UDIBILE".
Il dataset è stato diviso nel 90% in training set e il restante 10% è stato usato come
validation set.

# Architettura modello AMIE

*Spiegare l'immagine nella slide (parti da sinistra)*

Abbiamo 3 componenti principali:

- A sinsitra il generatore di dialoghi simulati
- Al centro i dataset per l'addestramento
- A destra la catena di ragionamento per l'inferenza online

AMIE è caratterizzato da due loop di self-play:

- Un loop interno dove il modello sfrutta feedback contestuale su dialoghi simulati
  per migliorare le sue risposte con pazienti AI
- Un loop esterno dove questi dialoghi simulati veniva inclusi nelle successive iterazioni
  di fine-tuning.

AMIE sfrutta anche una catena di ragionamento per l'inferenza online permettendogli
di migliorare le proprie risposte in base alla conversazione attuale per generare
una risposta coerente e il più possibile simile a quella di un umano.

# Sistema di autoapprendimento

I dati reali presentano problematiche che possono intaccare la scalabiltà
e completezza del modello, per esempio non sono in grado di cogliere
la complessità degli scenari in ambito medico.
Presentano termini colloquioli, riferimenti impliciti e presentano del rumore.

Per superare queste limitazioni è stato realizzato un ambiente di autoapprendimento
in un ambiente virtuale permettendo al modello di scalare le propria conoscenza
e capacità.
Questo ambiente è stato utilizzato per raffinare continuamente AMIE con un
set di dialoghi in continua evoluzione in aggiunta ai dataset citati precedentemente.

Per la generazione dei dialoghi è stato realizzato un Framework
multi-agente ad hoc, composto da 3 componenti:

- Generatore di scenari, AMIE sfruttando ricerche sul web
  per poter creare scenari su pazienti con determinate condizioni cliniche
- Generatore di dialogo simulato: composto da 3 agenti LLM
  tutti e 3 interpretati da AMIE, che svolgono il ruolo di
  medico, moderatore e paziente. Interagiscono tra di loro
  in un dialogo a turni.
- Feedback sul self-play: un quarto agente LLM svolge il ruolo di critico
  per poter dare un feedback all'agente medico e per aiutarlo a migliorare.

# Generatore di scenari

Il generatore di scenari si occupa di creare scenari
con contesti realistici sfruttando ricerche sul web
per varie condizioni cliniche.

Lo scenario include informazioni sul background del paziente:

- Demografica
- Sintomi
- Storia clinica del paziente (patologie, chirurgie...)
- Background sociale
- Domande del paziente
- Diagnosi e relativo piano terapeutico

Gli scenari venivano generati nel seguente modo:

- Estrazione di 60 passaggi, 20 per categoria, su argomenti come: demografica, sintomi e piano clinico.
- Per assicurarsi che gli estratti fossero pertinenti con lo scenario
  è stato utilizzato un LLM general purpose, PalM-2, per filtrare i passaggi estratti rimuovendo informazioni non adeguate al contesto.
- Infine la generazione dello scenario da paret di AMIE, sfruttando
  le informazioni estratte, segue un determinato modello.

*Cambia slide e parla dell'immagine*

Si parte con le informazioni di base sul paziente, sintomi e piano terapeutico
per una specifica condizione clinica.
Viene poi successivamente chiesto se le informazioni estratte siano coerenti
con la condizione clinica di partenza.
E infine viene generato un riepilogo dello scenario con tutte le informazioni del paziente
e piani terapeutici.

# Generatore dialogo simulato

L'altro componente è il generatore di dialogo simulato, che permette
di simulare una conversazione tra i 3 agenti AI su una piattaforma virtuale
seguendo i dati dello scenario che è stato generato in precedenza.

I tre agenti LLM, tutti interpretati da AMIE, avevano il compito di parlarsi tra
loro per generare un dialogo plausibile seguendo istruzioni ben precise.

L'agente paziente ha il compito di rispondere in modo veritiero alle domande dell'agente medico
e fare ulteriori domande nel caso in cui avesse ancora dubbi.

L'agente medico aveva il compito di essere empatico e di
comprendere al meglio la storia clinica del paziente
all'interno dell'ambiente virtuale,
e di formulare domande che portassero a una corretta diagnosi
e alla realizzazione di un piano terapeutico.

Il moderatore controlla l'andamento del dialogo tra i due agenti
determinando quando la discussione ha raggiunto una naturale conclusione:
l'agente medico ha trovato una diagnosi per il paziente,
ha stilato un piano terapeutico e ha risposto a tutte le domande del paziente.

*Cambia slide e parla dell'immagine dei prompt per i dialoghi*

Le istruzioni per il paziente erano quelle di rispondere onestamente alle domande
fatte dall'agente medico, rispettando lo scenario che gli era stato assegnato.

L'agente medico aveva il compito di essere empatico, rispondere alle domande del
paziente in un solo turno, rispondere in maniera appropriata alle domande che puo
fargli il paziente durante la consultazione.

Mentre le istruzioni per il moderatore erano quelle di terminare la conversazione
quando l'agente medico ha finito la consultazione proponendo una diagnosi e
un piano terapeutico e il paziente non ha più domande da fargli.

# Feedback self-play

Per garantire dialoghi simulati di alta qualità, è stato implementato
un framework di self-play per l'automiglioramento
dei dialoghi diagnostici tramite l'introduzione di un quarto agente AI
il critico, che è sempre interpretato da AMIE.
E' a conoscenza della diagnosi corretta in modo da guidare
l'agente medico, tramite feedback, a migliorare le sue prestazioni per future conversazioni.

Il critico ha valutato le risposte dell'agente medico secondo le seguenti metriche:

- Il medico mostra empatia e professionalità rispondendo alle domande e ai commenti del paziente
- Il medico evita domande ripetitive, o di fare troppe domande su informazioni già acquisite.
- Le risposte non devono far intendere all'interlocutore che si tratti di un agente AI.
  Quindi deve fare in modo che la conversazione scorra
  naturalmente
- L'agente medico ha posto domande in modo da individuare 2 diagnosi differenziali.

A seguito del feedback ricevuto, l'agente medico migliora le sue risposte verso
la diagnosi corretta e un piano di trattamento clinico adeguato.

# Istruzioni di fine-tuning

AMIE è stato sottoposto a un processo di fine-tuning per ottimizzare
le risposte.
Sono state fornite istruzioni specifiche in base al ruolo che AMIE deve interpretare
nel ruolo di dottore come gestire la conversazione,  creare sommari clinici
sulla condizione del paziente.
Il primo turno di fine-tuning ha utilizzato i dataset statici iniziali, mentre
i successivi turni hanno sfruttato i dialoghi generati dal loop interno di self-play.
AMIE col ruolo di paziente ha il compito di risponde con sincerità alle domande del medico.
Invece nel ruolo di medico deve essere empatico e cercare di raccogliere più informazioni
possibili per arrivare a una diagnosi.
Tutte le attività, ad eccezione della generazioen di dialoghi e risposte estese includevano
alcuni shot per dare più contesto al compito da eseguire.

# Catena di ragionamento per inferenza on-line

La sfida principale da affrontare nell'ambito del dialogo diagnostico
è quella di acquisire informazioni nell'incertezza, di conseguenza
AMIE sfrutta un strategia basata su una catena di ragionamento prima di
generare una risposta per ogni turno del dialogo.
Per catena di ragionamento ci si riferisce a una serie di chiamate
sequenziali al modello, ognuna dipendente dall'output precedente.
Nello specifico si è usato un processo di ragionamneto a 3 step:

1. Analizzare le informazioni del paziente:

- Data una conversazione, AMIE aveva il compito di riassumere
    i sintomi positivi e negativi e anche informazioni mediche
    relative ai familiari o al contesto sociale.
- Produrre una diagnosi differenziale su qusete informazioni
- Tenere traccia di informazioni mancanti per ottenere una diagnosi
    più accurata.
- Stabilire il grado di confidenza della diagnosi attuale e stimarne
    la gravità.

1. Formulare risposte e azioni:
  Tenendo conto della conversazione e dell'output dello step 1

- AMIE deve generare una risposta all'ultimo messaggio ricevuto dal paziente
  e fare ulteriori domande per estrapolare più informazioni per migliorare
  la diagnosi attuale
- Se necessario raccomandare azioni immediate come una visita al pronto soccorso.
    se ha abbastanza confidenza sulla diagnosi attuale può presentarla.

1. Raffinare la risposta:
AMIE raffina la risposta riguardando i suoi output precedenti per soddisfare
determinati criteri come, la fattualità, evitare domande ripetitive, mostrare empatia
e rispondere in modo comprensibile al paziente.

La strategia della catena di ragionamento ha permesso ad AMIE di migliorare
progressivamente le sue capacità conversazionali in base alla conversazione corrente
per arrivare ad una risposta ragionata.

# Struttura dell'esperimento

L'esperimento è basato sugli esperimenti OSCE remoti che sono
utilizzati nel mondo della medicina per valutare le prestazioni
dei medici su vari scenari.

Nello studio abbiamo 2 agenti OSCE, uno è AMIE e l'altro e il medico
che sono materia di valutazione da parte dei pazienti e di altri professionisti.

I due agenti OSCE interagiscono con il paziente simulato tramite una chat testuale
sincrona. Il paziente attore, come nei dialoghi simulati, deve rispettare lo scenario
che gli è stato assegnato, ovviamnete il paziente non sa se sta interagendo con il
sistema AI o con una persona umana.

Dopo la fase delle consultazioni viene dato un questionario a tutti i pazienti
per valutare la qualità della conversazione:

- Se il medico mostra empatia
- Se si mostra disponibile a rispondere alle domande poste dal paziente
- Come conduce la conversazione

C'è anche una fase di valutazione da parte di medici specialisti che valutano
le prestazioni dei due agenti OSCE in base alla loro accuratezza della diagnosi
Il modo in cui reperiscono informazioni, e valutano i piani terapeutici proposti.
Anche in questo caso i medici specialisti non sanno chi stanno valutando.

# Soggetti dell'esperimento

L'esperimento per AMIE ha coinvolto 20 medici certificati dall'albo
20 pazienti attori autorizzati per prendere parte a diagnosi
attraverso una chat testuale.
Gli scenari erano basati su casi canadesi, 60 scenari, e indiani, 75 scenari,
e 14 per il Regno Unito, che sono stati ripartiti tra gli scenari indiani e canadesi.
I medici avevano dai 3 a 25 anni di esperienza post-specializzazione
I pazienti avevano background diversi tra di loro: studenti di medicina,
cittadini e infermieri che avevano esperienza
in partecipiazione a esami OSCE.

# Sistema di valutazione

Lavori precedenti non permettevano di poter classificare
correttamente l'accuratezza dei dialoghi e la qualità delle diagnosi.
Dunque è stato realizzato un framework ad hoc per quanto riguarda la parte di valutazione
ed è basato sullo stile di un OSCE remoto.
Il framework tiene conto anche della qualità della conversazione
struttura, completezza, ruoli, responsabilità

# Consultazioni tramite chat

I pazienti interagivano con gli agenti OSCE tramite una chat testuale
dove ogni paziente aveva al massimo 20 minuti per terminare la conversazione.
I pazienti ovviamente non sapevano con quale dei due agenti OSCE stessero
interagendo e dopo la consultazione veniva chiesto a loro di compilare i
questionari sulla qualità della conversazione.

# Questionari post consultazione

Dopo la conversazione sia i pazienti che i due agenti OSCE devono compilare dei questionari
sulla valutazione della conversazione.

I pazienti davano una valutazione sulla qualità della conversazione
l'empatia mostrata dal medico e se ha risposto in maniera esaustiva.

I due agenti OSCE (medico ed AMIE) invece dovevano fornire minimo 3 diagnosi
differenziali con un massimo di 10 in base alle informazioni che sono
riusciti ad estrarre durante la consultazione.

# Valutazione da parte degli specialisti

Infine un pool di 23 specialisti, provenienti da varie parti del mondo
per valutare il comportamento dei medici di base e di AMIE
durante l'esperimento OSCE.
Ogni specialista doveva dare una valutazione ad entrambi gli agenti OSCE
in maniera anonima, quindi gli specialisti non sapevano
chi stessero effettivamente valutando.

Ogni specialista ha valutato una consultazione in base alla
sua specializzazione medica, quindi un cardiologo ha
valutato una consultazione che riguardavi problemi cardiovascolari.

Ovviamente gli specialisti avevano accesso allo scenario completo con la diagnosi
corretta e le ulteriori diagnosi accettabili.

I criteri di valutazione comprendo l'accuratezza, appropriatezza e comprensione della lista di DDx fornite,
raccomandazioni su azioni da intraprendere durante la consultazione come citato precedentemente.

# Modello di autovalutazione

E' stato introdotto anche un sistema di autovalutazione come
alternativa economica all'opinione degli esperti.

Per avere un punto di partenza si è partiti da un sottoinsime
della rubrica di valutazione PACES.

I risultati del processo di autovalutazione, che usa una strategia basata su
una catena di ragionamento permettendo
ad AMIE di valutare i dialoghi, era in linea
con la valutazione degli esperti.
L'autovalutazione è in linea con i risultati
per quanto riguarda la qualità del dialogo e per accurateza della diagnosi.

Il modello di autovalutazione è stato usato anche per:

- Confronto dell'accuratezza delle DDx di AMIE e dei medici di base
- Confronto dell'accuratezza delle DDx tra i pazienti attori in Canada e in India
  per evidenziare eventuali differenze tra le due località
- "Isolare gli effetti dell'acquisizione delle informazioni e della loro
  interpretazione analizzando l'accuratezza delle DDx di AMIE quando gli
  viene fornita una consultazione di un medico di base."
- Valutare l'efficienza nell'acquisizione di informazioni tra AMIE e medici
  di base analizzando l'accuratezza delle DDx man mano che il numero di turni
  nella conversazione aumenta.
- Valutare i benifici del self-play loop interno sulla qualità dei dialoghi
  prima e dopo il feedback.

# Risultati autovalutazione (lascio o no?)

Questi grafici mostrano le diverse tecniche di autovalutazione
sui 149 dialoghi condotti nell'esperimento.
Il grafico a sinistra confronta le prestazioni dei vari
metodi di autovalutazione.

La linea tratteggiata rappresenta la baseline randomica come punto
di riferimento per i risultati degli altri metodi.
Possiamo vedere che la tecnica della catena di ragionamento è la migliore
e che la modalità di autovalutazione con 5 shot si avvicina parecchio.

Il grafico a destra invece ci mostra le differenze tra il metodo
di autovalutazione e la valutazione degli specialisti.
Entambi i dati superano la baseline randomica, indicata dalla linea nera tratteggiata,
e abbiamo anche la baseline randomica con la linea verde tratteggiata mostra
la preferenza randomica degli specialisti.
Questo grafico ci mostra che il metodo di autovalutazione è in linea con la valutazione
inter-specialista, validando la qualità del sistema di autovalutazione.

# Valutazione qualità della conversazione

La qualità della conversazione è stata valutata in base al feedback ricevuto
dai pazienti attori, i medici specialisti
e l'output del modello di autovalutazione.

## Valutazione pazienti attori (qualità conversazione)

(immagine valutazione)
AMIE ha ricevuto una valutazione migliore rispetto ai medici
su 24 criteri di valutazione su 26.
Non si notano differenze significative per quanto riguarda rispetto della privacy e del paziente, e ammissione degli errori.

## Valutazione degli specialisti (qualità della conversazione)

(immagine valutazione)
I medici hanno valutato la qualità della conversazione
e le risposte dei due agenti OSCE che hanno dato nei questionari
in base al loro ambito medico.
Nuovamente, AMIE ha ottenuto una valutazione migliore
su 28 criteri su 32.
Gli specialisti hanno preferito le diagnosi, piani terapeutici, rispetto a quelli dei medici di base.
In questo caso si evidenzia una differenza sostanziale
tra AMIE e i professionisti.

# Analisi statistica, top-k accuracy

È stata valutata anche la top-k accuracy delle liste di DD
presentate da AMIE e dai medici su tutti i 149 pazienti simulati
La top-k accuracy è stata definita come la percentuale di casi dove la
diagnosi corretta appare nelle top-k posizioni della lista delle DD.
Una diagnosi candidata era considerata corretta se lo specialista la
valutava come corretta, o molto vicina alla ground truth.
La solidalità statistica è stata verificata tramite un  
test di boostrap con 10k campioni e una correzione sulla scoperta
falsi positivi su tutti i k.
I casi dove agente riceve "Impossibile da valutare / non applicabile"
sono stati esclusi

*Secondo grafico*

Mostra la top-k accuracy sull'accuratezza delle DD in base al grado
di corrispondenza valutato dagli specialisti.

- Somewhat related: la DD contiene qualcosa che è collegato alla diagnosi corretta
  ma difficilmente può portare alla diagnosi corretta.
- Relevant: la DD contiene qualcosa che è vicino alla diagnosi corretta e può
  tornare utile a determinarla con esattezza
- Extremely relevant: La DD contiene qualcosa che è molto vicino alla diagnosi corretta
- Exact match: la DD include la diagnosi corretta.
Si nota una significativa differenza statistica per tutti i
livelli di accuratezaz tranne per "Somewhat Related" tra  AMIE e i medici.

*Terzo grafico*

Questo grafico ci mostra l'accuratezza delle DD calcolata dall'autovalutazione.
É stato usato Med-PalM 2 per determinare se la diagnosi corretta appare nelle prime
top-k posizioni della lista di diagnosi differenziali.
Il grafico a) mostra i risultati di AMIE e dei medici di base rispetto
alla diagnosi corretta.
Il grafico b) mostra  i risultati di AMIE e dei medici sulle diagnosi accettate.

C'è una differenza evidente nel primo grafico per quanto riguarda l'accuratezza
sulla presenza della diangosi corretta. Sottolineando nuovamente la maggior
accuratezza del modello rispetto ai medici di base.

# Confronto con lavori precedenti

Studi passati confrontavano le prestazioni tra sistemi AI e medici
e mostravano una somiglianza tra le prestazioni con a volte
risultati migliori da parte dei sistemi AI. L'unica nota da tenere in
considerazione e che questi studi lavoravano su input fissi
per esempio veniva mostrata un immagine di una radiografia e si chiedeva
ai due soggetti di fare una diagnosi basandosi su quell'immagine.

Mentre lo studio su AMIE è molto più complesso, raccoglie informazioni
tramite il dialogo che devono poi essere elaborate, senza sfruttare
informazioni già acquisite dagli umani, quindi non si sono valutate solo
le sue capacità di inferenza ma anche la capacità di raccogliere informazioni
tramite il dialogo. Anche la varietà
degli scenari rappresenta una sfida significativa, permettendo di valutare
le prestazioni del modello su più specialità mediche.

A differenza di studi precedenti il framework di valutazione si basa
su strumenti già applicati nel mondo medico per la valutazione
delle prestaizoni dei professionisti. Al momento questo è il primo
studio che valuta un LLM utilizzando strumenti che si usano nel
mondo reale. Il framework di valutaizone utilizzato è anche più
granulare rispetto a quello di lavori precedenti.

# Limitazioni dello studio

Una delle limitazioni più importanti è la consultazione tramite testo,
visto che si perdono informazioni non verbali che si possono acquisire
durante la consultazione. I medici tradizionalmnete abituati a consultazioni
dal vivo e passare ad eseguire completamente delle diagnosi tramite
interfaccia testuale può risultare scomodo.

I dialoghi simulati che hanno permesso di poter scalare le capacità di AMIE
non riescono a cogliere la complessità dell'ambiente medico, visto che
una patologia può manifestarsi in modi completamente diversi, la
personalità del paziente, il suo background sociale e culturale.
Anche l'obiettivo di arrivare a una DD accettabile per AMIE nel contesto
reale potrebbe non essere possibile per alcune patologie.

I criteri di valutazione scelti non sono del tutto esaustivi e sono
liberi ad interpretazione, anche se nell'esperimento si sono sfruttati
dati e persone da varie parti del mondo si potrebbe espandere ulteriormente
puntando a generalizzare ancora di più i risultati.

Il framework di valutazione si concentra sulla qualità della conversazione
e dell'accuratezza della diagnosi, potrebbe essere migliorato ulteriormente
con futuri studi per esempio valutando la soddisfazione del paziente,
se il medico suggerisce cambi nello stile di vita del paziente.

Inoltre il framework non riesce a cogliere eventuali problemi di bias e di
correttezza, per esempio alcuni medici cambiano stile comunicativo
in base al background sociale e culturale del paziente compromettendo
la qualità della consultazione.

Infine le prestazioni dei modelli LLM tendono peggiorare con lingue con poche risorse
a disposizione.

# Problematiche future

Uno dei problemi futuri è permettere ai modelli LLM di imparare da
dati in costante evoluzione, soprattutto in ambito medico dove
le conoscenze si aggiornano rapidamente.

Il bisogno di evitare un eccessivo affidamento ai modelli LLM per la diagnosi
e invece cercare di sfruttarli come uno strumento da affiancare ai professionisti
durante il loro lavoro, e di non basarsi esclusivamente sull'output fornito dal modello
ma permettere anche di revisionare il processo di inferenza che ha portato a quell'output.

Un altro problema fondamentale è quello legato al bias e alla correttezza.
Si spera che un eventuale utilizzo sul campo di un modello LLM sia privo di bias
che alcuni medici possono avere. Magari permettendo a un team di professionisti
di partecipare alle fasi di addestramento del modello garantendo maggior equità
e correttezza.

Attualmente il passaggio da un prototipo a uno strumento che può essere sfruttato
dai professionisti richiederebbe parecchio tempo. Sia per controllare eventuali
problemi di sicurezza, controlli di qualità, conformità normativa prima di
una qualunque implementazione.

The End
