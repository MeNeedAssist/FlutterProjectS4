// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      categoryId: json['categoryId'] as int,
      categoryName: json['categoryName'] as String,
      featureImage: json['featureImage'] as String?,
      favorite: json['favorite'] as bool,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'featureImage': instance.featureImage,
      'favorite': instance.favorite,
    };
