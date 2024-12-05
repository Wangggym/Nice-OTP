// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_create_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenCreateRequest _$TokenCreateRequestFromJson(Map<String, dynamic> json) =>
    TokenCreateRequest(
      name: json['name'] as String,
      secret: json['secret'] as String,
      issuer: json['issuer'] as String,
    );

Map<String, dynamic> _$TokenCreateRequestToJson(TokenCreateRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'secret': instance.secret,
      'issuer': instance.issuer,
    };
