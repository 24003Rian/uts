import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/question_model.dart';

class QuizProvider with ChangeNotifier {
  static const int questionLimit = 120;
  static const _progressKey = 'quiz_progress';
  static const _analyticsKey = 'quiz_analytics';

  String _userName = '';
  int _currentIndex = 0;
  bool _isComplete = false;
  int? _questionDurationSeconds;
  int? _remainingQuizSeconds;
  final Map<int, int> _answers = {};
  final Set<int> _flaggedQuestions = {};
  final List<double> _accuracyHistory = [];
  List<Question> _questions = dummyQuestions;

  // Membuat provider dan memuat progres kuis yang tersimpan.
  QuizProvider() {
    loadPersistedProgress();
  }

  String get userName => _userName;
  int get currentIndex => _currentIndex;
  List<Question> get questions => _questions;
  int get availableQuestionCount => dummyQuestions.length;
  int? get selectedAnswer => _answers[_currentIndex];
  int get answeredCount => _answers.length;
  int get questionCount => _questions.length;
  int? get questionDurationSeconds => _questionDurationSeconds;
  int? get remainingQuizSeconds => _remainingQuizSeconds;
  bool get isTimed => _questionDurationSeconds != null;
  int get score => _answers.entries
      .where((answer) => questions[answer.key].correctIndex == answer.value)
      .length;
  bool get isComplete => _isComplete;
  int get completedQuizzes => _accuracyHistory.length;
  List<double> get accuracyHistory => List.unmodifiable(_accuracyHistory);
  double get accuracy => _accuracyHistory.isEmpty
      ? 0
      : _accuracyHistory.reduce((total, value) => total + value) /
            _accuracyHistory.length;
  double get averageScore => accuracy;
  Set<int> get flaggedQuestions => Set.unmodifiable(_flaggedQuestions);

  // Mengambil jawaban pengguna untuk indeks soal tertentu.
  int? answerFor(int questionIndex) => _answers[questionIndex];

  // Mengecek apakah soal tertentu ditandai sebagai ragu-ragu.
  bool isFlagged(int questionIndex) =>
      _flaggedQuestions.contains(questionIndex);

  // Menambah atau menghapus tanda ragu-ragu pada soal.
  void toggleFlag(int questionIndex) {
    if (questionIndex < 0 || questionIndex >= questions.length) return;
    if (!_flaggedQuestions.add(questionIndex)) {
      _flaggedQuestions.remove(questionIndex);
    }
    _saveProgress();
    notifyListeners();
  }

  // Berpindah ke soal lain dan menyimpan posisi terakhir.
  void goToQuestion(int questionIndex) {
    if (questionIndex < 0 || questionIndex >= questions.length) return;
    _currentIndex = questionIndex;
    _saveProgress();
    notifyListeners();
  }

  // Mengecek apakah jawaban pengguna pada soal benar.
  bool isAnswerCorrect(int questionIndex) {
    final answer = answerFor(questionIndex);
    return answer != null && questions[questionIndex].correctIndex == answer;
  }

  // Menyimpan nama pemain setelah menghapus spasi di sekitarnya.
  void setUserName(String name) {
    _userName = name.trim();
    notifyListeners();
  }

  // Menginisialisasi kuis baru dengan mode dan jumlah soal yang dipilih.
  void startQuiz({
    required String name,
    int? durationSeconds,
    int? questionCount,
  }) {
    final selectedQuestionCount = questionCount ?? availableQuestionCount;
    if (selectedQuestionCount < 1 ||
        selectedQuestionCount > questionLimit ||
        selectedQuestionCount > availableQuestionCount) {
      throw ArgumentError.value(
        selectedQuestionCount,
        'questionCount',
        'Must be between 1 and $availableQuestionCount.',
      );
    }

    _answers.clear();
    _flaggedQuestions.clear();
    _currentIndex = 0;
    _isComplete = false;
    _userName = name.trim();
    _questionDurationSeconds = durationSeconds;
    _remainingQuizSeconds = durationSeconds;
    _questions = dummyQuestions.take(selectedQuestionCount).toList();
    _saveProgress();
    notifyListeners();
  }

  // Mengurangi waktu kuis dan menyelesaikan kuis saat waktu habis.
  bool tickQuizTimer() {
    final remaining = _remainingQuizSeconds;
    if (remaining == null || _isComplete) return false;

    _remainingQuizSeconds = remaining > 0 ? remaining - 1 : 0;
    final hasExpired = _remainingQuizSeconds == 0;
    if (hasExpired) {
      _completeQuiz();
    }
    _saveProgress();
    notifyListeners();
    return hasExpired;
  }

  // Menyimpan jawaban untuk soal yang sedang aktif.
  void selectAnswer(int selectedIndex) {
    if (isComplete ||
        selectedIndex < 0 ||
        selectedIndex >= questions[_currentIndex].options.length) {
      return;
    }
    _answers[_currentIndex] = selectedIndex;
    _saveProgress();
    notifyListeners();
  }

  // Melanjutkan ke soal berikutnya jika soal saat ini sudah dijawab.
  void nextQuestion() {
    if (selectedAnswer == null || isComplete) return;
    _advanceQuestion();
  }

  // Berpindah ke soal berikutnya atau menyelesaikan kuis.
  void _advanceQuestion() {
    if (_currentIndex == questions.length - 1) {
      _completeQuiz();
    } else {
      _currentIndex++;
    }
    _saveProgress();
    notifyListeners();
  }

  // Menandai kuis selesai dan mencatat persentase hasilnya.
  void _completeQuiz() {
    if (_isComplete) return;
    _isComplete = true;
    final percentage = questions.isEmpty ? 0.0 : score / questions.length * 100;
    _accuracyHistory.add(percentage);
    _saveAnalytics();
  }

  // Menghapus sesi kuis aktif dan progres tersimpan.
  void resetQuiz() {
    _answers.clear();
    _flaggedQuestions.clear();
    _currentIndex = 0;
    _isComplete = false;
    _questionDurationSeconds = null;
    _remainingQuizSeconds = null;
    _clearPersistedProgress();
    notifyListeners();
  }

  // Memuat progres dan riwayat analitik dari penyimpanan lokal.
  Future<void> loadPersistedProgress() async {
    final preferences = await SharedPreferences.getInstance();
    final rawAnalytics = preferences.getString(_analyticsKey);
    if (rawAnalytics != null && rawAnalytics.isNotEmpty) {
      final analyticsData = jsonDecode(rawAnalytics);
      if (analyticsData is Map<String, dynamic>) {
        _accuracyHistory
          ..clear()
          ..addAll(
            (analyticsData['accuracyHistory'] is List
                    ? analyticsData['accuracyHistory'] as List
                    : const <Object?>[])
                .whereType<num>()
                .map((value) => value.toDouble()),
          );
      }
    }
    final rawProgress = preferences.getString(_progressKey);
    if (rawProgress == null || rawProgress.isEmpty) return;

    final data = jsonDecode(rawProgress);
    if (data is! Map<String, dynamic>) return;
    final questionCount = data['questionCount'];
    if (questionCount is! int ||
        questionCount < 1 ||
        questionCount > availableQuestionCount) {
      return;
    }

    _userName = data['userName'] as String? ?? '';
    _currentIndex = (data['currentIndex'] as int? ?? 0).clamp(
      0,
      questionCount - 1,
    );
    _questionDurationSeconds = data['durationSeconds'] as int?;
    _remainingQuizSeconds = data['remainingSeconds'] as int?;
    _isComplete = data['isComplete'] as bool? ?? false;
    _questions = dummyQuestions.take(questionCount).toList();

    final answers = data['answers'];
    _answers
      ..clear()
      ..addAll(_decodeIntMap(answers));
    final flags = data['flags'];
    _flaggedQuestions
      ..clear()
      ..addAll(
        flags is List
            ? flags.whereType<int>().where(
                (index) => index >= 0 && index < questionCount,
              )
            : const <int>[],
      );
    notifyListeners();
  }

  // Mengubah map dinamis dari JSON menjadi map indeks jawaban bertipe integer.
  Map<int, int> _decodeIntMap(Object? value) {
    if (value is! Map) return {};
    return {
      for (final entry in value.entries)
        if (int.tryParse('${entry.key}') != null && entry.value is int)
          int.parse('${entry.key}'): entry.value as int,
    };
  }

  // Menyimpan kondisi kuis aktif ke penyimpanan lokal.
  Future<void> _saveProgress() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _progressKey,
      jsonEncode({
        'userName': _userName,
        'currentIndex': _currentIndex,
        'questionCount': _questions.length,
        'durationSeconds': _questionDurationSeconds,
        'remainingSeconds': _remainingQuizSeconds,
        'isComplete': _isComplete,
        'score': score,
        'answers': {
          for (final entry in _answers.entries) '${entry.key}': entry.value,
        },
        'flags': _flaggedQuestions.toList(),
      }),
    );
  }

  // Menghapus progres kuis aktif dari penyimpanan lokal.
  Future<void> _clearPersistedProgress() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_progressKey);
  }

  // Menyimpan riwayat akurasi kuis ke penyimpanan lokal.
  Future<void> _saveAnalytics() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _analyticsKey,
      jsonEncode({'accuracyHistory': _accuracyHistory}),
    );
  }
}
