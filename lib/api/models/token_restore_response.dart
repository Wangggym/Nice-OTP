import 'package:json_annotation/json_annotation.dart';
import 'otp_token.dart';

part 'token_restore_response.g.dart';

@JsonSerializable()
class TokenRestoreResponse {
  final List<OTPToken> tokens;
  final int restored;
  final int total;
  @JsonKey(name: 'syncTime')
  final DateTime syncTime;

  TokenRestoreResponse({
    required this.tokens,
    required this.restored,
    required this.total,
    required this.syncTime,
  });

  factory TokenRestoreResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenRestoreResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TokenRestoreResponseToJson(this);
}
