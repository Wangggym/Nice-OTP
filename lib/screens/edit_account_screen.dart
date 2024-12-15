import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:two_factor_authentication/services/clipboard_service.dart';
import '../api/models/otp_token.dart';
import '../services/localization_service.dart';

class EditAccountScreen extends StatefulWidget {
  final OTPToken account;

  const EditAccountScreen({super.key, required this.account});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  late TextEditingController _nameController;
  late TextEditingController _issuerController;
  late String _keyUri;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.account.name);
    _issuerController = TextEditingController(text: widget.account.issuer);
    _keyUri = _generateKeyUri();
  }

  String _generateKeyUri() {
    return 'otpauth://totp/${widget.account.issuer}:${widget.account.name}?secret=${widget.account.secret}&issuer=${widget.account.issuer}';
  }

  void _copyToClipboard(String text) {
    final l10n = LocalizationService.of(context);
    ClipboardService.copyToClipboard(text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.translate('copied'))),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _issuerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = LocalizationService.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('edit_account')),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.save),
                label: Text(l10n.translate('save')),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedAccount = OTPToken(
                      name: _nameController.text,
                      secret: widget.account.secret,
                      issuer: _issuerController.text,
                      id: widget.account.id,
                    );
                    Navigator.pop(context, updatedAccount);
                  }
                },
              ),
            ),
            // First Card - Editable Fields
            Card(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabelText(l10n.translate('issuer')),
                    TextField(
                      controller: _issuerController,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        border: InputBorder.none,
                      ),
                    ),
                    const Divider(),
                    _buildLabelText(l10n.translate('account_name')),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        border: InputBorder.none,
                      ),
                    ),
                    const Divider(),
                    _buildLabelText(l10n.translate('secret_key')),
                    _buildReadOnlyField(widget.account.secret),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                l10n.translate('note_changes'),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
            // Second Card - Key URI
            Card(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabelText(l10n.translate('key_uri')),
                    _buildReadOnlyField(_keyUri),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Third Card - QR Code
            Card(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Center(
                  child: QrImageView(
                    data: _keyUri,
                    version: QrVersions.auto,
                    size: 200.0,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelText(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildReadOnlyField(String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              height: 2,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.copy, size: 20),
          onPressed: () => _copyToClipboard(value),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}
