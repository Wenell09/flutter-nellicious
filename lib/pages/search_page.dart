import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_nellicious/data/const/base_url.dart';
import 'package:flutter_nellicious/data/models/product_model.dart';
import 'package:flutter_nellicious/main.dart';
import 'package:flutter_nellicious/widgets/product_card.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController inputProduct = TextEditingController();
  List<ProductModel> product = [];
  bool isLoading = true;
  bool isblank = true;
  bool isShowClear = false;

  Future<void> getProduct(String query) async {
    try {
      setState(() {
        isLoading = true;
      });
      final response =
          await http.get(Uri.parse("$baseUrl/searchProduct?name=$query"));
      if (response.statusCode == 200) {
        final List result = jsonDecode(response.body)["data"];
        debugPrint("jumlah product dengan nama $query:${result.length}");
        setState(() {
          product = result.map((json) => ProductModel.fromJson(json)).toList();
          isLoading = false;
          isblank = false;
        });
      } else {
        throw Exception("Gagal get product dengan nama $query");
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    inputProduct.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pencarian",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: GestureDetector(
        onPanDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: (MyApp.of(context).isDarkMode)
                      ? Colors.grey
                      : Colors.grey[400],
                ),
                child: TextField(
                  autofocus: false,
                  controller: inputProduct,
                  onChanged: (value) {
                    getProduct(value);
                    if (inputProduct.text.isEmpty) {
                      setState(() {
                        isShowClear = false;
                      });
                    } else {
                      setState(() {
                        isShowClear = true;
                      });
                    }
                  },
                  onEditingComplete: () {
                    getProduct(inputProduct.text);
                    setState(() {
                      isShowClear = false;
                    });
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  textInputAction: TextInputAction.search,
                  style: TextStyle(fontSize: 17),
                  decoration: InputDecoration(
                      isCollapsed: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 9),
                      hintText: "Cari makanan/minuman disini!",
                      hintStyle: TextStyle(
                        fontSize: 17,
                        color: (MyApp.of(context).isDarkMode)
                            ? Colors.white
                            : Colors.black,
                      ),
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        size: 30,
                        color: (MyApp.of(context).isDarkMode)
                            ? Colors.white
                            : Colors.black,
                      ),
                      suffixIcon: (isShowClear)
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  isShowClear = false;
                                  inputProduct.clear();
                                });
                                getProduct(inputProduct.text);
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              child: Icon(
                                Icons.close,
                                size: 30,
                              ),
                            )
                          : null),
                ),
              ),
            ),
            SizedBox(height: 20),
            (isblank)
                ? SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 150,
                            color: Colors.grey[400],
                          ),
                          const Text(
                            textAlign: TextAlign.center,
                            "Cari makanan/minuman kesukaan kamu disini!",
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  )
                : (isLoading)
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Center(child: CircularProgressIndicator()))
                    : (product.isEmpty)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.close, size: 50),
                                  Text(
                                    textAlign: TextAlign.center,
                                    "Makanan/minuman yang anda cari tidak tersedia!",
                                    style: TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                          )
                        : ProductCard(product: product)
          ],
        ),
      ),
    );
  }
}
