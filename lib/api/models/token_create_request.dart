import 'package:json_annotation/json_annotation.dart';

part 'token_create_request.g.dart';

@JsonSerializable()
class TokenCreateRequest {
  final String name;
  final String secret;
  final String issuer;

  TokenCreateRequest({
    required this.name,
    required this.secret,
    required this.issuer,
  });

  factory TokenCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$TokenCreateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TokenCreateRequestToJson(this);
}
