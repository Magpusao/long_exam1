import 'package:flutter_test/flutter_test.dart';

import 'package:robles_advnobprog_longexam1/main.dart';

void main() {
  testWidgets('app starts on the splash screen', (tester) async {
    await tester.pumpWidget(const LongExamApp());

    expect(find.text('Long Exam 1'), findsOneWidget);
    expect(find.byType(LongExamApp), findsOneWidget);
  });
}
