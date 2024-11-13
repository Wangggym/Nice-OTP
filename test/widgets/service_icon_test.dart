import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:two_factor_authentication/widgets/service_icon.dart';

void main() {
  group('ServiceIcon Tests', () {
    testWidgets('renders known service icons correctly',
        (WidgetTester tester) async {
      final services = {
        'Google': FontAwesomeIcons.google,
        'GitHub': FontAwesomeIcons.github,
        'Facebook': FontAwesomeIcons.facebook,
        'Twitter': FontAwesomeIcons.twitter,
        'Amazon': FontAwesomeIcons.amazon,
        'Microsoft': FontAwesomeIcons.microsoft,
        'Apple': FontAwesomeIcons.apple,
        'Dropbox': FontAwesomeIcons.dropbox,
        'Slack': FontAwesomeIcons.slack,
        'Steam': FontAwesomeIcons.steam,
        'PayPal': FontAwesomeIcons.paypal,
        'Reddit': FontAwesomeIcons.reddit,
        'Twitch': FontAwesomeIcons.twitch,
      };

      for (final service in services.entries) {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: ServiceIcon(issuer: service.key),
            ),
          ),
        );

        final iconFinder = find.byWidgetPredicate(
          (widget) => widget is FaIcon && widget.icon == service.value,
        );
        expect(iconFinder, findsOneWidget,
            reason: 'Icon not found for ${service.key}');
      }
    });

    testWidgets('renders default icon for unknown service',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Material(
            child: ServiceIcon(issuer: 'UnknownService'),
          ),
        ),
      );

      final iconFinder = find.byWidgetPredicate(
        (widget) => widget is FaIcon && widget.icon == FontAwesomeIcons.shield,
      );
      expect(iconFinder, findsOneWidget);
    });

    testWidgets('handles case insensitive service names',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Material(
            child: ServiceIcon(issuer: 'gOoGlE'),
          ),
        ),
      );

      final iconFinder = find.byWidgetPredicate(
        (widget) => widget is FaIcon && widget.icon == FontAwesomeIcons.google,
      );
      expect(iconFinder, findsOneWidget);
    });

    testWidgets('applies custom size and color', (WidgetTester tester) async {
      const customSize = 40.0;
      const customColor = Colors.red;

      await tester.pumpWidget(
        const MaterialApp(
          home: Material(
            child: ServiceIcon(
              issuer: 'Google',
              size: customSize,
              color: customColor,
            ),
          ),
        ),
      );

      final icon = tester.widget<FaIcon>(find.byType(FaIcon));
      expect(icon.size, equals(customSize));
      expect(icon.color, equals(customColor));
    });
  });
}
