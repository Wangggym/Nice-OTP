import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:two_factor_authentication/services/clipboard_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = SystemChannels.platform;
  final List<MethodCall> log = <MethodCall>[];

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      log.add(methodCall);
      return null;
    });
    log.clear();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('copyToClipboard copies text correctly', () async {
    const text = 'test text';
    await ClipboardService.copyToClipboard(text);

    expect(log, hasLength(1));
    expect(log.single.method, 'Clipboard.setData');
    expect(log.single.arguments['text'], text);
  });

  test('copyOTP removes spaces and copies correctly', () async {
    const otp = '123 456';
    await ClipboardService.copyOTP(otp);

    expect(log, hasLength(1));
    expect(log.single.method, 'Clipboard.setData');
    expect(log.single.arguments['text'], '123456');
  });
}
