// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      userId: json['userId'] as int,
      email: json['email'] as String?,
      name: json['name'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      avatar: json['avatar'] as String?,
      gem: json['gem'] as int?,
      earned: json['earned'] as int?,
      spent: json['spent'] as int?,
      level: json['level'] as int?,
      exp: json['exp'] as int?,
      achievements: (json['achievements'] as List<dynamic>?)
          ?.map((e) => Achievements.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'name': instance.name,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'avatar': instance.avatar,
      'gem': instance.gem,
      'earned': instance.earned,
      'spent': instance.spent,
      'level': instance.level,
      'exp': instance.exp,
      'achievements': instance.achievements,
    };
