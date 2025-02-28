import 'package:flutter/material.dart';
import 'package:flutter_nellicious/main.dart';
import 'package:flutter_nellicious/pages/navigation_page.dart';

class TransactionErrorPage extends StatelessWidget {
  const TransactionErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Icon(
                Icons.warning,
                color: Colors.red,
                size: 150,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  textAlign: TextAlign.center,
                  "Pembayaran gagal!",
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
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => NavigationPage()),
                    (route) =>
                        false, // Menghapus semua halaman sebelumnya dari stack
                  );
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
                  child: Center(
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
