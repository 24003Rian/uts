import 'package:flutter/material.dart';
import '../models/question_model.dart';

class QuizProvider with ChangeNotifier {
  String _userName = '';
  int _currentIndex = 0;
  bool _isComplete = false;
  final Map<int, int> _answers = {};

  String get userName => _userName;
  int get currentIndex => _currentIndex;
  List<Question> get questions => dummyQuestions;
  int? get selectedAnswer => _answers[_currentIndex];
  int get answeredCount => _answers.length;
  int get score => _answers.entries
      .where((answer) =>
          questions[answer.key].correctIndex == answer.value)
      .length;
  bool get isComplete => _isComplete;

  void setUserName(String name) {
    _userName = name.trim();
    notifyListeners();
  }

  void selectAnswer(int selectedIndex) {
    if (isComplete || selectedIndex < 0 ||
        selectedIndex >= questions[_currentIndex].options.length) {
      return;
    }
    _answers[_currentIndex] = selectedIndex;
    notifyListeners();
  }

  void nextQuestion() {
    if (selectedAnswer == null || isComplete) return;
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
    notifyListeners();
  }
}