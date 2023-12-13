import 'package:json_annotation/json_annotation.dart';
part 'category.g.dart';

@JsonSerializable()
class Category {
  final int categoryId;
  final String categoryName;
  final String? featureImage;
  late bool favorite;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.featureImage,
    required this.favorite,
  });
  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
