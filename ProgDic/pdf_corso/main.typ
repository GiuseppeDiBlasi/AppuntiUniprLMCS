#import "../../Template typst/template.typ": academic-paper

#show: academic-paper.with(
  title: "Programmazione Dichiarativa",
  date: "A.A. 2026/2027",
  authors: (
    (
      name: "Giuseppe",
      affiliation: "Università di Parma",
      email: "giuseppe.diblasi@studenti.unipr.it",
    ),
  ),
  // L'abstract è opzionale, puoi anche ometterlo o lasciarlo vuoto
  abstract: [
    Appunti del corso di Programmazione Dichiarativa.
  ],
)


#include "lezione1.typ"
#include "lezione2.typ"
