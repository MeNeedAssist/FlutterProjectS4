import 'package:json_annotation/json_annotation.dart';
part 'comments.g.dart';

@JsonSerializable()
class Comments {
  final int feedbackId;
  final String content;
  final String userName;
  final String avatar;
  final DateTime creatatedAt;

  Comments({
    required this.feedbackId,
    required this.userName,
    required this.content,
    required this.avatar,
    required this.creatatedAt,
  });

  factory Comments.fromJson(Map<String, dynamic> json) =>
      _$CommentsFromJson(json);
  Map<String, dynamic> toJson() => _$CommentsToJson(this);
}
