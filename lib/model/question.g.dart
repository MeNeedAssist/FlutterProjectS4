// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      questionId: json['questionId'] as int,
      content: json['content'] as String,
      answerA: json['answerA'] as String,
      answerB: json['answerB'] as String,
      answerC: json['answerC'] as String,
      answerD: json['answerD'] as String,
      answer: json['answer'] as String?,
      rightAnswer: json['rightAnswer'] as String?,
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'questionId': instance.questionId,
      'content': instance.content,
      'answerA': instance.answerA,
      'answerB': instance.answerB,
      'answerC': instance.answerC,
      'answerD': instance.answerD,
      'answer': instance.answer,
      'rightAnswer': instance.rightAnswer,
    };
