---
layout: page
title: "01 Introduzione alla progettazione delle basi di dati"
argomento: Database
description: "Prima lezione del modulo: dal problema alla progettazione concettuale di una base di dati."
assets: /assets/apprendimento/database/01-introduzione-alla-progettazione-delle-basi-di-dati
---

> **Stub di esempio.** Il contenuto di questa pagina è segnaposto: serve solo a mostrare struttura e URL. Sostituiscilo con la lezione vera.

## Obiettivi della lezione

Al termine di questa lezione saprai:

- distinguere tra **dato** e **informazione**;
- riconoscere le fasi della progettazione di una base di dati;
- descrivere il ruolo del modello concettuale.

## Che cos'è una base di dati

Una **base di dati** (o *database*) è una collezione organizzata di dati, strutturata in modo da poter essere interrogata ed aggiornata in modo efficiente e senza ridondanze.

## Le fasi della progettazione

1. **Analisi dei requisiti** — raccolta delle esigenze di chi userà il sistema.
2. **Progettazione concettuale** — rappresentazione ad alto livello, indipendente dal DBMS (es. modello Entità-Relazione).
3. **Progettazione logica** — traduzione dello schema concettuale nel modello logico (es. relazionale).
4. **Progettazione fisica** — implementazione dello schema su uno specifico DBMS.

## Esempio di concetti

| Concetto | Esempio |
| --- | --- |
| Entità | Studente |
| Attributo | Matricola |
| Associazione | Studente — frequenta — Corso |

## Esercizi

1. Elenca tre differenze tra dato e informazione.
2. Descrivi con parole tue la differenza tra schema concettuale e schema logico.

## Materiali

![Schema Entità-Relazione]({{ page.assets }}/schema-er.png)

[Scarica gli esercizi (PDF)]({{ page.assets }}/esercizi.pdf)
