// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_operation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenOperationResponse _$TokenOperationResponseFromJson(
        Map<String, dynamic> json) =>
    TokenOperationResponse(
      success: json['success'] as bool,
      tokens: (json['tokens'] as List<dynamic>)
          .map((e) => OTPToken.fromJson(e as Map<String, dynamic>))
          .toList(),
      syncTime: DateTime.parse(json['syncTime'] as String),
      error: json['error'] as String? ?? '',
    );

Map<String, dynamic> _$TokenOperationResponseToJson(
        TokenOperationResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'tokens': instance.tokens,
      'syncTime': instance.syncTime.toIso8601String(),
      'error': instance.error,
    };
