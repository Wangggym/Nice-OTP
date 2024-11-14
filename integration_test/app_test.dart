import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:two_factor_authentication/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_factor_authentication/widgets/empty_state_widget.dart';
import 'helpers/test_translations.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Add account flow test with localization',
    (WidgetTester tester) async {
      // Load translations
      await TestTranslations.load('en');

      // Clear storage and set initial language
      SharedPreferences.setMockInitialValues({'selected_language': 'en'});
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('otp_accounts');

      // Launch app
      app.main();
      await tester.pumpAndSettle();

      // Verify empty state and localized text
      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.text(TestTranslations.text('no_accounts')), findsOneWidget);

      // Find and tap the add button using Key
      await tester.tap(find.byKey(const Key('add_account_button')));
      await tester.pumpAndSettle();

      // Switch to manual input mode
      await tester.tap(find.text(TestTranslations.text('by_secret_key')));
      await tester.pumpAndSettle();

      // Fill account information
      final textFields = find.byType(TextFormField);
      expect(textFields, findsNWidgets(3));

      await tester.enterText(textFields.at(0), 'Test Account');
      await tester.enterText(textFields.at(1), 'ABCDEFGHIJKLMNOP');
      await tester.enterText(textFields.at(2), 'Test Issuer');
      await tester.pumpAndSettle();

      // Click add button using Key
      await tester.tap(find.byKey(const Key('confirm_add_account_button')));
      await tester.pumpAndSettle();

      // Verify return to home page and new account display
      expect(find.text('Test Issuer: Test Account'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );
}
