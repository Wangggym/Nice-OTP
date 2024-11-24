import 'package:flutter/material.dart';
import 'package:two_factor_authentication/screens/language_screen.dart';
import 'package:two_factor_authentication/widgets/custom_about_dialog.dart';
import 'package:two_factor_authentication/widgets/wechat_login_button.dart';
import '../../services/localization_service.dart';

class ProfileTab extends StatelessWidget {
  final Function(Locale) onLocaleChanged;
  final Locale currentLocale;

  const ProfileTab({
    super.key,
    required this.onLocaleChanged,
    required this.currentLocale,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = LocalizationService.of(context);

    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.cloud_sync),
          title: Text(l10n.translate('cloud_sync')),
          subtitle: Text(l10n.translate('coming_soon')),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(l10n.translate('cloud_sync')),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.translate('cloud_sync_description')),
                    const SizedBox(height: 16),
                    Text(l10n.translate('coming_soon_message')),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.translate('ok')),
                  ),
                ],
              ),
            );
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
            showDialog(
              context: context,
              builder: (context) => const CustomAboutDialog(),
            );
          },
        ),
        WeChatLoginButton(
          onLoginComplete: (success) {
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('登录成功')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('登录失败')),
              );
            }
          },
        ),
      ],
    );
  }
}
