import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_nellicious/data/const/base_url.dart';
import 'package:flutter_nellicious/data/models/product_model.dart';
import 'package:flutter_nellicious/main.dart';
import 'package:flutter_nellicious/pages/cart_page.dart';
import 'package:flutter_nellicious/pages/category_page.dart';
import 'package:flutter_nellicious/pages/login_page.dart';
import 'package:flutter_nellicious/pages/register_page.dart';
import 'package:flutter_nellicious/pages/search_page.dart';
import 'package:flutter_nellicious/widgets/product_card.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List<ProductModel> product = [];

  Future<void> getProduct() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/product"));
      if (response.statusCode == 200) {
        final List result = jsonDecode(response.body)["data"];
        debugPrint("jumlah product:${result.length}");
        if (mounted) {
          setState(() {
            isLoading = false;
            product =
                result.map((json) => ProductModel.fromJson(json)).toList();
          });
        }
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SearchPage(),
                )),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Icon(
                            Icons.search,
                            size: 30,
                            color: Colors.black,
                          )),
                      Expanded(
                          flex: 6,
                          child: Text(
                            "Cari makanan/minuman disini!",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: Colors.green,
          title: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "Nellicious",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Badge.count(
                count: 0,
                child: Icon(
                  Icons.favorite_border,
                  size: 27,
                  color: Colors.white,
                ),
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
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    width: double.infinity,
                    height: 155,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: List.generate(
                      2,
                      (index) => Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CategoryPage(
                                title: (index == 0) ? "Makanan" : "Minuman",
                                categoryId: (index == 0) ? "CT01" : "CT02"),
                          )),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 5,
                              children: [
                                Icon(
                                  (index == 0)
                                      ? Icons.restaurant
                                      : Icons.coffee,
                                  color: Colors.white,
                                ),
                                Text(
                                  (index == 0) ? "Makanan" : "Minuman",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                (isLoading)
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Semua Produk",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          ProductCard(product: product),
                        ],
                      )
              ],
            ),
          ),
          (MyApp.of(context).userId.isEmpty)
              ? Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        2,
                        (index) => Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    (index == 0) ? RegisterPage() : LoginPage(),
                              )),
                              child: Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: (index == 0)
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                child: Center(
                                  child: Text(
                                    (index == 0) ? "Register" : "Login",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: (index == 0)
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
