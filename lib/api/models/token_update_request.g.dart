// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenUpdateRequest _$TokenUpdateRequestFromJson(Map<String, dynamic> json) =>
    TokenUpdateRequest(
      id: json['id'] as String,
      name: json['name'] as String,
      issuer: json['issuer'] as String,
    );

Map<String, dynamic> _$TokenUpdateRequestToJson(TokenUpdateRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'issuer': instance.issuer,
    };
