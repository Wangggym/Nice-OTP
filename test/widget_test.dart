// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:two_factor_authentication/main.dart';
import 'package:two_factor_authentication/screens/add_account_screen.dart';
import 'package:two_factor_authentication/screens/home_screen.dart';

void main() {
  group('App Widget Tests', () {
    testWidgets('App should start with HomeScreen',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('HomeScreen should have an Add Account button',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });

  group('Add Account Screen Tests', () {
    testWidgets('AddAccountScreen should have QR scanner',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddAccountScreen(),
        ),
      );
      expect(find.text('Scan QR Code'), findsOneWidget);
    });
  });
}
