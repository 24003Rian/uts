import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../widgets/quiz_components.dart';
import 'result_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  void _continue(BuildContext context, QuizProvider quiz) {
    final isLastQuestion = quiz.currentIndex == quiz.questions.length - 1;
    quiz.nextQuestion();
    if (isLastQuestion) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const ResultScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    final question = quiz.questions[quiz.currentIndex];
    const optionLabels = ['A', 'B', 'C', 'D'];

    return Scaffold(
      body: SafeArea(
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
                            ),
                          ),
                          const Spacer(),
                          const BrandMark(compact: true),
                          const Spacer(),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 5, 24, 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            QuizProgressHeader(
                              current: quiz.currentIndex + 1,
                              total: quiz.questions.length,
                            ),
                            SizedBox(
                              height: constraints.maxHeight < 650 ? 25 : 38,
                            ),
                            Text(
                              'Hai, ${quiz.userName}!',
                              style: const TextStyle(
                                color: forest,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 11),
                            Text(
                              question.questionText,
                              style: TextStyle(
                                color: ink,
                                fontSize: constraints.maxWidth < 380 ? 24 : 28,
                                height: 1.25,
                                letterSpacing: -0.8,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Pilih satu jawaban yang paling tepat.',
                              style: TextStyle(color: mutedInk, fontSize: 13),
                            ),
                            const SizedBox(height: 24),
                            ...List.generate(
                              question.options.length,
                              (index) => Padding(
                                padding: const EdgeInsets.only(bottom: 11),
                                child: AnswerOptionCard(
                                  label: optionLabels[index],
                                  text: question.options[index],
                                  isSelected: quiz.selectedAnswer == index,
                                  onTap: () => context
                                      .read<QuizProvider>()
                                      .selectAnswer(index),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                      child: PrimaryActionButton(
                        label: quiz.currentIndex == quiz.questions.length - 1
                            ? 'Lihat hasil'
                            : 'Lanjutkan',
                        onPressed: quiz.selectedAnswer == null
                            ? null
                            : () => _continue(context, quiz),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
