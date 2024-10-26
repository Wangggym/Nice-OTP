import 'package:flutter/material.dart';
import '../widgets/otp_card.dart';
import '../models/otp_account.dart';
import '../services/otp_service.dart';
import 'add_account_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<OTPAccount> _accounts = [];

  void _addRandomAccount() {
    setState(() {
      _accounts.add(OTPAccount(
        name: "Account ${_accounts.length + 1}",
        secret: OTPService.generateRandomSecret(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2FA Authenticator'),
      ),
      body: ListView.builder(
        itemCount: _accounts.length,
        itemBuilder: (context, index) {
          return OTPCard(account: _accounts[index]);
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _addRandomAccount,
            heroTag: 'addRandom',
            child: const Icon(Icons.shuffle),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddAccountScreen()),
              );
              if (result != null && result is OTPAccount) {
                setState(() {
                  _accounts.add(result);
                });
              }
            },
            heroTag: 'addManual',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
