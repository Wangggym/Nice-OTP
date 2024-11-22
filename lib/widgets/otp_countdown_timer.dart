import 'package:flutter/material.dart';

class OTPCountdownTimer extends StatelessWidget {
  final int remainingSeconds;

  const OTPCountdownTimer({
    super.key,
    required this.remainingSeconds,
  });

  Color _getProgressColor(int seconds) {
    if (seconds <= 5) {
      return Colors.red;
    } else if (seconds <= 10) {
      return Colors.orange;
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final progress = remainingSeconds / 30;

    return SizedBox(
      width: 36,
      height: 36,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 3,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
                _getProgressColor(remainingSeconds)),
            semanticsLabel: 'Circular progress indicator',
          ),
          Text(
            '$remainingSeconds',
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
