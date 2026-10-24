# Piani di Studio – Cybersecurity
## Esame: 6 settembre | Inizio: 6 agosto | 4-5h/giorno

---

> **Regola d'oro (valida per entrambi i piani)**
> Ogni blocco di studio finisce con 20-30 min in cui chiudi le slide e provi a rispondere/risolvere a memoria le domande/esercizi del giorno. Se non ci riesci, non passare oltre.
>
> **Priorità se sei in ritardo:** taglia Introduction, Anonymity, IPSec/TLS (poche domande).
> **Non tagliare mai:** RSA, CBC/OFB, DH, schemi combinati, certificati, firewall.

---

# PIANO A — 31 giorni (ritmo disteso)

**Struttura:** 21 giorni di studio + 7 giorni ripasso attivo + 3 giorni simulazione

---

## FASE 1 — Comprensione + prima pratica (Giorni 1-21)

### Giorno 1 · 6 ago — Introduzione
**Slide:** Introduction (1-10) | **Domande:** Q1-2

- [ ] Servizi di sicurezza (confidenzialità, integrità, autenticazione, non-ripudio, disponibilità)
- [ ] Minacce passive vs attive — esempi concreti
- [ ] Leggi il documento delle domande per intero: sai già dove devi arrivare

---

### Giorno 2 · 7 ago — Cifrari classici e concetti base
**Slide:** Secret Key ~11-50 | **Domande:** Q3-7 | **Esercizi:** Es.1-2

- [ ] Block cipher vs stream cipher
- [ ] Tipi di attacchi crittoanalitici (ciphertext-only, known-plaintext, chosen-plaintext, chosen-ciphertext)
- [ ] Sicurezza incondizionata vs computazionale
- [ ] Cifrario monoalfabetico, effetto valanga
- [ ] **Pratica:** Cesare con K=4, cifra "SECRET" (Es.1)
- [ ] **Pratica:** crittoanalisi cifrario affine con frequenze (Es.2)

---

### Giorno 3 · 8 ago — Modalità block cipher (teoria)
**Slide:** Secret Key ~51-100 | **Domande:** Q8

- [ ] ECB, CBC, OFB, CFB, CTR — schema di ognuna, differenze, quali usano solo la funzione di cifratura
- [ ] **Pratica:** disegna a mano gli schemi CBC e OFB senza guardare le slide

---

### Giorno 4 · 9 ago — CBC e OFB: calcolo intensivo
**Slide:** Secret Key ~100-134 | **Esercizi:** Es.3-6

- [ ] Schema CBC generico con blocchi Mi (Es.3)
- [ ] Complessità brute force su CBC in funzione di n,p,q (Es.4)
- [ ] CBC bit-a-bit con tabella di sostituzione (Es.5) — **fallo almeno 2 volte a mano**
- [ ] Manipolazione ciphertext OFB per ottenere plaintext scelto (Es.6) — capisci *perché* funziona (proprietà XOR)

---

### Giorno 5 · 10 ago — Modalità avanzate e padding
**Esercizi:** Es.7-9

- [ ] Effetto del riordino blocchi su CBC — cosa succede al plaintext? (Es.7)
- [ ] Schema senza avalanche effect con XOR (Es.8)
- [ ] Padding: quali algoritmi funzionano con block cipher e perché (Es.9)

⚠️ Prima di andare avanti: rifai Es.5 e Es.6 da zero senza guardare.

---

### Giorno 6 · 11 ago — Hash functions (teoria)
**Slide:** Hash (135-163) | **Domande:** Q9-12

- [ ] Proprietà hash sicura (resistenza preimmagine, seconda preimmagine, collisione)
- [ ] Usi delle hash function
- [ ] MAC e differenza con firma digitale
- [ ] Schema HMAC — conteggio passi C per messaggio N·M (Q12 è un esercizio camuffato da domanda)

---

### Giorno 7 · 12 ago — Hash: pratica
**Esercizi:** Es.10

- [ ] Schema autenticazione A↔B con hash e chiave condivisa (Es.10-i)
- [ ] Invio messaggio con autenticazione + integrità (Es.10-ii)
- [ ] Funzione di cifratura basata su hash (Es.10-iii)
- [ ] Rifai l'intero Es.10 da zero, disegnando gli schemi

---

### Giorno 8 · 13 ago — Teoria dei numeri (parte 1)
**Slide:** Number Theory (164-185) | **Domande:** Q13-15 | **Esercizi:** Es.11-14

- [ ] a≡b (mod n): significato e proprietà
- [ ] Inverso moltiplicativo modulo n — quando esiste
- [ ] Funzione di Eulero Φ(n)
- [ ] **Pratica:** inversi in Z7 (Es.11), coprimi in Z21 (Es.12), Euclide su 3 coppie (Es.13), dimostrazione Φ(pq) (Es.14)

---

### Giorno 9 · 14 ago — Teoria dei numeri (parte 2)
**Slide:** Number Theory (185-197) | **Domande:** Q16

- [ ] Logaritmo discreto — definizione, perché è difficile calcolarlo
- [ ] Radice primitiva — definizione e verifica
- [ ] **Pratica:** verifica che 2 è radice primitiva di 11 (Es.20, anticipato)

---

### Giorno 10 · 15 ago — RSA: generazione chiavi e cifratura
**Slide:** Public Key (198-220) | **Domande:** Q17 | **Esercizi:** Es.15-17

- [ ] RSA completo: p,q → n → Φ(n) → e → d (Euclide esteso) → cifratura/decifratura
- [ ] **Pratica (rifai ognuno 2 volte senza guardare):**
  - Es.15: p=3, q=11 → genera chiavi, cifra m=2
  - Es.16: p=7, q=11, e=13 → Euclide esteso per d, decifra c=2
  - Es.17: e=5, n=35, C=10 → trova M

---

### Giorno 11 · 16 ago — RSA: firma digitale + esercizio difficile
**Slide:** Public Key (220-239) | **Domande:** Q19 | **Esercizi:** Es.18

- [ ] Firma digitale RSA: schema firma + verifica
- [ ] **Pratica:** Es.18 — e=31, n=901 → fattorizza per trial-and-error, poi Euclide esteso per d

⚠️ Se non sei fluido su RSA, ripassa domani mattina prima di procedere.

---

### Giorno 12 · 17 ago — Diffie-Hellman
**Slide:** Public Key (fine) + Key Establishment (298-328) | **Domande:** Q18, Q24-25 | **Esercizi:** Es.19-21

- [ ] Scambio chiavi DH: schema, parametri pubblici vs privati
- [ ] Vulnerabilità MITM — disegna l'esempio di attacco
- [ ] DH generalizzato per gruppi
- [ ] **Pratica:** DH con g=2, p=11 (Es.19); calcolo yA/yB/KAB con p=71, g=7 (Es.21)

---

### Giorno 13 · 18 ago — Autenticità e schemi challenge-response
**Slide:** Authenticity (240-279) | **Domande:** Q20-21 | **Esercizi:** Es.22-23

- [ ] Schemi challenge-response: simmetrico, asimmetrico, hash, MAC, firma digitale
- [ ] Modi in cui si stabiliscono chiavi segrete tra due parti
- [ ] **Pratica:** Es.22 (confidenzialità RSA+AES), Es.23 (integrità hash+chiave) — disegna gli schemi

---

### Giorno 14 · 19 ago — Schemi combinati e KDC
**Slide:** Authenticity (resto) + Identification (280-297) | **Domande:** Q22-23 | **Esercizi:** Es.24-27

- [ ] Short-term key vs long-term key
- [ ] Key Distribution Center (KDC) — schema di distribuzione
- [ ] **Pratica:** Es.24 (confidenzialità+integrità RSA+AES+SHA1), Es.25 (2 destinatari), Es.26 (auth RSA), Es.27 (mutua auth hash)

---

### Giorno 15 · 20 ago — Key establishment e DH autenticato
**Slide:** Key Establishment (resto) + PKI (329-361) | **Domande:** Q28-29 | **Esercizi:** Es.28-29

- [ ] Key transport asimmetrico senza KDC (Es.28)
- [ ] DH autenticato anti-MITM (Es.29) — confronta con l'attacco del Giorno 12

---

### Giorno 16 · 21 ago — Certificati digitali e PKI
**Slide:** PKI (resto, 329-361) | **Domande:** Q26-29 | **Esercizi:** Es.30-31

- [ ] Certificato digitale, catena di certificati, contenuto X.509, CRL
- [ ] **Pratica chiave:** tabella Es.30 — capisci la logica della catena, non memorizzare le risposte
- [ ] Autenticazione incrociata con catene diverse (Es.31)

---

### Giorno 17 · 22 ago — IPSec e TLS
**Slide:** Secure Communications (362-411) | **Domande:** Q30-32

- [ ] Servizi IPSec ESP (confidenzialità, integrità, autenticazione origine, anti-replay)
- [ ] Servizi TLS, handshake TLS, certificato coinvolto
- [ ] Collega agli schemi combinati dei giorni 13-15

---

### Giorno 18 · 23 ago — Anonymity
**Slide:** Anonymity (412-446) | **Domande:** Q33-37 | **Esercizi:** Es.32

- [ ] Mix network ad alta latenza: schema e formato messaggio (Es.32)
- [ ] Onion Routing — differenze rispetto al mix network
- [ ] Sniffing vs MITM, spoofing, DoS (30 min bastano, sono definizioni)

---

### Giorno 19 · 24 ago — Software Security
**Slide:** Software Security (447-508) | **Domande:** Q35-40 | **Esercizi:** Es.33

- [ ] Network scanner vs vulnerability scanner
- [ ] Buffer overflow: come funziona sullo stack (Es.33 — analizza la funzione C e trova la password exploit)
- [ ] SQL injection: schema dell'attacco, esempio pratico

---

### Giorno 20 · 25 ago — Firewall e IDS
**Slide:** Firewalls (509-539) | **Domande:** Q41-42 | **Esercizi:** Es.34-35

- [ ] Packet filtering firewall: logica delle regole, stateful vs stateless
- [ ] IDS: host-based vs network-based
- [ ] **Pratica:** tabella filtro R1 web+SMTP (Es.34), R1+R2 con DMZ (Es.35) — costruisci da zero senza guardare

---

### Giorno 21 · 26 ago — Buffer e recupero
- [ ] Completa tutto ciò rimasto indietro nella Fase 1
- [ ] Rifai gli esercizi che ti hanno dato più problemi
- [ ] Foglio di formule: deve essere completo

---

## FASE 2 — Ripasso attivo (Giorni 22-28)

Ogni giorno: scorri le slide e rifai tutti gli esercizi/domande **senza guardare le soluzioni prima**.

| Giorno | Data   | Sezione                                                              |
|--------|--------|----------------------------------------------------------------------|
| 22     | 27 ago | Cifrari simmetrici + modalità (Es.1-9, Q3-8)                        |
| 23     | 28 ago | Hash + MAC (Es.10, Q9-12)                                           |
| 24     | 29 ago | Teoria dei numeri + RSA (Es.11-18, Q13-19)                          |
| 25     | 30 ago | DH + autenticazione + key establishment (Es.19-29, Q18-25)          |
| 26     | 31 ago | PKI + certificati (Es.30-31, Q26-29)                                |
| 27     | 1 set  | IPSec/TLS + Anonymity + Software Security (Es.32-33, Q30-40)        |
| 28     | 2 set  | Firewall + IDS (Es.34-35, Q41-42) + tutte le 42 domande a voce alta |

---

## FASE 3 — Simulazione (Giorni 29-31)

### Giorno 29 · 3 set — Simulazione esame completa
- [ ] 2-3 ore, niente slide, niente appunti
- [ ] 15 domande a caso + 5 esercizi a caso
- [ ] Correggi e segna i punti deboli

### Giorno 30 · 4 set — Solo i punti deboli
- [ ] Intera giornata dedicata agli argomenti dove ti sei bloccato
- [ ] Seconda simulazione parziale sulle aree deboli

### Giorno 31 · 5 set — Revisione finale leggera
- [ ] Scorri il foglio di formule
- [ ] 42 domande a voce, 1 minuto l'una
- [ ] **Smetti nel pomeriggio** — riposa, il cervello consolida di notte

---
---

# PIANO B — 27 giorni (ritmo accelerato, con accorpamenti)

**Differenza rispetto al Piano A:** 4 accorpamenti naturali liberano 4 giorni → finisci il 2 settembre con 3 giorni di buffer prima dell'esame.

**Accorpamenti applicati:**
- Giorni 1+2 → **un giorno solo** (Introduction è leggerissima)
- Giorni 6+7 → **un giorno solo** (Hash: teoria + pratica nella stessa giornata)
- Giorni 8+9 → **un giorno solo** (Teoria dei numeri è un blocco unico)
- Giorni 17+18 → **un giorno solo** (IPSec/TLS + Anonymity, entrambi leggeri)

---

## FASE 1 — Comprensione + prima pratica (Giorni 1-17)

### Giorno 1 · 6 ago — Introduzione + Cifrari classici
**Slide:** Introduction (1-10) + Secret Key ~11-50 | **Domande:** Q1-7 | **Esercizi:** Es.1-2

- [ ] Servizi di sicurezza, minacce passive vs attive
- [ ] Block cipher vs stream cipher, attacchi crittoanalitici
- [ ] Sicurezza incondizionata vs computazionale, cifrario monoalfabetico, effetto valanga
- [ ] **Pratica:** Cesare con K=4 (Es.1), crittoanalisi cifrario affine con frequenze (Es.2)

---

### Giorno 2 · 7 ago — Modalità block cipher (teoria)
**Slide:** Secret Key ~51-100 | **Domande:** Q8

- [ ] ECB, CBC, OFB, CFB, CTR — schemi, differenze, quali usano solo la cifratura
- [ ] **Pratica:** disegna CBC e OFB senza guardare le slide

---

### Giorno 3 · 8 ago — CBC e OFB: calcolo intensivo
**Slide:** Secret Key ~100-134 | **Esercizi:** Es.3-6

- [ ] Schema CBC generico (Es.3), complessità brute force (Es.4)
- [ ] CBC bit-a-bit con tabella (Es.5) — **almeno 2 volte a mano**
- [ ] Manipolazione OFB (Es.6) — capisci la proprietà XOR

---

### Giorno 4 · 9 ago — Modalità avanzate e padding
**Esercizi:** Es.7-9

- [ ] Riordino blocchi CBC (Es.7), schema senza avalanche XOR (Es.8), padding (Es.9)

⚠️ Rifai Es.5 e Es.6 da zero prima di procedere.

---

### Giorno 5 · 10 ago — Hash: teoria + pratica
**Slide:** Hash (135-163) | **Domande:** Q9-12 | **Esercizi:** Es.10

- [ ] Proprietà hash, usi, MAC, schema HMAC, conteggio passi C (Q12)
- [ ] **Pratica:** Es.10 completo (i, ii, iii) — disegna gli schemi da zero

---

### Giorno 6 · 11 ago — Teoria dei numeri (completa)
**Slide:** Number Theory (164-197) | **Domande:** Q13-16 | **Esercizi:** Es.11-14

- [ ] Aritmetica modulare, inverso moltiplicativo, Φ(n), logaritmo discreto, radice primitiva
- [ ] **Pratica:** Es.11-14 + verifica radice primitiva di 11 (Es.20 anticipato)

---

### Giorno 7 · 12 ago — RSA: generazione chiavi e cifratura
**Slide:** Public Key (198-220) | **Domande:** Q17 | **Esercizi:** Es.15-17

- [ ] RSA completo: p,q → n → Φ(n) → e → d → cifra/decifra
- [ ] **Pratica (2 volte ciascuno):** Es.15, Es.16, Es.17

---

### Giorno 8 · 13 ago — RSA: firma + esercizio difficile
**Slide:** Public Key (220-239) | **Domande:** Q19 | **Esercizi:** Es.18

- [ ] Firma digitale RSA: schema firma + verifica
- [ ] **Pratica:** Es.18 — fattorizza n=901, Euclide esteso per d

⚠️ Se RSA non è fluido, ripassa domani mattina prima di procedere.

---

### Giorno 9 · 14 ago — Diffie-Hellman
**Slide:** Public Key (fine) + Key Establishment (298-328) | **Domande:** Q18, Q24-25 | **Esercizi:** Es.19-21

- [ ] Schema DH, vulnerabilità MITM con esempio disegnato, DH di gruppo
- [ ] **Pratica:** Es.19 (g=2, p=11), Es.21 (p=71, g=7, calcolo yA/yB/KAB)

---

### Giorno 10 · 15 ago — Schemi di autenticazione
**Slide:** Authenticity (240-279) | **Domande:** Q20-21 | **Esercizi:** Es.22-23

- [ ] Challenge-response con cifratura simmetrica, asimmetrica, hash, MAC, firma
- [ ] **Pratica:** Es.22 (confidenzialità RSA+AES), Es.23 (integrità hash+chiave) — disegna gli schemi

---

### Giorno 11 · 16 ago — Schemi combinati e KDC
**Slide:** Authenticity (resto) + Identification (280-297) | **Domande:** Q22-23 | **Esercizi:** Es.24-27

- [ ] Short-term vs long-term key, KDC
- [ ] **Pratica:** Es.24 (RSA+AES+SHA1), Es.25 (2 destinatari), Es.26 (auth RSA), Es.27 (mutua auth hash)

---

### Giorno 12 · 17 ago — Key establishment e DH autenticato
**Slide:** Key Establishment (resto) + PKI (329-361) | **Domande:** Q28-29 | **Esercizi:** Es.28-29

- [ ] Key transport senza KDC (Es.28), DH autenticato anti-MITM (Es.29)

---

### Giorno 13 · 18 ago — Certificati digitali e PKI
**Slide:** PKI (resto, 329-361) | **Domande:** Q26-29 | **Esercizi:** Es.30-31

- [ ] Certificato digitale, catena, X.509, CRL
- [ ] **Pratica chiave:** tabella Es.30 (logica della catena), Es.31 (catene incrociate)

---

### Giorno 14 · 19 ago — IPSec/TLS + Anonymity
**Slide:** Secure Communications (362-411) + Anonymity (412-446) | **Domande:** Q30-37 | **Esercizi:** Es.32

- [ ] Servizi IPSec ESP, TLS handshake, certificato TLS
- [ ] Mix network (Es.32), Onion Routing, sniffing/MITM/spoofing/DoS

---

### Giorno 15 · 20 ago — Software Security
**Slide:** Software Security (447-508) | **Domande:** Q35-40 | **Esercizi:** Es.33

- [ ] Scanner, buffer overflow (Es.33 — trova la password exploit), SQL injection

---

### Giorno 16 · 21 ago — Firewall e IDS
**Slide:** Firewalls (509-539) | **Domande:** Q41-42 | **Esercizi:** Es.34-35

- [ ] Packet filtering, stateful vs stateless, IDS
- [ ] **Pratica:** Es.34 (R1 web+SMTP), Es.35 (R1+R2 DMZ) — costruisci da zero

---

### Giorno 17 · 22 ago — Buffer e recupero
- [ ] Completa ciò rimasto indietro, rifai gli esercizi problematici
- [ ] Foglio di formule: completo

---

## FASE 2 — Ripasso attivo (Giorni 18-24)

| Giorno | Data   | Sezione                                                              |
|--------|--------|----------------------------------------------------------------------|
| 18     | 23 ago | Cifrari simmetrici + modalità (Es.1-9, Q3-8)                        |
| 19     | 24 ago | Hash + MAC (Es.10, Q9-12)                                           |
| 20     | 25 ago | Teoria dei numeri + RSA (Es.11-18, Q13-19)                          |
| 21     | 26 ago | DH + autenticazione + key establishment (Es.19-29, Q18-25)          |
| 22     | 27 ago | PKI + certificati (Es.30-31, Q26-29)                                |
| 23     | 28 ago | IPSec/TLS + Anonymity + Software Security (Es.32-33, Q30-40)        |
| 24     | 29 ago | Firewall + IDS (Es.34-35, Q41-42) + tutte le 42 domande a voce alta |

---

## FASE 3 — Simulazione (Giorni 25-27)

### Giorno 25 · 30 ago — Simulazione esame completa
- [ ] 2-3 ore, niente slide, niente appunti
- [ ] 15 domande a caso + 5 esercizi a caso → correggi e segna i punti deboli

### Giorno 26 · 31 ago — Solo i punti deboli
- [ ] Intera giornata sugli argomenti dove ti sei bloccato
- [ ] Seconda simulazione parziale sulle aree deboli

### Giorno 27 · 1 set — Revisione finale leggera
- [ ] Scorri il foglio di formule
- [ ] 42 domande a voce, 1 minuto l'una
- [ ] **Smetti nel pomeriggio**

### Giorni 28-31 · 2-5 set — Buffer libero 🎉
Hai 4 giorni di riserva prima dell'esame. Usali per riposo, ripasso leggerissimo, o recupero se qualcosa è andato storto.

---

# Quale piano scegliere?

| | Piano A (31 gg) | Piano B (27 gg) |
|---|---|---|
| Ritmo | Disteso, 1 argomento/giorno | Leggermente più intenso |
| Buffer pre-esame | 1 giorno (5 set) | 4 giorni (2-5 set) |
| Consigliato se... | Vuoi capire senza fretta | Preferisci più buffer finale |
| Rischio | Basso | Basso (gli accorpamenti sono tutti su sezioni leggere) |

Entrambi i piani sono fattibili. La differenza concreta è dove preferisci avere il margine: distribuito durante il mese o concentrato alla fine.
