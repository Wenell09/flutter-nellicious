// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_nellicious/data/const/base_url.dart';
import 'package:flutter_nellicious/data/models/detail_product_model.dart';
import 'package:flutter_nellicious/main.dart';
import 'package:flutter_nellicious/pages/cart_page.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final String productId;
  const DetailPage({super.key, required this.productId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<DetailProductModel> detailProduct = [];
  bool isLoading = true;
  int quantity = 1;
  bool isLoadingAddCart = false;

  Future<void> getDetailProduct(String productId) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/product/$productId"));
      if (response.statusCode == 200) {
        debugPrint("success get detail product ${widget.productId}");
        final List result = jsonDecode(response.body)["data"];
        setState(() {
          isLoading = false;
          detailProduct =
              result.map((json) => DetailProductModel.fromJson(json)).toList();
        });
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addCart(String userId, String productId, int quantity) async {
    try {
      setState(() {
        isLoadingAddCart = true;
      });
      Map<String, dynamic> data = {
        "user_id": userId,
        "product_id": productId,
        "quantity": quantity
      };
      final response = await http.post(
        Uri.parse("$baseUrl/addCart"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        debugPrint("Add Cart:${response.body}");
        setState(() {
          isLoadingAddCart = false;
        });
        MyApp.of(context).getCartUser();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 1),
            content: Text(
              "Produk berhasil ditambah ke keranjang!",
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      } else {
        setState(() {
          isLoadingAddCart = false;
        });
        debugPrint("Error add Cart:${response.body}");
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

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
  void initState() {
    getDetailProduct(widget.productId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        actions: [
          IconButton(
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
                    (result) => result.product.productId == widget.productId);
                if (isFavorite) {
                  var favorite = MyApp.of(context).favorite.firstWhere(
                        (result) =>
                            result.product.productId == widget.productId,
                      );
                  deleteFavorite(MyApp.of(context).userId, favorite.favoriteId);
                } else {
                  addFavorite(widget.productId);
                }
              }
            },
            icon: Icon(
              (MyApp.of(context).favorite.any(
                      (result) => result.product.productId == widget.productId))
                  ? Icons.favorite
                  : Icons.favorite_border_outlined,
              size: 27,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CartPage(
                  cart: MyApp.of(context).cart,
                ),
              )),
              icon: Badge.count(
                count: MyApp.of(context).cart?.data.length ?? 0,
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: 27,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
      body: (isLoading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final data = detailProduct[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            fit: BoxFit.cover,
                            data.image,
                            width: double.infinity,
                            height: 250,
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    maxLines: 2,
                                    data.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Rp ${data.price}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              spacing: 10,
                              children: List.generate(
                                3,
                                (index) {
                                  return Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.green,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                              (index == 0)
                                                  ? Icons.star
                                                  : (index == 1)
                                                      ? Icons.favorite
                                                      : Icons.shopping_cart,
                                              color: Colors.white),
                                          Text(
                                            (index == 0)
                                                ? "${data.ratings}(${data.numberOfRatings})"
                                                : (index == 1)
                                                    ? "${data.numberOfFavorites} favorite"
                                                    : "${data.numberOfSales} terjual",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Deskripsi",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              data.description,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          )
                        ],
                      );
                    },
                    itemCount: detailProduct.length,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  height: 110,
                  color: Colors.green,
                  child: Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (quantity > 1) {
                                      quantity--;
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.remove,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            quantity.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (quantity >= 99) {
                                      quantity = 99;
                                    } else {
                                      quantity++;
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
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
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                },
                              );
                            } else {
                              addCart(
                                MyApp.of(context).userId,
                                widget.productId,
                                quantity,
                              );
                            }
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: (isLoadingAddCart)
                                  ? Colors.grey
                                  : Colors.white,
                            ),
                            child: (isLoadingAddCart)
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Center(
                                    child: Text(
                                      "Tambahkan ke keranjang",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
