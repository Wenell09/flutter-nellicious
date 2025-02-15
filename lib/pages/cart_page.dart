// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_nellicious/data/const/base_url.dart';
import 'package:flutter_nellicious/data/models/cart_model.dart';
import 'package:flutter_nellicious/main.dart';
import 'package:flutter_nellicious/pages/detail_page.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  final CartModel? cart;
  const CartPage({super.key, required this.cart});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isLoadingTransaction = false;

  Future<void> updateCart(String userId, String productId, int quantity) async {
    try {
      Map<String, dynamic> data = {
        "user_id": userId,
        "product_id": productId,
        "quantity": quantity
      };
      final response = await http.patch(
        Uri.parse("$baseUrl/updateCart"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        debugPrint("Add cart:${response.body}");
        if (mounted) {
          MyApp.of(context).getCartUser();
        }
      } else {
        debugPrint("Error add Cart:${response.body}");
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCart(String userId, String cartId) async {
    try {
      final response =
          await http.delete(Uri.parse("$baseUrl/deleteCart/$userId/$cartId"));
      if (response.statusCode == 200) {
        debugPrint("delete cart:${response.body}");
        MyApp.of(context).getCartUser();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            content: Text(
              "delete produk berhasil!",
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      } else {
        debugPrint("error delete cart:${response.body}");
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back, color: Colors.white)),
        title: Text(
          "Keranjang",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: (MyApp.of(context).userId.isEmpty)
          ? Center(
              child: Text(
                "Daftar keranjang kosong!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  flex: 1,
                  child: ListView(
                    children: [
                      SizedBox(height: 20),
                      (widget.cart!.data.isEmpty)
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height / 1.5,
                              child: Center(
                                child: Text(
                                  "Daftar keranjang kosong!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final data = widget.cart!.data[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: InkWell(
                                    onTap: () => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                          productId: data.product.productId),
                                    )),
                                    child: Card(
                                      child: Container(
                                        margin: EdgeInsets.only(right: 5),
                                        width: double.infinity,
                                        height: 110,
                                        child: Row(
                                          spacing: 10,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10)),
                                                  child: Image.network(
                                                    data.product.image,
                                                    fit: BoxFit.cover,
                                                    height: double.infinity,
                                                  )),
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: Column(
                                                  spacing: 5,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 5),
                                                    Flexible(
                                                      child: Text(
                                                        data.product.name,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Text(
                                                      data.product.category
                                                          .name,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: (MyApp.of(
                                                                    context)
                                                                .isDarkMode)
                                                            ? Colors.grey[400]
                                                            : Colors.grey[600],
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        "Rp.${data.totalPrice}",
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          20),
                                                              actionsAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              content:
                                                                  const Text(
                                                                "Apakah kamu yakin ingin menghapus produk ini?",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 17,
                                                                ),
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(),
                                                                  child:
                                                                      const Text(
                                                                    "Tidak",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    deleteCart(
                                                                        MyApp.of(context)
                                                                            .userId,
                                                                        widget
                                                                            .cart!
                                                                            .data[0]
                                                                            .cartId);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    "Ya",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .green,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      icon: Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      )),
                                                  Container(
                                                    width: 100,
                                                    height: 45,
                                                    decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Flexible(
                                                          child: IconButton(
                                                              onPressed: () => updateCart(
                                                                  MyApp.of(
                                                                          context)
                                                                      .userId,
                                                                  data.product
                                                                      .productId,
                                                                  (data.quantity -
                                                                      1)),
                                                              icon: Icon(
                                                                Icons.remove,
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                        ),
                                                        Text(
                                                          data.quantity
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: IconButton(
                                                              onPressed: () =>
                                                                  updateCart(
                                                                    MyApp.of(
                                                                            context)
                                                                        .userId,
                                                                    data.product
                                                                        .productId,
                                                                    (data.quantity +
                                                                        1),
                                                                  ),
                                                              icon: Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: widget.cart!.data.length,
                            )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  height: 130,
                  color: Colors.green,
                  child: Column(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Total bayar: Rp.${widget.cart!.totalBayar}",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: (isLoadingTransaction)
                              ? Colors.grey
                              : Colors.white,
                        ),
                        child: (isLoadingTransaction)
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Center(
                                child: Text(
                                  "Lanjutkan pembayaran",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
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
