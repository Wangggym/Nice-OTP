import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static const String _tokenKey = 'auth_token';
  static const String _accountsKey = 'otp_accounts';
  static const String _pinnedKey = 'pinned_accounts';

  // 单例模式
  static final StorageManager _instance = StorageManager._internal();
  factory StorageManager() => _instance;
  StorageManager._internal();

  late SharedPreferences _prefs;
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  // Auth Token 相关方法
  Future<String?> getToken() async {
    await init();
    return _prefs.getString(_tokenKey);
  }

  Future<void> setToken(String token) async {
    await init();
    await _prefs.setString(_tokenKey, token);
  }

  Future<void> removeToken() async {
    await init();
    await _prefs.remove(_tokenKey);
  }

  // OTP Accounts 相关方法
  Future<String?> getAccounts() async {
    await init();
    return _prefs.getString(_accountsKey);
  }

  Future<void> setAccounts(String accountsJson) async {
    await init();
    await _prefs.setString(_accountsKey, accountsJson);
  }

  // Pinned Accounts 相关方法
  Future<List<String>> getPinnedAccounts() async {
    await init();
    return _prefs.getStringList(_pinnedKey) ?? [];
  }

  Future<void> setPinnedAccounts(List<String> pinnedAccounts) async {
    await init();
    await _prefs.setStringList(_pinnedKey, pinnedAccounts);
  }

  // 清除所有数据
  Future<void> clearAll() async {
    await init();
    await _prefs.clear();
  }
}
