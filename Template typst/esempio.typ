// Esempio di documento Typst
// Compila con: typst compile esempio.typ
// Preview live con: typst watch esempio.typ (oppure :TypstPreview in Neovim)

#set document(title: "Documento di prova", author: "Il tuo nome")
#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 3cm),
  numbering: "1",
)
#set text(
  font: "Linux Libertine",
  size: 11pt,
  lang: "it",
)
#set heading(numbering: "1.1")
#set par(justify: true, leading: 0.65em)

#align(center)[
  #text(20pt, weight: "bold")[Documento di prova]
  #v(0.3cm)
  #text(12pt, style: "italic")[Un esempio per testare Typst e la preview in Neovim]
]

#v(1cm)

= Introduzione

Questo è un documento di esempio scritto in *Typst*. Serve per verificare che
la compilazione e la preview funzionino correttamente nel tuo editor.

Typst supporta il grassetto (\*così\*), il corsivo (\_così\_) e anche il
#underline[testo sottolineato].

== Un elenco puntato

- Primo elemento
- Secondo elemento
- Terzo elemento con una nota a piè di pagina#footnote[Questa è una nota a piè di pagina di esempio.]

== Un elenco numerato

+ Installare Typst
+ Installare il plugin per Neovim
+ Aprire questo file e lanciare la preview

= Formule matematiche

Typst gestisce la matematica in modo nativo, senza bisogno di pacchetti esterni:

$ integral_0^infinity e^(-x^2) dif x = sqrt(pi) / 2 $

Anche formule inline funzionano bene, ad esempio $a^2 + b^2 = c^2$ nel testo.

= Una tabella

#table(
  columns: (auto, auto, auto),
  align: center,
  table.header[*Nome*][*Ruolo*][*Anno*],
  [Typst], [Linguaggio], [2023],
  [Neovim], [Editor], [2014],
  [Arch Linux], [Distro], [2002],
)

= Codice

Anche i blocchi di codice sono supportati con syntax highlighting:

```python
def saluta(nome):
    print(f"Ciao, {nome}!")

saluta("mondo")
```

= Conclusione

Se vedi questo documento renderizzato correttamente nella preview di Neovim,
tutto funziona a dovere. Buon lavoro con Typst!
