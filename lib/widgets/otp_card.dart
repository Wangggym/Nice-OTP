import 'dart:async';

import 'package:flutter/material.dart';
import '../models/otp_account.dart';
import '../services/otp_service.dart';
import '../services/clipboard_service.dart';
import 'account_options_menu.dart';
import 'press_animation_widget.dart';
import 'copy_animated_text.dart';
import 'service_icon.dart';
import 'otp_countdown_timer.dart';

class OTPCard extends StatefulWidget {
  final OTPAccount account;
  final Function(OTPAccount) onDelete;
  final Function(OTPAccount) onEdit;
  final Function(OTPAccount) onPin;
  final bool isPinned;

  const OTPCard({
    super.key,
    required this.account,
    required this.onDelete,
    required this.onEdit,
    required this.onPin,
    required this.isPinned,
  });

  @override
  State<OTPCard> createState() => _OTPCardState();
}

class _OTPCardState extends State<OTPCard> {
  late String _otp;
  late Timer _timer;
  late int _remainingSeconds;
  final GlobalKey<CopyAnimatedTextState> _copyTextKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _updateOTP();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
        if (_remainingSeconds <= 0) {
          _updateOTP();
        }
      });
    });
  }

  void _updateOTP() {
    final otpData = OTPService.generateOTP(widget.account.secret);
    setState(() {
      _otp = _formatOTP(otpData.otp);
      _remainingSeconds = otpData.remainingSeconds;
    });
  }

  String _formatOTP(String otp) {
    return '${otp.substring(0, 3)} ${otp.substring(3)}';
  }

  void _copyOTPToClipboard() async {
    await ClipboardService.copyOTP(_otp);
    _copyTextKey.currentState?.triggerCopy();
  }

  void _showOptionsMenu(BuildContext context, LongPressStartDetails details) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final position = RelativeRect.fromRect(
      details.globalPosition & const Size(40, 40),
      Offset.zero & overlay.size,
    );

    AccountOptionsMenu.show(
      context: context,
      position: position,
      account: widget.account,
      onDelete: widget.onDelete,
      onEdit: widget.onEdit,
      onPin: widget.onPin,
      onCopy: _copyOTPToClipboard,
      isPinned: widget.isPinned,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const iconSize = 28.0;

    return PressAnimationWidget(
      onTap: _copyOTPToClipboard,
      onLongPressStart: (details) => _showOptionsMenu(context, details),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.isPinned)
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.push_pin, size: 16, color: Colors.amber),
                ),
              ServiceIcon(
                issuer: widget.account.issuer,
                size: iconSize,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CopyAnimatedText(
                      key: _copyTextKey,
                      text: _otp,
                      onCopy: () {},
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${widget.account.issuer}: ${widget.account.name}',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              OTPCountdownTimer(
                remainingSeconds: _remainingSeconds,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
