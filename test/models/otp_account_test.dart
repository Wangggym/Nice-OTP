import 'package:flutter_test/flutter_test.dart';
import 'package:two_factor_authentication/models/otp_account.dart';

void main() {
  group('OTPAccount', () {
    test('creates instance with required parameters', () {
      final account = OTPAccount(
        name: 'Test User',
        secret: 'TESTSECRET',
        issuer: 'Test Issuer',
      );

      expect(account.name, 'Test User');
      expect(account.secret, 'TESTSECRET');
      expect(account.issuer, 'Test Issuer');
    });

    test('fromJson creates instance correctly', () {
      final json = {
        'name': 'Test User',
        'secret': 'TESTSECRET',
        'issuer': 'Test Issuer',
      };

      final account = OTPAccount.fromJson(json);

      expect(account.name, 'Test User');
      expect(account.secret, 'TESTSECRET');
      expect(account.issuer, 'Test Issuer');
    });

    test('toJson converts instance to map correctly', () {
      final account = OTPAccount(
        name: 'Test User',
        secret: 'TESTSECRET',
        issuer: 'Test Issuer',
      );

      final json = account.toJson();

      expect(json['name'], 'Test User');
      expect(json['secret'], 'TESTSECRET');
      expect(json['issuer'], 'Test Issuer');
    });

    test('fromUri parses otpauth URI correctly', () {
      final uri = Uri.parse(
          'otpauth://totp/Test%20Issuer:Test%20User?secret=TESTSECRET&issuer=Test%20Issuer');

      final account = OTPAccount.fromUri(uri);

      expect(account.name, 'Test User');
      expect(account.secret, 'TESTSECRET');
      expect(account.issuer, 'Test Issuer');
    });

    test('fromUri handles URI without issuer in parameters', () {
      final uri = Uri.parse(
          'otpauth://totp/Test%20Issuer:Test%20User?secret=TESTSECRET');

      final account = OTPAccount.fromUri(uri);

      expect(account.name, 'Test User');
      expect(account.secret, 'TESTSECRET');
      expect(account.issuer, 'Test Issuer');
    });

    test('fromUri handles URI without issuer in label', () {
      final uri = Uri.parse(
          'otpauth://totp/Test%20User?secret=TESTSECRET&issuer=Test%20Issuer');

      final account = OTPAccount.fromUri(uri);

      expect(account.name, 'Test User');
      expect(account.secret, 'TESTSECRET');
      expect(account.issuer, 'Test Issuer');
    });

    test('fromUri throws FormatException for invalid URI', () {
      final invalidUri = Uri.parse('invalid://uri');

      expect(
        () => OTPAccount.fromUri(invalidUri),
        throwsA(isA<FormatException>()),
      );
    });

    test('fromUri throws FormatException for missing secret', () {
      final uriWithoutSecret =
          Uri.parse('otpauth://totp/Test%20Issuer:Test%20User');

      expect(
        () => OTPAccount.fromUri(uriWithoutSecret),
        throwsA(isA<FormatException>()),
      );
    });

    test('toString returns formatted string', () {
      final account = OTPAccount(
        name: 'Test User',
        secret: 'TESTSECRET',
        issuer: 'Test Issuer',
      );

      expect(account.toString(), 'Test Issuer: Test User');
    });

    test('== operator compares correctly', () {
      final account1 = OTPAccount(
        name: 'Test User',
        secret: 'TESTSECRET',
        issuer: 'Test Issuer',
      );

      final account2 = OTPAccount(
        name: 'Test User',
        secret: 'TESTSECRET',
        issuer: 'Test Issuer',
      );

      final account3 = OTPAccount(
        name: 'Different User',
        secret: 'TESTSECRET',
        issuer: 'Test Issuer',
      );

      expect(account1 == account2, true);
      expect(account1 == account3, false);
    });

    test('hashCode is consistent', () {
      final account1 = OTPAccount(
        name: 'Test User',
        secret: 'TESTSECRET',
        issuer: 'Test Issuer',
      );

      final account2 = OTPAccount(
        name: 'Test User',
        secret: 'TESTSECRET',
        issuer: 'Test Issuer',
      );

      expect(account1.hashCode == account2.hashCode, true);
    });
  });
}
