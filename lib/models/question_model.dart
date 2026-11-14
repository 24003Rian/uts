class Question {
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  // Membuat satu data soal beserta pilihan, jawaban benar, dan penjelasan.
  Question({
    required this.questionText,
    required this.options,
    required this.correctIndex,
    this.explanation = 'Pelajari kembali konsep ini untuk memperkuat pemahamanmu.',
  });
}

// Dummy data diletakkan di sini agar ringkas
final List<Question> dummyQuestions = [
  Question(
    questionText: 'Bahasa pemrograman yang digunakan untuk membangun aplikasi Flutter adalah ...',
    options: ['Java', 'Kotlin', 'Dart', 'Swift'],
    correctIndex: 2,
  ),
  Question(
    questionText: 'Widget mana yang tepat untuk antarmuka yang dapat berubah karena interaksi pengguna?',
    options: ['StatelessWidget', 'StatefulWidget', 'Container', 'Text'],
    correctIndex: 1,
  ),
  Question(
    questionText: 'Apa fungsi utama file pubspec.yaml dalam proyek Flutter?',
    options: [
      'Menulis logika aplikasi',
      'Menyimpan data pengguna',
      'Mengatur dependensi dan aset',
      'Menghubungkan aplikasi ke server',
    ],
    correctIndex: 2,
  ),
  Question(
    questionText:
        'Widget Flutter yang menyusun elemen secara vertikal adalah ...',
    options: ['Row', 'Column', 'Stack', 'Wrap'],
    correctIndex: 1,
  ),
  Question(
    questionText:
        'Manakah cara yang benar untuk menampilkan ikon dari Material Design?',
    options: [
      'Icon(Icons.home)',
      'Image(Icons.home)',
      'Text(Icons.home)',
      'Asset(Icons.home)',
    ],
    correctIndex: 0,
  ),
  Question(
    questionText: 'Apa kegunaan setState() pada StatefulWidget?',
    options: [
      'Menghapus halaman',
      'Meminta Flutter membangun ulang UI setelah state berubah',
      'Menambahkan dependensi',
      'Menyimpan aplikasi ke database',
    ],
    correctIndex: 1,
  ),
  Question(
    questionText: 'Widget yang digunakan sebagai titik awal struktur aplikasi Flutter adalah ...',
    options: ['MaterialApp', 'Scaffold', 'Builder', 'Navigator'],
    correctIndex: 0,
  ),
  Question(
    questionText: 'Widget yang menyediakan struktur dasar halaman Material Design adalah ...',
    options: ['Scaffold', 'Column', 'Theme', 'SafeArea'],
    correctIndex: 0,
  ),
  Question(
    questionText:
        'Properti apa yang digunakan untuk menampilkan teks pada widget Text?',
    options: ['label', 'value', 'data', 'text'],
    correctIndex: 3,
  ),
  Question(
    questionText: 'Widget yang menyusun elemen secara horizontal adalah ...',
    options: ['Column', 'Row', 'ListView', 'Expanded'],
    correctIndex: 1,
  ),
  Question(
    questionText: 'Widget apa yang membuat elemen mengisi ruang yang tersedia di dalam Row atau Column?',
    options: ['Expanded', 'Padding', 'Center', 'SizedBox'],
    correctIndex: 0,
  ),
  Question(
    questionText:
        'Widget yang memungkinkan halaman digulir secara vertikal adalah ...',
    options: ['Stack', 'ListView', 'Opacity', 'Divider'],
    correctIndex: 1,
  ),
  Question(
    questionText: 'Apa fungsi utama Navigator dalam aplikasi Flutter?',
    options: [
      'Mengatur warna tema',
      'Mengelola perpindahan antarhalaman',
      'Menyimpan data lokal',
      'Menggambar ikon',
    ],
    correctIndex: 1,
  ),
  Question(
    questionText:
        'Metode yang umum digunakan untuk membuka halaman baru adalah ...',
    options: [
      'Navigator.push()',
      'Navigator.open()',
      'Page.show()',
      'Route.start()',
    ],
    correctIndex: 0,
  ),
  Question(
    questionText: 'Apa kegunaan method build() pada widget Flutter?',
    options: [
      'Menghapus state',
      'Mengembalikan tampilan widget',
      'Mengunduh dependensi',
      'Menutup aplikasi',
    ],
    correctIndex: 1,
  ),
  Question(
    questionText: 'Class yang digunakan untuk membuat widget tanpa state yang berubah adalah ...',
    options: [
      'StatefulWidget',
      'InheritedWidget',
      'StatelessWidget',
      'RenderObject',
    ],
    correctIndex: 2,
  ),
  Question(
    questionText: 'Lifecycle method yang dipanggil satu kali saat State pertama kali dibuat adalah ...',
    options: ['dispose()', 'build()', 'initState()', 'didUpdateWidget()'],
    correctIndex: 2,
  ),
  Question(
    questionText: 'Lifecycle method yang tepat untuk membersihkan Timer atau controller adalah ...',
    options: ['dispose()', 'initState()', 'reassemble()', 'deactivate()'],
    correctIndex: 0,
  ),
  Question(
    questionText: 'File yang mendefinisikan nama proyek dan dependensi Flutter adalah ...',
    options: [
      'main.dart',
      'pubspec.yaml',
      'analysis_options.yaml',
      'README.md',
    ],
    correctIndex: 1,
  ),
  Question(
    questionText: 'Perintah untuk mengambil dependensi yang tercantum di pubspec.yaml adalah ...',
    options: [
      'flutter get',
      'flutter packages',
      'flutter pub get',
      'dart install',
    ],
    correctIndex: 2,
  ),
  Question(
    questionText: 'Paket Flutter yang biasa digunakan untuk mengelola state dengan ChangeNotifier adalah ...',
    options: ['provider', 'http', 'path', 'intl'],
    correctIndex: 0,
  ),
  Question(
    questionText: 'Widget untuk menyediakan objek kepada widget-widget turunannya dengan package Provider adalah ...',
    options: [
      'ChangeNotifierProvider',
      'StateProvider',
      'ObjectProvider',
      'InheritedRoute',
    ],
    correctIndex: 0,
  ),
  Question(
    questionText: 'Widget yang membantu menyesuaikan layout berdasarkan ukuran ruang yang tersedia adalah ...',
    options: ['LayoutBuilder', 'TextBuilder', 'RouteBuilder', 'ColorBuilder'],
    correctIndex: 0,
  ),
  Question(
    questionText: 'Apa fungsi SafeArea pada layout Flutter?',
    options: [
      'Membuat aplikasi selalu fullscreen',
      'Menghindari area yang tertutup notch atau sistem',
      'Mengatur koneksi internet',
      'Menyimpan ukuran layar',
    ],
    correctIndex: 1,
  ),
  Question(
    questionText:
        'Widget yang menampilkan gambar dari folder assets adalah ...',
    options: [
      'Image.asset()',
      'Asset.image()',
      'Picture.file()',
      'Icon.asset()',
    ],
    correctIndex: 0,
  ),
  Question(
    questionText: 'Aset gambar dan font biasanya didaftarkan pada bagian ... di pubspec.yaml.',
    options: ['dependencies', 'environment', 'flutter', 'scripts'],
    correctIndex: 2,
  ),
  Question(
    questionText: 'Widget yang menempatkan child tepat di tengah area yang tersedia adalah ...',
    options: ['Align', 'Center', 'Positioned', 'Spacer'],
    correctIndex: 1,
  ),
  Question(
    questionText: 'Apa fungsi Padding pada widget Flutter?',
    options: [
      'Memberikan jarak di dalam batas widget',
      'Mengubah data menjadi JSON',
      'Membuat halaman baru',
      'Menjalankan kode secara paralel',
    ],
    correctIndex: 0,
  ),
  Question(
    questionText: 'Widget yang digunakan untuk membuat tombol dengan gaya Material modern adalah ...',
    options: ['FilledButton', 'PressableText', 'ActionLabel', 'TapContainer'],
    correctIndex: 0,
  ),
  Question(
    questionText: 'Metode yang dipanggil untuk memberi tahu listener bahwa state berubah adalah ...',
    options: [
      'updateState()',
      'notifyListeners()',
      'refreshWidget()',
      'emitChange()',
    ],
    correctIndex: 1,
  ),
];
