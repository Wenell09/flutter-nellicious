import 'package:flutter_nellicious/data/models/product_model.dart';

class FavoriteModel {
  final String favoriteId;
  final String createdAt;
  final ProductModel product;

  FavoriteModel({
    required this.favoriteId,
    required this.createdAt,
    required this.product,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      favoriteId: json['favorite_id'] ?? "",
      createdAt: json['created_at'] ?? "",
      product: ProductModel.fromJson(json['product']),
    );
  }
}
