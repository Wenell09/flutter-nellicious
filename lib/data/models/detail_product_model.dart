import 'package:flutter_nellicious/data/models/category_model.dart';

class DetailProductModel {
  final String productId;
  final String name;
  final String image;
  final int price;
  final int ratings;
  final int numberOfRatings;
  final int numberOfFavorites;
  final int numberOfSales;
  final String description;
  final String createdAt;
  final CategoryModel category;

  DetailProductModel({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.ratings,
    required this.numberOfRatings,
    required this.numberOfFavorites,
    required this.numberOfSales,
    required this.description,
    required this.createdAt,
    required this.category,
  });

  factory DetailProductModel.fromJson(Map<String, dynamic> json) {
    return DetailProductModel(
      productId: json['product_id'] ?? "",
      name: json['name'] ?? "",
      image: json['image'] ?? "",
      price: json['price'] ?? 0,
      ratings: json['ratings'] ?? 0,
      numberOfRatings: json['number_of_ratings'] ?? 0,
      numberOfFavorites: json['number_of_favorites'] ?? 0,
      numberOfSales: json['number_of_sales'] ?? 0,
      description: json['description'] ?? "",
      createdAt: json['created_at'] ?? "",
      category: CategoryModel.fromJson(json['category']),
    );
  }
}
