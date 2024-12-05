import 'package:json_annotation/json_annotation.dart';

part 'otp_token.g.dart';

@JsonSerializable()
class OTPToken {
  final String id;
  final String name;
  final String secret;
  final String issuer;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;

  OTPToken({
    required this.id,
    required this.name,
    required this.secret,
    required this.issuer,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory OTPToken.fromJson(Map<String, dynamic> json) =>
      _$OTPTokenFromJson(json);

  Map<String, dynamic> toJson() => _$OTPTokenToJson(this);
}
