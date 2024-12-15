import 'package:flutter/foundation.dart';

import 'package:mpflutter_core/mpflutter_core.dart';
import 'package:mpflutter_wechat_api/mpflutter_wechat_api.dart';
import 'package:two_factor_authentication/app.dart';
import 'package:two_factor_authentication/config/env_config.dart';

void main() async {
  await EnvConfig().initialize(Environment.dev);
  runMPApp(const MyApp());

  /**
   * 务必保留这段代码，否则第一次调用 wx 接口会提示异常。
   */
  if (kIsMPFlutter) {
    try {
      wx.$$context$$;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to initialize wx context: $e');
      }
    }
  }

  /**
   * 使用 AppDelegate 响应应用生命周期事件、分享事件。
   */
  // ignore: unused_local_variable
  final appDelegate = MyAppDelegate();
}
