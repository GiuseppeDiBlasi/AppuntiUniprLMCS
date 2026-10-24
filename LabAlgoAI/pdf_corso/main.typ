#import "../../Template typst/template.typ": academic-paper

#show: academic-paper.with(
  title: "Laboratorio di Algoritmi per l'intelligenza artificiale",
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
    Appunti per il corso di Laboratorio di Algoritmi per l'intelligenza artificiale
  ],
)

#include "linee_guida_progetto.typ"
