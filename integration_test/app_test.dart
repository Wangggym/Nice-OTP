import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:two_factor_authentication/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_factor_authentication/widgets/otp_card.dart';
import 'helpers/test_translations.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end tests', () {
    setUp(() async {
      await TestTranslations.load('en');
      SharedPreferences.setMockInitialValues({
        'selected_language': 'en',
        'test_mode': true,
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('otp_accounts');
      await prefs.remove('pinned_accounts');
    });

    // testWidgets('Add account flow test', (WidgetTester tester) async {
    //   app.main();
    //   await tester.pumpAndSettle();

    //   expect(find.byType(EmptyStateWidget), findsOneWidget);
    //   expect(find.text(TestTranslations.text('no_accounts')), findsOneWidget);

    //   await tester.tap(find.byKey(const Key('add_account_button')));
    //   await tester.pumpAndSettle();

    //   await tester.tap(find.text(TestTranslations.text('by_secret_key')));
    //   await tester.pumpAndSettle();

    //   final textFields = find.byType(TextFormField);
    //   await tester.enterText(textFields.at(0), 'Test Account');
    //   await tester.enterText(textFields.at(1), 'ABCDEFGHIJKLMNOP');
    //   await tester.enterText(textFields.at(2), 'Test Issuer');
    //   await tester.pumpAndSettle();

    //   await tester.tap(find.byKey(const Key('confirm_add_account_button')));
    //   await tester.pumpAndSettle();

    //   expect(find.text('Test Issuer: Test Account'), findsOneWidget);
    //   expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // });

    testWidgets('Pin and unpin account test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _addTestAccount(tester);
      await tester.pumpAndSettle();

      final accountCard = find.byType(OTPCard);
      await tester.longPress(accountCard);
      await tester.pumpAndSettle();

      final pinMenuItem = find.ancestor(
        of: find.text(TestTranslations.text('pin')),
        matching: find.byType(PopupMenuItem<String>),
      );
      await tester.tap(pinMenuItem);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.push_pin), findsOneWidget);

      await tester.longPress(accountCard);
      await tester.pumpAndSettle();

      final unpinMenuItem = find.ancestor(
        of: find.text(TestTranslations.text('unpin')),
        matching: find.byType(PopupMenuItem<String>),
      );
      await tester.tap(unpinMenuItem);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.push_pin), findsNothing);
    });

    // testWidgets('Edit account test', (WidgetTester tester) async {
    //   app.main();
    //   await tester.pumpAndSettle();

    //   await _addTestAccount(tester);
    //   await tester.pumpAndSettle();

    //   await tester.longPress(find.byType(OTPCard));
    //   await tester.pumpAndSettle();

    //   final editMenuItem = find.ancestor(
    //     of: find.text(TestTranslations.text('edit')),
    //     matching: find.byType(PopupMenuItem<String>),
    //   );
    //   await tester.tap(editMenuItem);
    //   await tester.pumpAndSettle();

    //   final nameField = find.byType(TextField).first;
    //   await tester.enterText(nameField, 'Updated Account');
    //   await tester.pumpAndSettle();

    //   await tester.tap(find.text(TestTranslations.text('save')));
    //   await tester.pumpAndSettle();

    //   expect(find.textContaining('Updated Account'), findsOneWidget);
    // });

    // testWidgets('Delete account test', (WidgetTester tester) async {
    //   app.main();
    //   await tester.pumpAndSettle();

    //   await _addTestAccount(tester);
    //   await tester.pumpAndSettle();

    //   await tester.longPress(find.byType(OTPCard));
    //   await tester.pumpAndSettle();

    //   await tester.tap(find.text(TestTranslations.text('delete')));
    //   await tester.pumpAndSettle();

    //   expect(find.byType(EmptyStateWidget), findsOneWidget);
    //   expect(find.text(TestTranslations.text('no_accounts')), findsOneWidget);
    // });
  });
}

Future<void> _addTestAccount(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('add_account_button')));
  await tester.pumpAndSettle();

  await tester.tap(find.text(TestTranslations.text('by_secret_key')));
  await tester.pumpAndSettle();

  final textFields = find.byType(TextFormField);
  await tester.enterText(textFields.at(0), 'Test Account');
  await tester.enterText(textFields.at(1), 'ABCDEFGHIJKLMNOP');
  await tester.enterText(textFields.at(2), 'Test Issuer');
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('confirm_add_account_button')));
  await tester.pumpAndSettle();
}
