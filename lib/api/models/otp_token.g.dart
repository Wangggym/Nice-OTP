// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OTPToken _$OTPTokenFromJson(Map<String, dynamic> json) => OTPToken(
      id: json['id'] as String? ?? '',
      name: json['name'] as String,
      secret: json['secret'] as String,
      issuer: json['issuer'] as String? ?? '',
      pinnedTime: json['pinned_time'] == null
          ? null
          : DateTime.parse(json['pinned_time'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
    );

Map<String, dynamic> _$OTPTokenToJson(OTPToken instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'secret': instance.secret,
      'issuer': instance.issuer,
      'pinned_time': instance.pinnedTime?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };
