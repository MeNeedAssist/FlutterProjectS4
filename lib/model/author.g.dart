// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Author _$AuthorFromJson(Map<String, dynamic> json) => Author(
      userId: json['userId'] as int,
      avatar: json['avatar'] as String,
      author: json['author'] as String,
      authorEmail: json['authorEmail'] as String,
      countLesson: json['countLesson'] as int,
      soldLesson: json['soldLesson'] as int,
    );

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      'userId': instance.userId,
      'avatar': instance.avatar,
      'author': instance.author,
      'authorEmail': instance.authorEmail,
      'countLesson': instance.countLesson,
      'soldLesson': instance.soldLesson,
    };
