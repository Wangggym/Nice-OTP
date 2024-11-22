import 'package:flutter/material.dart';
import '../../models/otp_account.dart';
import '../../widgets/otp_card.dart';
import '../../widgets/empty_state_widget.dart';

class HomeTab extends StatelessWidget {
  final List<OTPAccount> accounts;
  final List<String> pinnedAccountNames;
  final Function(OTPAccount) onDelete;
  final Function(OTPAccount) onEdit;
  final Function(OTPAccount) onPin;
  final Function(OTPAccount) onAccountAdded;
  final VoidCallback onAddPressed;

  const HomeTab({
    super.key,
    required this.accounts,
    required this.pinnedAccountNames,
    required this.onDelete,
    required this.onEdit,
    required this.onPin,
    required this.onAddPressed,
    required this.onAccountAdded,
  });

  @override
  Widget build(BuildContext context) {
    return accounts.isEmpty
        ? EmptyStateWidget(
            onAddPressed: onAddPressed, onAccountAdded: onAccountAdded)
        : ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              return OTPCard(
                account: accounts[index],
                onDelete: onDelete,
                onEdit: onEdit,
                onPin: onPin,
                isPinned: pinnedAccountNames.contains(accounts[index].name),
              );
            },
          );
  }
}
