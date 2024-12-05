import 'dart:convert';
import 'dart:math';
import 'package:two_factor_authentication/services/otp_service.dart';

import '../models/otp_account.dart';
import 'storage_manager.dart';

class StorageService {
  static const int maxAccounts = 15;
  final StorageManager _storage = StorageManager();

  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  Future<void> saveAccounts(List<OTPAccount> accounts) async {
    final String encodedData = json.encode(
      accounts.map((account) => account.toJson()).toList(),
    );
    await _storage.setAccounts(encodedData);
  }

  Future<List<OTPAccount>> loadAccounts() async {
    final String? encodedData = await _storage.getAccounts();
    if (encodedData == null) {
      return [];
    }
    final List<dynamic> decodedData = json.decode(encodedData);
    return decodedData.map((item) => OTPAccount.fromJson(item)).toList();
  }

  Future<void> savePinnedAccounts(List<String> pinnedAccountNames) async {
    await _storage.setPinnedAccounts(pinnedAccountNames);
  }

  Future<List<String>> loadPinnedAccounts() async {
    return await _storage.getPinnedAccounts();
  }

  Future<bool> canAddMoreAccounts() async {
    return (await loadAccounts()).length < maxAccounts;
  }

  OTPAccount addRandomAccount() {
    final random = Random();
    final randomIssuers = [
      'Google',
      'GitHub',
      'Facebook',
      'Twitter',
      'Amazon',
      'Microsoft',
      'Apple'
    ];
    final randomIssuer = randomIssuers[random.nextInt(randomIssuers.length)];

    return OTPAccount(
      name: "Account ${DateTime.now().millisecondsSinceEpoch}",
      secret: OTPService.generateRandomSecret(),
      issuer: randomIssuer,
    );
  }
}
