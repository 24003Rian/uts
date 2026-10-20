# RuangKuis

Aplikasi kuis pilihan ganda sederhana untuk menguji wawasan seputar Flutter.
Pemain memasukkan nama, menjawab enam pertanyaan, lalu melihat skor dan
persentase hasilnya.

## Identitas Mahasiswa

- Nama: **Isi nama**
- NIM: **Isi NIM**
- Lab: **Isi lab**

## Fitur

- Halaman awal dengan validasi nama pemain.
- Kuis pilihan ganda dengan indikator progres dan pilihan jawaban yang dapat
  diubah sebelum dilanjutkan.
- Progres dan jawaban disimpan dalam `QuizProvider` selama sesi aplikasi.
- Halaman hasil menampilkan skor, persentase, dan ringkasan benar/salah.
- Tombol untuk memulai sesi baru.
- Tata letak responsif untuk ponsel dan tablet.
- Ikon Material Design dan font Manrope kustom.

## Menjalankan Aplikasi

```bash
flutter pub get
flutter run
```

## Struktur Utama

- `lib/models/`: model pertanyaan dan data kuis lokal.
- `lib/providers/`: state sesi dan jawaban kuis.
- `lib/screens/`: halaman awal, kuis, dan hasil.
- `lib/widgets/`: komponen UI yang digunakan ulang.

## Kredit Aset

- Ikon: [Material Symbols / Material Design](https://fonts.google.com/icons),
  digunakan melalui ikon bawaan Flutter.
- Font: [Manrope oleh Mikhail Sharanda](https://fonts.google.com/specimen/Manrope),
  dimuat menggunakan paket `google_fonts`.
- Ilustrasi: elemen dekoratif dibuat dari komponen Flutter; tidak memakai
  gambar eksternal.

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
2. **0:45–1:30** — Masukkan nama, tunjukkan validasi, lalu mulai kuis.
3. **1:30–3:00** — Jawab beberapa soal dan perlihatkan progres serta pilihan
   yang tetap tersimpan saat berpindah halaman atau orientasi.
4. **3:00–3:45** — Selesaikan kuis dan jelaskan skor pada halaman hasil.
5. **3:45–5:00** — Tunjukkan layout di ukuran layar berbeda dan jelaskan struktur
   model, provider, screen, serta reusable widget.
