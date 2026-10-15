#!/usr/bin/env bash
# Usage: ./render.sh reference.mp4 vo_hook1.wav KF1013-1_H1.mp4
# Recadre la ref en 4:5 1080x1350, remplace l'audio par la nouvelle VO,
# pose l overlay complet (bannière Amazon avec logo + disclaimer).
set -euo pipefail
REF=$1; VO=$2; OUT=$3
ffmpeg -y -i "$REF" -i "$VO" -i overlay_banner_disclaimer_4x5.png -filter_complex "\
[0:v]scale=1080:1350:force_original_aspect_ratio=increase,crop=1080:1350,setsar=1[v];\
[v][2:v]overlay=0:0[out]" \
-map "[out]" -map 1:a -shortest -c:v libx264 -crf 20 -preset slow -pix_fmt yuv420p \
-c:a aac -b:a 192k -movflags +faststart "$OUT"
ls -lh "$OUT"
