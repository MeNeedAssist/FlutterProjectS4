// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievements.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Achievements _$AchievementsFromJson(Map<String, dynamic> json) => Achievements(
      achievementId: json['achievementId'] as int,
      title: json['title'] as String,
      isReceive: json['isReceive'] as bool,
      score: json['score'] as int,
      process: (json['process'] as num).toDouble(),
      badge: json['badge'] as String,
    );

Map<String, dynamic> _$AchievementsToJson(Achievements instance) =>
    <String, dynamic>{
      'achievementId': instance.achievementId,
      'title': instance.title,
      'isReceive': instance.isReceive,
      'score': instance.score,
      'process': instance.process,
      'badge': instance.badge,
    };
