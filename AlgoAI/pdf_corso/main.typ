#import "../../Template typst/template.typ": academic-paper

#show: academic-paper.with(
  title: "Algoritmi per l'intelligenza artificiale",
  date: "A.A. 2026/2027",
  authors: (
    (
      name: "Giuseppe Di Blasi",
      affiliation: "Università di Parma",
      email: "giuseppe.diblasi@studenti.unipr.it",
    ),
  ),
  // L'abstract è opzionale, puoi anche ometterlo o lasciarlo vuoto
  abstract: [
    Appunti del corso di Algoritmi per l'intelligenza artificiale.
  ],
)


#include "lezione1.typ"
#include "lezione2.typ"
#include "lezione3.typ"
#include "lezione4.typ"
#include "lezione5.typ"
#include "lezione6.typ"
#include "lezione7.typ"
#include "lezione8.typ"
