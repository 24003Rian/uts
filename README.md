# RuangKuis

Aplikasi kuis pilihan ganda sederhana untuk menguji wawasan seputar Flutter.
Pemain memasukkan nama, menjawab enam pertanyaan, lalu melihat skor dan
persentase hasilnya.

## Identitas Mahasiswa

- Nama: **Isi nama**
- NIM: **Isi NIM**
- Lab: **Isi lab**

## Fitur

- Halaman awal untuk memasukkan dan memvalidasi nama pemain.
- Halaman pilihan mode setelah nama dimasukkan: kuis santai atau kuis dengan
  timer total 15, 30, 60, atau 120 detik untuk menyelesaikan seluruh soal.
- Kuis pilihan ganda dengan indikator progres dan pilihan jawaban yang dapat
  diubah sebelum dilanjutkan.
- Kuis bertimer menampilkan jawaban soal aktif dengan animasi pop saat waktu
  total habis, lalu membuka halaman hasil.
- Perpindahan antarsoal menggunakan animasi reveal bergelombang yang lembut
  tanpa mengatur ulang waktu total.
- Progres dan jawaban disimpan dalam `QuizProvider` selama sesi aplikasi.
- Halaman hasil menampilkan skor, persentase, dan ringkasan benar/salah.
- Tombol untuk memulai sesi baru.
- Tata letak responsif untuk ponsel dan tablet.
- Visual konsisten dengan latar netral, aksen biru, kartu jawaban yang jelas,
  indikator progres, dan layar hasil yang mudah dibaca.
- Ilustrasi PNG dan font Manrope lokal di folder `assets/`, sehingga aplikasi
  tidak perlu mengunduh font dari internet saat dijalankan.
- Ikon Material Design.

## Menjalankan Aplikasi

```bash
flutter pub get
flutter run
```

## Struktur Utama

- `lib/models/`: model pertanyaan dan data kuis lokal.
- `lib/providers/`: state sesi dan jawaban kuis.
- `lib/screens/`: halaman nama, pilihan mode, kuis, dan hasil.
- `lib/widgets/`: komponen UI yang digunakan ulang.
- `assets/images/`: ilustrasi kartu kuis, doodle otak, dan badge menang/kalah.
- `assets/fonts/`: font variabel Manrope beserta lisensi SIL Open Font License.

## Kredit Aset

- Ikon: [Material Symbols / Material Design](https://fonts.google.com/icons),
  digunakan melalui ikon bawaan Flutter.
- Font: [Manrope oleh Mikhail Sharanda](https://fonts.google.com/specimen/Manrope),
  disertakan lokal di `assets/fonts/Manrope-Variable.ttf` dengan lisensi SIL
  Open Font License (`assets/fonts/OFL.txt`).
- Ilustrasi PNG: dibuat khusus untuk aplikasi dan disimpan di `assets/images/`.

## Dokumentasi

### Screenshot

Tambahkan screenshot aplikasi setelah dijalankan:

| Beranda | Kuis | Hasil |
| --- | --- | --- |
| `docs/screenshots/home.png` | `docs/screenshots/quiz.png` | `docs/screenshots/result.png` |

### Mockup / Prototype

- Link: **Tambahkan tautan Figma atau prototype di sini**

## Rencana Demo Presentasi (5 Menit)

1. **0:00–0:45** — Perkenalkan tujuan dan tampilan halaman beranda.
2. **0:45–1:30** — Masukkan nama, pilih mode kuis, lalu mulai.
3. **1:30–3:00** — Jawab beberapa soal dan perlihatkan progres serta pilihan
   yang tetap tersimpan saat berpindah halaman atau orientasi.
4. **3:00–3:45** — Selesaikan kuis dan jelaskan skor pada halaman hasil.
5. **3:45–5:00** — Tunjukkan layout di ukuran layar berbeda dan jelaskan struktur
   model, provider, screen, serta reusable widget.
