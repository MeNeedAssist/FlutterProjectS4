// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lesson _$LessonFromJson(Map<String, dynamic> json) => Lesson(
      id: json['id'] as int,
      featureImage: json['featureImage'] as String?,
      video: json['video'] as String?,
      price: json['price'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      authorName: json['authorName'] as String,
      categoryName: json['categoryName'] as String,
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => Comments.fromJson(e as Map<String, dynamic>))
          .toList(),
      questions: (json['questions'] as List<dynamic>?)
          ?.map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
      passed: json['passed'] as bool,
    );

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
      'id': instance.id,
      'featureImage': instance.featureImage,
      'video': instance.video,
      'price': instance.price,
      'title': instance.title,
      'content': instance.content,
      'authorName': instance.authorName,
      'categoryName': instance.categoryName,
      'comments': instance.comments,
      'questions': instance.questions,
      'passed': instance.passed,
    };
