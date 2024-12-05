import 'package:json_annotation/json_annotation.dart';
import 'otp_token.dart';

part 'token_operation_response.g.dart';

@JsonSerializable()
class TokenOperationResponse {
  final bool success;
  final List<OTPToken> tokens;
  @JsonKey(name: 'syncTime')
  final DateTime syncTime;

  TokenOperationResponse({
    required this.success,
    required this.tokens,
    required this.syncTime,
  });

  factory TokenOperationResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenOperationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TokenOperationResponseToJson(this);
}
