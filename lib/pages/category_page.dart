import 'dart:convert';
import 'package:flutter_nellicious/widgets/product_card.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_nellicious/data/const/base_url.dart';
import 'package:flutter_nellicious/data/models/product_model.dart';

class CategoryPage extends StatefulWidget {
  final String title;
  final String categoryId;
  const CategoryPage(
      {super.key, required this.title, required this.categoryId});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isLoading = true;
  List<ProductModel> product = [];
  Future<void> getProduct() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/product"));
      if (response.statusCode == 200) {
        final List result = jsonDecode(response.body)["data"];
        debugPrint("jumlah product:${result.length}");
        setState(() {
          isLoading = false;
          product = result.map((json) => ProductModel.fromJson(json)).toList();
        });
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        centerTitle: true,
        backgroundColor: Colors.green,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: (isLoading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                const SizedBox(height: 10),
                ProductCard(product: product),
              ],
            ),
    );
  }
}
