// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_nellicious/data/const/base_url.dart';
import 'package:flutter_nellicious/data/models/product_model.dart';
import 'package:flutter_nellicious/main.dart';
import 'package:flutter_nellicious/pages/detail_page.dart';
import 'package:http/http.dart' as http;

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.product,
  });

  final List<ProductModel> product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Future<void> addFavorite(String productId) async {
    try {
      final Map<String, dynamic> data = {
        "user_id": MyApp.of(context).userId,
        "product_id": productId,
      };
      final response = await http.post(
        Uri.parse("$baseUrl/addFavorite"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        debugPrint(response.body);
        MyApp.of(context).getFavoriteUser();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            content: Text(
              "tambah favorite berhasil!",
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      } else {
        debugPrint(response.body);
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteFavorite(String userId, String favoriteId) async {
    try {
      final response = await http
          .delete(Uri.parse("$baseUrl/deleteFavorite/$userId/$favoriteId"));
      if (response.statusCode == 200) {
        debugPrint(response.body);
        MyApp.of(context).getFavoriteUser();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            content: Text(
              "hapus favorite berhasil!",
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      } else {
        debugPrint(response.body);
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Jumlah card per baris
          crossAxisSpacing: 10, // Spasi horizontal antara card
          mainAxisSpacing: 10, // Spasi vertikal antara card
          childAspectRatio: 1 / 1.2), //1 lebar 1.3 tinggi
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (context, index) {
        final data = widget.product[index];
        return Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailPage(productId: data.productId),
              )),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Image.network(
                          errorBuilder: (context, error, stackTrace) {
                            return Center(child: CircularProgressIndicator());
                          },
                          data.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              data.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Color(0xFFF5BB17),
                              ),
                              Text(
                                data.ratings.toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          data.category.name,
                          style: TextStyle(
                            color: (MyApp.of(context).isDarkMode)
                                ? Colors.grey[400]
                                : Colors.grey[600],
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Rp.${data.price}",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    if (MyApp.of(context).userId.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            content: const Text(
                              "Login terlebih dahulu!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                      );
                    } else {
                      bool isFavorite = MyApp.of(context).favorite.any(
                          (result) =>
                              result.product.productId == data.productId);
                      if (isFavorite) {
                        var favorite = MyApp.of(context).favorite.firstWhere(
                              (result) =>
                                  result.product.productId == data.productId,
                            );
                        deleteFavorite(
                            MyApp.of(context).userId, favorite.favoriteId);
                      } else {
                        addFavorite(data.productId);
                      }
                    }
                  },
                  icon: Icon(
                    (MyApp.of(context).favorite.any((result) =>
                            result.product.productId == data.productId))
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    color: Colors.red,
                    size: 35,
                  )),
            ),
          ],
        );
      },
      itemCount: widget.product.length,
    );
  }
}
