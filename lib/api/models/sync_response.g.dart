// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncResponse _$SyncResponseFromJson(Map<String, dynamic> json) => SyncResponse(
      success: json['success'] as bool,
      syncTime: DateTime.parse(json['syncTime'] as String),
      error: json['error'] as String? ?? '',
    );

Map<String, dynamic> _$SyncResponseToJson(SyncResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'syncTime': instance.syncTime.toIso8601String(),
      'error': instance.error,
    };
