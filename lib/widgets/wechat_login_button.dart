import 'package:flutter/material.dart';

class WeChatLoginButton extends StatefulWidget {
  final Function(bool success)? onLoginComplete;

  const WeChatLoginButton({super.key, this.onLoginComplete});

  @override
  State<WeChatLoginButton> createState() => _WeChatLoginButtonState();
}

class _WeChatLoginButtonState extends State<WeChatLoginButton> {
  final bool _isLoading = false;

  Future<void> _handleLogin() async {}

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : ElevatedButton.icon(
            onPressed: _handleLogin,
            icon: const Icon(Icons.wechat), // 使用微信图标
            label: const Text('微信登录'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          );
  }
}
