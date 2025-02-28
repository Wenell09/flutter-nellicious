// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_nellicious/main.dart';
import 'package:flutter_nellicious/pages/navigation_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_nellicious/data/const/base_url.dart';

class TransactionSuccessPage extends StatefulWidget {
  final List items;
  const TransactionSuccessPage({super.key, required this.items});

  @override
  State<TransactionSuccessPage> createState() => _TransactionSuccessPageState();
}

class _TransactionSuccessPageState extends State<TransactionSuccessPage> {
  bool isLoading = false;
  Future<void> addTransaction(String userId, List items) async {
    try {
      setState(() {
        isLoading = true;
      });
      Map<String, dynamic> data = {
        "user_id": userId,
        "items": items,
      };
      final response = await http.post(
        Uri.parse("$baseUrl/addTransaction"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        debugPrint(response.body);
        setState(() {
          isLoading = false;
        });
        MyApp.of(context).getCartUser();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => NavigationPage()),
          (route) => false, // Menghapus semua halaman sebelumnya dari stack
        );
      } else {
        debugPrint(response.body);
        setState(() {
          isLoading = false;
        });
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Icon(
                Icons.check_circle_sharp,
                color: Colors.green,
                size: 150,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  textAlign: TextAlign.center,
                  "Pembayaran Berhasil!Terima kasih sudah membeli di Nellicious!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              GestureDetector(
                onTap: () {
                  if (isLoading) {
                    return;
                  } else {
                    addTransaction(MyApp.of(context).userId, widget.items);
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: (MyApp.of(context).isDarkMode)
                        ? Colors.white
                        : Colors.black,
                  ),
                  child: (isLoading)
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center(
                          child: Text(
                            "Kembali ke halaman utama",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: (MyApp.of(context).isDarkMode)
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
