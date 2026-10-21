import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../widgets/quiz_components.dart';
import 'quiz_screen.dart';

class ModeSelectionScreen extends StatefulWidget {
  const ModeSelectionScreen({required this.playerName, super.key});

  final String playerName;

  @override
  State<ModeSelectionScreen> createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen> {
  int? _selectedDurationSeconds;

  bool _canResume(QuizProvider quiz) =>
      quiz.userName == widget.playerName &&
      quiz.questionDurationSeconds == _selectedDurationSeconds &&
      quiz.answeredCount > 0 &&
      !quiz.isComplete;

  void _startQuiz() {
    final quiz = context.read<QuizProvider>();
    if (!_canResume(quiz)) {
      quiz.startQuiz(
        name: widget.playerName,
        durationSeconds: _selectedDurationSeconds,
      );
    }
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const QuizScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    final canResume = _canResume(quiz);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 380 ? 22.0 : 28.0;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    16,
                    horizontalPadding,
                    24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        tooltip: 'Kembali',
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: ink,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const BrandMark(),
                      const SizedBox(height: 34),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(23),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6D18A8),
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'LANGKAH BERIKUTNYA',
                              style: TextStyle(
                                color: Color(0xFFFFD66B),
                                fontSize: 10,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Hai, ${widget.playerName}!',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                height: 1.15,
                                letterSpacing: -0.8,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Pilih cara bermain yang paling cocok untukmu.',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 13,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Pilih mode kuis',
                        style: TextStyle(
                          color: ink,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        'Kamu bisa bermain santai atau melawan waktu.',
                        style: TextStyle(color: mutedInk, fontSize: 13),
                      ),
                      const SizedBox(height: 18),
                      _ModeCard(
                        title: 'Kuis santai',
                        subtitle: 'Jawab tanpa batas waktu',
                        detail: 'Nikmati setiap soal dengan ritmemu sendiri.',
                        icon: Icons.self_improvement_rounded,
                        isSelected: _selectedDurationSeconds == null,
                        onTap: () =>
                            setState(() => _selectedDurationSeconds = null),
                      ),
                      const SizedBox(height: 13),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _selectedDurationSeconds != null
                                ? const Color(0xFF6D18A8)
                                : lineColor,
                            width: _selectedDurationSeconds != null ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => setState(
                                () => _selectedDurationSeconds ??= 15,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 43,
                                    height: 43,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF0D8),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(
                                      Icons.bolt_rounded,
                                      color: Color(0xFFE89A16),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Kuis dengan waktu',
                                          style: TextStyle(
                                            color: ink,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          'Batas waktu untuk menyelesaikan seluruh soal',
                                          style: TextStyle(
                                            color: mutedInk,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    _selectedDurationSeconds != null
                                        ? Icons.radio_button_checked_rounded
                                        : Icons.radio_button_off_rounded,
                                    color: _selectedDurationSeconds != null
                                        ? const Color(0xFF6D18A8)
                                        : mutedInk,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [15, 30, 60, 120]
                                  .map(
                                    (seconds) => _DurationChoice(
                                      seconds: seconds,
                                      isSelected:
                                          _selectedDurationSeconds == seconds,
                                      onTap: () => setState(
                                        () =>
                                            _selectedDurationSeconds = seconds,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 26),
                      PrimaryActionButton(
                        label: canResume ? 'Lanjutkan kuis' : 'Mulai kuis',
                        onPressed: _startQuiz,
                      ),
                      const SizedBox(height: 14),
                      Center(
                        child: Text(
                          '${quiz.questions.length} soal pilihan ganda',
                          style: const TextStyle(
                            color: mutedInk,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
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
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String detail;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? const Color(0xFF6D18A8) : lineColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F0E9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: forest),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(color: mutedInk, fontSize: 12),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      detail,
                      style: const TextStyle(
                        color: mutedInk,
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isSelected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: isSelected ? const Color(0xFF6D18A8) : mutedInk,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DurationChoice extends StatelessWidget {
  const _DurationChoice({
    required this.seconds,
    required this.isSelected,
    required this.onTap,
  });

  final int seconds;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text('$seconds detik'),
      selected: isSelected,
      onSelected: (_) => onTap(),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : ink,
        fontSize: 12,
        fontWeight: FontWeight.w800,
      ),
      backgroundColor: paper,
      selectedColor: const Color(0xFF6D18A8),
      side: BorderSide(color: isSelected ? const Color(0xFF6D18A8) : lineColor),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    );
  }
}
