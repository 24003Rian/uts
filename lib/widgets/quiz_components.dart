import 'package:flutter/material.dart';

const Color ink = Color(0xFF1D2D44);
const Color forest = Color(0xFF356AE6);
const Color mutedInk = Color(0xFF718096);
const Color paper = Color(0xFFF5F7FB);
const Color lineColor = Color(0xFFE2E8F0);
const Color deepBlue = forest;

class QuizGameBackground extends StatelessWidget {
  const QuizGameBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: paper),
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -90,
            child: Container(
              width: 240,
              height: 240,
              decoration: const BoxDecoration(
                color: Color(0xFFEAF0FF),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -125,
            left: -95,
            child: Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                color: Color(0xFFEDF4FF),
                shape: BoxShape.circle,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 38 : 44,
          height: compact ? 38 : 44,
          decoration: BoxDecoration(
            color: const Color(0xFFE8EEFF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.bubble_chart_rounded,
            size: compact ? 22 : 25,
            color: forest,
          ),
        ),
        const SizedBox(width: 11),
        Text(
          'ruangkuis',
          style: TextStyle(
            color: ink,
            fontSize: compact ? 17 : 19,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
          ),
        ),
      ],
    );
  }
}

class PrimaryActionButton extends StatelessWidget {
  const PrimaryActionButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon = Icons.arrow_forward_rounded,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: forest,
          foregroundColor: Colors.white,
          disabledBackgroundColor: forest.withValues(alpha: 0.45),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Icon(icon, size: 19),
          ],
        ),
      ),
    );
  }
}

class QuizProgressHeader extends StatelessWidget {
  const QuizProgressHeader({
    required this.current,
    required this.total,
    super.key,
  });

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : current / total;
    return Column(
      children: [
        Row(
          children: [
            Text(
              'PERTANYAAN ${current.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: ink,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            const Spacer(),
            Text(
              '$current dari $total',
              style: TextStyle(
                color: mutedInk,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            backgroundColor: lineColor,
            valueColor: AlwaysStoppedAnimation<Color>(forest),
          ),
        ),
      ],
    );
  }
}

class AnswerOptionCard extends StatelessWidget {
  const AnswerOptionCard({
    required this.label,
    required this.text,
    required this.isSelected,
    required this.onTap,
    super.key,
    this.isCorrect = false,
  });

  final String label;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    final accentColor = isCorrect ? const Color(0xFF168A52) : forest;
    return Semantics(
      button: true,
      selected: isSelected || isCorrect,
      label: 'Pilihan $label: $text',
      child: Material(
        color: isCorrect
            ? const Color(0xFFE2F8EA)
            : isSelected
            ? const Color(0xFFEDF2FF)
            : Colors.white,
        borderRadius: BorderRadius.circular(17),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(17),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: isCorrect || isSelected ? accentColor : lineColor,
                width: isCorrect || isSelected ? 1.7 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isCorrect
                        ? accentColor
                        : isSelected
                        ? accentColor
                        : const Color(0xFFF0F3F8),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isCorrect || isSelected ? Colors.white : mutedInk,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: ink,
                      fontSize: 14,
                      height: 1.35,
                      fontWeight: isSelected || isCorrect
                          ? FontWeight.w800
                          : FontWeight.w600,
                    ),
                  ),
                ),
                if (isSelected || isCorrect)
                  Icon(
                    Icons.check_circle_rounded,
                    color: accentColor,
                    size: 21,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
