// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchaseBundle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseBundle _$PurchaseBundleFromJson(Map<String, dynamic> json) =>
    PurchaseBundle(
      id: json['id'] as int,
      price: (json['price'] as num).toDouble(),
      gem: json['gem'] as int,
      description: json['description'] as String,
    );

Map<String, dynamic> _$PurchaseBundleToJson(PurchaseBundle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'price': instance.price,
      'gem': instance.gem,
      'description': instance.description,
    };
