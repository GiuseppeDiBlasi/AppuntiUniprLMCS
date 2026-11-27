# Lezione 27 del 27 novembre 2026 

- Mirai malware (parentesi)

# Standard e metriche sulla qualità del software

Ridurre al minimo i bug presenti nel codice.

Hack equifax -> danni reputazionali ed economici 

attacco di tipo: SQL injection e cross site scripting
- cross site scripting: eseguo script malevoli dentro ad una pagina web (esempio ebay).

Vulnerabilità all'interno delle automobili moderne.

- Caso Ariane 5 
- SolarWinds Orion (2020)
- MOVEit Transfer (2023)
- xz-utils backdoor (2024)
- CrowdStrike (2024)
- Cloudflare (2025)
- npm worm (2025)

Non c'è una regolamentazione sulla qualità del software a differenza di altri settori industriali (regolamenti ambientali, sicurezza fisica dei dispositivi, es. le auto)

Per l'analisi statica in azienda vogliamo che sia automatica

static: guardiamo il codice senza eseguire il programma.
dynamic: eseguiamo il programma e vedo il comportamento.

analisi semantica e sintattica:

- semantica: lenta ma precisa
- sintattica: efficiente ma meno precisa

Si puo fare analisi sul codice sorgente o bytecode

# Mitre corporation e CVE

Dal Mitre nasce il CVE, un database pubblico che contiene tutte le vulnerabilità  software.

bug, vulnerability e weakness. CVE definisce il concetto di weakness e lo collega a vulnerability.
Per esempio il bug di ariane 5 non è una weakness (debolezza) del software che è stata sfruttato da qualcuno.
Il bug genera un crash del programma.

# CVSS 

# CWE 

Vogliamo tipologie di vulnerabilità, per questo abbiamo CWE (Common Weakness Enumeration).

# Log4j (skip)

# Owasp 

Comunità online che produce documenti, articoli, metodologie per sicurezza di applicazioni web.

L'owasp benchmark permette di stabilire se un analizzatore statico è migliore di un altro.

# SAMATE (NIST)

Altro benchmark come l'Owasp benchmark.

# WASC 

Consorzio di un gruppo di esperti per produrre best-practice open source.

# AI Generativa

Sistemi AI come vulnerabilità: riuscire a manomettere i dati di training, prompt per ottenere informazioni riservate...
Anche come meccanismo di difesa: analizzare il codice e poi risolvere vulnerabilità.

# Static Analysis in the AI era

Analisi basate su LLM: 
- Bug semantici
- Non deterministica 

Anlisi statiche sound:
- Gantisce per tutte le esecuzioni 
- Deterministica e certificabile
- Falsi allarmi
