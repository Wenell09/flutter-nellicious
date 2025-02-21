// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_nellicious/data/const/base_url.dart';
import 'package:flutter_nellicious/data/models/detail_product_model.dart';
import 'package:flutter_nellicious/data/models/review_model.dart';
import 'package:flutter_nellicious/main.dart';
import 'package:flutter_nellicious/pages/cart_page.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final String productId;
  const DetailPage({super.key, required this.productId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<DetailProductModel> detailProduct = [];
  List<ReviewModel> reviews = [];
  TextEditingController inputReview = TextEditingController();
  bool isLoading = true;
  bool isLoadingReviewProduct = true;
  int quantity = 1;
  bool isLoadingAddCart = false;
  int changeIndex = 0;
  int indexStar = 0;

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

  Future<void> getReviewProduct(String productId) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/review/$productId"));
      if (response.statusCode == 200) {
        debugPrint("review produk ${widget.productId} : ${response.body}");
        final List result = jsonDecode(response.body)["data"];
        setState(() {
          isLoadingReviewProduct = false;
          reviews = result.map((json) => ReviewModel.fromJson(json)).toList();
        });
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addReviewProduct(
    String userId,
    String productId,
    String description,
    int rating,
  ) async {
    try {
      Map<String, dynamic> data = {
        "user_id": userId,
        "product_id": productId,
        "description": description,
        "rating": rating
      };
      final response = await http.post(
        Uri.parse("$baseUrl/addReview"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        debugPrint("Add review product:${response.body}");
        getReviewProduct(widget.productId);
      } else {
        debugPrint("Error add review product:${response.body}");
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

  Future<void> deleteFavorite(String userId, String productId) async {
    try {
      final response = await http
          .delete(Uri.parse("$baseUrl/deleteFavorite/$userId/$productId"));
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
    getReviewProduct(widget.productId);
    super.initState();
  }

  @override
  void dispose() {
    inputReview.dispose();
    super.dispose();
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
                  deleteFavorite(MyApp.of(context).userId, widget.productId);
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
                        children: [
                          Image.network(
                            fit: BoxFit.cover,
                            data.image,
                            width: double.infinity,
                            height: 250,
                          ),
                          Row(
                            children: List.generate(
                              2,
                              (index) => Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      changeIndex = index;
                                    });
                                  },
                                  child: Container(
                                    height: 70,
                                    color: (changeIndex == index)
                                        ? Colors.green
                                        : Colors.grey,
                                    child: Center(
                                      child: Text(
                                        (index == 0)
                                            ? "Deskripsi"
                                            : "Penilaian produk",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          (changeIndex == 0)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
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
                                                                : Icons
                                                                    .shopping_cart,
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
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Text(
                                        "Deskripsi",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Text(
                                        data.description,
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final review = reviews[index];
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    "http://idoxaxo.sufydely.com/profile_pic.png"),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      review.user.username,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    (review.rating == 0)
                                                        ? Container()
                                                        : SizedBox(
                                                            height: 20,
                                                            child: Row(
                                                              children:
                                                                  List.generate(
                                                                review.rating,
                                                                (index) {
                                                                  return const Icon(
                                                                    Icons.star,
                                                                    color: Colors
                                                                        .orange,
                                                                    size: 15,
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                    Text(
                                                      review.description,
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                formatDate(review.createdAt),
                                                style: const TextStyle(
                                                    fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                    itemCount: reviews.length,
                                  ),
                                )
                        ],
                      );
                    },
                    itemCount: detailProduct.length,
                  ),
                ),
                (changeIndex == 0)
                    ? Container(
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
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                      )
                    : Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        width: double.infinity,
                        color: Colors.green,
                        child: Column(
                          spacing: 10,
                          children: [
                            Row(
                              spacing: 2,
                              children: List.generate(
                                5,
                                (index) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      indexStar = (index + 1);
                                    });
                                  },
                                  child: (indexStar > index)
                                      ? Icon(
                                          Icons.star,
                                          size: 35,
                                          color: Colors.amber,
                                        )
                                      : Icon(
                                          Icons.star_border,
                                          size: 35,
                                          color: Colors.white,
                                        ),
                                ),
                              ),
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                Expanded(
                                    child: TextField(
                                  style: TextStyle(color: Colors.black),
                                  controller: inputReview,
                                  cursorColor: Colors.green,
                                  decoration: InputDecoration(
                                    hintText: "Berikan review untuk produk ini",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide.none),
                                  ),
                                )),
                                GestureDetector(
                                  onTap: () {
                                    if (MyApp.of(context).userId.isEmpty) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                      inputReview.clear();
                                      setState(() {
                                        indexStar = 0;
                                      });
                                      FocusScope.of(context).unfocus();
                                    } else {
                                      if (indexStar == 0 &&
                                          inputReview.text.isEmpty) {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              content: const Text(
                                                "Pastikan rating dan isi review terisi!",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                      addReviewProduct(
                                        MyApp.of(context).userId,
                                        widget.productId,
                                        inputReview.text,
                                        indexStar,
                                      );
                                      inputReview.clear();
                                      setState(() {
                                        indexStar = 0;
                                      });
                                      FocusScope.of(context).unfocus();
                                    }
                                  },
                                  child: Container(
                                    width: 65,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.send,
                                        size: 27,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
              ],
            ),
    );
  }
}

String formatDate(String dateString) {
  final DateTime dateTime = DateTime.parse(dateString);
  final DateFormat formatter = DateFormat('dd MMMM yyyy');
  return formatter.format(dateTime);
}
