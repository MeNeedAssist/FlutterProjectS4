import 'package:json_annotation/json_annotation.dart';
part 'purchaseBundle.g.dart';

@JsonSerializable()
class PurchaseBundle {
  final int id;
  final double price;
  final int gem;
  final String description;

  PurchaseBundle({
    required this.id,
    required this.price,
    required this.gem,
    required this.description,
  });

  factory PurchaseBundle.fromJson(Map<String, dynamic> json) =>
      _$PurchaseBundleFromJson(json);
  Map<String, dynamic> toJson() => _$PurchaseBundleToJson(this);
}
