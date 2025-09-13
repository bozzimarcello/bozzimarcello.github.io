---
layout: post
title: "Realtà Virtuale per l'apprendimento con Unity"
date:   2024-07-13 16:30:00 +0200
categories: vr coding unity
---

La Realtà Virtuale (VR) e la Realtà Aumentata (AR) rappresentano una frontiera di eccezionale interesse per la didattica, in particolare per le discipline STEM. Queste tecnologie permettono di trasporre concetti astratti in esperienze immersive e interattive, offrendo agli studenti la possibilità di visualizzare strutture molecolari complesse, esplorare modelli fisici o simulare esperimenti in un ambiente controllato e sicuro.

Questo articolo delinea un percorso introduttivo allo sviluppo di semplici esperienze VR utilizzando Unity, un motore di sviluppo versatile e potente, pensato per docenti che desiderano integrare questa tecnologia nella propria cassetta degli attrezzi.

### Lo strumento: perché Unity?

La scelta di un ambiente di sviluppo è il primo passo fondamentale. Sebbene esistano diverse alternative, **Unity** si distingue per una serie di ragioni strategiche:

* **Ecosistema e Community:** Dispone di una community vasta e matura e di un ecosistema di risorse (documentazione, forum, asset pronti all'uso) difficilmente eguagliabile.
* **Curva di apprendimento:** Presenta una curva di apprendimento più accessibile rispetto ad altri motori di gioco, rendendolo ideale per un contesto formativo.
* **Linguaggio di scripting:** Utilizza **C#**, un linguaggio moderno e strutturato, ampiamente diffuso e didatticamente valido.
* **Applicazioni consolidate:** È una piattaforma rodata, utilizzata per lo sviluppo di applicativi celebri come *Among Us* e per soluzioni professionali in ambito industriale, come i simulatori realizzati da **Volvo**.

Il suo principale concorrente, Unreal Engine, pur offrendo un impatto visivo notevole, si basa su C++, un linguaggio mediamente più complesso per chi si approccia alla programmazione da zero.

### Un percorso formativo di riferimento: Create with VR

Unity stesso offre un percorso formativo ufficiale, gratuito e di alta qualità, denominato **Create with VR**, che costituisce una base di partenza eccellente.

**Link al corso:** [https://learn.unity.com/course/create-with-vr](https://learn.unity.com/course/create-with-vr)

Questo corso è particolarmente valido per diversi motivi:
- Le istruzioni fornite sono testate e funzionanti.
- I contenuti sono disponibili sia in formato video che testuale.
- Vengono forniti tutti i materiali e gli asset necessari per completare i progetti.
- Include un simulatore che permette di sviluppare e testare le applicazioni anche in assenza di un visore VR.

Esiste inoltre un'espansione, **Create with VR for Educators**, che arricchisce il percorso con spunti pedagogici e metodologici forniti da altri docenti.

**Risorse aggiuntive per formatori:**
- **Portale Unity per Educatori:** [https://learn.unity.com/educators](https://learn.unity.com/educators)
- **Community Unity per Insegnanti (EN):** [https://www.facebook.com/groups/unityteachcommunity](https://www.facebook.com/groups/unityteachcommunity)

### Configurazione dell'ambiente di sviluppo

Per iniziare, è necessario predisporre correttamente l'ambiente di lavoro.

1.  **Versioni software:** L'ambiente di riferimento per questo percorso è la versione **Unity 2022.3.x LTS (Long Term Support)**. Durante l'installazione tramite Unity Hub, è indispensabile includere il modulo **Android Build Support**, necessario per la compilazione di applicazioni per i visori standalone (come la serie Meta Quest).
2.  **Account e Strumenti:**
    * Creare un account su [unity.com](https://unity.com/).
    * Creare un account su [github.com](https://github.com/) e configurare un sistema di controllo di versione (Git) sulla propria macchina.
    * Installare Unity Hub e da lì l'editor Unity nella versione specificata.
    * Installare il software di gestione del proprio visore VR (es. Oculus App per PC).

### Impostazione del progetto iniziale

Il corso "Create with VR" fornisce un progetto template che funge da base di partenza.

* **Progetto iniziale (2022 LTS):** [Download Link](https://unity-connect-prd.storage.googleapis.com/20240215/d39c8bf6-4913-43da-80a7-137b06275884/Create-with-VR_2022LTS.zip)
* **Riferimento comandi simulatore:** [Keyboard Shortcuts PDF](https://unity-connect-prd.storage.googleapis.com/20210604/28db6ca9-aba1-4ac3-a15a-24664daff3ea/Rig%20Simulator%20Keyboard%20Shortcuts.pdf)

I passi operativi per la configurazione sono i seguenti:
1.  Creare un repository Git per il progetto.
2.  Scaricare e decomprimere il progetto iniziale all'interno della cartella del repository.
3.  Aprire il progetto tramite Unity Hub.
4.  Esplorare la struttura del progetto, notando le configurazioni specifiche per la VR.
5.  Procedere con le prime modifiche guidate dal corso, come l'aggiunta di elementi di arredo e l'implementazione di meccaniche base di rotazione (`Snap Turn`) e spostamento (`Teleport`).

### Anatomia di un progetto VR in Unity

Un progetto Unity per la VR si basa su un insieme di pacchetti e componenti specifici, gestiti principalmente tramite l'**XR Interaction Toolkit (XRI)**. Di seguito sono elencati gli elementi fondamentali.

#### Packages
* **OpenXR Plugin:** Lo standard industriale che garantisce la compatibilità del progetto con un'ampia gamma di visori VR.
* **Universal Render Pipeline (URP):** Gestisce il rendering grafico in modo ottimizzato per performance elevate su diverse piattaforme.
* **XR Plugin Management:** Permette di configurare quali sistemi VR (es. Oculus, SteamVR) devono essere supportati dal progetto.
* **XR Interaction Toolkit:** Il framework centrale che fornisce componenti pre-costruiti per gestire interazioni come afferrare oggetti, teletrasportarsi, interagire con interfacce utente e molto altro.

#### GameObjects essenziali
* **XR Rig:** Il GameObject che rappresenta il giocatore all'interno della scena virtuale. Contiene le camere (testa) e i controller (mani).
* **Input Action Manager:** Gestisce la mappatura degli input fisici (pulsanti, joystick) alle azioni logiche definite nel progetto.
* **XR Interaction Manager:** Il componente singleton che orchestra tutte le interazioni tra l'utente e gli oggetti interattivi nella scena.

#### Componenti di interazione (da aggiungere ai GameObjects)
* **Locomotion System:** Aggiunto all'XR Rig, abilita e gestisce i sistemi di movimento.
* **Snap Turn Provider / Continuous Turn Provider:** Componenti per implementare la rotazione del punto di vista, a scatti o continua.
* **Teleportation Provider:** Abilita la meccanica del teletrasporto.
* **Teleportation Area / Anchor:** Definiscono le superfici e i punti specifici su cui è possibile teletrasportarsi.
* **XR Grab Interactable:** Rende un oggetto afferrabile dalle mani del giocatore.
* **XR Socket Interactor:** Crea un "alloggiamento" in cui un oggetto afferrabile può essere inserito, attivando una specifica reazione.

Affrontare lo sviluppo in VR con Unity apre a scenari didattici di grande impatto. Sebbene l'argomento sia vasto, le risorse disponibili e la strutturazione della piattaforma consentono di approcciare questo mondo in modo progressivo e metodico, costruendo competenze solide da poter poi reinvestire in progetti didattici sempre più ambiziosi.