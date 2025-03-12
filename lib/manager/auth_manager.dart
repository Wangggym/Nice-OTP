import 'package:mpflutter_core/mpflutter_core.dart';
import 'package:two_factor_authentication/config/env_config.dart';
import 'package:two_factor_authentication/services/wechat_login_service.dart';

import '../api/services/auth_service.dart';
import 'storage_manager.dart';
import '../store/user_store.dart';

class AuthManager {
  final AuthService _authService = AuthService();
  final StorageManager _storage = StorageManager();
  final UserStore _userStore = UserStore();

  // 单例模式
  static final AuthManager _instance = AuthManager._internal();
  factory AuthManager() => _instance;
  AuthManager._internal();

  String? _cachedToken;

  Future<String?> getToken() async {
    if (_cachedToken != null) return _cachedToken;

    _cachedToken = await _storage.getToken();
    return _cachedToken;
  }

  Future<void> setToken(String token) async {
    _cachedToken = token;
    await _storage.setToken(token);
  }

  Future<void> clearToken() async {
    _cachedToken = null;
    await _storage.removeToken();
    _userStore.clearUser();
  }

  Future<bool> isAuthenticated() async {
    return await getToken() != null;
  }

  authenticate() async {
    try {
      // 检查是否已有token
      if (await isAuthenticated()) {
        try {
          // 尝试获取用户信息
          final response = await _authService.getProfile();
          if (response.success && response.data != null) {
            _userStore.setUser(response.data!);
            return response.data;
          }
          // 如果获取失败，清除token
          await clearToken();
          // 继续执行登录流程
        } catch (e) {
          print('获取用户信息失败: $e');
          await clearToken();
        }
      }

      if (kIsMPFlutterWechat) {
        print('开始微信登录流程');
        final weChatLoginService = WeChatLoginService();

        print('获取微信登录码...');
        final weChatCode = await weChatLoginService.getLoginCode();
        print('获取到微信登录码: $weChatCode');

        print('调用登录接口...');
        final loginResponse = await _authService.login(weChatCode);
        if (!loginResponse.success || loginResponse.data == null) {
          throw Exception('Login failed: ${loginResponse.error}');
        }
        print('登录成功，token: ${loginResponse.data!.token}');

        await setToken(loginResponse.data!.token);
      } else {
        await _storage.setToken(EnvConfig().debugToken);
      }

      try {
        print('获取用户信息...');
        final userResponse = await _authService.getProfile();
        if (userResponse.success && userResponse.data != null) {
          print('获取用户信息成功: ${userResponse.data!.nickname}');
          _userStore.setUser(userResponse.data!);
          return userResponse.data;
        }
        print('获取用户信息失败: ${userResponse.error}');
        return null;
      } catch (e) {
        print('获取用户信息失败，但保留token: $e');
        return null;
      }
    } catch (e, stackTrace) {
      print('登录过程出错:');
      print('错误: $e');
      print('堆栈: $stackTrace');
      await clearToken();
      rethrow;
    }
  }

  // 登出
  Future<void> logout() async {
    await clearToken();
  }
}
