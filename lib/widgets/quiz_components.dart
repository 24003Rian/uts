import 'package:flutter/material.dart';

const Color ink = Color(0xFF173D35);
const Color forest = Color(0xFF176B5B);
const Color mutedInk = Color(0xFF71807A);
const Color paper = Color(0xFFF7F6F1);
const Color lineColor = Color(0xFFE7E9E2);
const Color mango = Color(0xFFF3B45B);

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
            color: ink,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.bubble_chart_rounded,
            size: compact ? 22 : 25,
            color: mango,
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
          backgroundColor: ink,
          foregroundColor: Colors.white,
          disabledBackgroundColor: ink.withValues(alpha: 0.35),
          padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
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
    this.onDark = false,
  });

  final int current;
  final int total;
  final bool onDark;

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
                color: onDark ? Colors.white : forest,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            const Spacer(),
            Text(
              '$current dari $total',
              style: TextStyle(
                color: onDark ? Colors.white.withValues(alpha: 0.75) : mutedInk,
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
            backgroundColor: onDark
                ? Colors.white.withValues(alpha: 0.22)
                : lineColor,
            valueColor: AlwaysStoppedAnimation<Color>(
              onDark ? const Color(0xFF32D979) : forest,
            ),
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
    this.playful = false,
  });

  final String label;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isCorrect;
  final bool playful;

  @override
  Widget build(BuildContext context) {
    final accentColor = isCorrect
        ? const Color(0xFF18A957)
        : playful
        ? const Color(0xFFFF145A)
        : forest;
    return Semantics(
      button: true,
      selected: isSelected || isCorrect,
      label: 'Pilihan $label: $text',
      child: Material(
        color: isCorrect
            ? const Color(0xFFE2F8EA)
            : playful && isSelected
            ? const Color(0xFFFFF0F5)
            : isSelected
            ? const Color(0xFFE5F0E9)
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
                color: isCorrect || (playful && isSelected)
                    ? accentColor
                    : isSelected
                    ? accentColor
                    : lineColor,
                width: isCorrect || isSelected ? 1.5 : 1,
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
                        : playful
                        ? const Color(0xFFFF145A)
                        : isSelected
                        ? accentColor
                        : paper,
                    shape: playful ? BoxShape.circle : BoxShape.rectangle,
                    borderRadius: playful ? null : BorderRadius.circular(11),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isCorrect || isSelected || playful
                          ? Colors.white
                          : mutedInk,
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
