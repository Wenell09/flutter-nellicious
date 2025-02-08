import 'package:flutter_nellicious/data/models/product_model.dart';
import 'package:flutter_nellicious/data/models/user_model.dart';

class TransactionModel {
  final String transactionId;
  final int quantity;
  final int totalPrice;
  final UserModel user;
  final ProductModel product;
  final String createdAt;

  TransactionModel({
    required this.transactionId,
    required this.quantity,
    required this.totalPrice,
    required this.user,
    required this.product,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionId: json["transaction_id"] ?? "",
      quantity: json["quantity"] ?? 0,
      totalPrice: json["totalPrice"] ?? 0,
      user: UserModel.fromJson(json["user"]),
      product: ProductModel.fromJson(json["product"]),
      createdAt: json["created_at"] ?? "",
    );
  }
}
