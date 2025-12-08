import 'package:json_annotation/json_annotation.dart';

part 'cart_model.g.dart';

@JsonSerializable(createToJson: false)
class CartModel {
  final int? id;
  final int? userId;
  final String? date;
  final List<CartProduct>? products;

  CartModel({
    this.id,
    this.userId,
    this.date,
    this.products,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return _$CartModelFromJson(json);
  }
}

@JsonSerializable(createToJson: false)
class CartProduct {
  final int? productId;
  final int? quantity;

  CartProduct({
    this.productId,
    this.quantity,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return _$CartProductFromJson(json);
  }
}

// Note: After creating this file, run:
// flutter pub run build_runner build