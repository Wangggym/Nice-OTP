class OTPAccount {
  final String name;
  final String secret;
  final String issuer;

  OTPAccount({
    required this.name,
    required this.secret,
    required this.issuer,
  });

  factory OTPAccount.fromJson(Map<String, dynamic> json) {
    return OTPAccount(
      name: json['name'] as String,
      secret: json['secret'] as String,
      issuer: json['issuer'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'secret': secret,
      'issuer': issuer,
    };
  }

  factory OTPAccount.fromUri(Uri uri) {
    if (uri.scheme != 'otpauth' || uri.host != 'totp') {
      throw const FormatException('Invalid OTP URI format');
    }

    final secret = uri.queryParameters['secret'];
    if (secret == null || secret.isEmpty) {
      throw const FormatException('Secret is required');
    }

    String name;
    String issuer;

    final path =
        Uri.decodeComponent(uri.path.substring(1)); // Remove leading '/'

    if (path.contains(':')) {
      final parts = path.split(':');
      issuer = parts[0];
      name = parts[1];
    } else {
      name = path;
      issuer = uri.queryParameters['issuer'] ?? '';
    }

    // If issuer is provided in query parameters, it takes precedence
    if (uri.queryParameters['issuer'] != null) {
      issuer = uri.queryParameters['issuer']!;
    }

    return OTPAccount(
      name: name,
      secret: secret,
      issuer: issuer,
    );
  }

  @override
  String toString() => '$issuer: $name';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OTPAccount &&
        other.name == name &&
        other.secret == secret &&
        other.issuer == issuer;
  }

  @override
  int get hashCode => Object.hash(name, secret, issuer);
}
