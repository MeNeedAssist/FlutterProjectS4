import 'package:json_annotation/json_annotation.dart';
part 'question.g.dart';

@JsonSerializable()
class Question {
  final int questionId;
  final String content;
  final String answerA;
  final String answerB;
  final String answerC;
  final String answerD;
  late String? answer;
  final String? rightAnswer;

  Question({
    required this.questionId,
    required this.content,
    required this.answerA,
    required this.answerB,
    required this.answerC,
    required this.answerD,
    required this.answer,
    required this.rightAnswer,
  });
  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}
