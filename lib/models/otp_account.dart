class OTPAccount {
  final String name;
  final String secret;
  final String issuer;

  OTPAccount({required this.name, required this.secret, required this.issuer});

  // 从 JSON 创建 OTPAccount 对象
  factory OTPAccount.fromJson(Map<String, dynamic> json) {
    return OTPAccount(
      name: json['name'],
      secret: json['secret'],
      issuer: json['issuer'] ?? '',
    );
  }

  // 将 OTPAccount 对象转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'secret': secret,
      'issuer': issuer,
    };
  }

  // New factory method to create OTPAccount from URI
  factory OTPAccount.fromUri(Uri uri) {
    final uriParams = uri.queryParameters;
    final path = uri.path.split(':');

    String name = path.length > 1 ? path[1] : uriParams['accountname'] ?? '';
    String secret = uriParams['secret'] ?? '';
    String issuer = uriParams['issuer'] ?? (path.length > 1 ? path[0] : '');

    return OTPAccount(
      name: name,
      secret: secret,
      issuer: issuer,
    );
  }
}
