class Question {
  final String questionText;
  final List<String> options;
  final int correctIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctIndex,
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
    questionText: 'Widget Flutter yang menyusun elemen secara vertikal adalah ...',
    options: ['Row', 'Column', 'Stack', 'Wrap'],
    correctIndex: 1,
  ),
  Question(
    questionText: 'Manakah cara yang benar untuk menampilkan ikon dari Material Design?',
    options: ['Icon(Icons.home)', 'Image(Icons.home)', 'Text(Icons.home)', 'Asset(Icons.home)'],
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
];