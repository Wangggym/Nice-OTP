// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_restore_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenRestoreResponse _$TokenRestoreResponseFromJson(
        Map<String, dynamic> json) =>
    TokenRestoreResponse(
      tokens: (json['tokens'] as List<dynamic>)
          .map((e) => OTPToken.fromJson(e as Map<String, dynamic>))
          .toList(),
      restored: (json['restored'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      syncTime: DateTime.parse(json['syncTime'] as String),
    );

Map<String, dynamic> _$TokenRestoreResponseToJson(
        TokenRestoreResponse instance) =>
    <String, dynamic>{
      'tokens': instance.tokens,
      'restored': instance.restored,
      'total': instance.total,
      'syncTime': instance.syncTime.toIso8601String(),
    };
