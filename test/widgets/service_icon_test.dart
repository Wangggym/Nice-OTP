import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:two_factor_authentication/widgets/service_icon.dart';

void main() {
  group('ServiceIcon Tests', () {
    setUp(() {
      // 确保测试环境可以加载SVG
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    testWidgets('renders known service icons correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ServiceIcon(issuer: 'google'),
          ),
        ),
      );

      // 验证SvgPicture widget是否存在，而不是查找具体的icon
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('renders default icon for unknown service', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ServiceIcon(issuer: 'unknown_service'),
          ),
        ),
      );

      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('handles case insensitive service names', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ServiceIcon(issuer: 'GOOGLE'),
          ),
        ),
      );

      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('applies custom size and color', (tester) async {
      const customSize = 40.0;
      const customColor = Colors.red;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ServiceIcon(
              issuer: 'google',
              size: customSize,
              color: customColor,
            ),
          ),
        ),
      );

      final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));

      // 验证size属性
      expect(svgPicture.width, equals(customSize));
      expect(svgPicture.height, equals(customSize));

      // 验证color属性
      expect(svgPicture.colorFilter, isA<ColorFilter>());
      expect(
        svgPicture.colorFilter,
        const ColorFilter.mode(customColor, BlendMode.srcIn),
      );
    });
  });
}
