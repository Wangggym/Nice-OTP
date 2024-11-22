import 'package:flutter/material.dart';
import 'package:two_factor_authentication/models/otp_account.dart';
import 'package:two_factor_authentication/services/storage_service.dart';
import '../services/localization_service.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onAddPressed;
  final Function(OTPAccount) onAccountAdded;

  const EmptyStateWidget({
    super.key,
    required this.onAddPressed,
    required this.onAccountAdded,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = LocalizationService.of(context);

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
                onAccountAdded(
                  StorageService.addRandomAccount(),
                );
              },
              icon: const Icon(Icons.shuffle),
              label: Text(l10n.translate('add_random_account')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black87,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
