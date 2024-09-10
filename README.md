# img2vid-slideshow
Uno script automatizzato in Bash per convertire una serie di immagini (.jpg, .png, .webp) in un video slideshow con una durata personalizzata per ciascuna immagine. Lo script utilizza FFmpeg per creare video con transizioni fluide e personalizzabili, ideale per generare presentazioni video a partire da raccolte di immagini.

Questo script Bash ha il compito di creare un video a partire da una serie di immagini (formati `.jpg`, `.png`, e `.webp`) presenti in una directory. Ogni immagine viene visualizzata per una durata di 2 secondi e viene concatenata con le altre in un unico video. Di seguito una descrizione dettagliata di come funziona ogni parte dello script:

### Descrizione dettagliata dello script:

1. **Definizione delle variabili**:
   - `IMAGES_DIR="./"`: La directory che contiene le immagini. In questo caso, viene utilizzata la directory corrente (`./`).
   - `OUTPUT_VIDEO="output.mp4"`: Nome del video di output che sarà generato dallo script.
   - `DURATION=2`: La durata (in secondi) per cui ciascuna immagine verrà mostrata nel video.
   - `FRAMERATE=30`: Il frame rate del video di output, ossia il numero di fotogrammi per secondo (FPS) del video finale.

2. **Verifica dell'esistenza della directory**:
   ```bash
   if [ ! -d "$IMAGES_DIR" ]; then
     echo "La cartella $IMAGES_DIR non esiste."
     exit 1
   fi
   ```
   Questo blocco verifica se la directory che contiene le immagini esiste. Se la directory non esiste, lo script termina con un messaggio di errore.

3. **Creazione del file temporaneo `images_list.txt`**:
   ```bash
   IMAGES_LIST="images_list.txt"
   > "$IMAGES_LIST"  # Crea un file vuoto
   ```
   Crea un file di testo vuoto chiamato `images_list.txt` che conterrà un elenco delle immagini e la loro durata per essere processato successivamente da FFmpeg.

4. **Elenco delle immagini**:
   ```bash
   find "$IMAGES_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.webp' \) | while read -r file; do
     echo "file '$file'" >> "$IMAGES_LIST"
     echo "duration $DURATION" >> "$IMAGES_LIST"
   done
   ```
   Questa parte dello script usa il comando `find` per cercare tutte le immagini nelle estensioni `.jpg`, `.png`, e `.webp` presenti nella directory specificata. Per ciascun file trovato:
   - Viene aggiunta una riga `file 'percorso_file'` al file `images_list.txt`, dove `percorso_file` è il percorso effettivo del file immagine.
   - Viene aggiunta una riga `duration 2`, che imposta la durata dell'immagine a 2 secondi.

5. **Gestione dell'ultima immagine**:
   ```bash
   LAST_FILE=$(tail -n 2 "$IMAGES_LIST" | head -n 1)
   echo "file '$LAST_FILE'" >> "$IMAGES_LIST"
   ```
   Questa parte del codice assicura che l'ultima immagine del video non abbia una durata esplicita. Alcune versioni di FFmpeg generano un errore se l'ultima immagine ha una durata specificata. Pertanto, l'ultima immagine viene aggiunta nuovamente senza l'opzione `duration`.

6. **Creazione del video con FFmpeg**:
   ```bash
   ffmpeg -f concat -safe 0 -i "$IMAGES_LIST" -r $FRAMERATE -c:v libx264 -pix_fmt yuv420p "$OUTPUT_VIDEO"
   ```
   Utilizza **FFmpeg** per concatenare le immagini in un video. Le opzioni utilizzate:
   - `-f concat`: Specifica che il file di input (`images_list.txt`) è un file di concatenazione che contiene una lista di immagini e durate.
   - `-safe 0`: Permette l'uso di percorsi non sicuri (come i percorsi assoluti o relativi).
   - `-i "$IMAGES_LIST"`: Indica che il file di input è il file `images_list.txt` creato precedentemente.
   - `-r $FRAMERATE`: Imposta il frame rate del video finale.
   - `-c:v libx264`: Utilizza il codec video H.264 per comprimere il video.
   - `-pix_fmt yuv420p`: Imposta il formato pixel del video per garantire la compatibilità con i lettori video.

7. **Rimozione del file temporaneo**:
   ```bash
   rm "$IMAGES_LIST"
   ```
   Dopo la creazione del video, lo script elimina il file temporaneo `images_list.txt` che conteneva l'elenco delle immagini e la loro durata.

8. **Messaggio di completamento**:
   ```bash
   echo "Video creato con successo: $OUTPUT_VIDEO"
   ```
   Al termine, viene visualizzato un messaggio che conferma la creazione del video e il nome del file di output.

### Cosa fa lo script:
- Lo script cerca tutte le immagini di tipo `.jpg`, `.png`, e `.webp` in una specifica directory.
- Crea un file temporaneo che contiene l'elenco delle immagini da includere nel video e la durata di ciascuna immagine (2 secondi).
- Usa **FFmpeg** per concatenare queste immagini in un video, impostando un frame rate di 30 fotogrammi al secondo.
- Dopo la creazione del video, il file temporaneo viene eliminato.

### Usi e potenzialità:
Questo script è utile per automatizzare la creazione di slideshow video a partire da una collezione di immagini. Può essere facilmente adattato modificando la directory delle immagini, la durata di visualizzazione di ogni immagine o il frame rate del video risultante.
