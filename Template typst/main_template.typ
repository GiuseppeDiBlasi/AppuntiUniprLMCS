#import "template.typ": academic-paper

#show: academic-paper.with(
  title: "Corso",
  date: "A.A. 202X/202X",
  authors: (
    (
      name: "Giuseppe",
      affiliation: "Università di Parma",
      email: "giuseppe.diblasi@studenti.unipr.it"
    ),
  ),
  // L'abstract è opzionale, puoi anche ometterlo o lasciarlo vuoto
  abstract: [
    Abstract del documento
  ]
)

