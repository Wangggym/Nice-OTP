import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:two_factor_authentication/widgets/copy_animated_text.dart';
import 'package:two_factor_authentication/services/localization_service.dart';

class MockLocalizationService extends LocalizationService {
  MockLocalizationService() : super(const Locale('en'));

  @override
  String translate(String key, {Map<String, String>? args}) {
    return key == 'copied' ? 'Copied!' : key;
  }
}

void main() {
  setUp(() {
    LocalizationService.instance = MockLocalizationService();
  });

  group('CopyAnimatedText Tests', () {
    testWidgets('displays initial text correctly', (WidgetTester tester) async {
      const testText = 'Test Text';

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: CopyAnimatedText(
              text: testText,
              onCopy: () {},
            ),
          ),
        ),
      );

      expect(find.text(testText), findsOneWidget);
      expect(find.text('Copied!'), findsNothing);
    });

    testWidgets('shows copied text when triggered and reverts back',
        (WidgetTester tester) async {
      const testText = 'Test Text';
      bool copyWasCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: CopyAnimatedText(
              text: testText,
              onCopy: () => copyWasCalled = true,
            ),
          ),
        ),
      );

      final state =
          tester.state<CopyAnimatedTextState>(find.byType(CopyAnimatedText));

      state.triggerCopy();
      await tester.pump();

      expect(copyWasCalled, true);
      expect(find.text('Copied!'), findsOneWidget);
      expect(find.text(testText), findsNothing);

      // Wait for animation duration
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Copied!'), findsOneWidget);

      // Wait for the delay before reverting
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      expect(find.text(testText), findsOneWidget);
      expect(find.text('Copied!'), findsNothing);
    });

    testWidgets('handles rapid multiple triggers correctly',
        (WidgetTester tester) async {
      const testText = 'Test Text';

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: CopyAnimatedText(
              text: testText,
              onCopy: () {},
            ),
          ),
        ),
      );

      final state =
          tester.state<CopyAnimatedTextState>(find.byType(CopyAnimatedText));

      // Trigger multiple times rapidly
      state.triggerCopy();
      await tester.pump(const Duration(milliseconds: 100));
      state.triggerCopy();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Copied!'), findsOneWidget);
      expect(find.text(testText), findsNothing);

      // Wait for the delay
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      expect(find.text(testText), findsOneWidget);
      expect(find.text('Copied!'), findsNothing);
    });
  });
}
