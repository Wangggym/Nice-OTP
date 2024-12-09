import 'package:json_annotation/json_annotation.dart';
import 'otp_token.dart';

part 'token_list_response.g.dart';

@JsonSerializable()
class TokenListResponse {
  final List<OTPToken> tokens;
  final int total;

  TokenListResponse({
    required this.tokens,
    required this.total,
  });

  factory TokenListResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TokenListResponseToJson(this);
}
