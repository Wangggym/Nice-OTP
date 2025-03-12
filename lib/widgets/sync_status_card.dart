import 'package:flutter/material.dart';
import '../services/localization_service.dart';

class SyncStatusCard extends StatelessWidget {
  final VoidCallback onSync;

  const SyncStatusCard({
    super.key,
    required this.onSync,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = LocalizationService.of(context);

    return Card(
      child: ListTile(
        leading: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.amber,
          size: 28,
        ),
        title: Text(
          l10n.translate('data_not_synced'),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          l10n.translate('sync_data_hint'),
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: ElevatedButton(
          onPressed: onSync,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
          child: Text(l10n.translate('sync')),
        ),
      ),
    );
  }
}
