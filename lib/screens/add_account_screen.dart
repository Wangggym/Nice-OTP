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
                onPressed: _scanQRCode,
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

  Future<void> _scanQRCode() async {
    final currentContext = context; // 保存context
    try {
      final qrCode = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const QRScanner(),
        ),
      );

      // 移除不必要的空值检查
      if (qrCode != null) {
        final uri = Uri.parse(qrCode);
        final account = OTPAccount.fromUri(uri);
        setState(() {
          _nameController.text = account.name;
          _secretController.text = account.secret;
          _issuerController.text = account.issuer;
        });
      }

      // 在使用context前检查
      if (!currentContext.mounted) return;
      // 使用context的代码
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
    super.dispose();
  }
}
