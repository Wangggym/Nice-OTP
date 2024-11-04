import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/otp_account.dart';
import '../services/otp_service.dart';
import 'account_options_menu.dart';
import 'press_animation_widget.dart';
import 'copy_animated_text.dart';

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

class _OTPCardState extends State<OTPCard> with SingleTickerProviderStateMixin {
  late String _otp;
  late int _remainingSeconds;
  AnimationController? _animationController;
  final GlobalKey<CopyAnimatedTextState> _copyTextKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    _updateOTP();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _updateOTP() {
    final otpData = OTPService.generateOTP(widget.account.secret);
    setState(() {
      _otp = _formatOTP(otpData.otp);
      _remainingSeconds = otpData.remainingSeconds;
    });
    _animationController?.value = _remainingSeconds / 30; // 从剩余时间比例开始
    _animationController?.animateTo(0,
        duration: Duration(seconds: _remainingSeconds)); // 动画到0
    Future.delayed(const Duration(seconds: 1), _updateOTP);
  }

  String _formatOTP(String otp) {
    return '${otp.substring(0, 3)} ${otp.substring(3)}';
  }

  Color _getProgressColor() {
    if (_remainingSeconds <= 5) {
      return Colors.red;
    } else if (_remainingSeconds <= 10) {
      return Colors.orange;
    }
    return Colors.blue;
  }

  void _copyOTPToClipboard() {
    Clipboard.setData(ClipboardData(text: _otp.replaceAll(' ', '')));
    _copyTextKey.currentState?.triggerCopy();
  }

  IconData _getServiceIcon() {
    switch (widget.account.issuer.toLowerCase()) {
      case 'google':
        return FontAwesomeIcons.google;
      case 'github':
        return FontAwesomeIcons.github;
      case 'facebook':
        return FontAwesomeIcons.facebook;
      case 'twitter':
        return FontAwesomeIcons.twitter;
      case 'amazon':
        return FontAwesomeIcons.amazon;
      case 'microsoft':
        return FontAwesomeIcons.microsoft;
      case 'apple':
        return FontAwesomeIcons.apple;
      case 'dropbox':
        return FontAwesomeIcons.dropbox;
      case 'slack':
        return FontAwesomeIcons.slack;
      case 'steam':
        return FontAwesomeIcons.steam;
      case 'paypal':
        return FontAwesomeIcons.paypal;
      case 'reddit':
        return FontAwesomeIcons.reddit;
      case 'twitch':
        return FontAwesomeIcons.twitch;
      default:
        return FontAwesomeIcons.shield;
    }
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
              FaIcon(_getServiceIcon(), size: iconSize, color: Colors.black87),
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
              SizedBox(
                width: 36,
                height: 36,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_animationController != null)
                      AnimatedBuilder(
                        animation: _animationController!,
                        builder: (context, child) {
                          return CircularProgressIndicator(
                            value: _animationController!.value,
                            strokeWidth: 3,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                                _getProgressColor()),
                            semanticsLabel: 'Circular progress indicator',
                            semanticsValue:
                                '${(_animationController!.value * 100).toInt()}%',
                          );
                        },
                      ),
                    Text(
                      '$_remainingSeconds',
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
