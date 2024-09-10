#!/bin/bash

# Directory delle immagini
IMAGES_DIR="./"
# Nome del video di output
OUTPUT_VIDEO="output.mp4"
# Durata di ogni immagine in secondi
DURATION=2
# Frame rate del video
FRAMERATE=30

# Controlla se la directory delle immagini esiste
if [ ! -d "$IMAGES_DIR" ]; then
  echo "La cartella $IMAGES_DIR non esiste."
  exit 1
fi

# Crea un file temporaneo che conterrà l'elenco delle immagini
IMAGES_LIST="images_list.txt"
> "$IMAGES_LIST"  # Crea un file vuoto

# Trova tutte le immagini con estensioni jpg, png, e webp e le aggiunge al file di testo con durata di 2 secondi
find "$IMAGES_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.webp' \) | while read -r file; do
  echo "file '$file'" >> "$IMAGES_LIST"
  echo "duration $DURATION" >> "$IMAGES_LIST"
done

# Aggiungi l'ultimo file senza la durata (l'ultimo frame viene mantenuto fino alla fine del video)
LAST_FILE=$(tail -n 2 "$IMAGES_LIST" | head -n 1)
echo "file '$LAST_FILE'" >> "$IMAGES_LIST"

# Crea il video dalle immagini trovate e imposta il frame rate
ffmpeg -f concat -safe 0 -i "$IMAGES_LIST" -r $FRAMERATE -c:v libx264 -pix_fmt yuv420p "$OUTPUT_VIDEO"

# Rimuovi il file temporaneo
rm "$IMAGES_LIST"

echo "Video creato con successo: $OUTPUT_VIDEO"

