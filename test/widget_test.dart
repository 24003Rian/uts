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

    await tester.enterText(find.byType(TextFormField), 'Nadia');
    await tester.tap(find.text('Mulai tantangan'));
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
    await tester.binding.setSurfaceSize(null);
  });
}
