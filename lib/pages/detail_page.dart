import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_nellicious/data/const/base_url.dart';
import 'package:flutter_nellicious/data/models/detail_product_model.dart';
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
            onPressed: () {},
            icon: Icon(
              Icons.favorite_border,
              size: 27,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {},
              icon: Badge.count(
                count: 0,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                    )),
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
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white,
                          ),
                          child: Center(
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
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
