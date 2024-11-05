import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'selected_language';

  static final Map<String, Locale> supportedLocales = {
    '简体中文': const Locale('zh'),
    'English': const Locale('en'),
    '日本語': const Locale('ja'),
    // 'Español': const Locale('es'),
    // 'Français': const Locale('fr'),
  };

  static Future<Locale> getSelectedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'zh';
    return Locale(languageCode);
  }

  static Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
  }
}
