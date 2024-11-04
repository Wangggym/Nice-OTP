import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:two_factor_authentication/widgets/copy_animated_text.dart';
import 'package:two_factor_authentication/widgets/press_animation_widget.dart';
import 'package:two_factor_authentication/services/localization_service.dart';

// Mock LocalizationService
class MockLocalizationService extends LocalizationService {
  static final MockLocalizationService _instance =
      MockLocalizationService._internal();

  factory MockLocalizationService() {
    return _instance;
  }

  MockLocalizationService._internal() : super(const Locale('en'));

  @override
  String translate(String key, {Map<String, String>? args}) {
    return key == 'copied' ? 'Copied!' : key;
  }
}

void main() {
  setUp(() {
    LocalizationService.instance = MockLocalizationService();
  });

  group('CopyAnimatedText Widget Tests', () {
    testWidgets(
        'displays initial text and changes to copied text when triggered',
        (WidgetTester tester) async {
      bool copyWasCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: CopyAnimatedText(
              text: '123 456',
              onCopy: () {
                copyWasCalled = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('123 456'), findsOneWidget);

      final state = tester.state<CopyAnimatedTextState>(
        find.byType(CopyAnimatedText),
      );

      state.triggerCopy();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(copyWasCalled, true);
      expect(find.text('Copied!'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      expect(find.text('123 456'), findsOneWidget);
    });
  });

  group('PressAnimationWidget Tests', () {
    testWidgets('responds to tap events', (WidgetTester tester) async {
      bool tapWasCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: PressAnimationWidget(
              onTap: () {
                tapWasCalled = true;
              },
              child: const Text('Press Me'),
            ),
          ),
        ),
      );

      expect(find.text('Press Me'), findsOneWidget);

      await tester.tap(find.byType(PressAnimationWidget));
      await tester.pumpAndSettle();

      expect(tapWasCalled, true);
    });

    testWidgets('responds to long press events', (WidgetTester tester) async {
      bool longPressStartCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: PressAnimationWidget(
              onLongPressStart: (_) {
                longPressStartCalled = true;
              },
              child: const Text('Press Me'),
            ),
          ),
        ),
      );

      await tester.longPress(find.byType(PressAnimationWidget));
      await tester.pumpAndSettle();

      expect(longPressStartCalled, true);
    });
  });
}
