# Lezione 6 del 7 ottobre 2026 

NO, MODIFICHE MANUALI AL DATASET, tutte le operazioni vanno fatte tramite comandi, devono essere riproducibili.
I modelli dipendono fortemente dal dataset.

occhio alle scale su cui si eseguono i calcoli.

orange data mining tool

- Get data: capire qual è l'obiettivo e se i dati che si vogliono osservare ci aiutano a ottenere il nostro obiettivo.

Se i dati sono naturali, la distribuzione sarà gaussiana.

Avere troppe feature può confondere il classificatore inficiando sulle prestazioni.

Le feature che scelgo sono sufficienti a risolvere il problema di classificazione?

Per un modello di machine learning, il prof valuta il procedimento applicato: normalizzazione, standardizzazione, feature selection etc...

feature con varianza più alta coprono meglio lo spazio, ma non implicano che siano correlate per poter risolvere il nostro problema. Per un problema di ricorsione non c'è questa domanda.

Le reti neurali fanno classificazione, ma lavorano tramite regressione.

Occhio quando si usa StandardScaler con sci-kit learn, potrebbe fare la normalizzazione prendendo come min max i valori di tutto il dataset, invece vogliamo che la normalizzazione avvenga su OGNI feature.

One hot encoder, ci permette di trasformare valori categoriali/nominali in valori ordinali.