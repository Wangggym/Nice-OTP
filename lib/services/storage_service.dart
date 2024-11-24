import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_factor_authentication/services/otp_service.dart';
import '../models/otp_account.dart';

class StorageService {
  static const String _key = 'otp_accounts';
  static const String _pinnedKey = 'pinned_accounts';
  static const int maxAccounts = 15;

  static Future<void> saveAccounts(List<OTPAccount> accounts) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      accounts.map((account) => account.toJson()).toList(),
    );
    await prefs.setString(_key, encodedData);
  }

  static Future<List<OTPAccount>> loadAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(_key);
    if (encodedData == null) {
      return [];
    }
    final List<dynamic> decodedData = json.decode(encodedData);
    return decodedData.map((item) => OTPAccount.fromJson(item)).toList();
  }

  static Future<void> savePinnedAccounts(
      List<String> pinnedAccountNames) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_pinnedKey, pinnedAccountNames);
  }

  static Future<List<String>> loadPinnedAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_pinnedKey) ?? [];
  }

  static Future<bool> canAddMoreAccounts() async {
    return (await loadAccounts()).length < maxAccounts;
  }

  static OTPAccount addRandomAccount() {
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

    final account = OTPAccount(
      name: "Account ${DateTime.now().millisecondsSinceEpoch}",
      secret: OTPService.generateRandomSecret(),
      issuer: randomIssuer,
    );
    return account;
  }
}
