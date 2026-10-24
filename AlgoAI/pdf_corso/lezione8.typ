#import "../../Template typst/template.typ": c-border, definition, exam, example, note, separator, theorem, warning
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

= Lezione 8 del 19 ottobre 2026

Abbiamo visto random forest nella scorsa lezione e i metodi di consenso.
Adesso vediamo i Support Vector Machine come metodo di classificazione o regressione

== Support Vector Machine

È uno degli strumenti più utilizzati per la classificazione di pattern in machine learning.

L'obiettivo è quello di determinare le superfici decisionali tra le classi (*classification boundaries*).

#figure(image("img/lezione8/svm_margin.svg"), caption: [Esempio Support Vector Machine.])

La tecnica SVM nasce come classificatore binario, estendibile a più cassi:
- SVM *lineare*: a superficie di separazione è un *iperpiano*, tra i pattern del training set linearmente separabili.
- SVM *lineare* e patter *non linearmente separabili*: Ci saranno inevitabilmente errori di classificazione nel training set dato che non esiste un iperpiano che separi i pattern.
- SVM *non lineare*:  superficie di separazione complessa senza ipotesi di separabilità dei pattern.
- Estensione per casi *multiclasse*.

Per un problema di classificazione possiamo avere più iperpiani possibili per poter dividere le due classi, teniamo in considerazione il caso con due classi che è quello più semplice.
SVM determina l'iperpiano in grado di separare le classi con il maggior *margine* possibile.

Il margine è la distanza minima dei punti delle due classi ne training set dell'iperpiano individuato.

#figure(image("img/lezione8/optimal_hyperplane.svg"), caption: [Margine e iperpiano ottimale.])

Avere un ampio margine permette una miglior generalizzazione del modello. Con un ampio margine di classificazione dei record del training set, ci permette di poter generalizzare meglio il processo di classificazione per eventuali dati che risiedono in prossimità del confine tra le due classi.
Il problema può essere impostato come un'ottimizzazione convessa (convex optimization), questo ammette un solo minimo gobale.

=== SVM Lineari

Date due classi linearmente separabili, e un training set TS contenente $n$ campioni di coordinate $(x_1, y_1), dots (x_n, y_n)$ dove $x_i in RR^d$, sono i record multidimensionali e $y_j in {+1, -1}$ sono le etichette delle due classi.

#figure(image("img/lezione8/hyperplane_3d.svg", width: 60%), caption: [Iperpiano in 3D.])

#definition(name: "Iperpiano")[

  Un generico iperpiano è definito dai parametri $(w, b)$:

  $ D(x) = w dot x + b $

  - $w$, vettore normale all'iperpiano.
  - $frac(b, ||w||)$, è la distanza dall'origine.
  - $D(x) = 0$, è il luogo dei vettori sul piano.

]

Gli iperpiani $(w, b)$ che separano i dati del TS, con distanza minima $frac(1, ||w||)$ su ogni lato, soddisfano per $i = 1, dots, n$ le seguenti equazioni:

$ w dot x_i + b >= + 1 quad "se" y_i = + 1 $
$ w dot x_i + b <= - 1 quad "se" y_i = - 1 $

O in modo più compatto:

$ y_i [w dot x_i + b] >= 1 quad "per" i = 1, dots, n $

#figure(image("img/lezione8/svm_Dx_Dy.svg", width: 60%), caption: [Esempio SVM.])<ex-SVM>

La minima distanza tra l'iperpiano di separazione e un dato di training set è detto *margine* $(tau)$.

La distanza dei punti che giacciono sull'iperpiano $D(x) = + 1$ dall'iperpiano di separazione $D(x) = 0$ è $frac(1, ||w||)$; lo stesso vale per i punti sull'iperpiano $D(x) = - 1$. Pertanto il margine è $tau = frac(2, ||w||)$.

=== Iperpiano ottimo

L'iperpiano ottimo secondo SVM è quello che soddisfa i vincoli di separazione dei dati e massimizza i margine $tau$.

- Minimizzare: $frac(||w||^2, 2)$
- Vincoli: $y_i [w dot x_i + b] >= 1 quad "per" i = 1, dots, n$

I dati del training set che giacciono sul margine, i cerchi pieni in figura @ex-SVM, sono detti *support vector*.
Tali dati, che costituiscono i casi più complessi, definiscono completamente la soluzione del problema, che può essere espressa come funzione di solo tali dati indipendentemente dalla dimensionalità dello spazio $d$ e dal numero $n$ di elementi in TS.

Uno dei vantaggi di SVM è che permette di scalare molto bene rispetto alla dimensionalità $d$ delo spazio delle feature.

== SVM per dati non separabili

Nel caso in cui avessimo dati non separabili? In questo caso dobbiamo rilassare i vincoli di separazione per far si che alcuni pattern possano valicare il confine della classe. L'obiettivo è quello di ridurre al minimo il numero di questi pattern fuori dalla propria classe d'appartenenza.

A tal fine si introducono $n$ variabili di slack positive $xi_i$ per $i = 1, dots, n$ e si modificano i vincoli di seprazione in: $y_i [w dot x_i + b] >= 1 - xi_i quad "per" i = 1, dots, n$

Per ogni dato $x_i$ del TS, la variabile $xi_i$ codifica la deviazione dal margine.
Per i dati separabili del TS le corrispondenti variabili di slack assumono
valore 0.

#figure(image("img/lezione8/svm_soft_margin.svg", width: 60%), caption: [SVM per dati non separabili.])

In questo caso, l'iperpiano ottimale deve ancora *massimizzare il margine*, ma allo stesso tempo *minimizzare il numero di elementi non correttamente classificati*.
Di conseguenza il nuovo problema di ottimizzazione diventa:

- *Minimizzare*: $frac(||w||^2, 2) + C sum_(i = 1, dots, n) xi_i$
- *Vincoli*: $y_i [w dot x_i + b] >= 1 quad "per" i = 1, dots, n$

Il coefficiente $C$ del problema di ottimizzazione indica l'importanza relativa degli errori di classificazione rispetto all'ampiezza del margine.

#figure(image("img/lezione8/svm_C_comparison.svg", width: 60%), caption: [Confronto valori di C.])

== SVM non lineari

Una tecnica che può tornare utile è quella di passare ad uno spazio dimensionale più grande di quello di partenza.
Questo magari se nel nostro spazio di partenza non siamo in grado separare le classi, con l'aggiunta di una nuova o più dimensioni possiamo trovare un iperpiano che separi le due classi.

Definiamo quindi un *mapping non lineare* dei dati dello spazio di partenza $RR^d$ verso uno spazio $RR^m$ a più dimensionalità, $m >d$.

$ Phi: R^d arrow R^m, quad Phi(x) = [g_1 (x), g_2 (x), dots g_m (x)] $

Nello spazio $RR^m$, dove ci permette di avere più gradi di libertà, i dati $Phi(x_1), Phi(x_2), dots, Phi(x_n)$ possono essere più facilmente separati da un iperpiano.

#figure(
  image("img/lezione8/separabilita_kernel.svg", width: 70%),
  caption: [Separazione classi in una dimensione maggiore di quella partenza.],
)

#pagebreak()

== SVM: Estensione multiclasse

Come possiamo separare più di due classi nello stesso piano dimensionale?
Gli approcci più utiizzati al momento sono:

=== One against one

Troviamo gli iperpiani di separazione a coppie di classi:

#figure(image("img/lezione8/classificatori_multiclasse.svg", width: 70%), caption: [Tecnica SVM: One Against One.])

=== One against all

La one against all funziona nel seguente modo:

- Date $s$ classi $w_1, w_2, dots, w_s$
- Per ogni casse $w_k$ si determina con SVM la superficie di separazione tra i dati di $w_k$ (etichetta + 1) da una parte, e i dati di tutte le rimanenti classi con $w_(h!=k)$ (etichettati con -1) dall'altra. Si ottiene la funzione $D_k (x)$ che indica quanto $x$ è distante dalla superficie decisionale in direzione $w_k$. Maggiore è $D_k (x)$ più confidenti siamo dell'appartenenza di x a $w_k$.
- Al termine del training si assegna il dato $X$ ala classe $k^*$ per cui è massima la distanza dalla superficie decisionale.

Non è necessario eseguire $s$ training SVM diversi.

#figure(image("img/lezione8/classificatori_multiclasse_2.svg", width: 70%), caption: [Tecnica SVM: One against all.])


In entrambe le tecniche si stabilisce dove cadano nuovi dati da classificare in base ai quadranti che nascono dagli iperpiani.
