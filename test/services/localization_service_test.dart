import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:two_factor_authentication/services/localization_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalizationService', () {
    test('creates instance with correct locale', () {
      const locale = Locale('en');
      final service = LocalizationService(locale);
      expect(service.locale, locale);
    });

    test('LocalizationDelegate supports correct locales', () {
      const delegate = LocalizationDelegate();
      expect(delegate.isSupported(const Locale('en')), true);
      expect(delegate.isSupported(const Locale('zh')), true);
      expect(delegate.isSupported(const Locale('ja')), true);
      expect(delegate.isSupported(const Locale('invalid')), false);
    });

    test('translate returns key when translation is not found', () async {
      const locale = Locale('en');
      final service = LocalizationService(locale);
      const testKey = 'non.existent.key';
      expect(service.translate(testKey), testKey);
    });
  });
}
