import 'dart:convert';
import 'package:flutter/services.dart';

class TestTranslations {
  static Map<String, dynamic>? _translations;

  /// Load translations from json file for specified locale
  static Future<void> load(String locale) async {
    final jsonString =
        await rootBundle.loadString('assets/translations/$locale.json');
    _translations = json.decode(jsonString);
  }

  /// Get translated text for given key
  /// Optional args map for replacing placeholders in translation strings
  static String text(String key, {Map<String, String>? args}) {
    if (_translations == null) {
      throw Exception('Translations not loaded. Call load() first.');
    }

    String translation = _translations![key] ?? key;

    if (args != null) {
      args.forEach((key, value) {
        translation = translation.replaceAll('{$key}', value);
      });
    }

    return translation;
  }
}
