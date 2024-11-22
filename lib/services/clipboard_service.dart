import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mpflutter_core/mpflutter_core.dart';
import 'package:mpflutter_wechat_api/mpflutter_wechat_api.dart';

class ClipboardService {
  /// Copies the given text to clipboard and returns a Future that completes when the operation is done
  static Future<void> copyToClipboard(String text) async {
    if (kIsMPFlutterWechat || kIsMPFlutterDevmode) {
      // 微信小程序环境
      wx.setClipboardData(
        SetClipboardDataOption()
          ..data = text
          ..success = (res) {
            if (kDebugMode) {
              print('Copied to clipboard: $res');
            }
          }
          ..fail = (res) {
            if (kDebugMode) {
              print('Failed to copy to clipboard: $res');
            }
          },
      );
    } else {
      // Flutter 原生环境
      await Clipboard.setData(ClipboardData(text: text));
    }
  }

  /// Copies OTP to clipboard by removing spaces
  static Future<void> copyOTP(String otp) async {
    await copyToClipboard(otp.replaceAll(' ', ''));
  }
}
