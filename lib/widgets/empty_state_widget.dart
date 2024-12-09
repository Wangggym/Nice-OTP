import 'package:flutter/material.dart';
import '../services/localization_service.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onAddPressed;
  final Function() onAccountAdded;
  final bool canAddMoreTokens;

  const EmptyStateWidget({
    super.key,
    required this.onAddPressed,
    required this.onAccountAdded,
    required this.canAddMoreTokens,
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
                if (canAddMoreTokens) {
                  onAccountAdded();
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
