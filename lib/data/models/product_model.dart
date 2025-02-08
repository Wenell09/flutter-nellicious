import 'package:flutter_nellicious/data/models/category_model.dart';

class ProductModel {
  final String productId;
  final String name;
  final String image;
  final int price;
  final int ratings;
  final CategoryModel category;

  ProductModel({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.ratings,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['product_id'] ?? "",
      name: json['name'] ?? "",
      image: json['image'] ?? "",
      price: json['price'] ?? 0,
      ratings: json['ratings'] ?? 0,
      category: CategoryModel.fromJson(json['category']),
    );
  }
}
