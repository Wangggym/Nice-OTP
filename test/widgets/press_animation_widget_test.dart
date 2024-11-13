import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:two_factor_authentication/widgets/press_animation_widget.dart';

void main() {
  group('PressAnimationWidget Tests', () {
    testWidgets('renders child widget correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: PressAnimationWidget(
                child: Container(
                  key: const Key('test-child'),
                  child: const Text('Test Child'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('test-child')), findsOneWidget);
      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('triggers animation on tap down and up',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: PressAnimationWidget(
                onTap: () {},
                child: const ColoredBox(
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      );

      final state = tester
          .state<PressAnimationWidgetState>(find.byType(PressAnimationWidget));

      // Verify initial state
      expect(state.controller.value, equals(0.0));

      // Trigger tap down
      final gesture = await tester.createGesture();
      final center = tester.getCenter(find.byType(ColoredBox));
      await gesture.down(center);

      // Pump multiple frames to allow animation to progress
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));

      // Verify animation started
      expect(state.controller.value, greaterThan(0));

      // Release tap
      await gesture.up();
      await tester.pumpAndSettle();

      // Verify animation completed
      expect(state.controller.value, equals(0));
    });

    testWidgets('calls onTap callback when tapped',
        (WidgetTester tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: PressAnimationWidget(
                onTap: () => wasTapped = true,
                child: const ColoredBox(
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ColoredBox));
      await tester.pumpAndSettle();

      expect(wasTapped, true);
    });

    testWidgets('calls onLongPressStart callback when long pressed',
        (WidgetTester tester) async {
      bool wasLongPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: PressAnimationWidget(
                onLongPressStart: (_) => wasLongPressed = true,
                child: const ColoredBox(
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.longPress(find.byType(ColoredBox));
      await tester.pumpAndSettle();

      expect(wasLongPressed, true);
    });

    testWidgets('animation cancels on tap cancel', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: PressAnimationWidget(
                child: ColoredBox(
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      );

      final state = tester
          .state<PressAnimationWidgetState>(find.byType(PressAnimationWidget));

      // Start gesture
      final gesture = await tester.createGesture();
      final center = tester.getCenter(find.byType(ColoredBox));
      await gesture.down(center);

      // Pump multiple frames to allow animation to progress
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));

      // Verify animation started
      expect(state.controller.value, greaterThan(0));

      // Cancel gesture
      await gesture.cancel();
      await tester.pumpAndSettle();

      // Verify animation reset
      expect(state.controller.value, equals(0));
    });
  });
}
