# Piano di migrazione: da GitHub a OVH + Codeberg

Questo documento riassume le decisioni prese e descrive, passo per passo, come
spostare il sito da GitHub Pages a:

- **hosting statico**: piano **gratuito OVH** (dominio `marcellobozzi.it`);
- **build**: **locale**, che genera l'HTML statico in `_site/`;
- **codice sorgente**: repository su **Codeberg** (può essere privato);
- **backup**: mirror del repository su **NAS Synology** (opzionale).

---

## 1. Sommario della conversazione

### 1.1 Stato attuale del sito

- Sito statico **Jekyll 3.9** con tema `minima`, oggi pubblicato con
  **GitHub Pages** sul dominio personalizzato `marcellobozzi.it` (file `CNAME`).
- I **post** del blog stanno in `_posts/` e vengono elencati automaticamente
  dalla home (`index.md`, `layout: home`): il layout del tema scorre `site.posts`,
  quindi `index.md` non cita esplicitamente gli articoli.
- Le **lezioni** sono una *collection* Jekyll (`apprendimento`) definita in
  `_config.yml`, con permalink `/apprendimento/:path/`. Il percorso del file
  determina l'URL: `_apprendimento/database/01-introduzione.md` →
  `/apprendimento/database/01-introduzione/`.
- Le lezioni **non** sono linkate da home o navigazione: sono raggiungibili solo
  conoscendone l'URL (decisione: "unlisted", ma lasciate indicizzabili dai motori
  di ricerca).
- I **materiali** delle lezioni (immagini, PDF) stanno in
  `assets/apprendimento/<argomento>/<slug>/` e vengono referenziati con la
  variabile `{{ page.assets }}` definita nel front matter.
- `img/` contiene le immagini del sito, `slides/` i PDF dei corsi.
- Il footer con licenza Creative Commons è sovrascritto in `_includes/footer.html`.

### 1.2 Modifiche già applicate

- Corretti alcuni refusi in `curriculum.md`
  (`basi di dati`, `fundraising`, `e-Learning`, `Versioning`).
- Introdotta la collection `apprendimento` in `_config.yml`.
- Creata la lezione di esempio
  `_apprendimento/database/01-introduzione-alla-progettazione-delle-basi-di-dati.md`
  con front matter `argomento`, `description`, `assets`.
- Creata la cartella materiali
  `assets/apprendimento/database/01-introduzione-alla-progettazione-delle-basi-di-dati/`
  (popolata con `schema-er.png` ed `esercizi.pdf`).
- Riscritto `README.md` con panoramica, funzionamento e istruzioni per
  aggiungere post e lezioni.
- Aggiunto un blocco `exclude:` in `_config.yml` (incluso `README.md`).

### 1.3 Decisioni prese

- **Abbandonare completamente GitHub** per questo sito (sia hosting sia sorgente).
- **Hosting**: piano **gratuito OVH**, con possibilità futura di passare al piano
  a pagamento **Starter** (1 GB) se servirà più spazio per PDF/immagini.
- **Build**: **locale** (Docker), non serve un servizio che compili sul server.
- **Sorgente**: repository su **Codeberg**.
- **Backup**: mirror su **NAS Synology** (opzionale).
- **DNS**: il dominio è già gestito da OVH (nameserver `ns108.ovh.net` /
  `dns108.ovh.net`), attualmente i record A puntano a GitHub
  (`185.199.108-111.153`).

### 1.4 Opzioni valutate e scartate

- **Piano gratuito OVH** (scelto): 100 MB SSD, SSL gratuiti illimitati, FTP,
  traffico illimitato, 1 sito. Nessun MySQL/PHP dinamico: irrilevante per un
  sito statico.
- **OVH Eco Starter** (riserva): 1 GB SSD, ~1,59 €/mese il primo anno, 1
  database, Git (1 repo) e FTP. Utile solo se lo spazio diventa stretto.
- **Codeberg Pages** (scartato come hosting): gratuito e con build via Forgejo
  Actions, ma richiede repository **pubblico** e le condizioni d'uso sono
  orientate al software libero (non un CDN/file host). Codeberg resta comunque
  scelto come **repository del codice**.

### 1.5 Vincoli e note

- Il piano gratuito OVH offre **100 MB**: oggi il sito generato pesa ~8,4 MB,
  quindi c'è margine, ma conviene **ottimizzare le immagini** (la sola
  `schema-er.png` pesa 4,2 MB).
- OVH **non esegue Jekyll** lato server: la build va fatta in locale.
- Ruby non è installato sulla macchina Windows di sviluppo: la build avviene
  tramite **Docker** (il repository contiene già `dockerfile` e `.devcontainer`).
- I nomi dei file devono restare **minuscoli e senza spazi** (OVH è su Linux,
  case-sensitive).

---

## 2. Architettura di destinazione

```
modifica in locale
   -> build Docker: bundle exec jekyll build  ->  _site/
   -> git push     ->  Codeberg (sorgente, anche privato)
   -> sync FTP     ->  OVH  www/  ->  https://marcellobozzi.it
   -> mirror git   ->  NAS Synology (backup)
```

---

## 3. Prerequisiti

- Accesso allo **Spazio Cliente OVH** con il dominio `marcellobozzi.it`.
- Un account **Codeberg** e una chiave SSH configurata (oppure uso di HTTPS).
- **Docker Desktop** installato su Windows (in alternativa Ruby + Bundler).
- Un client FTP/SFTP. Consigliato **WinSCP** (con supporto scripting).
- (Opzionale) NAS Synology con SSH abilitato o pacchetto Git Server.

---

## 4. Fase 1 — Preparare il repository

Obiettivo: rimuovere tutto ciò che è specifico di GitHub Pages.

1. **Eliminare il file `CNAME`** (serve solo a GitHub Pages; su OVH è inutile).
2. **Creare il file `.htaccess`** per OVH (vedi Appendice A).
3. **Aggiornare `_config.yml`**:
   - verificare `url: "https://marcellobozzi.it/"` e `baseurl: ""`;
   - aggiungere `.htaccess` e i file di sviluppo all'elenco `exclude` e
     forzare l'inclusione di `.htaccess` (Jekyll esclude i file che iniziano con
     un punto). Esempio:

     ```yaml
     include:
       - .htaccess

     exclude:
       - README.md
       - MIGRATION_PLAN.md
       - LICENSE
       - Gemfile
       - Gemfile.lock
       - dockerfile
       - .devcontainer/
       - deploy/
       - node_modules/
       - vendor/bundle/
       - vendor/cache/
       - vendor/gems/
       - vendor/ruby/
     ```

4. **Creare la cartella `deploy/`** con gli script di build e sincronizzazione
   (Appendice B).
5. **Aggiornare `README.md`** nella sezione pubblicazione (oggi descrive il
   push-to-deploy di GitHub).
6. Commit locale:

   ```bash
   git add -A
   git commit -m "Preparazione migrazione a OVH: rimozione CNAME, htaccess, esclusioni"
   ```

> Nota: `MIGRATION_PLAN.md` è un documento interno, quindi va escluso dalla
> pubblicazione tramite `exclude` (come sopra).

---

## 5. Fase 2 — Spostare il repository su Codeberg

1. Su Codeberg creare un nuovo repository, ad esempio `marcellobozzi.it`,
   **privato** (Codeberg consente repository privati; non serve pubblico perché
   non useremo Codeberg Pages).
2. Aggiungere Codeberg come nuovo remote e rinominare l'attuale:

   ```bash
   git remote rename origin github
   git remote add origin git@codeberg.org:UTENTE/marcellobozzi.it.git
   ```

3. Pubblicare tutti i rami e i tag:

   ```bash
   git push -u origin main
   git push origin --tags
   ```

4. Quando tutto è verificato, rimuovere il remote GitHub:

   ```bash
   git remote remove github
   ```

5. Da questo momento `origin` punta a Codeberg e il flusso è:

   ```bash
   git add -A
   git commit -m "..."
   git push
   ```

---

## 6. Fase 3 — Build locale in HTML statico

Il repository contiene già un `dockerfile` per un'immagine Ruby + Jekyll.

1. Costruire l'immagine (una sola volta):

   ```powershell
   docker build -t jekyll-bozzi .
   ```

2. Aprire una shell nel container con il progetto montato:

   ```powershell
   docker run --rm -it -v "${PWD}:/srv/jekyll" -w /srv/jekyll -p 4000:4000 jekyll-bozzi sh
   ```

3. Dentro il container, installare le dipendenze e generare il sito:

   ```bash
   bundle install
   bundle exec jekyll build
   ```

   Il risultato finisce in `_site/`.

4. Per l'anteprima locale:

   ```bash
   bundle exec jekyll serve --host 0.0.0.0
   ```

   e aprire <http://localhost:4000>.

In alternativa (senza shell interattiva), build in un solo comando:

```powershell
docker run --rm -v "${PWD}:/srv/jekyll" -w /srv/jekyll jekyll-bozzi sh -c "bundle install && bundle exec jekyll build"
```

---

## 7. Fase 4 — Attivare l'hosting gratuito OVH

1. Nello Spazio Cliente OVH accedere a **Hosting Web** e attivare l'**hosting
   gratuito** incluso con il dominio `marcellobozzi.it`.
2. Annotare i dati di accesso **FTP** dal gestore:
   - server/host FTP (es. `ftp.clusterXXX.hosting.ovh.net`),
   - nome utente,
   - password (reimpostabile dal gestore),
   - directory web (`www`).
3. Verificare dallo Spazio Cliente che l'hosting sia associato al dominio.

---

## 8. Fase 5 — Primo caricamento

Caricare **il contenuto** di `_site/` nella directory `www` dell'hosting. Due
modi:

- **WinSCP (GUI)**: connettersi in FTP e trascinare il contenuto di `_site/`.
- **WinSCP (script)**: usare `deploy/sync.txt` (Appendice B) con
  `winscp.com /script=deploy\sync.txt`.

Prima del cambio DNS, verificare il sito tramite l'URL temporaneo fornito da OVH
o in anteprima locale.

---

## 9. Fase 6 — DNS e HTTPS

1. Nello Spazio Cliente OVH, sezione **Zona DNS** del dominio:
   - sostituire i record **A** che puntano a GitHub
     (`185.199.108.153`, `185.199.109.153`, `185.199.110.153`,
     `185.199.111.153`) con l'indirizzo dell'hosting OVH indicato dal gestore;
   - se il gestore lo richiede, aggiornare anche i record **AAAA**;
   - rimuovere eventuali record `www` che puntano a `bozzimarcello.github.io` e
     reindirizzarli all'hosting.
2. Abilitare il **certificato SSL gratuito** (Let's Encrypt) dal gestore e
   attivare il **redirect forzato a HTTPS**.
3. Attendere la propagazione del DNS e verificare:
   - `https://marcellobozzi.it/` risponde correttamente;
   - il lucchetto HTTPS è valido;
   - `/apprendimento/database/01-introduzione-alla-progettazione-delle-basi-di-dati/`
     è raggiungibile;
   - la pagina 404 personalizzata funziona.

---

## 10. Fase 7 — Dismettere GitHub Pages

Solo dopo aver verificato che il nuovo hosting funziona:

1. In GitHub, rimuovere il dominio personalizzato dalle impostazioni Pages del
   repository (il file `CNAME` è già stato eliminato).
2. (Opzionale) archiviare o eliminare il repository GitHub, ora che la sorgente
   vive su Codeberg.

---

## 11. Fase 8 — Backup su NAS Synology (opzionale)

1. Abilitare SSH sul NAS (Pannello di controllo → Terminale e SNMP).
2. Creare un mirror del repository Codeberg:

   ```bash
   mkdir -p /volume1/git
   git clone --mirror https://codeberg.org/UTENTE/marcellobozzi.it.git /volume1/git/marcellobozzi.it.git
   ```

3. Aggiornare periodicamente il mirror con un'attività pianificata (Task
   Scheduler, cadenza giornaliera):

   ```bash
   cd /volume1/git/marcellobozzi.it.git && git remote update --prune
   ```

In alternativa, eseguire il backup della cartella locale del progetto con
Hyper Backup o Active Backup for Business.

---

## 12. Fase 9 — Flusso di lavoro continuativo

1. Modificare i contenuti in locale.
2. Build: `docker run ... jekyll-bozzi sh -c "bundle install && bundle exec jekyll build"`.
3. Verifica in anteprima (`bundle exec jekyll serve`).
4. Commit e push su Codeberg:

   ```bash
   git add -A
   git commit -m "Nuova lezione"
   git push
   ```

5. Sincronizzare `_site/` verso OVH con `deploy/sync.txt`.
6. (Opzionale) il NAS aggiorna automaticamente il mirror.

---

## Appendice A — Contenuto di `.htaccess`

```apache
# Forza HTTPS
RewriteEngine On
RewriteCond %{HTTPS} !=on
RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]

# Pagina 404 personalizzata
ErrorDocument 404 /404.html

# Cache dei file statici
<IfModule mod_expires.c>
  ExpiresActive On
  ExpiresByType image/jpeg "access plus 30 days"
  ExpiresByType image/png  "access plus 30 days"
  ExpiresByType text/css   "access plus 7 days"
  ExpiresByType application/javascript "access plus 7 days"
  ExpiresByType application/pdf "access plus 7 days"
</IfModule>
```

Ricordare di forzare l'inclusione del file in `_config.yml` con
`include: [.htaccess]`, altrimenti Jekyll (che ignora i file che iniziano con
un punto) non lo copierà in `_site/`.

---

## Appendice B — Script di supporto (cartella `deploy/`)

### `deploy/build.ps1` (build locale via Docker)

```powershell
docker run --rm -v "${PWD}:/srv/jekyll" -w /srv/jekyll jekyll-bozzi `
  sh -c "bundle install && bundle exec jekyll build"
```

### `deploy/sync.txt` (script WinSCP per il mirroring su OVH)

```text
open ftp://UTENTE:PASSWORD@ftp.clusterXXX.hosting.ovh.net/
synchronize remote -delete "C:\_marcellobozzi_it\bozzimarcello.github.io\_site" /www
exit
```

Esecuzione:

```powershell
winscp.com /script=deploy\sync.txt
```

> L'opzione `-delete` rimuove dal server i file non più presenti in `_site/`,
> evitando pagine "fantasma". Conservare `sync.txt` fuori dal versionamento se
> contiene la password (oppure usare una variabile d'ambiente / sessione
> salvata di WinSCP).

### Alternativa con `lftp` (WSL/Git Bash)

```bash
lftp -e "mirror -R --delete _site /www; quit" -u UTENTE,PASSWORD ftp://ftp.clusterXXX.hosting.ovh.net
```

---

## Appendice C — Note e limiti

- **Spazio**: piano gratuito 100 MB. Il sito è ~8,4 MB; attenzione alla crescita
  di PDF e immagini. Per più spazio si può passare al piano **Starter** (1 GB)
  senza rifare la configurazione.
- **Immagini**: ottimizzare prima del commit (ridimensionare/compressione). La
  `schema-er.png` (4,2 MB) è l'esempio tipico da ridurre.
- **Dinamico**: nessun MySQL/PHP necessario; il sito è interamente statico.
- **URL stabili**: non rinominare `argomento`/`slug` delle lezioni pubblicate,
  perché gli URL sono usati nei link condivisi (es. Moodle).
- **File con spazi**: i PDF in `slides/` hanno spazi nei nomi (URL con `%20`);
  funziona ma è sconsigliato per i nuovi materiali.

---

## Appendice D — Rollback

Se dopo il cambio DNS qualcosa non funziona, si può tornare temporaneamente a
GitHub Pages:

1. ripristinare i record A del dominio agli indirizzi GitHub
   (`185.199.108.153` …);
2. ripristinare il file `CNAME` con `marcellobozzi.it` nel repository;
3. riattivare il dominio personalizzato nelle impostazioni Pages.

Mantenere il remote `github` e il repository originale finché la migrazione non è
completamente verificata.
