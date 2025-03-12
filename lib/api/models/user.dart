import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  @JsonKey(name: 'email', defaultValue: '')
  final String email;
  @JsonKey(name: 'nickname', defaultValue: '')
  final String nickname;
  @JsonKey(name: 'sync_enabled', defaultValue: false)
  bool syncEnabled;

  @JsonKey(name: 'last_sync_at')
  final DateTime? lastSyncAt;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    required this.nickname,
    required this.syncEnabled,
    this.lastSyncAt,
    required this.createdAt,
    required this.updatedAt,
  });

  User copyWith({
    String? id,
    String? email,
    String? nickname,
    bool? syncEnabled,
    DateTime? lastSyncAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      syncEnabled: syncEnabled ?? this.syncEnabled,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
