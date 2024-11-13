import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ServiceIcon extends StatelessWidget {
  final String issuer;
  final double size;
  final Color? color;

  const ServiceIcon({
    super.key,
    required this.issuer,
    this.size = 28.0,
    this.color,
  });

  static final Map<String, IconData> _serviceIcons = {
    'google': FontAwesomeIcons.google,
    'github': FontAwesomeIcons.github,
    'facebook': FontAwesomeIcons.facebook,
    'twitter': FontAwesomeIcons.twitter,
    'amazon': FontAwesomeIcons.amazon,
    'microsoft': FontAwesomeIcons.microsoft,
    'apple': FontAwesomeIcons.apple,
    'dropbox': FontAwesomeIcons.dropbox,
    'slack': FontAwesomeIcons.slack,
    'steam': FontAwesomeIcons.steam,
    'paypal': FontAwesomeIcons.paypal,
    'reddit': FontAwesomeIcons.reddit,
    'twitch': FontAwesomeIcons.twitch,
  };

  IconData get _icon {
    final normalizedIssuer = issuer.toLowerCase();
    return _serviceIcons[normalizedIssuer] ?? FontAwesomeIcons.shield;
  }

  @override
  Widget build(BuildContext context) {
    return FaIcon(
      _icon,
      size: size,
      color: color ?? Colors.black87,
    );
  }
}
