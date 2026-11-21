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

# Timecode adegan (detik di file trailer) — CARI DULU di trailer, jangan tebak:
# A = split 2013 vs 2026 (Trailer 1, suasana Los Santos / Trailer 2, Vice City)
# B..E = 4 adegan montase Trailer 2 (pantai, Ocean Drive neon, Lucia keluar penjara,
#         Jason menjemput, jalanan Leonida) — masing-masing ~2 detik
# F = satu shot tenang pantai untuk pitch make.fun di 0:23-0:30 (~7 detik)
A1_START=0 A1_END=0
B_START=0 B_END=0
C_START=0 C_END=0
D_START=0 D_END=0
E_START=0 E_END=0
F_START=0 F_END=0

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
