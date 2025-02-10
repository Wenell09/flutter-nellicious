import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_nellicious/data/const/base_url.dart';
import 'package:flutter_nellicious/data/models/user_model.dart';
import 'package:flutter_nellicious/main.dart';
import 'package:flutter_nellicious/pages/home_page.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<UserModel> user = [];
  Future<void> getUser(String userId) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/account/$userId"));
      if (response.statusCode == 200) {
        debugPrint("result user:${response.body}");
        final List result = jsonDecode(response.body)["data"];
        setState(() {
          user = result.map((json) => UserModel.fromJson(json)).toList();
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
    getUser(MyApp.of(context).userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 70,
                    color: Colors.green,
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  Text(
                    (user.isEmpty) ? "loading" : user[0].username,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    (user.isEmpty) ? "" : user[0].email,
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: (MyApp.of(context).isDarkMode)
                          ? Colors.white
                          : Colors.black,
                    ),
                    child: Center(
                      child: Text(
                        "Edit Akun",
                        style: TextStyle(
                            color: (MyApp.of(context).isDarkMode)
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.grey[350],
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.person, color: Colors.indigo),
                            title: Text(
                              "Informasi akun",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.shopping_cart_rounded,
                                color: Colors.green),
                            title: Text(
                              "Riwayat transaksi",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          Divider(),
                          ListTile(
                              leading: Icon(
                                (MyApp.of(context).isDarkMode)
                                    ? Icons.dark_mode
                                    : Icons.sunny,
                                color: (MyApp.of(context).isDarkMode)
                                    ? Colors.blue
                                    : Colors.orange,
                              ),
                              title: Text(
                                (MyApp.of(context).isDarkMode)
                                    ? "Mode gelap"
                                    : "Mode terang",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              trailing: Switch(
                                key: ValueKey<bool>(
                                    MyApp.of(context).isDarkMode),
                                value: MyApp.of(context).isDarkMode,
                                activeColor: Colors.white,
                                activeTrackColor: Colors.grey[700],
                                inactiveTrackColor: Colors.white,
                                inactiveThumbColor: Colors.grey[700],
                                onChanged: (value) async {
                                  MyApp.of(context).toggleDarkMode();
                                },
                              )),
                          Divider(),
                          InkWell(
                            onTap: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    actionsAlignment:
                                        MainAxisAlignment.spaceAround,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    content: const Text(
                                      "Apakah kamu yakin ingin keluar?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text(
                                          "Tidak",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            MyApp.of(context).userId = "";
                                          });
                                          MyApp.of(context).saveUserId();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              duration: Duration(seconds: 1),
                                              content: Text(
                                                "Keluar berhasil!",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          );
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage()),
                                            (route) =>
                                                false, // Menghapus semua halaman sebelumnya dari stack
                                          );
                                        },
                                        child: const Text(
                                          "Ya",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: ListTile(
                              leading: Icon(Icons.logout, color: Colors.red),
                              title: Text(
                                "Keluar",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Divider(),
                          Center(
                            child: const Text(
                              textAlign: TextAlign.center,
                              "Versi Aplikasi\n1.0.0",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          SizedBox(height: 10)
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.015,
                left: MediaQuery.of(context).size.width / 2 - 62.5,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.greenAccent,
                  backgroundImage: NetworkImage(
                      "http://idoxaxo.sufydely.com/profile_pic.png"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
