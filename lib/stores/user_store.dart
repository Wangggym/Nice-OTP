import '../api/models/user.dart';

class UserStore {
  static final UserStore _instance = UserStore._internal();
  factory UserStore() => _instance;
  UserStore._internal();

  User? _currentUser;

  // 获取当前用户信息
  User? get currentUser => _currentUser;

  // 设置当前用户信息
  void setUser(User user) {
    _currentUser = user;
  }

  // 清除用户信息
  void clearUser() {
    _currentUser = null;
  }

  // 检查是否已登录
  bool get isLoggedIn => _currentUser != null;

  // 获取用户昵称（带默认值）
  String get nickname => _currentUser?.nickname ?? 'Guest';

  // 获取用户邮箱（带默认值）
  String get email => _currentUser?.email ?? '';

  // 获取同步状态
  bool get isSyncEnabled => _currentUser?.syncEnabled ?? false;

  // 获取最后同步时间
  DateTime? get lastSyncTime => _currentUser?.lastSyncAt;
}
