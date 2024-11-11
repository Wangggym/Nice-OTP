import 'package:flutter/services.dart';

class ClipboardService {
  /// Copies the given text to clipboard and returns a Future that completes when the operation is done
  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  /// Copies OTP to clipboard by removing spaces
  static Future<void> copyOTP(String otp) async {
    await copyToClipboard(otp.replaceAll(' ', ''));
  }
}
