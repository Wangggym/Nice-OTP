import 'package:flutter/material.dart';
import 'package:two_factor_authentication/store/otp_token_store.dart';

import '../services/localization_service.dart';
import '../manager/cloud_sync_manager.dart';
import 'tabs/home_tab.dart' deferred as home_tab;
import 'tabs/add_tab.dart' deferred as add_tab;
import 'tabs/profile_tab.dart' deferred as profile_tab;

class HomeScreen extends StatefulWidget {
  final Function(Locale) onLocaleChanged;

  const HomeScreen({
    super.key,
    required this.onLocaleChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Future<void>? _homeTabFuture;
  Future<void>? _addTabFuture;
  Future<void>? _profileTabFuture;
  final CloudSyncManager _cloudSync = CloudSyncManager();
  final OTPTokenStore _otpTokenStore = OTPTokenStore();

  @override
  void initState() {
    super.initState();
    _loadAccounts();
    _homeTabFuture = home_tab.loadLibrary();
    _addTabFuture = add_tab.loadLibrary();
    _profileTabFuture = profile_tab.loadLibrary();
  }

  Future<void> _loadAccounts() async {
    await _cloudSync.sync();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = LocalizationService.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Nice OTP',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          FutureBuilder(
            future: _homeTabFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              return home_tab.HomeTab(
                onAddPressed: () => setState(() => _selectedIndex = 1),
              );
            },
          ),
          FutureBuilder(
            future: _addTabFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              return add_tab.AddTab(
                onAccountAdded: (account) {
                  _cloudSync.createToken(account);
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
                onAccountDeleteAll: () {
                  _cloudSync.deleteAllTokens();
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
              );
            },
          ),
          FutureBuilder(
            future: _profileTabFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              return profile_tab.ProfileTab(
                onLocaleChanged: widget.onLocaleChanged,
                currentLocale: Localizations.localeOf(context),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) async {
          if (index == 1 && _otpTokenStore.canAddMoreTokens == false) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.translate('account_limit_reached')),
              ),
            );
          }
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: l10n.translate('accounts'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.add),
            label: l10n.translate('add_account'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: l10n.translate('me'),
          ),
        ],
      ),
    );
  }
}
