import 'package:flutter_nellicious/data/models/product_model.dart';

class CartModel {
  final List<CartItem> data;
  final int totalBayar;

  CartModel({
    required this.data,
    required this.totalBayar,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      data: (json["data"] as List)
          .map((json) => CartItem.fromJson(json))
          .toList(),
      totalBayar: json['total_bayar'] ?? 0,
    );
  }
}

class CartItem {
  final String cartId;
  final int quantity;
  final int totalPrice;
  final String createdAt;
  final ProductModel product;

  CartItem({
    required this.cartId,
    required this.quantity,
    required this.totalPrice,
    required this.createdAt,
    required this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartId: json['cart_id'] ?? "",
      quantity: json['quantity'] ?? 0,
      totalPrice: json['total_price'] ?? 0,
      createdAt: json['created_at'] ?? "",
      product: ProductModel.fromJson(json['product']),
    );
  }
}
