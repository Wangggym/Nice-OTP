import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:two_factor_authentication/services/localization_service.dart';

@GenerateMocks([BuildContext])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalizationService', () {
    late LocalizationService service;

    setUp(() async {
      service = LocalizationService(const Locale('en'));
      LocalizationService.instance = service;
      // 加载测试用的翻译文件
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        return ByteData.sublistView(Uint8List.fromList(
            '{"test.key": "Test {name} with {value}"}'.codeUnits));
      });
      await service.loadTranslations();
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', null);
    });

    test('creates instance with correct locale', () {
      const locale = Locale('en');
      final service = LocalizationService(locale);
      expect(service.locale, locale);
      expect(LocalizationService.instance, service);
    });

    testWidgets('LocalizationService.of returns correct instance',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          home: Builder(
            builder: (context) {
              final result = LocalizationService.of(context);
              expect(result.locale.languageCode, 'en');
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets(
        'LocalizationService.of creates new instance when no instance exists',
        (tester) async {
      LocalizationService.instance = null;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          home: Builder(
            builder: (context) {
              final result = LocalizationService.of(context);
              expect(result, isNotNull);
              expect(result.locale.languageCode, 'en');
              return const SizedBox();
            },
          ),
        ),
      );
    });

    test('load loads translations correctly', () async {
      const locale = Locale('en');
      final service = await LocalizationService.load(locale);
      expect(service.locale, locale);
    });

    test('translate returns key when translation is not found', () {
      const testKey = 'non.existent.key';
      expect(service.translate(testKey), testKey);
    });

    test('translate with parameters replaces correctly', () {
      final result = service.translate(
        'test.key',
        args: {'name': 'Test', 'value': '123'},
      );
      expect(result, 'Test Test with 123');
    });

    test('LocalizationDelegate supports correct locales', () {
      const delegate = LocalizationDelegate();
      expect(delegate.isSupported(const Locale('en')), true);
      expect(delegate.isSupported(const Locale('zh')), true);
      expect(delegate.isSupported(const Locale('ja')), true);
      expect(delegate.isSupported(const Locale('invalid')), false);
    });

    test('LocalizationDelegate load returns LocalizationService', () async {
      const delegate = LocalizationDelegate();
      const locale = Locale('en');

      final service = await delegate.load(locale);
      expect(service, isA<LocalizationService>());
      expect(service.locale, locale);
    });

    test('LocalizationDelegate shouldReload returns false', () {
      const delegate = LocalizationDelegate();
      expect(delegate.shouldReload(delegate), false);
    });
  });
}
