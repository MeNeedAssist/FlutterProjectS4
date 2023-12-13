import 'package:json_annotation/json_annotation.dart';
import 'package:project_s4/model/question.dart';
part 'test_result.g.dart';

@JsonSerializable()
class TestResult {
  late List<Question> questions;
  late bool passed;
  late int totalAnswer;
  late int correctAnswer;
  late int score;
  late int gainGem;
  late int oldLevel;
  late int newLevel;
  late int oldExp;
  late int newExp;
  late String resultMessage;

  TestResult({
    required this.questions,
    required this.passed,
    required this.totalAnswer,
    required this.correctAnswer,
    required this.score,
    required this.gainGem,
    required this.oldExp,
    required this.newExp,
    required this.oldLevel,
    required this.newLevel,
    required this.resultMessage,
  });
  factory TestResult.fromJson(Map<String, dynamic> json) =>
      _$TestResultFromJson(json);

  Map<String, dynamic> toJson() => _$TestResultToJson(this);
}
