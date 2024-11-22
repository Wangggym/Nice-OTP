import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mpflutter_core/mpflutter_core.dart';
import 'package:mpflutter_wechat_api/mpflutter_wechat_api.dart';
import '../../models/otp_account.dart';
import '../../services/localization_service.dart';
import '../../widgets/qr_scanner.dart';
import '../../services/storage_service.dart';

class AddTab extends StatelessWidget {
  final Function(OTPAccount) onAccountAdded;
  final Function() onAccountDeleteAll;

  const AddTab({
    super.key,
    required this.onAccountAdded,
    required this.onAccountDeleteAll,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AddAccountForm(
            onAccountAdded: onAccountAdded,
            onAccountDeleteAll: onAccountDeleteAll),
      ),
    );
  }
}

class AddAccountForm extends StatefulWidget {
  final Function(OTPAccount) onAccountAdded;
  final Function() onAccountDeleteAll;

  const AddAccountForm({
    super.key,
    required this.onAccountAdded,
    required this.onAccountDeleteAll,
  });

  @override
  State<AddAccountForm> createState() => _AddAccountFormState();
}

class _AddAccountFormState extends State<AddAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _secretController = TextEditingController();
  final _issuerController = TextEditingController();
  final _urlController = TextEditingController();
  bool _isUrlMode = true;

  @override
  void dispose() {
    _nameController.dispose();
    _secretController.dispose();
    _issuerController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _scanQRCode() async {
    final l10n = LocalizationService.of(context);

    try {
      // ignore: prefer_typing_uninitialized_variables
      var qrCode;

      if (kIsMPFlutterWechat || kIsMPFlutter || kIsMPFlutterDevmode) {
        final completer = Completer<String>();
        wx.scanCode(ScanCodeOption()
          ..success = (result) {
            qrCode = result.result;
            completer.complete(qrCode);
          });
        qrCode = await completer.future;
      } else {
        qrCode = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const QRScanner(),
          ),
        );
      }
      if (qrCode != null) {
        setState(() {
          _isUrlMode = true;
          _urlController.text = qrCode;
          final account = OTPAccount.fromUri(Uri.parse(qrCode));
          _nameController.text = account.name;
          _secretController.text = account.secret;
          _issuerController.text = account.issuer;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.translate('invalid_url')}: $e'),
        ),
      );
    }
  }

  void _handleSubmit() {
    final l10n = LocalizationService.of(context);

    if (_formKey.currentState!.validate()) {
      if (_isUrlMode) {
        try {
          final account = OTPAccount.fromUri(Uri.parse(_urlController.text));
          widget.onAccountAdded(account);
          _clearInputs();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.translate('invalid_url')),
            ),
          );
        }
      } else {
        widget.onAccountAdded(
          OTPAccount(
            name: _nameController.text,
            secret: _secretController.text,
            issuer: _issuerController.text,
          ),
        );
        _clearInputs();
      }
    }
  }

  void _clearInputs() {
    setState(() {
      _urlController.clear();
      _nameController.clear();
      _secretController.clear();
      _issuerController.clear();
    });
  }

  Future<bool> _checkAccountLimit() async {
    final l10n = LocalizationService.of(context);

    if (!(await StorageService.canAddMoreAccounts())) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.translate('account_limit_reached')),
        ),
      );
      return false;
    }
    return true;
  }

  void _addRandomAccount() {
    OTPAccount account = StorageService.addRandomAccount();

    widget.onAccountAdded(account);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = LocalizationService.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(
                value: true,
                label: Text(l10n.translate('by_key_url')),
              ),
              ButtonSegment(
                value: false,
                label: Text(l10n.translate('by_secret_key')),
              ),
            ],
            selected: {_isUrlMode},
            onSelectionChanged: (Set<bool> newSelection) {
              setState(() {
                _isUrlMode = newSelection.first;
              });
            },
          ),
          const SizedBox(height: 16),
          if (_isUrlMode)
            TextFormField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: l10n.translate('url'),
                hintText: l10n.translate('enter_url'),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.translate('please_enter_url');
                }
                if (!value.startsWith('otpauth://')) {
                  return l10n.translate('invalid_url');
                }
                return null;
              },
              onChanged: (url) {
                if (url.startsWith('otpauth://')) {
                  try {
                    final account = OTPAccount.fromUri(Uri.parse(url));
                    setState(() {
                      _nameController.text = account.name;
                      _secretController.text = account.secret;
                      _issuerController.text = account.issuer;
                    });
                  } catch (e) {
                    // Invalid URL format, ignore
                  }
                }
              },
            )
          else
            Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: l10n.translate('account_name'),
                    hintText: l10n.translate('enter_account_name'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.translate('please_enter_account');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _secretController,
                  decoration: InputDecoration(
                    labelText: l10n.translate('secret_key'),
                    hintText: l10n.translate('enter_secret_key'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.translate('please_enter_secret');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _issuerController,
                  decoration: InputDecoration(
                    labelText: l10n.translate('issuer'),
                    hintText: l10n.translate('enter_issuer'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.translate('please_enter_issuer');
                    }
                    return null;
                  },
                ),
              ],
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _scanQRCode,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: Text(l10n.translate('scan_qr_code')),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    if (await _checkAccountLimit()) {
                      _handleSubmit();
                    }
                  },
                  child: Text(l10n.translate('add_account')),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (kDebugMode)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (await _checkAccountLimit()) {
                        _addRandomAccount();
                      }
                    },
                    icon: const Icon(Icons.shuffle),
                    label: Text(l10n.translate('add_random_account')),
                  ),
                ),
              ],
            ),
          if (kDebugMode) const SizedBox(height: 16),
          if (kDebugMode)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final l10n = LocalizationService.of(context);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(l10n.translate('clear_all_accounts')),
                          content: Text(
                              l10n.translate('clear_all_accounts_confirm')),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(l10n.translate('cancel')),
                            ),
                            TextButton(
                              onPressed: () {
                                widget.onAccountDeleteAll();
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        l10n.translate('accounts_cleared')),
                                  ),
                                );
                              },
                              child: Text(l10n.translate('clear')),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete_forever),
                    label: Text(l10n.translate('clear_all_accounts')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
