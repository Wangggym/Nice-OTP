import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:two_factor_authentication/widgets/otp_card.dart';
import 'package:two_factor_authentication/models/otp_account.dart';
import 'package:two_factor_authentication/services/localization_service.dart';
import 'package:two_factor_authentication/widgets/account_options_menu.dart';

class MockLocalizationService extends LocalizationService {
  MockLocalizationService() : super(const Locale('en'));

  @override
  String translate(String key, {Map<String, String>? args}) => key;
}

void main() {
  late OTPAccount testAccount;

  setUp(() {
    LocalizationService.instance = MockLocalizationService();
    testAccount = OTPAccount(
      name: 'TestUser',
      secret: 'TESTSECRET',
      issuer: 'Google',
    );
  });

  group('OTPCard Tests', () {
    testWidgets('renders basic elements correctly',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: OTPCard(
                account: testAccount,
                onDelete: (_) {},
                onEdit: (_) {},
                onPin: (_) {},
                isPinned: false,
              ),
            ),
          ),
        );

        await tester.pump();
        expect(find.text('Google: TestUser'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pump(const Duration(seconds: 1));
      });
    });

    testWidgets('shows pin icon when pinned', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: OTPCard(
                account: testAccount,
                onDelete: (_) {},
                onEdit: (_) {},
                onPin: (_) {},
                isPinned: true,
              ),
            ),
          ),
        );

        await tester.pump();
        expect(find.byIcon(Icons.push_pin), findsOneWidget);
        await tester.pump(const Duration(seconds: 1));
      });
    });

    testWidgets('handles menu interactions', (WidgetTester tester) async {
      bool pinPressed = false;
      bool editPressed = false;
      bool deletePressed = false;
      bool copyPressed = false;

      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (BuildContext context) {
                return TextButton(
                  onPressed: () {
                    AccountOptionsMenu.show(
                      context: context,
                      position: const RelativeRect.fromLTRB(0, 0, 0, 0),
                      account: testAccount,
                      onDelete: (_) => deletePressed = true,
                      onEdit: (_) => editPressed = true,
                      onPin: (_) => pinPressed = true,
                      onCopy: () => copyPressed = true,
                      isPinned: false,
                    );
                  },
                  child: const Text('Show Menu'),
                );
              },
            ),
          ),
        );

        await tester.pump();

        // Show the menu
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Test pin action
        await tester.tap(find.text('pin'));
        await tester.pumpAndSettle();
        expect(pinPressed, true);

        // Show menu again
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Test edit action
        await tester.tap(find.text('edit'));
        await tester.pumpAndSettle();
        expect(editPressed, true);

        // Show menu again
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Test delete action
        await tester.tap(find.text('delete'));
        await tester.pumpAndSettle();
        expect(deletePressed, true);

        // Show menu again
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        // Test copy action
        await tester.tap(find.text('copy'));
        await tester.pumpAndSettle();
        expect(copyPressed, true);

        await tester.pump(const Duration(seconds: 1));
      });
    });
  });
}
