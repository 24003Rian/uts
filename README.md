# RuangKuis

Aplikasi kuis pilihan ganda sederhana untuk menguji wawasan seputar Flutter.
Pemain memasukkan nama, menjawab hingga tiga puluh pertanyaan, lalu melihat skor dan
persentase hasilnya.

## Identitas Mahasiswa

- Nama: **Rian Ansari**
- NIM: **241401003**
- Lab: **pmob6**

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
| <img width="770" height="1570" alt="image" src="https://github.com/user-attachments/assets/0f2e2c80-63ac-43e1-9676-2a3451db0d00" />
| <img width="770" height="1570" alt="image" src="https://github.com/user-attachments/assets/bb57ed6d-5758-4b3f-a378-e184a8c7b2b6" />
 | <img width="770" height="1570" alt="image" src="https://github.com/user-attachments/assets/2fe47bba-f316-4d40-8f96-76c087303930" />
 



