# Sito personale di Marcello Bozzi

Sorgenti del sito <https://marcellobozzi.it>.

Il sito è un progetto [Jekyll](https://jekyllrb.com/) statico, pubblicato con
GitHub Pages e servito sul dominio personalizzato `marcellobozzi.it` (file
`CNAME`).

## Come funziona

Jekyll legge i sorgenti e genera un sito di file HTML statici. I punti chiave:

- La configurazione globale è in `_config.yml` (titolo, email, descrizione,
  tema `minima`, plugin e collezioni).
- I **post** del blog vivono in `_posts/` e vengono raccolti automaticamente da
  Jekyll nell'array `site.posts`, ordinato dal più recente.
- La home (`index.md`) usa `layout: home`: il layout del tema `minima` stampa il
  contenuto di `index.md` e poi l'elenco dei post. È per questo che `index.md`
  non contiene alcun riferimento esplicito agli articoli.
- Le **lezioni** sono una *collection* Jekyll (`apprendimento`), definita in
  `_config.yml`, quindi NON compaiono nella navigazione né nella home finché
  non vengono linkate esplicitamente.
- Le immagini del sito e le slide dei corsi sono in `img/` e `slides/`; i
  materiali delle lezioni (immagini, PDF) sono in `assets/apprendimento/`.
- Il footer con la licenza Creative Commons è sovrascritto in
  `_includes/footer.html`.

### Struttura del repository

```
_config.yml            configurazione del sito (tema, plugin, collezioni)
index.md               home page
curriculum.md          pagina del Curriculum Vitae
404.html               pagina di errore
CNAME                  dominio personalizzato (marcellobozzi.it)
_includes/footer.html  override del footer del tema
_posts/                articoli del blog
_apprendimento/        lezioni (collection)
assets/apprendimento/  materiali delle lezioni (immagini, PDF)
img/                   immagini del sito
slides/                PDF delle slide dei corsi
dockerfile             immagine di sviluppo (Ruby + Jekyll)
.devcontainer/         configurazione VS Code Dev Containers
```

### Pubblicazione

Il repository è del tipo `<utente>.github.io`: ogni push sul branch `main`
viene compilato e pubblicato automaticamente da GitHub Pages. Non serve un passo
di build manuale.

## Sviluppo in locale

Con Ruby installato:

```bash
bundle install
bundle exec jekyll serve
```

Il sito sarà su <http://localhost:4000>.

In alternativa, aprire il progetto con VS Code e "Reopen in Container": il
`devcontainer` costruisce l'immagine dal `dockerfile`, poi eseguire gli stessi
comandi (`bundle install` e `bundle exec jekyll serve`).

## Aggiungere un post

1. Creare un file in `_posts/` con nome `AAAA-MM-GG-titolo-breve.markdown`
   (es. `2026-01-15-nuovo-articolo.markdown`).
2. Aggiungere il front matter:

   ```markdown
   ---
   layout: post
   title: "Il titolo dell'articolo"
   date: 2026-01-15 16:30:00 +0200
   categories: categoria1 categoria2
   ---

   Testo dell'articolo...
   ```

3. Salvare, committare e pushare. Il post apparirà automaticamente nell'elenco
   della home, con URL del tipo `/2026/01/15/nuovo-articolo/`.

Le immagini del post possono essere messe in `img/` e referenziate con
`![descrizione](/img/nome-file.jpg)`.

## Aggiungere una lezione

Le lezioni sono raccolte nella collection `apprendimento` con permalink
`/apprendimento/:path/`. Il percorso del file determina l'URL.

1. Creare il file in `_apprendimento/<argomento>/<slug>.md`
   (es. `_apprendimento/database/01-introduzione.md`).
   Usare nomi in minuscolo e senza spazi: GitHub Pages è case-sensitive.
2. Aggiungere il front matter:

   ```markdown
   ---
   layout: page
   title: "01 Introduzione"
   argomento: Database
   description: "Breve descrizione della lezione."
   assets: /assets/apprendimento/database/01-introduzione
   ---

   Contenuto della lezione...
   ```

3. L'URL sarà `/apprendimento/database/01-introduzione/`.

Per impostazione predefinita la lezione NON è linkata da nessuna parte e non
compare in navigazione: è raggiungibile solo conoscendone l'URL. Per renderla
visibile basta aggiungere i link (es. nella home o in una pagina indice), senza
spostare o rinominare alcun file.

### Materiali di una lezione

Le immagini e i PDF di una lezione vanno in una cartella che rispecchia il
percorso della lezione:

```
assets/apprendimento/<argomento>/<slug>/
```

Referenziarli nel Markdown usando la variabile definita nel front matter
(`assets`), così non si ripete il percorso:

```markdown
![Schema entità-relazione]({{ page.assets }}/schema-er.png)

[Scarica gli esercizi (PDF)]({{ page.assets }}/esercizi.pdf)
```

### Attenzione agli URL

Gli URL delle lezioni sono stabili e vengono usati per i link condivisi (es. da
Moodle). Non rinominare `argomento` o `slug` di una lezione già pubblicata:
romperebbe i link.

## Licenza

- Codice: GNU General Public License v3.0 (`LICENSE`).
- Contenuti: Creative Commons Attribuzione - Condividi allo stesso modo 4.0.
