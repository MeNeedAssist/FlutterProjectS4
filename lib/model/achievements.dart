import 'package:json_annotation/json_annotation.dart';
part 'achievements.g.dart';

@JsonSerializable()
class Achievements {
  final int achievementId;
  final String title;
  final bool isReceive;
  final int score;
  final double process;
  final String badge;

  Achievements({
    required this.achievementId,
    required this.title,
    required this.isReceive,
    required this.score,
    required this.process,
    required this.badge,
  });
  factory Achievements.fromJson(Map<String, dynamic> json) =>
      _$AchievementsFromJson(json);
  Map<String, dynamic> toJson() => _$AchievementsToJson(this);
}
