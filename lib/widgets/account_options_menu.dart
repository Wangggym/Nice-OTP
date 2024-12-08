import 'package:flutter/material.dart';
import 'package:two_factor_authentication/api/models/otp_token.dart';
import '../services/localization_service.dart';

class AccountOptionsMenu extends StatelessWidget {
  final OTPToken account;
  final Function(OTPToken) onDelete;
  final Function(OTPToken) onEdit;
  final Function(OTPToken) onPin;
  final Function() onCopy;
  final bool isPinned;
  final RelativeRect position;

  const AccountOptionsMenu({
    super.key,
    required this.account,
    required this.onDelete,
    required this.onEdit,
    required this.onPin,
    required this.onCopy,
    required this.isPinned,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = LocalizationService.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMenuItem(
          icon: Icons.copy,
          title: l10n.translate('copy'),
          onTap: () {
            Navigator.pop(context);
            onCopy();
          },
        ),
        _buildMenuItem(
          icon: Icons.edit,
          title: l10n.translate('edit'),
          onTap: () {
            Navigator.pop(context);
            onEdit(account);
          },
        ),
        _buildMenuItem(
          icon: isPinned ? Icons.push_pin : Icons.push_pin_outlined,
          title: l10n.translate(isPinned ? 'unpin' : 'pin'),
          onTap: () {
            Navigator.pop(context);
            onPin(account);
          },
        ),
        _buildMenuItem(
          icon: Icons.delete,
          title: l10n.translate('delete'),
          onTap: () {
            Navigator.pop(context);
            onDelete(account);
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 20),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required RelativeRect position,
    required OTPToken account,
    required Function(OTPToken) onDelete,
    required Function(OTPToken) onEdit,
    required Function(OTPToken) onPin,
    required Function() onCopy,
    required bool isPinned,
  }) {
    return showMenu<T>(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          child: AccountOptionsMenu(
            account: account,
            onDelete: onDelete,
            onEdit: onEdit,
            onPin: onPin,
            onCopy: onCopy,
            isPinned: isPinned,
            position: position,
          ),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 8,
    );
  }
}
