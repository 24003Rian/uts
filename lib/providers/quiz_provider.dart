import 'package:flutter/material.dart';

import '../models/question_model.dart';

class QuizProvider with ChangeNotifier {
  String _userName = '';
  int _currentIndex = 0;
  bool _isComplete = false;
  int? _questionDurationSeconds;
  int? _remainingQuizSeconds;
  final Map<int, int> _answers = {};

  String get userName => _userName;
  int get currentIndex => _currentIndex;
  List<Question> get questions => dummyQuestions;
  int? get selectedAnswer => _answers[_currentIndex];
  int get answeredCount => _answers.length;
  int? get questionDurationSeconds => _questionDurationSeconds;
  int? get remainingQuizSeconds => _remainingQuizSeconds;
  bool get isTimed => _questionDurationSeconds != null;
  int get score => _answers.entries
      .where((answer) => questions[answer.key].correctIndex == answer.value)
      .length;
  bool get isComplete => _isComplete;

  void setUserName(String name) {
    _userName = name.trim();
    notifyListeners();
  }

  void startQuiz({required String name, int? durationSeconds}) {
    _answers.clear();
    _currentIndex = 0;
    _isComplete = false;
    _userName = name.trim();
    _questionDurationSeconds = durationSeconds;
    _remainingQuizSeconds = durationSeconds;
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
    notifyListeners();
  }

  void resetQuiz() {
    _answers.clear();
    _currentIndex = 0;
    _isComplete = false;
    _questionDurationSeconds = null;
    _remainingQuizSeconds = null;
    notifyListeners();
  }
}
