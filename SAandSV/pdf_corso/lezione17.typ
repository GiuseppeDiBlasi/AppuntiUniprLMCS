#import "../../Template typst/template.typ": c-border, definition, example, note, sqglb, sqle, sqlub, theorem
#import "@preview/fletcher:0.5.8": diagram, edge, node, shapes

#let sem-code(body) = {
  show regex("\b(if|else|return|new|is|or|type)\b"): set text(fill: rgb("#0000ff"), weight: "bold")
  show regex("\bstring\b"): set text(fill: rgb("#800080"), weight: "bold")
  show regex("\bsemantics\b"): set text(fill: rgb("#007c7c"), weight: "bold")
  show regex("\b(eval|isSatisfied|isTrue|isFalse|store)\b"): set text(fill: rgb("#b08000"), weight: "bold")
  show regex("\"[^\"]*\""): set text(fill: rgb("#ff0000"), weight: "regular")
  show regex("//.*"): set text(fill: rgb("#777777"), weight: "regular")
  show raw.line: it => box(width: 100%, grid(
    columns: (1.6em, 1fr),
    text(size: 7pt, fill: rgb("#888888"))[#it.number], it.body,
  ))
  body
}

= Lezione 17 del 29 ottobre 2026

== LiSA, Library for Static Analysis

Nella lezione di oggi vedremo una breve introduzione a LiSA, una libreria per creare analizzatori statici basati su interpretazione astratta.
L'obiettivo è di creare una libreria più generica possibile, in modo che possa essere utilizzata su più linguaggi di programmazione.

#figure(image("img/lezione17/lisa_full_analyzer.svg", width: 70%), caption: [Overview full-analyzer.])

Le analisi vengono svolte sul CFG ottenuto dalla compilazione del linguaggio che si vuole analizzare.
Poi su questo CFG si calcola il least fixpoint come abbiamo già visto nelle lezioni precedenti.

#figure(image("img/lezione17/lisa_architecture.svg", width: 100%), caption: [Overview di LiSA.])

== Calcolo fixpoint dell'intero programma

Per calcolare il fixpoint dell'intero programma, partiamo dall'entry point, di solito la funzione main, e calcoliamo il fixpoint per il CFG della funzione main.

Se è un programma complesso sicuramente avremo altre chiamate a funzione all'interno del main, quindi poi dovremo calcolare i fixpoint delle altre funzioni/procedure che vengono invocate, stessa cosa per invocazioni dentro ad altre funzioni e così via.

== Statement semantics

Vogliamo concentrarci sulla semantica, senza doverci preoccupare della sintassi del linguaggio di partenza, in modo da poter svolgere analisi 'generali'.

Una soluzione è quello di portare tutto a una singola IR.

La soluzione di LiSA è quella di spezzare gli *statement* in *SymbolicExpressions*.
Le SymbolicExpressions sono estensibili, quindi un utente può definirne di nuove.

Questo permette all'analisi di ignorare la sintassi che sta dietro agli statement e di concentrarsi esclusivamente sul significato semantico.

#example(name: "Esempi con pseudocodice")[
  #sem-code(```
  Plus.semantics(): // left + right
    if type(left) is string or type(right) is string:
      return domain.eval(new BinaryExpression("cat", left, right))
    else:
      return domain.eval(new BinaryExpression("+", left, right))
  ```)

  #sem-code(```
  Conditional.semantics(): // condition ? ifTrue : ifFalse
    sat = domain.isSatisfied(condition)
    tt = ifTrue.semantics()
    ff = ifFalse.semantics()
    return sat.isTrue() ? tt : (sat.isFalse() ? ff : tt ⊔ ff)
  ```)

  #sem-code(```
  PreIncrement.semantics(): // ++var
    add = new BinaryExpression("+", var, new Const(1))
    d1 = domain.store(var, add)
    return d1.eval(var)
  ```)
]
