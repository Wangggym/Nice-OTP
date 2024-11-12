
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:two_factor_authentication/services/localization_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalizationService Error Cases', () {
    late LocalizationService service;

    setUp(() {
      service = LocalizationService(const Locale('en'));
      LocalizationService.instance = null;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', null);
    });

    testWidgets('LocalizationService.of handles Localizations lookup error',
        (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final result = LocalizationService.of(context);
            expect(result.locale.languageCode, 'en');
            return const SizedBox();
          },
        ),
      );
    });

    test('loadTranslations handles file loading error', () async {
      await service.loadTranslations();
      expect(service.translate('test.key'), 'test.key');
    });

    test('loadTranslations handles JSON decode error', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        return ByteData.sublistView(
            Uint8List.fromList('invalid json'.codeUnits));
      });

      await service.loadTranslations();
      expect(service.translate('test.key'), 'test.key');
    });

    test('translate handles missing translation key', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        return ByteData.sublistView(
            Uint8List.fromList('{"existing.key": "value"}'.codeUnits));
      });

      await service.loadTranslations();
      expect(service.translate('missing.key'), 'missing.key');
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', null);
    });
  });
}
