import 'package:flutter/material.dart';
import '../models/otp_account.dart';
import '../widgets/qr_scanner.dart';

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
  bool _isUrlMode = true; // Track which input mode is selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Account'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input mode selector
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(
                    value: true,
                    label: Text('By Key URL'),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text('By Secret Key'),
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

              // Show different fields based on mode
              if (_isUrlMode)
                TextFormField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                    labelText: 'URL',
                    hintText: 'Enter otpauth:// URL',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a URL';
                    }
                    if (!value.startsWith('otpauth://')) {
                      return 'Invalid OTP URL format';
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
                      decoration: const InputDecoration(
                        labelText: 'Account Name',
                        hintText:
                            'Enter account name (e.g. johndoe@example.com)',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an account name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _secretController,
                      decoration: const InputDecoration(
                        labelText: 'Secret Key',
                        hintText: 'Enter secret key',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a secret key';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _issuerController,
                      decoration: const InputDecoration(
                        labelText: 'Issuer',
                        hintText: 'Enter issuer (e.g. GitHub, Google)',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an issuer';
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
                label: const Text('Scan QR Code'),
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
                          SnackBar(content: Text('Invalid URL format: $e')),
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
                child: const Text('Add Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _scanQRCode() async {
    final currentContext = context;
    try {
      final qrCode = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const QRScanner(),
        ),
      );

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
        SnackBar(content: Text('Error: $e')),
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
