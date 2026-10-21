import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../widgets/quiz_components.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Timer? _timer;
  bool _isRevealingAnswer = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startQuizTimer());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startQuizTimer() {
    _timer?.cancel();
    final quiz = context.read<QuizProvider>();
    final duration = quiz.questionDurationSeconds;
    if (duration == null || !mounted) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final hasExpired = context.read<QuizProvider>().tickQuizTimer();
      if (hasExpired) {
        timer.cancel();
        _revealCorrectAnswer();
      }
    });
  }

  void _revealCorrectAnswer() {
    if (_isRevealingAnswer) return;
    setState(() => _isRevealingAnswer = true);
    _timer = Timer(const Duration(milliseconds: 1250), _showResultsAfterTimeout);
  }

  void _showResultsAfterTimeout() {
    if (!mounted) return;
    _openResults();
  }

  void _continue() {
    if (_isRevealingAnswer) return;
    final quiz = context.read<QuizProvider>();
    final isLastQuestion = quiz.currentIndex == quiz.questions.length - 1;
    quiz.nextQuestion();
    if (isLastQuestion) {
      _openResults();
      return;
    }

    setState(() => _isRevealingAnswer = false);
  }

  void _openResults() {
    _timer?.cancel();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const ResultScreen()),
    );
  }

  Widget _questionSwapTransition(Widget child, Animation<double> animation) {
    final easedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubic,
    );
    final slide = Tween<Offset>(
      begin: const Offset(0, -0.035),
      end: Offset.zero,
    ).animate(easedAnimation);

    return AnimatedBuilder(
      animation: easedAnimation,
      child: child,
      builder: (context, animatedChild) => ClipPath(
        clipper: _WaveRevealClipper(progress: easedAnimation.value),
        child: FadeTransition(
          opacity: easedAnimation,
          child: SlideTransition(position: slide, child: animatedChild),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    final question = quiz.questions[quiz.currentIndex];
    const optionLabels = ['A', 'B', 'C', 'D'];
    final duration = quiz.questionDurationSeconds;
    final remaining = quiz.remainingQuizSeconds;

    return Scaffold(
      backgroundColor: paper,
      body: QuizGameBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 14, 24, 18),
                        child: Row(
                          children: [
                            IconButton(
                              tooltip: 'Kembali ke beranda',
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.arrow_back_rounded),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: ink,
                                side: const BorderSide(color: lineColor),
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              'RUANG KUIS',
                              style: TextStyle(
                                color: ink,
                                fontSize: 15,
                                letterSpacing: 1.3,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 42,
                              height: 42,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: deepBlue,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${quiz.currentIndex + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 720),
                          switchInCurve: Curves.easeInOutCubic,
                          switchOutCurve: Curves.easeInOutCubic,
                          transitionBuilder: _questionSwapTransition,
                          child: SingleChildScrollView(
                            key: ValueKey<int>(quiz.currentIndex),
                            padding: const EdgeInsets.fromLTRB(24, 5, 24, 18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                QuizProgressHeader(
                                  current: quiz.currentIndex + 1,
                                  total: quiz.questions.length,
                                ),
                                if (duration != null) ...[
                                  const SizedBox(height: 14),
                                  _CountdownIndicator(
                                    remaining: remaining ?? duration,
                                    duration: duration,
                                  ),
                                ],
                                SizedBox(
                                  height: constraints.maxHeight < 650 ? 25 : 38,
                                ),
                                Text(
                                  'Hai, ${quiz.userName}!',
                                  style: const TextStyle(
                                    color: mutedInk,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 11),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.fromLTRB(
                                    20,
                                    24,
                                    20,
                                    22,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: lineColor),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    question.questionText,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: ink,
                                      fontSize: constraints.maxWidth < 380
                                          ? 21
                                          : 24,
                                      height: 1.25,
                                      letterSpacing: -0.5,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  _isRevealingAnswer
                                      ? 'Waktu habis! Ini jawaban yang benar.'
                                      : 'Pilih satu jawaban yang paling tepat.',
                                  style: TextStyle(
                                    color: mutedInk,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                ...List.generate(question.options.length, (
                                  index,
                                ) {
                                  final isCorrect =
                                      _isRevealingAnswer &&
                                      question.correctIndex == index;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 11),
                                    child: AnimatedScale(
                                      key: ValueKey<String>(
                                        '${quiz.currentIndex}-$index',
                                      ),
                                      scale: isCorrect ? 1.08 : 1,
                                      duration: const Duration(
                                        milliseconds: 420,
                                      ),
                                      curve: Curves.elasticOut,
                                      child: AnswerOptionCard(
                                        label: optionLabels[index],
                                        text: question.options[index],
                                        isSelected:
                                            quiz.selectedAnswer == index,
                                        isCorrect: isCorrect,
                                        onTap: _isRevealingAnswer
                                            ? () {}
                                            : () => context
                                                  .read<QuizProvider>()
                                                  .selectAnswer(index),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                        child: PrimaryActionButton(
                          label: quiz.currentIndex == quiz.questions.length - 1
                              ? 'Lihat hasil'
                              : 'Lanjutkan',
                          onPressed:
                              quiz.selectedAnswer == null || _isRevealingAnswer
                              ? null
                              : _continue,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _WaveRevealClipper extends CustomClipper<Path> {
  const _WaveRevealClipper({required this.progress});

  final double progress;

  @override
  Path getClip(Size size) {
    final normalizedProgress = progress.clamp(0.0, 1.0);
    final revealHeight = size.height * normalizedProgress;
    final amplitude =
        math.min(18.0, size.height * 0.035) *
        math.sin(math.pi * normalizedProgress);
    final path = Path()..moveTo(0, 0);

    for (var step = 0; step <= 40; step++) {
      final fraction = step / 40;
      final x = size.width * fraction;
      final waveOffset =
          math.sin(fraction * math.pi * 2 + normalizedProgress * math.pi * 2) *
          amplitude;
      path.lineTo(x, (revealHeight + waveOffset).clamp(0.0, size.height));
    }

    path
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant _WaveRevealClipper oldClipper) =>
      oldClipper.progress != progress;
}

class _CountdownIndicator extends StatelessWidget {
  const _CountdownIndicator({required this.remaining, required this.duration});

  final int remaining;
  final int duration;

  @override
  Widget build(BuildContext context) {
    final isUrgent = remaining <= 5;
    final color = isUrgent ? const Color(0xFFD64545) : forest;
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.timer_outlined, color: color, size: 18),
            const SizedBox(width: 7),
            Text(
              'WAKTU KUIS TERSISA',
              style: TextStyle(
                color: isUrgent ? color : ink,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
            const Spacer(),
            Text(
              '$remaining detik',
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: duration == 0 ? 0 : remaining / duration,
            minHeight: 7,
            backgroundColor: lineColor,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
