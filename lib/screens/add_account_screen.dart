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
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Account Name',
                  hintText: 'Enter account name (e.g. johndoe@example.com)',
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
                  hintText: 'Enter secret key or scan QR code',
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
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QRScanner()),
                  );
                  if (result != null && result is String) {
                    try {
                      final uri = Uri.parse(result);
                      final account = OTPAccount.fromUri(uri);
                      setState(() {
                        _nameController.text = account.name;
                        _secretController.text = account.secret;
                        _issuerController.text = account.issuer ?? '';
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Invalid QR code: $e')),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan QR Code'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(
                      context,
                      OTPAccount(
                        name: _nameController.text,
                        secret: _secretController.text,
                        issuer: _issuerController.text,
                      ),
                    );
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

  @override
  void dispose() {
    _nameController.dispose();
    _secretController.dispose();
    _issuerController.dispose();
    super.dispose();
  }
}
