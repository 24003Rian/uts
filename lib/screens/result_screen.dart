import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../widgets/quiz_components.dart';
import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  String _message(int score, int total) {
    if (score == total) return 'Luar biasa! Semua jawabanmu tepat.';
    if (score >= (total * 0.7).ceil()) return 'Keren, wawasanmu sudah kuat!';
    if (score >= (total * 0.4).ceil()) return 'Awal yang bagus. Coba sekali lagi!';
    return 'Terus berlatih, hasilmu pasti meningkat.';
  }

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    final total = quiz.questions.length;
    final percentage = total == 0 ? 0 : (quiz.score / total * 100).round();

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: BrandMark(),
                      ),
                      SizedBox(height: constraints.maxHeight < 650 ? 32 : 52),
                      Container(
                        width: constraints.maxWidth < 380 ? 108 : 124,
                        height: constraints.maxWidth < 380 ? 108 : 124,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE5F0E9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          percentage >= 70
                              ? Icons.emoji_events_rounded
                              : Icons.auto_awesome_rounded,
                          color: forest,
                          size: constraints.maxWidth < 380 ? 54 : 62,
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        'TANTANGAN SELESAI',
                        style: TextStyle(
                          color: forest,
                          fontSize: 11,
                          letterSpacing: 1.8,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Bagus sekali,\n${quiz.userName}!',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: ink,
                          fontSize: 31,
                          height: 1.15,
                          letterSpacing: -1,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 11),
                      Text(
                        _message(quiz.score, total),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: mutedInk, fontSize: 14),
                      ),
                      const SizedBox(height: 27),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 22,
                        ),
                        decoration: BoxDecoration(
                          color: ink,
                          borderRadius: BorderRadius.circular(23),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '$percentage%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                height: 1,
                                letterSpacing: -1.8,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${quiz.score} dari $total jawaban benar',
                              style: const TextStyle(
                                color: Color(0xFFC1D0CA),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 17),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: LinearProgressIndicator(
                                value: total == 0 ? 0 : quiz.score / total,
                                minHeight: 7,
                                backgroundColor: Colors.white.withValues(alpha: 0.16),
                                valueColor: const AlwaysStoppedAnimation<Color>(mango),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: _ResultStat(
                              icon: Icons.check_circle_outline_rounded,
                              title: '${quiz.score} benar',
                              subtitle: 'jawaban tepat',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ResultStat(
                              icon: Icons.question_mark_rounded,
                              title: '${total - quiz.score} salah',
                              subtitle: 'bisa dicoba lagi',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      PrimaryActionButton(
                        label: 'Main lagi',
                        icon: Icons.refresh_rounded,
                        onPressed: () {
                          context.read<QuizProvider>().resetQuiz();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute<void>(
                              builder: (_) => const HomeScreen(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  const _ResultStat({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: lineColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: forest, size: 20),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: ink,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: mutedInk, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
