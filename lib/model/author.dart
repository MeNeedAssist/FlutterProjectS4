import 'package:json_annotation/json_annotation.dart';
part 'author.g.dart';

@JsonSerializable()
class Author {
  final int userId;
  final String avatar;
  final String author;
  final String authorEmail;
  final int countLesson;
  final int soldLesson;

  Author({
    required this.userId,
    required this.avatar,
    required this.author,
    required this.authorEmail,
    required this.countLesson,
    required this.soldLesson,
  });

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);
  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}
