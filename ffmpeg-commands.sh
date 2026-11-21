#!/bin/sh
# ffmpeg-commands.sh — potong & render klip "13 TAHUN NUNGGU GTA 6" (30 detik, 1080x1920).
# TEMPLATE: isi dulu variabel di bawah setelah menemukan adegan di file trailer.
# Butuh: ffmpeg. Jalankan dari folder yang berisi file trailer + script.md.
# TIDAK ada file video di repo ini — trailer diunduh sendiri dari kanal YouTube resmi Rockstar Games.
set -e

# --- ISI DULU (contoh format detik: 12.5) ---
TRAILER2="gta6-trailer2.mp4"   # Trailer 2 GTA VI (Rockstar Games, YouTube resmi)
TRAILER1="gta6-trailer1.mp4"   # Trailer 1 GTA VI
VOICEOVER="voiceover.m4a"      # Rekaman voiceover sesuai script.md (opsional kalau pakai TTS)
MUSIC="music.m4a"              # Musik bebas lisensi (YouTube Audio Library)

# Timecode adegan (detik di file trailer) — DIVERIFIKASI dari frame (contact sheet + strip 1fps + scene detection), 21 Nov 2026:
# A kiri  = GTA V trailer 11.6-16.6 (palem + skyline Los Santos; crop tepi kiri; 5.0s -> 6s)
# A kanan = GTA VI Trailer 1 11.0-17.0 (aerial pantai Vice City, 6s)
# B = Trailer 2 39.0-41.0 (pantai Vice City ramai, bench press)
# C = Trailer 2 127.0-129.0 (Ocean Drive neon malam)
# D = Trailer 2 64.0-66.0 (Lucia keluar penjara + Jason menjemput)
# E = Trailer 2 35.2-37.2 (jalanan Leonida siang, highway + pesawat)
# MID = Trailer 2 45.2-50.0 (driving mural street, 4.8s -> slow-mo 7s; tiga kartu teks)
# F = Trailer 2 38.5-41.5 (pantai bench press, 3.0s -> slow-mo 7s; bookend dengan B)
# CATATAN: template ini TIDAK dipakai untuk render final karena (1) concat-nya hanya 23 detik
# (segmen MID 0:16-0:23 tidak ada) dan (2) hook lavfi default 25fps. Render final memakai
# production/build.sh (perbaikan di atas + split-screen A + VO + bed audio). Hasil terverifikasi:
# gta6-13-tahun-short.mp4 — 30.000 detik, 1080x1920, 30fps, H.264+AAC, ~17,7 MB.
A1_START=11.6 A1_END=16.6
A2_START=11.0 A2_END=17.0
B_START=39.0 B_END=41.0
C_START=127.0 C_END=129.0
D_START=64.0 D_END=66.0
E_START=35.2 E_END=37.2
MID_START=45.2 MID_END=50.0
F_START=38.5 F_END=41.5

# --- Potong tiap segmen jadi vertikal 1080x1920 ---
# (crop tengah 9:16 dari 16:9, scale ke 1080x1920, 30fps)
cut() { # $1=input $2=start $3=dur $4=out
  ffmpeg -y -loglevel error -ss "$2" -i "$1" -t "$3" \
    -vf "crop=ih*9/16:ih,scale=1080:1920,fps=30,format=yuv420p" \
    -an -c:v libx264 -preset medium -crf 20 "$4"
}
cut "$TRAILER1" "$A1_START" 6 seg_a.mp4
cut "$TRAILER2" "$B_START" 2 seg_b.mp4
cut "$TRAILER2" "$C_START" 2 seg_c.mp4
cut "$TRAILER2" "$D_START" 2 seg_d.mp4
cut "$TRAILER2" "$E_START" 2 seg_e.mp4
cut "$TRAILER2" "$F_START" 7 seg_f.mp4

# --- Hook 0:00-0:02: layar hitam + teks (dibuat dari gambar diam) ---
ffmpeg -y -loglevel error -f lavfi -i color=c=black:s=1080x1920:d=2 \
  -vf "drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf:text='13 TAHUN.':fontsize=160:fontcolor=white:x=(w-text_w)/2:y=(h-text_h)/2-80,drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf:text='GTA 6 AKHIRNYA...':fontsize=72:fontcolor=white:x=(w-text_w)/2:y=(h-text_h)/2+100,format=yuv420p" \
  -c:v libx264 -preset medium -crf 20 seg_hook.mp4

# --- Gabung: hook(2) + A(6) + B-E(8) + pitch-teks di F(7) + ... = 30 detik ---
# Teks on-screen untuk segmen A dan F dibakar di sini (posisi y aman dari judul Shorts):
ffmpeg -y -loglevel error -i seg_f.mp4 \
  -vf "drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf:text='SAMBIL NUNGGU, AI GUE KERJA.':fontsize=64:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=h*0.30,drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf:text='make.fun - \$500 BOUNTY':fontsize=56:fontcolor=yellow:borderw=3:bordercolor=black:x=(w-text_w)/2:y=h*0.38,format=yuv420p" \
  -c:v libx264 -preset medium -crf 20 seg_f_text.mp4
printf "file 'seg_hook.mp4'\nfile 'seg_a.mp4'\nfile 'seg_b.mp4'\nfile 'seg_c.mp4'\nfile 'seg_d.mp4'\nfile 'seg_e.mp4'\nfile 'seg_f_text.mp4'\n" > concat.txt
ffmpeg -y -loglevel error -f concat -safe 0 -i concat.txt -c copy clip_novoice.mp4

# --- Campur voiceover + musik, hasil akhir ---
ffmpeg -y -loglevel error -i clip_novoice.mp4 -i "$VOICEOVER" -i "$MUSIC" \
  -filter_complex "[1:a]volume=1.0[vo];[2:a]volume=0.25[mu];[vo][mu]amix=inputs=2:duration=first[a]" \
  -map 0:v -map "[a]" -c:v copy -c:a aac -shortest gta6-13-tahun-short.mp4

echo "HASIL: gta6-13-tahun-short.mp4 (cek durasi 30 detik, 1080x1920, teks terbaca di HP)"
ffprobe -v error -show_entries format=duration -show_entries stream=width,height,r_frame_rate -of default=noprint_wrappers=1 gta6-13-tahun-short.mp4
