import 'package:mpflutter_core/mpflutter_core.dart';
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
          final user = await _authService.getProfile();
          _userStore.setUser(user);
          return user;
        } catch (e) {
          print('获取用户信息失败: $e');
          // 如果获取失败，清除token
          await clearToken();
          // 继续执行登录流程
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
        print('登录成功，token: ${loginResponse.token}');

        await setToken(loginResponse.token);

        try {
          print('获取用户信息...');
          final user = await _authService.getProfile();
          print('获取用户信息成功: ${user.nickname}');
          _userStore.setUser(user);
          return user;
        } catch (e) {
          print('获取用户信息失败，但保留token: $e');
          // 即使获取用户信息失败，也不清除token
          return null;
        }
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
