// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenListResponse _$TokenListResponseFromJson(Map<String, dynamic> json) =>
    TokenListResponse(
      tokens: (json['tokens'] as List<dynamic>)
          .map((e) => OTPToken.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$TokenListResponseToJson(TokenListResponse instance) =>
    <String, dynamic>{
      'tokens': instance.tokens,
      'total': instance.total,
    };
