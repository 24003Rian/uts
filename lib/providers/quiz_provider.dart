import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/question_model.dart';

class QuizProvider with ChangeNotifier {
  static const int questionLimit = 120;
  static const _progressKey = 'quiz_progress';

  String _userName = '';
  int _currentIndex = 0;
  bool _isComplete = false;
  int? _questionDurationSeconds;
  int? _remainingQuizSeconds;
  final Map<int, int> _answers = {};
  final Set<int> _flaggedQuestions = {};
  List<Question> _questions = dummyQuestions;

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
  Set<int> get flaggedQuestions => Set.unmodifiable(_flaggedQuestions);

  int? answerFor(int questionIndex) => _answers[questionIndex];

  bool isFlagged(int questionIndex) => _flaggedQuestions.contains(questionIndex);

  void toggleFlag(int questionIndex) {
    if (questionIndex < 0 || questionIndex >= questions.length) return;
    if (!_flaggedQuestions.add(questionIndex)) {
      _flaggedQuestions.remove(questionIndex);
    }
    _saveProgress();
    notifyListeners();
  }

  void goToQuestion(int questionIndex) {
    if (questionIndex < 0 || questionIndex >= questions.length) return;
    _currentIndex = questionIndex;
    _saveProgress();
    notifyListeners();
  }

  bool isAnswerCorrect(int questionIndex) {
    final answer = answerFor(questionIndex);
    return answer != null && questions[questionIndex].correctIndex == answer;
  }

  void setUserName(String name) {
    _userName = name.trim();
    notifyListeners();
  }

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

  bool tickQuizTimer() {
    final remaining = _remainingQuizSeconds;
    if (remaining == null || _isComplete) return false;

    _remainingQuizSeconds = remaining > 0 ? remaining - 1 : 0;
    final hasExpired = _remainingQuizSeconds == 0;
    if (hasExpired) {
      _isComplete = true;
    }
    _saveProgress();
    notifyListeners();
    return hasExpired;
  }

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

  void nextQuestion() {
    if (selectedAnswer == null || isComplete) return;
    _advanceQuestion();
  }

  void _advanceQuestion() {
    if (_currentIndex == questions.length - 1) {
      _isComplete = true;
    } else {
      _currentIndex++;
    }
    _saveProgress();
    notifyListeners();
  }

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

  Future<void> loadPersistedProgress() async {
    final preferences = await SharedPreferences.getInstance();
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
    _currentIndex = (data['currentIndex'] as int? ?? 0)
        .clamp(0, questionCount - 1);
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

  Map<int, int> _decodeIntMap(Object? value) {
    if (value is! Map) return {};
    return {
      for (final entry in value.entries)
        if (int.tryParse('${entry.key}') != null && entry.value is int)
          int.parse('${entry.key}'): entry.value as int,
    };
  }

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
          for (final entry in _answers.entries)
            '${entry.key}': entry.value,
        },
        'flags': _flaggedQuestions.toList(),
      }),
    );
  }

  Future<void> _clearPersistedProgress() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_progressKey);
  }
}
