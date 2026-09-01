// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mini_gamer/main.dart';

void main() {
  testWidgets(
    'shows the MINI GAMER launcher and difficulty dropdown on the home screen',
    (WidgetTester tester) async {
      await tester.pumpWidget(const RocketAvoidApp());

      expect(find.text('MINI GAMES'), findsOneWidget);
      expect(find.text('Choose your game'), findsOneWidget);
      expect(find.text('Rocket Avoid'), findsOneWidget);
      expect(find.text('Balloon Pop Party'), findsOneWidget);
      expect(find.text('Difficulty'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<GameLevel>), findsOneWidget);
      expect(find.text('Launch Selected App'), findsOneWidget);

      await tester.tap(find.text('Balloon Pop Party'));
      await tester.pumpAndSettle();
      expect(find.text('Difficulty'), findsNothing);

      await tester.tap(find.text('How to Play'));
      await tester.pumpAndSettle();
      expect(find.text('Tap balloons'), findsOneWidget);
      expect(find.text('Steer your rocket'), findsNothing);
      await tester.tap(find.text('GOT IT'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Rocket Avoid'));
      await tester.pumpAndSettle();
      expect(find.text('Difficulty'), findsOneWidget);

      await tester.ensureVisible(find.text('Launch Selected App'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Launch Selected App'));
      await tester.pumpAndSettle();

      expect(find.text('ROCKET AVOID'), findsOneWidget);
    },
  );
}
