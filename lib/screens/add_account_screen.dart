import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mpflutter_core/mpflutter_core.dart';
import 'package:mpflutter_wechat_api/mpflutter_wechat_api.dart';
import '../models/otp_account.dart';
import '../widgets/qr_scanner.dart';
import '../services/localization_service.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _secretController = TextEditingController();
  final _issuerController = TextEditingController();
  final _urlController = TextEditingController();
  bool _isUrlMode = true;

  @override
  Widget build(BuildContext context) {
    final l10n = LocalizationService.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('add_account')),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
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
              ElevatedButton.icon(
                onPressed: _scanQRCode,
                icon: const Icon(Icons.qr_code_scanner),
                label: Text(l10n.translate('scan_qr_code')),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_isUrlMode) {
                      try {
                        final account =
                            OTPAccount.fromUri(Uri.parse(_urlController.text));
                        Navigator.pop(context, account);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('${l10n.translate('invalid_url')}: $e'),
                          ),
                        );
                      }
                    } else {
                      Navigator.pop(
                        context,
                        OTPAccount(
                          name: _nameController.text,
                          secret: _secretController.text,
                          issuer: _issuerController.text,
                        ),
                      );
                    }
                  }
                },
                child: Text(l10n.translate('add_account')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _scanQRCode() async {
    final currentContext = context;
    final l10n = LocalizationService.of(context);

    try {
      // ignore: prefer_typing_uninitialized_variables
      var qrCode;

      if (kIsMPFlutterWechat || kIsMPFlutterDevmode) {
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
          _isUrlMode = true; // Switch to URL mode
          _urlController.text = qrCode;
          final account = OTPAccount.fromUri(Uri.parse(qrCode));
          _nameController.text = account.name;
          _secretController.text = account.secret;
          _issuerController.text = account.issuer;
        });
      }

      if (!currentContext.mounted) return;
    } catch (e) {
      if (!currentContext.mounted) return;
      ScaffoldMessenger.of(currentContext).showSnackBar(
        SnackBar(
          content: Text('${l10n.translate('invalid_url')}: $e'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _secretController.dispose();
    _issuerController.dispose();
    _urlController.dispose();
    super.dispose();
  }
}
