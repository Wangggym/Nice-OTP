import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:two_factor_authentication/services/storage_service.dart';
import 'package:two_factor_authentication/models/otp_account.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StorageService', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    test('saveAccounts and loadAccounts work correctly', () async {
      final testAccounts = [
        OTPAccount(
          name: 'Test Account',
          issuer: 'Test Issuer',
          secret: 'TESTSECRET',
        ),
      ];

      // 保存账户
      await StorageService.saveAccounts(testAccounts);

      // 加载并验证
      final loadedAccounts = await StorageService.loadAccounts();
      expect(loadedAccounts.length, 1);
      expect(loadedAccounts.first.name, 'Test Account');
      expect(loadedAccounts.first.issuer, 'Test Issuer');
      expect(loadedAccounts.first.secret, 'TESTSECRET');
    });

    test('loadAccounts returns empty list when no data exists', () async {
      final accounts = await StorageService.loadAccounts();
      expect(accounts, isEmpty);
    });

    test('savePinnedAccounts and loadPinnedAccounts work correctly', () async {
      final testPinnedAccounts = ['Account1', 'Account2'];

      // 保存置顶账户
      await StorageService.savePinnedAccounts(testPinnedAccounts);

      // 加载并验证
      final loadedPinnedAccounts = await StorageService.loadPinnedAccounts();
      expect(loadedPinnedAccounts, equals(testPinnedAccounts));
    });

    test('loadPinnedAccounts returns empty list when no data exists', () async {
      final pinnedAccounts = await StorageService.loadPinnedAccounts();
      expect(pinnedAccounts, isEmpty);
    });
  });
}
