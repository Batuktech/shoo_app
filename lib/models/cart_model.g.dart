// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartModel _$CartModelFromJson(Map<String, dynamic> json) => CartModel(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      date: json['date'] as String?,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => CartProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

CartProduct _$CartProductFromJson(Map<String, dynamic> json) => CartProduct(
      productId: json['productId'] as int?,
      quantity: json['quantity'] as int?,
    );