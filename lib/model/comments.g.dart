// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comments _$CommentsFromJson(Map<String, dynamic> json) => Comments(
      feedbackId: json['feedbackId'] as int,
      userName: json['userName'] as String,
      content: json['content'] as String,
      avatar: json['avatar'] as String,
      creatatedAt: DateTime.parse(json['creatatedAt'] as String),
    );

Map<String, dynamic> _$CommentsToJson(Comments instance) => <String, dynamic>{
      'feedbackId': instance.feedbackId,
      'content': instance.content,
      'userName': instance.userName,
      'avatar': instance.avatar,
      'creatatedAt': instance.creatatedAt.toIso8601String(),
    };
