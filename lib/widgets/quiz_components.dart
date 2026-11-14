import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app_theme.dart';

const Color ink = Color(0xFF1D2D44);
const Color forest = Color(0xFF356AE6);
const Color mutedInk = Color(0xFF718096);
const Color paper = Color(0xFFFFF8E7);
const Color creamSurface = Color(0xFFFFFCF3);
const Color lineColor = Color(0xFFE8DDC7);
const Color deepBlue = forest;

class QuizGameBackground extends StatelessWidget {
  // Membuat latar belakang dekoratif untuk seluruh halaman kuis.
  const QuizGameBackground({required this.child, super.key});

  final Widget child;

  @override
  // Menampilkan child di atas latar belakang scrapbook.
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ScrapbookBackgroundPainter(
        isDark: Theme.of(context).brightness == Brightness.dark,
      ),
      child: child,
    );
  }
}

class _ScrapbookBackgroundPainter extends CustomPainter {
  // Membuat painter latar belakang dengan warna sesuai mode tema.
  const _ScrapbookBackgroundPainter({required this.isDark});

  final bool isDark;

  @override
  // Menggambar kertas, grid, dekorasi, gelombang, dan bintang.
  void paint(Canvas canvas, Size size) {
    final navy = isDark ? const Color(0xFF0D1A2B) : const Color(0xFF214F78);
    final paperColor = isDark
        ? const Color(0xFF263448)
        : const Color(0xFFF7F6F1);
    final gridColor = isDark
        ? const Color(0xFF40536B)
        : const Color(0xFFD8DDE1);
    canvas.drawRect(Offset.zero & size, Paint()..color = navy);

    final paperPath = Path()
      ..moveTo(size.width * .08, size.height * .05)
      ..lineTo(size.width * .92, size.height * .04)
      ..lineTo(size.width * .95, size.height * .96)
      ..lineTo(size.width * .06, size.height * .95)
      ..close();
    canvas.drawPath(paperPath, Paint()..color = paperColor);

    final grid = Paint()
      ..color = gridColor.withValues(alpha: .42)
      ..strokeWidth = .7;
    for (var x = size.width * .06; x < size.width * .96; x += 22) {
      canvas.drawLine(
        Offset(x, size.height * .04),
        Offset(x, size.height * .96),
        grid,
      );
    }
    for (var y = size.height * .04; y < size.height * .98; y += 22) {
      canvas.drawLine(
        Offset(size.width * .06, y),
        Offset(size.width * .96, y),
        grid,
      );
    }

    final scrap = Paint()
      ..color = const Color(0xFF315D87).withValues(alpha: .9);
    final topCorner = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * .34, 0)
      ..lineTo(size.width * .23, size.height * .12)
      ..lineTo(0, size.height * .16)
      ..close();
    canvas.drawPath(topCorner, scrap);
    final bottomCorner = Path()
      ..moveTo(size.width, size.height)
      ..lineTo(size.width * .68, size.height)
      ..lineTo(size.width * .78, size.height * .84)
      ..lineTo(size.width, size.height * .76)
      ..close();
    canvas.drawPath(bottomCorner, scrap);

    final news = Paint()
      ..color = paperColor.withValues(alpha: .32)
      ..strokeWidth = 2;
    for (var index = 0; index < 8; index++) {
      final y = size.height * .06 + index * 9;
      canvas.drawLine(
        Offset(size.width * .72, y),
        Offset(size.width * .96, y + 24),
        news,
      );
    }

    final wave = Paint()
      ..color = isDark ? const Color(0xFF182A40) : const Color(0xFF9BC4EA)
      ..style = PaintingStyle.fill;
    final wavePath = Path()
      ..moveTo(0, size.height * .78)
      ..cubicTo(
        size.width * .2,
        size.height * .68,
        size.width * .36,
        size.height * .86,
        size.width * .56,
        size.height * .78,
      )
      ..cubicTo(
        size.width * .76,
        size.height * .7,
        size.width * .86,
        size.height * .91,
        size.width,
        size.height * .82,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(wavePath, wave);

    final stars = Paint()
      ..color = isDark ? const Color(0xFFB7D6F4) : const Color(0xFF315D87)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    _drawStar(canvas, Offset(size.width * .13, size.height * .09), 16, stars);
    _drawStar(canvas, Offset(size.width * .87, size.height * .9), 20, stars);
  }

  // Menggambar bentuk bintang pada posisi dan ukuran tertentu.
  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (var index = 0; index < 10; index++) {
      final angle = -math.pi / 2 + index * math.pi / 5;
      final currentRadius = index.isEven ? radius : radius * .42;
      final point = Offset(
        center.dx + math.cos(angle) * currentRadius,
        center.dy + math.sin(angle) * currentRadius,
      );
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  // Menggambar ulang latar hanya jika mode gelap berubah.
  bool shouldRepaint(covariant _ScrapbookBackgroundPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

class BrandMark extends StatelessWidget {
  // Membuat logo aplikasi beserta tombol pergantian tema.
  const BrandMark({super.key, this.compact = false});

  final bool compact;

  @override
  // Menampilkan ikon, nama aplikasi, dan kontrol tema.
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 38 : 44,
          height: compact ? 38 : 44,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.bubble_chart_rounded,
            size: compact ? 22 : 25,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 11),
        Text(
          'ruangkuis',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: compact ? 17 : 19,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          tooltip: Theme.of(context).brightness == Brightness.dark
              ? 'Aktifkan mode terang'
              : 'Aktifkan mode gelap',
          onPressed: AppThemeController.toggle,
          icon: Icon(
            Theme.of(context).brightness == Brightness.dark
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
            size: compact ? 19 : 21,
          ),
          visualDensity: VisualDensity.compact,
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}

const avatarOptions = [
  'assets/images/avatars/avatar_face.svg',
  'assets/images/avatars/avatar_happy.svg',
  'assets/images/avatars/avatar_brain.svg',
  'assets/images/avatars/avatar_rocket.svg',
  'assets/images/avatars/avatar_star.svg',
];

class UserAvatar extends StatelessWidget {
  // Membuat avatar pengguna berdasarkan indeks aset avatar.
  const UserAvatar({required this.index, super.key, this.size = 46});

  final int index;
  final double size;

  @override
  // Menampilkan aset avatar dalam bentuk lingkaran.
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final safeIndex = index.clamp(0, avatarOptions.length - 1);
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: scheme.primaryContainer,
      child: ClipOval(
        child: SvgPicture.asset(
          avatarOptions[safeIndex],
          width: size,
          height: size,
          fit: BoxFit.cover,
          semanticsLabel: 'Avatar pengguna ${safeIndex + 1}',
        ),
      ),
    );
  }
}

class AvatarPicker extends StatelessWidget {
  // Membuat pemilih avatar yang dapat ditekan pengguna.
  const AvatarPicker({
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  // Menampilkan seluruh pilihan avatar dan status pilihan aktif.
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih avatar',
          style: TextStyle(
            color: scheme.onSurface,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: List.generate(avatarOptions.length, (index) {
            final selected = index == selectedIndex;
            return Semantics(
              button: true,
              selected: selected,
              label: 'Avatar ${index + 1}',
              child: InkWell(
                onTap: () => onSelected(index),
                borderRadius: BorderRadius.circular(30),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? scheme.primary : scheme.outlineVariant,
                      width: selected ? 2.5 : 1,
                    ),
                  ),
                  child: UserAvatar(index: index, size: 42),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class PrimaryActionButton extends StatelessWidget {
  // Membuat tombol aksi utama yang konsisten di seluruh aplikasi.
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
  // Menampilkan tombol penuh dengan label dan ikon.
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Theme.of(context).colorScheme.primary
              .withValues(alpha: 0.45),
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
  // Membuat header yang menunjukkan posisi pengguna dalam kuis.
  const QuizProgressHeader({
    required this.current,
    required this.total,
    super.key,
  });

  final int current;
  final int total;

  @override
  // Menampilkan nomor soal dan progress bar kuis.
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : current / total;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Row(
          children: [
            Text(
              'PERTANYAAN ${current.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: scheme.onSurface,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            const Spacer(),
            Text(
              '$current dari $total',
              style: TextStyle(
                color: scheme.onSurfaceVariant,
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
            backgroundColor: scheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
          ),
        ),
        const SizedBox(height: 7),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            progress >= 1 ? 'Selesai!' : '${(progress * 100).round()}% selesai',
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class AnswerOptionCard extends StatelessWidget {
  // Membuat kartu pilihan jawaban dengan status terpilih atau benar.
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
  // Menampilkan pilihan jawaban yang dapat dipilih pengguna.
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accentColor = isCorrect ? const Color(0xFF168A52) : scheme.primary;
    return Semantics(
      button: true,
      selected: isSelected || isCorrect,
      label: 'Pilihan $label: $text',
      child: Material(
        color: isCorrect
            ? (Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1E4532)
                  : const Color(0xFFE2F8EA))
            : isSelected
            ? scheme.primaryContainer
            : scheme.surfaceContainer,
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
                color: isCorrect || isSelected
                    ? accentColor
                    : scheme.outlineVariant,
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
                        : scheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isCorrect || isSelected
                          ? Colors.white
                          : scheme.onSurfaceVariant,
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
                      color: scheme.onSurface,
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

class QuestionNavigator extends StatelessWidget {
  // Membuat navigasi cepat antarsoal dan kontrol tanda ragu-ragu.
  const QuestionNavigator({
    required this.questionCount,
    required this.currentIndex,
    required this.answeredQuestions,
    required this.flaggedQuestions,
    required this.onQuestionSelected,
    required this.onToggleFlag,
    super.key,
  });

  final int questionCount;
  final int currentIndex;
  final Set<int> answeredQuestions;
  final Set<int> flaggedQuestions;
  final ValueChanged<int> onQuestionSelected;
  final VoidCallback onToggleFlag;

  @override
  // Menampilkan nomor soal beserta status jawabannya.
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'NAVIGASI SOAL',
                style: TextStyle(
                  color: scheme.onSurface,
                  fontSize: 11,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: onToggleFlag,
                icon: Icon(
                  flaggedQuestions.contains(currentIndex)
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  size: 17,
                ),
                label: Text(
                  flaggedQuestions.contains(currentIndex)
                      ? 'Hapus ragu'
                      : 'Ragu-ragu',
                ),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFF0A020),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: List.generate(questionCount, (index) {
              final isCurrent = index == currentIndex;
              final isAnswered = answeredQuestions.contains(index);
              final isFlagged = flaggedQuestions.contains(index);
              final color = isFlagged
                  ? const Color(0xFFF0A020)
                  : isAnswered
                  ? const Color(0xFF168A52)
                  : scheme.surfaceContainerHighest;
              return InkWell(
                onTap: () => onQuestionSelected(index),
                borderRadius: BorderRadius.circular(9),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 35,
                  height: 35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                      color: isCurrent ? scheme.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isAnswered || isFlagged
                          ? Colors.white
                          : scheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 9),
          Text(
            'Hijau: dijawab  •  Abu-abu: belum  •  Kuning: ragu-ragu',
            style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
