import 'package:flutter_nellicious/data/models/user_model.dart';

class ReviewModel {
  final String reviewId, productId, description, createdAt;
  final int rating;
  UserModel user;
  ReviewModel({
    required this.reviewId,
    required this.productId,
    required this.description,
    required this.rating,
    required this.user,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      reviewId: json["review_id"] ?? "",
      productId: json["product_id"] ?? "",
      description: json["description"] ?? "",
      rating: json["rating"] ?? "",
      user: UserModel.fromJson(json["user"]),
      createdAt: json["created_at"] ?? "",
    );
  }
}
