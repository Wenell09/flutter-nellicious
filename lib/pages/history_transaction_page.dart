import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_nellicious/data/const/base_url.dart';
import 'package:flutter_nellicious/data/models/transaction_model.dart';
import 'package:flutter_nellicious/main.dart';
import 'package:flutter_nellicious/pages/detail_page.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HistoryTransactionPage extends StatefulWidget {
  const HistoryTransactionPage({super.key});

  @override
  State<HistoryTransactionPage> createState() => _HistoryTransactionPageState();
}

class _HistoryTransactionPageState extends State<HistoryTransactionPage> {
  List<TransactionModel> transaction = [];
  bool isLoading = true;

  Future<void> getTransaction(String userId) async {
    try {
      final response =
          await http.get(Uri.parse("$baseUrl/transaction/$userId"));
      if (response.statusCode == 200) {
        debugPrint("transaction user:${response.body}");
        final List result = jsonDecode(response.body)["data"];
        setState(() {
          isLoading = false;
          transaction =
              result.map((json) => TransactionModel.fromJson(json)).toList();
        });
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
    getTransaction(MyApp.of(context).userId);
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
          "Riwayat Transaksi",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: (isLoading)
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                SizedBox(height: 20),
                (transaction.isEmpty)
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: Center(
                          child: Text(
                            "Daftar transaksi kosong!",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          final data = transaction[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: InkWell(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DetailPage(
                                    productId: data.product.productId),
                              )),
                              child: Card(
                                child: Container(
                                  margin: EdgeInsets.only(right: 5),
                                  width: double.infinity,
                                  height: 125,
                                  child: Row(
                                    spacing: 10,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft:
                                                    Radius.circular(10)),
                                            child: Image.network(
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              },
                                              data.product.image,
                                              fit: BoxFit.cover,
                                              height: double.infinity,
                                            )),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          spacing: 5,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 5),
                                            Flexible(
                                              child: Text(
                                                "${data.product.name} x${data.quantity}",
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Text(
                                              data.product.category.name,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: (MyApp.of(context)
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
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                formatDate(data.createdAt),
                                                maxLines: 1,
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
                        itemCount: transaction.length,
                      )
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
