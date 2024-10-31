import 'package:flutter/material.dart';
import 'package:screen_capturer/screen_capturer.dart';
import 'dart:io' show Platform;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:zxing2/qrcode.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  bool isCapturing = false;
  bool hasScanned = false;

  @override
  Widget build(BuildContext context) {
    // 桌面平台使用屏幕捕获
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Capture QR Code'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isCapturing)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _captureScreen,
                  child: const Text('Capture Screen QR Code'),
                ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Position the QR code on your screen and click the button above to scan it.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
    }
    // 移动平台使用摄像头
    else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Scan QR Code'),
        ),
        body: MobileScanner(
          onDetect: (capture) {
            if (!hasScanned && capture.barcodes.isNotEmpty) {
              final barcode = capture.barcodes.first;
              if (barcode.rawValue != null) {
                hasScanned = true;
                Navigator.pop(context, barcode.rawValue);
              }
            }
          },
        ),
      );
    }
  }

  Future<void> _captureScreen() async {
    setState(() {
      isCapturing = true;
    });

    try {
      // 捕获屏幕
      final capturedData = await ScreenCapturer.instance.capture(
        mode: CaptureMode.region,
      );

      if (capturedData != null && capturedData.imageBytes != null) {
        // 将 CapturedData 转换为 Image
        final image = img.decodeImage(capturedData.imageBytes!);

        if (image != null) {
          // 转换为灰度图像以提高识别率
          final grayscale = img.grayscale(image);

          // 创建 ZXing 的 LuminanceSource
          final luminances = Int32List(grayscale.width * grayscale.height);
          int index = 0;
          for (int y = 0; y < grayscale.height; y++) {
            for (int x = 0; x < grayscale.width; x++) {
              // 获取像素值并提取亮度
              final pixel = grayscale.getPixel(x, y);
              final r = pixel.r.toInt();
              luminances[index++] = r; // 在灰度图中，R=G=B
            }
          }

          final source = RGBLuminanceSource(
            grayscale.width,
            grayscale.height,
            luminances,
          );
          final bitmap = BinaryBitmap(HybridBinarizer(source));

          // 使用 zxing2 解析二维码
          final reader = QRCodeReader();
          try {
            final result = reader.decode(bitmap);
            if (mounted) {
              Navigator.pop(context, result.text);
            }
          } catch (e) {
            throw Exception('No QR code found in the captured area');
          }
        } else {
          throw Exception('Failed to decode captured image');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to capture or decode QR code: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isCapturing = false;
        });
      }
    }
  }
}
