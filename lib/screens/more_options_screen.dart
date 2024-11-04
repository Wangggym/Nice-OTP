import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'language_screen.dart';
import '../services/localization_service.dart';

class MoreOptionsScreen extends StatelessWidget {
  final Function() onAddRandomAccount;
  final Function(Locale) onLocaleChanged;
  final Locale currentLocale;

  const MoreOptionsScreen({
    super.key,
    required this.onAddRandomAccount,
    required this.onLocaleChanged,
    required this.currentLocale,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = LocalizationService.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('more_options')),
      ),
      body: ListView(
        children: [
          if (kDebugMode)
            ListTile(
              leading: const Icon(Icons.shuffle),
              title: Text(l10n.translate('add_random_account')),
              onTap: () {
                onAddRandomAccount();
                Navigator.pop(context);
              },
            ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.translate('language')),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LanguageScreen(
                    onLanguageSelected: onLocaleChanged,
                    currentLocale: currentLocale,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.translate('about')),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: l10n.translate('app_name'),
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2024 Auth2',
              );
            },
          ),
        ],
      ),
    );
  }
}
