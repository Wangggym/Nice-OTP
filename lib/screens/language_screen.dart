import 'package:flutter/material.dart';
import '../services/language_service.dart';
import '../services/localization_service.dart';

class LanguageScreen extends StatelessWidget {
  final Function(Locale) onLanguageSelected;
  final Locale currentLocale;

  const LanguageScreen({
    super.key,
    required this.onLanguageSelected,
    required this.currentLocale,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = LocalizationService.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('language')),
      ),
      body: ListView.builder(
        itemCount: LanguageService.supportedLocales.length,
        itemBuilder: (context, index) {
          final entry =
              LanguageService.supportedLocales.entries.elementAt(index);
          final isSelected =
              entry.value.languageCode == currentLocale.languageCode;

          return ListTile(
            title: Text(entry.key),
            trailing: isSelected ? const Icon(Icons.check) : null,
            onTap: () {
              onLanguageSelected(entry.value);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
