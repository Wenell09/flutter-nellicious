import 'package:flutter/material.dart';
import 'package:flutter_nellicious/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isDark = false;
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
                    "Username",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Username@gmail.com",
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
                                (isDark) ? Icons.dark_mode : Icons.sunny,
                                color: (isDark) ? Colors.blue : Colors.orange,
                              ),
                              title: Text(
                                (isDark) ? "Mode gelap" : "Mode terang",
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
                          ListTile(
                            leading: Icon(Icons.logout, color: Colors.red),
                            title: Text(
                              "Keluar",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
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
