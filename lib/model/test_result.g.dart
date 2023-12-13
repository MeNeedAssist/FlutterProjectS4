// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestResult _$TestResultFromJson(Map<String, dynamic> json) => TestResult(
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
      passed: json['passed'] as bool,
      totalAnswer: json['totalAnswer'] as int,
      correctAnswer: json['correctAnswer'] as int,
      score: json['score'] as int,
      gainGem: json['gainGem'] as int,
      oldExp: json['oldExp'] as int,
      newExp: json['newExp'] as int,
      oldLevel: json['oldLevel'] as int,
      newLevel: json['newLevel'] as int,
      resultMessage: json['resultMessage'] as String,
    );

Map<String, dynamic> _$TestResultToJson(TestResult instance) =>
    <String, dynamic>{
      'questions': instance.questions,
      'passed': instance.passed,
      'totalAnswer': instance.totalAnswer,
      'correctAnswer': instance.correctAnswer,
      'score': instance.score,
      'gainGem': instance.gainGem,
      'oldLevel': instance.oldLevel,
      'newLevel': instance.newLevel,
      'oldExp': instance.oldExp,
      'newExp': instance.newExp,
      'resultMessage': instance.resultMessage,
    };
