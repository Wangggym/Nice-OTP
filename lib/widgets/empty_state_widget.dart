import 'package:flutter/material.dart';
import 'package:two_factor_authentication/api/models/otp_token.dart';
import 'package:two_factor_authentication/services/storage_service.dart';
import '../services/localization_service.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onAddPressed;
  final Function(OTPToken) onAccountAdded;

  const EmptyStateWidget({
    super.key,
    required this.onAddPressed,
    required this.onAccountAdded,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = LocalizationService.of(context);
    final storageService = StorageService();

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.translate('no_accounts'),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onAddPressed,
              icon: const Icon(Icons.add),
              label: Text(l10n.translate('add_account')),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                if (await storageService.canAddMoreAccounts()) {
                  onAccountAdded(storageService.addRandomAccount());
                }
              },
              icon: const Icon(Icons.auto_awesome),
              label: Text(l10n.translate('add_random_account')),
            ),
          ],
        ),
      ),
    );
  }
}
