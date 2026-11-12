import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/question_model.dart';
import '../providers/quiz_provider.dart';
import '../widgets/quiz_components.dart';
import 'mode_selection_screen.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({this.avatarIndex = 0, super.key});

  final int avatarIndex;

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
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              const BrandMark(),
                              const Spacer(),
                              UserAvatar(index: avatarIndex, size: 44),
                            ],
                          ),
                        ),
                        SizedBox(height: compact ? 24 : 42),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: scheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'HASIL KUIS',
                            style: TextStyle(
                              color: scheme.primary,
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
                            color: scheme.primaryContainer,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            '$percentage%',
                            style: TextStyle(
                              color: scheme.primary,
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
                          style: TextStyle(
                            color: scheme.onSurface,
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
                            color: scheme.onSurface,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _message(quiz.score, total),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: scheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: compact ? 17 : 24),
                        _ResultStats(
                          correct: quiz.score,
                          incorrect: quiz.answeredCount - quiz.score,
                          unanswered: total - quiz.answeredCount,
                        ),
                        SizedBox(height: compact ? 17 : 24),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'RINGKASAN JAWABAN',
                            style: TextStyle(
                              color: scheme.onSurface,
                              fontSize: 13,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(
                          total,
                          (index) => _AnswerReviewCard(
                            index: index,
                            question: quiz.questions[index],
                            userAnswer: quiz.answerFor(index),
                            isCorrect: quiz.isAnswerCorrect(index),
                          ),
                        ),
                        const SizedBox(height: 12),
                        PrimaryActionButton(
                          label: 'Main lagi',
                          icon: Icons.refresh_rounded,
                          onPressed: () => _restartQuiz(context, quiz),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () {
                            final playerName = quiz.userName;
                            quiz.resetQuiz();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute<void>(
                                builder: (_) => ModeSelectionScreen(
                                  playerName: playerName,
                                  avatarIndex: avatarIndex,
                                ),
                              ),
                              (route) => false,
                            );
                          },
                          icon: const Icon(Icons.home_outlined),
                          label: const Text('Kembali ke ruang kuis'),
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
    final questionCount = quiz.questionCount;
    quiz.startQuiz(
      name: playerName,
      durationSeconds: durationSeconds,
      questionCount: questionCount,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => QuizScreen(avatarIndex: avatarIndex),
      ),
    );
  }
}

class _ResultStats extends StatelessWidget {
  const _ResultStats({
    required this.correct,
    required this.incorrect,
    required this.unanswered,
  });

  final int correct;
  final int incorrect;
  final int unanswered;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ResultStatTile(
              value: '$correct',
              label: 'Benar',
              color: const Color(0xFF168A52),
              icon: Icons.check_circle_rounded,
            ),
          ),
          Container(width: 1, height: 38, color: scheme.outlineVariant),
          Expanded(
            child: _ResultStatTile(
              value: '$incorrect',
              label: 'Salah',
              color: const Color(0xFFD64545),
              icon: Icons.cancel_rounded,
            ),
          ),
          Container(width: 1, height: 38, color: scheme.outlineVariant),
          Expanded(
            child: _ResultStatTile(
              value: '$unanswered',
              label: 'Kosong',
              color: const Color(0xFFF0A020),
              icon: Icons.help_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultStatTile extends StatelessWidget {
  const _ResultStatTile({
    required this.value,
    required this.label,
    required this.color,
    required this.icon,
  });

  final String value;
  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: scheme.onSurfaceVariant,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _AnswerReviewCard extends StatelessWidget {
  const _AnswerReviewCard({
    required this.index,
    required this.question,
    required this.userAnswer,
    required this.isCorrect,
  });

  final int index;
  final Question question;
  final int? userAnswer;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final statusColor = isCorrect ? scheme.tertiary : scheme.error;
    final statusBackground = isCorrect
        ? scheme.tertiaryContainer
        : scheme.errorContainer;
    final userAnswerText = userAnswer == null
        ? 'Tidak dijawab'
        : question.options[userAnswer!];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Soal ${index + 1}',
                  style: const TextStyle(
                    color: ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: statusBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isCorrect ? 'BENAR' : 'SALAH',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            question.questionText,
            style: const TextStyle(
              color: ink,
              fontSize: 13,
              height: 1.4,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            question.explanation,
            style: TextStyle(
              color: mutedInk,
              fontSize: 12,
              height: 1.4,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),
          _ReviewAnswerLine(
            label: 'Jawabanmu',
            value: userAnswerText,
            color: isCorrect ? statusColor : const Color(0xFFD64545),
          ),
          if (!isCorrect) ...[
            const SizedBox(height: 5),
            _ReviewAnswerLine(
              label: 'Jawaban benar',
              value: question.options[question.correctIndex],
              color: const Color(0xFF168A52),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReviewAnswerLine extends StatelessWidget {
  const _ReviewAnswerLine({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 12, height: 1.35),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(
              color: mutedInk,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(color: color, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
