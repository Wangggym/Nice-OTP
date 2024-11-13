import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:two_factor_authentication/widgets/qr_scanner.dart';
import 'package:two_factor_authentication/services/localization_service.dart';

class MockLocalizationService extends LocalizationService {
  MockLocalizationService() : super(const Locale('en'));

  @override
  String translate(String key, {Map<String, String>? args}) => key;
}

void main() {
  setUp(() {
    LocalizationService.instance = MockLocalizationService();
  });

  group('QRScanner Tests', () {
    testWidgets('renders correctly on desktop platforms',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: QRScanner(),
        ),
      );

      expect(find.text('scan_qr_code_desktop'), findsOneWidget);
      expect(find.text('scan_qr_position_hint'), findsOneWidget);
    });
  });
}
