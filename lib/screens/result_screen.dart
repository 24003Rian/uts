import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../widgets/quiz_components.dart';
import 'home_screen.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  String _message(int score, int total) {
    if (score == total) return 'Luar biasa! Semua jawabanmu tepat.';
    if (score >= (total * 0.7).ceil()) return 'Keren, wawasanmu sudah kuat!';
    if (score >= (total * 0.4).ceil()) {
      return 'Awal yang bagus. Coba sekali lagi!';
    }
    return 'Terus berlatih, hasilmu pasti meningkat.';
  }

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    final total = quiz.questions.length;
    final percentage = total == 0 ? 0 : (quiz.score / total * 100).round();
    final didWin = percentage >= 50;

    return Scaffold(
      backgroundColor: paper,
      body: QuizGameBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxHeight < 720;
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: BrandMark(),
                        ),
                        SizedBox(height: compact ? 24 : 42),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8EEFF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'HASIL KUIS',
                            style: TextStyle(
                              color: deepBlue,
                              fontSize: 12,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(height: compact ? 15 : 22),
                        Image.asset(
                          didWin
                              ? 'assets/images/win_badge.png'
                              : 'assets/images/lose_badge.png',
                          width: double.infinity,
                          height: compact ? 190 : 220,
                          fit: BoxFit.contain,
                          semanticLabel: didWin
                              ? 'Ilustrasi YOU WIN'
                              : 'Ilustrasi YOU LOST',
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8EEFF),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            '$percentage%',
                            style: const TextStyle(
                              color: deepBlue,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        SizedBox(height: compact ? 18 : 24),
                        Text(
                          didWin
                              ? 'Bagus sekali,\n${quiz.userName}!'
                              : 'Coba lagi,\n${quiz.userName}!',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: ink,
                            fontSize: 24,
                            height: 1.12,
                            letterSpacing: -0.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${quiz.score} dari $total jawaban benar',
                          style: TextStyle(
                            color: ink,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _message(quiz.score, total),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: mutedInk,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: compact ? 17 : 24),
                        PrimaryActionButton(
                          label: 'Main lagi',
                          icon: Icons.refresh_rounded,
                          onPressed: () => _restartQuiz(context, quiz),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () {
                            quiz.resetQuiz();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute<void>(
                                builder: (_) => const HomeScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          icon: const Icon(Icons.home_outlined),
                          label: const Text('Kembali ke beranda'),
                          style: TextButton.styleFrom(
                            foregroundColor: mutedInk,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _restartQuiz(BuildContext context, QuizProvider quiz) {
    final playerName = quiz.userName;
    final durationSeconds = quiz.questionDurationSeconds;
    quiz.startQuiz(name: playerName, durationSeconds: durationSeconds);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const QuizScreen()),
    );
  }
}
