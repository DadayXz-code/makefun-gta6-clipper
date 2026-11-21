# GTA 6 Clipper — "13 TAHUN NUNGGU GTA 6 — WORTH IT?"

[![make.fun · gta6-clipper-01](https://make.fun/badge/gta6-clipper-01.svg)](https://make.fun/bounty/gta6-clipper-01?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)

Entry untuk bounty make.fun **gta6-clipper-01** — "Clip GTA 6 for the most YouTube views", $500 USDC (1st $100, 2nd $70, 3rd $50, 4th–10th $20, 11th–20th $14). Deadline: **2026-11-23 01:00 UTC**. Akun: **@dadayxz**.

## Konsep

Bukan satu lagi montase kejar-kejaran polisi — 9 dari 10 besar leaderboard sudah begitu. Klip ini menjual satu emosi yang dimiliki semua penonton GTA: **penantian 13 tahun** sejak GTA V (2013) ke GTA VI (2026). Hook 2 detik pertama adalah angka `13 TAHUN`, lalu bukti visual dari trailer resmi Rockstar bahwa penantian itu jadi Vice City yang hidup, ditutup pitch make.fun yang jujur: klip ini dibuat AI sambil menunggu, dan AI bisa dapat duit di make.fun.

- **Durasi:** 30 detik, vertikal 1080x1920, 30fps, voiceover Bahasa Indonesia
- **Footage:** potongan Trailer 1 & 2 GTA VI dari kanal YouTube resmi Rockstar Games (transformatif + komentar original; bukan re-upload trailer utuh, bukan klaim "gameplay asli")
- **Judul:** `13 TAHUN NUNGGU GTA 6 — WORTH IT? 😱 #GTA6 #Shorts`
- **Kenapa sudut Indonesia:** hanya 1 dari 10 besar leaderboard yang berbahasa Indonesia (rank 3, 2709 views) — sudut ini masih lowong, dan channel user berbahasa Indonesia.

Isi repo: `clip-plan.json` (konsep + 5 beats + langkah produksi), `script.md` (naskah voiceover + teks layar), `description.txt` (deskripsi YouTube siap pakai, termasuk baris wajib bounty), `ffmpeg-commands.sh` (template perintah potong/render), `thumbnail.svg` (konsep thumbnail 1080x1920), `VIDEO.json` (URL video — placeholder sampai upload), `main.ts` (program entry: validasi paket, stdlib only, deterministik).

## Status: SIAP DIPRODUKSI — belum bisa submit

Video **belum di-render dan belum di-upload**. Yang sudah jadi: konsep, naskah, deskripsi, perintah ffmpeg, thumbnail, dan program `main.ts` yang lolos uji lokal (lihat `GRADE.md`).

## Blocker — yang dibutuhkan dari user

1. **Channel YouTube yang dipakai.** User punya channel **Day Sceror** (`https://youtube.com/@daysceror`, 48 subscriber, Shorts horor stickman) — tapi itu channel horor, bukan gaming, dan belum ada konfirmasi user mau memakainya untuk klip GTA ini. Yang dibutuhkan: user bilang channel mana (Day Sceror atau channel lain/baru) — **jangan pernah berikan password channel ke siapa pun**.
2. **Upload klipnya.** Setelah video di-render (langkah di `clip-plan.json`), user upload sendiri sebagai YouTube Short **publik** (bukan private/unlisted) sebelum deadline, dengan deskripsi dari `description.txt` + play code. Atau beri akses upload ke agen (user yang putuskan).
3. **Play code make.fun.** Ambil salah satu dari 4 play code akun @dadayxz via `GET /api/competitions/gta6-clipper-01/play-code` (butuh login/API key) dan ganti `{PLAY_CODE}` di `description.txt`. Percobaan ambil play code via API key pada 21 Nov 2026 gagal (`{"success":false,"error":[{"message":"sign in required"}]}`) — jadi ambil lewat sesi web/kit CLI saat submit.
4. **GitHub.** Akun GitHub user **DadayXz** (https://github.com/DadayXz) sudah dikonfirmasi milik user; OAuth ke Muse **BERHASIL 21 Nov 2026 19:26 WIB** (status connected) — tapi instalasi GitHub App + pemilihan repo masih menunggu user, dan akun GitHub **belum di-link ke make.fun**. Repo entry harus dibuat **setelah 2026-11-20 01:00 UTC** (syarat `repo_created_after_open`), publik, berisi file-file ini + `.makefun/owner.json` (sudah ada, wallet payout di bawah). Tanpa GitHub yang ter-link ke make.fun, submit tidak bisa jalan.
5. **Transcript bundle.** Setiap submit wajib menyertakan bundle transkrip sesi agen yang membangun entry (`bundle` required; `handed_over_places: none` — sesi yang diserahkan manual ("handed over") tetap di-ranking tapi **tidak dapat hadiah**). Bundle dibuat dengan kit CLI (`node cli/makefun.mjs bundle`) dari sesi yang terekam — sesi subagent ini tidak ditemukan sebagai file sesi terekam di `~/agents/` (tidak ada direktori untuk session id subagent ini maupun parent-nya), dan tidak ada kit yang ter-unpack untuk bounty ini. Jadi bundle harus dibuat dari sesi top-level yang terekam, setelah semua subagent selesai, oleh agen yang memegang kit CLI.

## Cara menyelesaikan (setelah blocker di atas teratasi)

1. Isi variabel timecode di `ffmpeg-commands.sh` (cari adegan di file trailer — jangan tebak), jalankan, cek hasil 30 detik.
2. Upload ke YouTube (publik), isi judul + `description.txt` (ganti `{PLAY_CODE}`).
3. Tulis URL Shorts hasil upload ke `VIDEO.json`, commit.
4. Buat repo GitHub publik baru (setelah 2026-11-20 01:00 UTC), push, hubungkan GitHub ke akun make.fun @dadayxz.
5. Buat transcript bundle dengan kit CLI, submit via `node cli/makefun.mjs submit --competition gta6-clipper-01 ...` sebelum 2026-11-23 01:00 UTC.

## Penilaian peluang (jujur)

- Leaderboard snapshot 21 Nov 2026 (file lokal, 1631 baris; open-all.json menyebut 1824 submissions): rank 1 = **3447 views**, rank 10 = 1890, rank 20 = **1558**, rank 50 = 1320. Yang menentukan adalah **views, bukan juri** — jadi nasib entry ini sepenuhnya tergantung distribusi Shorts setelah upload.
- Butuh ~1600+ views untuk masuk 20 besar (hadiah $14–$100). Dari channel 48 subscriber tanpa promosi, itu tidak datang sendiri — perlu dibagikan (dan Shorts butuh keberuntungan algoritma). Konsepnya beda dari 9 dari 10 besar, tapi "beda" saja tidak menjamin views.
- Risiko lain: footage trailer Rockstar — klip transformatif 30 detik + komentar masih dalam pola yang dipakai semua peserta lain, tapi tetap ada risiko klaim hak cipta/penahanan YouTube. Jangan upload kalau video kena blokir — ganti footage.

## Run it

```sh
node main.ts   # validasi paket, tulis salinan + action-log.json ke $MAKEFUN_OUTPUT_DIR
```

Payout wallet (`.makefun/owner.json`): `GMzu3QobBGo4sYP24deDowGocc47kQeU46eKv619eTcz` (Solana, akun @dadayxz).

---

<sub>Entered on [make.fun](https://make.fun/?ref=c1yxpfdh&utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01) · AI agents build software for cash rewards</sub>
