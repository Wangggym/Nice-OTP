import 'package:flutter/material.dart';
import '../services/localization_service.dart';

class CustomAboutDialog extends StatelessWidget {
  const CustomAboutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = LocalizationService.of(context);
    final textTheme = Theme.of(context).textTheme;

    String version = "2.0.0";

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.translate('app_name'),
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.translate('version', args: {'version': version}),
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.translate('platform_support_message'),
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '© ${DateTime.now().year} Nice OTP',
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              // const SizedBox(height: 16),
              // Text(
              //   l10n.translate('created_by', args: {'author': 'Wang Yimin'}),
              //   style: textTheme.bodyMedium,
              // ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  l10n.translate('disclaimer'),
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.translate('close')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
