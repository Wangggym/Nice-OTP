import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:two_factor_authentication/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_factor_authentication/widgets/empty_state_widget.dart';
import 'package:two_factor_authentication/widgets/otp_card.dart';
import 'helpers/test_translations.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end tests', () {
    setUp(() async {
      await TestTranslations.load('en');
      SharedPreferences.setMockInitialValues({'selected_language': 'en'});
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('otp_accounts');
      await prefs.remove('pinned_accounts');
    });

    testWidgets('Add account flow test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.text(TestTranslations.text('no_accounts')), findsOneWidget);

      await tester.tap(find.byKey(const Key('add_account_button')));
      await tester.pump(const Duration(seconds: 2));

      await tester.tap(find.text(TestTranslations.text('by_secret_key')));
      await tester.pump(const Duration(seconds: 1));

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Test Account');
      await tester.enterText(textFields.at(1), 'ABCDEFGHIJKLMNOP');
      await tester.enterText(textFields.at(2), 'Test Issuer');
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.byKey(const Key('confirm_add_account_button')));
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Test Issuer: Test Account'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Pin and unpin account test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _addTestAccount(tester);

      await tester.pump(const Duration(seconds: 2));

      final accountCard = find.byType(OTPCard);
      await tester.longPress(accountCard);
      await tester.pump(const Duration(seconds: 1));

      final pinButton =
          find.widgetWithText(ListTile, TestTranslations.text('pin'));
      await tester.tap(pinButton);
      await tester.pump(const Duration(seconds: 2));

      expect(find.byIcon(Icons.push_pin), findsOneWidget);

      await tester.longPress(accountCard);
      await tester.pump(const Duration(seconds: 1));

      final unpinButton =
          find.widgetWithText(ListTile, TestTranslations.text('unpin'));
      await tester.tap(unpinButton);
      await tester.pump(const Duration(seconds: 2));

      expect(find.byIcon(Icons.push_pin), findsNothing);
    });

    testWidgets('Edit account test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _addTestAccount(tester);

      await tester.pump(const Duration(seconds: 2));

      await tester.longPress(find.byType(OTPCard));
      await tester.pump(const Duration(seconds: 1));

      final editButton =
          find.widgetWithText(ListTile, TestTranslations.text('edit'));
      await tester.tap(editButton);
      await tester.pump(const Duration(seconds: 2));

      final nameField = find.byType(TextField).first;
      await tester.enterText(nameField, 'Updated Account');
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text(TestTranslations.text('save')));
      await tester.pump(const Duration(seconds: 2));

      await tester.pump(const Duration(seconds: 2));

      final updatedText = find.descendant(
        of: find.byType(OTPCard),
        matching: find.text('Test Issuer: Updated Account'),
      );
      expect(updatedText, findsOneWidget);
    });

    testWidgets('Delete account test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _addTestAccount(tester);

      await tester.longPress(find.byType(OTPCard));
      await tester.pump(const Duration(seconds: 1));
      await tester.tap(find.text(TestTranslations.text('delete')));
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.text(TestTranslations.text('no_accounts')), findsOneWidget);
    });
  });
}

Future<void> _addTestAccount(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('add_account_button')));
  await tester.pump(const Duration(seconds: 2));

  await tester.tap(find.text(TestTranslations.text('by_secret_key')));
  await tester.pump(const Duration(seconds: 1));

  final textFields = find.byType(TextFormField);
  await tester.enterText(textFields.at(0), 'Test Account');
  await tester.enterText(textFields.at(1), 'ABCDEFGHIJKLMNOP');
  await tester.enterText(textFields.at(2), 'Test Issuer');
  await tester.pump(const Duration(seconds: 1));

  await tester.tap(find.byKey(const Key('confirm_add_account_button')));
  await tester.pump(const Duration(seconds: 2));
}
