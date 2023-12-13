import 'package:json_annotation/json_annotation.dart';
part 'comments.g.dart';

@JsonSerializable()
class Comments {
  final int feedbackId;
  final String content;
  final String userName;

  Comments({
    required this.feedbackId,
    required this.userName,
    required this.content,
  });

  factory Comments.fromJson(Map<String, dynamic> json) =>
      _$CommentsFromJson(json);
  Map<String, dynamic> toJson() => _$CommentsToJson(this);
}
