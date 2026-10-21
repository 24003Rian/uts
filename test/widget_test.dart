// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/main.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/providers/quiz_provider.dart';

void main() {
  testWidgets('home adapts to a narrow mobile viewport', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => QuizProvider(),
        child: const MyApp(),
      ),
    );

    expect(find.text('Seberapa luas\nwawasanmu?'), findsOneWidget);
    expect(find.text('Kuis santai'), findsNothing);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.semanticLabel ==
                'Ilustrasi kartu quiz berwarna putih dengan doodle',
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('user can resume progress and see the final score', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => QuizProvider(),
        child: const MyApp(),
      ),
    );

    expect(find.text('Seberapa luas\nwawasanmu?'), findsOneWidget);

    await tester.ensureVisible(find.byType(TextFormField));
    await tester.enterText(find.byType(TextFormField), 'Nadia');
    await tester.ensureVisible(find.text('Pilih mode kuis'));
    await tester.tap(find.text('Pilih mode kuis'));
    await tester.pumpAndSettle();
    expect(find.text('Kuis santai'), findsOneWidget);
    expect(find.text('Kuis dengan waktu'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image && widget.semanticLabel == 'Ilustrasi doodle otak',
      ),
      findsOneWidget,
    );
    await tester.ensureVisible(find.text('Mulai kuis'));
    await tester.tap(find.text('Mulai kuis'));
    await tester.pumpAndSettle();

    final firstQuestion = dummyQuestions.first;
    await tester.tap(
      find.text(firstQuestion.options[firstQuestion.correctIndex]),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Lanjutkan kuis'), findsOneWidget);
    await tester.tap(find.text('Lanjutkan kuis'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Bahasa pemrograman yang digunakan'),
      findsOneWidget,
    );
    await tester.tap(find.text('Lanjutkan'));
    await tester.pumpAndSettle();

    for (var index = 1; index < dummyQuestions.length; index++) {
      final question = dummyQuestions[index];
      await tester.tap(find.text(question.options[question.correctIndex]));
      await tester.pumpAndSettle();
      await tester.tap(
        find.text(
          index == dummyQuestions.length - 1 ? 'Lihat hasil' : 'Lanjutkan',
        ),
      );
      await tester.pumpAndSettle();
    }

    expect(find.text('100%'), findsOneWidget);
    expect(find.text('6 dari 6 jawaban benar'), findsOneWidget);
    expect(find.text('Bagus sekali,\nNadia!'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image && widget.semanticLabel == 'Ilustrasi YOU WIN',
      ),
      findsOneWidget,
    );
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('timed quiz uses one total timer for all questions', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    final quizProvider = QuizProvider();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(value: quizProvider, child: const MyApp()),
    );

    await tester.ensureVisible(find.byType(TextFormField));
    await tester.enterText(find.byType(TextFormField), 'Nadia');
    await tester.ensureVisible(find.text('Pilih mode kuis'));
    await tester.tap(find.text('Pilih mode kuis'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('15 detik'));
    await tester.ensureVisible(find.text('Mulai kuis'));
    await tester.tap(find.text('Mulai kuis'));
    await tester.pumpAndSettle();

    expect(find.text('WAKTU KUIS TERSISA'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    expect(quizProvider.remainingQuizSeconds, 10);

    final firstQuestion = dummyQuestions.first;
    await tester.tap(
      find.text(firstQuestion.options[firstQuestion.correctIndex]),
    );
    await tester.pump();
    expect(quizProvider.selectedAnswer, firstQuestion.correctIndex);
    expect(quizProvider.isComplete, isFalse);
    await tester.ensureVisible(find.text('Lanjutkan'));
    final nextButton = tester.widget<FilledButton>(
      find.ancestor(
        of: find.text('Lanjutkan'),
        matching: find.byType(FilledButton),
      ),
    );
    expect(nextButton.onPressed, isNotNull);
    await tester.tap(find.text('Lanjutkan'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(quizProvider.currentIndex, 1);
    expect(find.byType(ClipPath), findsWidgets);
    final remainingAfterAdvance = quizProvider.remainingQuizSeconds!;
    expect(remainingAfterAdvance, lessThan(15));
    expect(remainingAfterAdvance, greaterThan(0));

    await tester.pump(Duration(seconds: remainingAfterAdvance));
    expect(find.text('Waktu habis! Ini jawaban yang benar.'), findsOneWidget);
    expect(
      find.text(dummyQuestions[1].options[dummyQuestions[1].correctIndex]),
      findsOneWidget,
    );
    expect(
      tester
          .widget<AnimatedScale>(find.byKey(const ValueKey<String>('1-1')))
          .scale,
      1.08,
    );
    expect(quizProvider.score, 1);
    expect(quizProvider.currentIndex, 1);
    await tester.pump(const Duration(milliseconds: 1250));
    await tester.pumpAndSettle();
    expect(find.text('17%'), findsOneWidget);
    expect(find.text('1 dari 6 jawaban benar'), findsOneWidget);
    await tester.binding.setSurfaceSize(null);
  });
}
