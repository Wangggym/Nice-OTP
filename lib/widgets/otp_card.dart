import 'package:flutter/material.dart';
import '../models/otp_account.dart';
import '../services/otp_service.dart';

class OTPCard extends StatefulWidget {
  final OTPAccount account;

  const OTPCard({super.key, required this.account});

  @override
  State<OTPCard> createState() => _OTPCardState();
}

class _OTPCardState extends State<OTPCard> {
  late String _otp;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _updateOTP();
  }

  void _updateOTP() {
    final otpData = OTPService.generateOTP(widget.account.secret);
    setState(() {
      _otp = otpData.otp;
      _remainingSeconds = otpData.remainingSeconds;
    });
    Future.delayed(Duration(seconds: 1), _updateOTP);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.account.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _otp,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                CircularProgressIndicator(
                  value: _remainingSeconds / 30,
                  strokeWidth: 2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
