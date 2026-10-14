#!/usr/bin/env bash
# Usage: ./render.sh reference.mp4 vo_hook1.wav logo.png KF1013-1_H1.mp4
# Recadre la ref en 4:5 1080x1350, remplace l'audio par la nouvelle VO,
# pose le logo Amazon officiel (x=90,y=105, 240x90 max) + overlay bannière/disclaimer.
set -euo pipefail
REF=$1; VO=$2; LOGO=$3; OUT=$4
ffmpeg -y -i "$REF" -i "$VO" -i "$LOGO" -i overlay_banner_disclaimer_4x5.png -filter_complex "\
[0:v]scale=1080:1350:force_original_aspect_ratio=increase,crop=1080:1350,setsar=1[v];\
[2:v]scale=240:90:force_original_aspect_ratio=decrease[logo];\
[v][3:v]overlay=0:0[v1];[v1][logo]overlay=90+(240-w)/2:105+(90-h)/2[out]" \
-map "[out]" -map 1:a -shortest -c:v libx264 -crf 20 -preset slow -pix_fmt yuv420p \
-c:a aac -b:a 192k -movflags +faststart "$OUT"
ls -lh "$OUT"
