import 'package:flutter/material.dart';

class CopyAnimatedText extends StatefulWidget {
  final String text;
  final VoidCallback onCopy;

  const CopyAnimatedText({
    super.key,
    required this.text,
    required this.onCopy,
  });

  @override
  CopyAnimatedTextState createState() => CopyAnimatedTextState();
}

class CopyAnimatedTextState extends State<CopyAnimatedText> {
  bool _isCopied = false;

  void triggerCopy() {
    _handleCopy();
  }

  void _handleCopy() {
    widget.onCopy();
    setState(() => _isCopied = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isCopied = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: SizedBox(
        width: double.infinity,
        child: Text(
          _isCopied ? 'Copied' : widget.text,
          key: ValueKey<bool>(_isCopied),
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}
