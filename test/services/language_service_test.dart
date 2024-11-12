import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:two_factor_authentication/services/language_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  test('getSelectedLocale returns default locale when no preference is set',
      () async {
    final locale = await LanguageService.getSelectedLocale();
    expect(locale.languageCode, 'zh');
  });

  test('setLocale and getSelectedLocale work correctly', () async {
    const testLocale = Locale('en');
    await LanguageService.setLocale(testLocale);
    final locale = await LanguageService.getSelectedLocale();
    expect(locale.languageCode, 'en');
  });

  test('supportedLocales contains correct locales', () {
    expect(LanguageService.supportedLocales.length, 3);
    expect(LanguageService.supportedLocales['English']?.languageCode, 'en');
    expect(LanguageService.supportedLocales['简体中文']?.languageCode, 'zh');
    expect(LanguageService.supportedLocales['日本語']?.languageCode, 'ja');
  });
}
