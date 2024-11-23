import 'package:flutter_test/flutter_test.dart';
import 'package:two_factor_authentication/services/otp_service.dart';

void main() {
  group('OTPService', () {
    test('generateOTP returns correct length OTP', () {
      final secret = OTPService.generateRandomSecret();
      final result = OTPService.generateOTP(secret, now: OTPService.getNow());

      expect(result.otp.length, 6);
      expect(int.tryParse(result.otp), isNotNull);
    });

    test('generateRandomSecret returns 32 character string', () {
      final secret = OTPService.generateRandomSecret();
      expect(secret.length, 32);
      expect(secret, matches(RegExp(r'^[A-Z234567]+$')));
    });

    test('Base32 decode works correctly', () {
      const input = 'JBSWY3DPEHPK3PXP';
      final decoded = Base32.decode(input);
      expect(decoded, isNotEmpty);
    });
  });
}
