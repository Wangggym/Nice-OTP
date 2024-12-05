import 'package:flutter/material.dart';

import '../models/otp_account.dart';
import '../services/localization_service.dart';
import '../services/storage_service.dart';
import 'edit_account_screen.dart';
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
  List<OTPAccount> _accounts = [];
  List<String> _pinnedAccountNames = [];
  int _selectedIndex = 0;
  Future<void>? _homeTabFuture;
  Future<void>? _addTabFuture;
  Future<void>? _profileTabFuture;
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _loadAccounts();
    _homeTabFuture = home_tab.loadLibrary();
    _addTabFuture = add_tab.loadLibrary();
    _profileTabFuture = profile_tab.loadLibrary();
  }

  Future<void> _loadAccounts() async {
    final accounts = await _storageService.loadAccounts();
    final pinnedNames = await _storageService.loadPinnedAccounts();
    setState(() {
      _accounts = accounts;
      _pinnedAccountNames = pinnedNames;
      _sortAccounts();
    });
  }

  void _sortAccounts() {
    _accounts.sort((a, b) {
      final isPinnedA = _pinnedAccountNames.contains(a.name);
      final isPinnedB = _pinnedAccountNames.contains(b.name);
      if (isPinnedA && !isPinnedB) return -1;
      if (!isPinnedA && isPinnedB) return 1;
      return a.name.compareTo(b.name);
    });
  }

  Future<void> _saveAccounts() async {
    await _storageService.saveAccounts(_accounts);
    await _storageService.savePinnedAccounts(_pinnedAccountNames);
  }

  void _deleteAccount(OTPAccount account) {
    setState(() {
      _accounts.removeWhere((a) => a.name == account.name);
      _pinnedAccountNames.remove(account.name);
    });
    _saveAccounts();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          LocalizationService.of(context).translate(
            'has_been_deleted',
            args: {'name': account.name},
          ),
        ),
      ),
    );
  }

  void _editAccount(OTPAccount account) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAccountScreen(account: account),
      ),
    );

    if (result != null && result is OTPAccount) {
      setState(() {
        final index = _accounts.indexWhere(
            (a) => a.name == account.name && a.secret == account.secret);
        if (index != -1) {
          _accounts[index] = result;
          _sortAccounts();
        }
      });
      _saveAccounts();
    }
  }

  void _pinAccount(OTPAccount account) {
    setState(() {
      if (_pinnedAccountNames.contains(account.name)) {
        _pinnedAccountNames.remove(account.name);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              LocalizationService.of(context).translate(
                'has_been_unpinned',
                args: {'name': account.name},
              ),
            ),
          ),
        );
      } else {
        _pinnedAccountNames.add(account.name);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              LocalizationService.of(context).translate(
                'has_been_pinned',
                args: {'name': account.name},
              ),
            ),
          ),
        );
      }
      _sortAccounts();
    });
    _saveAccounts();
  }

  void _onAccountAdded(OTPAccount account) {
    setState(() {
      _accounts.add(account);
      _sortAccounts();
      _selectedIndex = 0;
    });
    _saveAccounts();
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
                accounts: _accounts,
                pinnedAccountNames: _pinnedAccountNames,
                onAccountAdded: _onAccountAdded,
                onDelete: _deleteAccount,
                onEdit: _editAccount,
                onPin: _pinAccount,
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
                onAccountAdded: _onAccountAdded,
                onAccountDeleteAll: () {
                  setState(() {
                    _accounts = [];
                    _pinnedAccountNames = [];
                    _selectedIndex = 0;
                  });
                  _saveAccounts();
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
          if (index == 1 && !(await _storageService.canAddMoreAccounts())) {
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
