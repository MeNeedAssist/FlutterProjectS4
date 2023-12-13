import 'package:json_annotation/json_annotation.dart';
import 'package:project_s4/model/comments.dart';
import 'package:project_s4/model/question.dart';
part 'lesson.g.dart';

@JsonSerializable()
class Lesson {
  final int id;
  final String? featureImage;
  final String? video;
  final int price;
  final String title;
  final String content;
  final String authorName;
  final String categoryName;
  final List<Comments>? comments;
  final List<Question>? questions;
  final bool passed;

  Lesson({
    required this.id,
    required this.featureImage,
    required this.video,
    required this.price,
    required this.title,
    required this.content,
    required this.authorName,
    required this.categoryName,
    required this.comments,
    required this.questions,
    required this.passed,
  });
  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);

  Map<String, dynamic> toJson() => _$LessonToJson(this);
}
