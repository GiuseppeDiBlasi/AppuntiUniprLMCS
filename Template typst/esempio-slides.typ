#import "slides-template.typ": *
#show: slides.with(
  title: "Provably Correct Floating-Point Implementation of a Point-in-Polygon Algorithm",
  subtitle: "Analisi statica e verifica del software",
  authors: (
    (name: "Giuseppe Di Blasi", affiliation: "Università di Parma", email: "giuseppe.diblasi@studenti.unipr.it"),
  ),
)
= Fondamenti
== Reticoli
#definition(
  name: "Reticolo",
)[Un insieme parzialmente ordinato $(L, sqle(L))$ in cui ogni coppia ha $sqlub("")$ e $sqglb("")$.]
- Primo punto
- Secondo punto
  - annidato
#note[Una nota importante.]
== Teoremi
#cols[
  #theorem(name: "Knaster–Tarski")[Ogni funzione monotona ha un punto fisso.]
][
  #example[Esempio con $x^2$.]
  #warning[Attenzione!]
]
#formula(name: "Punto fisso")[$ "lfp"(f) = sqlub("") { f^n(bot) } $]
== Altro
#recall(topic: "Reticoli")[Ripasso.]
#exam(answer: [Perché è monotona.])[Perché esiste il punto fisso?]
```python
print("ciao")
```
#table(
  columns: 2,
  [A], [B],
  [1], [2],
)
= Conclusioni
== Fine
#focus[Grazie per l'attenzione]
