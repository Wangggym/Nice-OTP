import 'dart:math';
import 'package:crypto/crypto.dart';

import 'package:flutter/foundation.dart';

class OTPService {
  static OTPData generateOTP(String secret,
      {int timeStep = 30, int digits = 6}) {
    try {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final step = now ~/ timeStep;
      final hmac = Hmac(sha1, Base32.decode(secret));
      final hmacResult = hmac.convert(intToBytes(step));
      final offset = hmacResult.bytes[hmacResult.bytes.length - 1] & 0xf;
      final binary = ByteData.sublistView(Uint8List.fromList(
                  hmacResult.bytes.sublist(offset, offset + 4)))
              .getUint32(0, Endian.big) &
          0x7fffffff;
      final otp = binary % pow(10, digits).toInt();
      final remainingSeconds = timeStep - (now % timeStep);
      return OTPData(
        otp: otp.toString().padLeft(digits, '0'),
        remainingSeconds: remainingSeconds,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to generate OTP: $e');
      }
      return OTPData(otp: '000000', remainingSeconds: 30);
    }
  }

  static List<int> intToBytes(int value) {
    var result = Uint8List(8);
    for (int i = 7; i >= 0; i--) {
      result[i] = value & 0xff;
      value >>= 8;
    }
    return result;
  }

  static String generateRandomSecret() {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    Random rnd = Random.secure();
    return String.fromCharCodes(Iterable.generate(
        32, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }
}

class OTPData {
  final String otp;
  final int remainingSeconds;

  OTPData({required this.otp, required this.remainingSeconds});
}

class Base32 {
  static List<int> decode(String input) {
    const String alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    final List<int> output = [];
    int buffer = 0;
    int bitsLeft = 0;

    for (int i = 0; i < input.length; i++) {
      final int val = alphabet.indexOf(input[i].toUpperCase());
      if (val == -1) continue;
      buffer = (buffer << 5) | val;
      bitsLeft += 5;
      if (bitsLeft >= 8) {
        output.add((buffer >> (bitsLeft - 8)) & 0xFF);
        bitsLeft -= 8;
      }
    }

    return output;
  }
}
