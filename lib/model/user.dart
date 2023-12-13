import 'package:project_s4/model/achievements.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  final int userId;
  final String? email;
  final String? name;
  final DateTime? dateOfBirth;
  final String? avatar;
  final int? gem;
  final int? earned;
  final int? spent;
  final int? level;
  final int? exp;
  final List<Achievements>? achievements;

  User({
    required this.userId,
    required this.email,
    required this.name,
    required this.dateOfBirth,
    required this.avatar,
    required this.gem,
    required this.earned,
    required this.spent,
    required this.level,
    required this.exp,
    required this.achievements,
  });
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
