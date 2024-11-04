import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocalizationService {
  late final Locale locale;
  static LocalizationService? instance;
  Map<String, String> _localizedStrings = {};

  LocalizationService(this.locale) {
    instance = this;
  }

  static LocalizationService of(BuildContext context) {
    try {
      final service =
          Localizations.of<LocalizationService>(context, LocalizationService);
      if (service != null) {
        debugPrint('LocalizationService found in Localizations');
        return service;
      }

      if (instance != null) {
        debugPrint('LocalizationService found in static instance');
        return instance!;
      }

      debugPrint(
          'Creating new LocalizationService instance with platform locale');
      return LocalizationService(View.of(context).platformDispatcher.locale);
    } catch (e) {
      debugPrint('Error in LocalizationService.of: $e');
      return LocalizationService(const Locale('en'));
    }
  }

  static Future<LocalizationService> load(Locale locale) async {
    final service = LocalizationService(locale);
    await service.loadTranslations();
    instance = service;
    return service;
  }

  Future<void> loadTranslations() async {
    try {
      final jsonString = await rootBundle
          .loadString('assets/translations/${locale.languageCode}.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });
    } catch (e) {
      debugPrint('Error loading translations: $e');
      if (locale.languageCode != 'en') {
        final jsonString =
            await rootBundle.loadString('assets/translations/en.json');
        Map<String, dynamic> jsonMap = json.decode(jsonString);
        _localizedStrings = jsonMap.map((key, value) {
          return MapEntry(key, value.toString());
        });
      }
    }
  }

  String translate(String key, {Map<String, String>? args}) {
    String translation = _localizedStrings[key] ?? key;

    if (args != null) {
      args.forEach((key, value) {
        translation = translation.replaceAll('{$key}', value);
      });
    }

    return translation;
  }
}

class LocalizationDelegate extends LocalizationsDelegate<LocalizationService> {
  const LocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh', 'ja', 'es', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<LocalizationService> load(Locale locale) {
    return LocalizationService.load(locale);
  }

  @override
  bool shouldReload(LocalizationDelegate old) => false;
}
