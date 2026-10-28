#import "../../Template typst/template.typ": academic-paper, exam-appendix

#set text(lang: "it")


#show: academic-paper.with(
  title: "Analisi statica e verifica del software",
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
    Appunti sul corso di Analisi statica e verifica del software
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
#include "lezione9.typ"
#include "lezione10.typ"
#include "lezione11.typ"
#include "lezione12.typ"
#include "lezione13.typ"
#include "lezione14.typ"
#include "lezione15.typ"
#include "lezione16.typ"

#exam-appendix()
