// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comments _$CommentsFromJson(Map<String, dynamic> json) => Comments(
      feedbackId: json['feedbackId'] as int,
      userName: json['userName'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$CommentsToJson(Comments instance) => <String, dynamic>{
      'feedbackId': instance.feedbackId,
      'content': instance.content,
      'userName': instance.userName,
    };
