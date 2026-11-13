#import "../../Template typst/template.typ": (
  c-border, definition, example, lbs, note, rbs, separator, sqglb, sqle, sqlub, theorem,
)
#import "@preview/fletcher:0.5.8": diagram, edge, node, shapes
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

= Lezione 22 del 13 novembre 2026

La scorsa lezione abbiamo visto la definizione della semantica concreta per le stringhe in Imp, e dell'analisi dei prefissi e definito la semantica astratta per suddetta analisi.

In questa lezione guardiamo l'analisi dei suffissi.

== Dominio dei suffissi

Vogliamo definire il dominio dei suffissi per le stringhe, vogliamo rappresentare i suffissi nel seguente modo:

$ *"acb"; quad * $

Con $*$ rappresentiamo quello che viene prima del suffisso, di cui non siamo a conoscenza, con solo l'operatore $*$ indichiamo la stringa vuota.

Definiamo il reticolo per il dominio dei suffissi, è praticamente lo stesso del dominio dei prefissi.

$ "SU" = chevron.l Sigma^+ union {bot_"SU"}, sqle("SU"), union.sq_"SU", epsilon, bot_"SU" chevron.r $

Per definire l'ordinamento:

$ s_1 sqle("SU") s_2 <=> s_1 = bot_"SU" or (s_2 "is suffix of" s_1) $

Il lub invece tra due suffissi è:

$ s_1 sqle("SU") s_2 = "largest common suffix"(s_1, s_2) $

Il glb invece lo definiamo:

$ s_1 sqglb("SU") s_2 = cases(s_1 &quad s_1 sqle("SU") s_2, s_2 &quad s_2 sqle("SU") s_1, bot_"SU" &quad "altrimenti") $

#align(center)[
  #figure(
    diagram(
      node-stroke: none,
      spacing: (0pt, 1.5em),

      // nodi
      node((0, 0), $epsilon$, name: <eps>),
      node((0, 2), $b$, name: <b>),
      node((0, 3), $a b$, name: <ab>),
      node((0, 4), $c a b$, name: <cab>),
      node((0, 6), $bot_"su"$, name: <bot>),

      // asterischi a sinistra dei nodi
      node((-0.45, 2), $*$),
      node((-0.55, 3), $*$),
      node((-0.65, 4), $*$),

      // archi
      edge(<eps>, <b>, "-", stroke: (dash: "dotted")),
      edge(<b>, <ab>, "-"),
      edge(<ab>, <cab>, "-"),
      edge(<cab>, <bot>, "-", stroke: (dash: "dotted")),
    ),
    caption: [Reticolo parziale dei suffissi.],
  )
]

=== Galois connection e funzioni di concretizzazione e astrazione

Anche per il dominio dei suffissi abbiamo una connessione di Galois tra il concreto e l'astratto:

$
  cal(P)(Sigma^*) #box(baseline: 30%, stack(
    dir: ttb,
    spacing: 6pt,
    $attach(arrow.r.long, t: alpha_"SU")$,
    $attach(arrow.l.long, b: gamma_"SU")$,
  )) "SU"
$

Come per il dominio dei prefissi, possiamo definire $gamma_"SU"$ e poi indurre la funzione di astrazione tramite $gamma_"SU"$.
Definiamo la funzione di concretizzazione: $gamma_"SU" : "SU" arrow cal(P)(Sigma^*)$

$
  gamma_"SU" = cases(emptyset &quad "se" s = bot_"su", {sigma in Sigma^* | exists w in Sigma^*, w s = sigma} &quad "altrimenti")
$

Da $gamma_"SU"$ possiamo indurre la funzione d'astrazione $alpha_"SU": cal(P)(Sigma^*) arrow "SU"$.

$ alpha_"SU" (S) = inter.sq {s in "SU" | S subset.eq gamma_"SU"(s)} $

Possiamo anche indurre $gamma_"SU"$ partendo da $alpha_"SU"$:

$ alpha_"SU" (S) = cases(bot_"SU" &quad "se" S = emptyset, "longest common suffix"(S) &quad "altrimenti") $

Ora che abbiamo reso $alpha_"SU"$ esplicita possiamo indurre la funzione $gamma_"SU"$:

$ gamma_"SU" (hat(s)) = union {S in cal(P)(Sigma^*) | alpha_"SU" (S) sqle("SU") hat(s)} $

=== Semantica astratta

Come per il dominio dei prefissi, dobbiamo definire la semantica astratta per il dominio dei suffissi. Abbiamo sempre la funzione di memoria astratta $MM^"#" : VV arrow "SU"$.

- $lbs sigma rbs^"#" m^"#" = * sigma$

- $lbs s_1 + s_2 rbs^"#" m^"#" = lbs s_2 rbs^"#" m^"#"$

- $lbs "substring"_i^j (s) rbs^"#" m^"#" = epsilon$; vale $epsilon$ perché  non so quanto sia lunga la stringa.

- $lbs s_1 == s_2 rbs^"#" m^"#" = cases(bot_(m^"#") &quad lbs s_1 rbs^"#" m^"#" inter.sq lbs s_2 rbs^"#" m^"#" = bot_"SU", m^"#" &quad "altrimenti")$

Per la semantica della valutazione di un'espressione booleana facciamo qualche esempio per chiarire:

#example(name: "Esempio espressione booleana per suffissi")[
  Partiamo da questo insieme di memorie:
  $
    mat(
      delim: "[",
      x, arrow.r, *"a";
      y, arrow.r, *"b";
      z, arrow.r, *"cba";
      column-gap: #1em
    )
  $

  Ipotizziamo di dover lavorare sul seguente CFG:

  #align(center)[
    #diagram(
      spacing: (7em, 5em),
      node-inset: 10pt,

      // blocchi
      node((0, 0), $x == y$, name: <cond>, stroke: 0.7pt),
      node((-0.6, 2), $z = z + x$, name: <body>, stroke: 0.7pt, corner-radius: 4pt),

      // ramo true
      edge(<cond>, <body>, "->", label: $bot_(m^sharp) quad "TT"$, label-side: right),

      // ramo false (omesso)
      edge(<cond>, (0.9, 1), "--", label: "FF", label-side: left),
      node((0.9, 1), $dots.v$, stroke: none),
    )
  ]

  In questo caso il ramo true 'TT' è unreachable, di conseguenza dobbiamo restituire $bot_(m^"#")$.

  #separator()

  Consideriamo adesso invece il seguente set di memorie:

  $
    mat(
      delim: "[",
      x, arrow.r, *"a";
      y, arrow.r, *"ba";
      z, arrow.r, *"cba";
      column-gap: #1em
    )
  $

  #align(center)[
    #diagram(
      spacing: (7em, 4.5em),
      node-inset: 10pt,

      // blocchi
      node((0, 0), $x == y$, name: <cond>, stroke: 0.7pt),
      node((-0.6, 2), $z = z + x$, name: <body>, stroke: 0.7pt, corner-radius: 4pt),

      // ramo true
      edge(<cond>, <body>, "->", label: "TT", label-side: right),

      // ramo false (omesso)
      edge(<cond>, (0.9, 1), "--", label: "FF", label-side: left),
      node((0.9, 1), $dots.v$, stroke: none),

      // stato sotto il CFG
      node((-0.6, 2.5), $x arrow.r dots$, stroke: none),
      node((-0.6, 2.7), $z arrow.r dots$, stroke: none),
    )
  ]

  In questo caso confrontando i due suffissi $*"a"$, $*"ba"$, potrebbero essere uguali, quindi dobbiamo restituire $m^"#"$ e poi proseguire con il resto dell'analisi nel ramo true 'TT'.

]

Utilizzando semplicemente il dominio dei suffissi così da solo non ha molto senso. Una cosa molto utile che possiamo fare se dobbiamo fare analisi di stringhe è quella di *combinare più domini tra loro* tramite prodotto cartesiano, per esempio: 'prefix' $times$ 'suffix' $times$ 'str_length'.
Così facendo possiamo tenere traccia delle informazioni in questo modo:

$ x arrow ("a"*, *"b", [2, + infinity]) $

Qui rappresentiamo una stringa $x$ che ha come prefisso 'a' e come suffisso 'b'. La lunghezza minima è 2, perché la stringa più piccola che possiamo ottenere è 'ab'.

Se consideriamo invece

$ x arrow ("a"*, *"b", [2, 3]) $

Stiamo dicendo che $x$ è una stringa con lo stesso prefisso e suffisso di prima, ma ha una lunghezza finita di 3. Possiamo formalizzarla nel seguente modo: ${a sigma b | |sigma| <= 1}$.
