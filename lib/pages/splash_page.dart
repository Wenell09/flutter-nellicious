// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_nellicious/main.dart';
import 'package:flutter_nellicious/pages/home_page.dart';
import 'package:flutter_nellicious/pages/navigation_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 1),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => (MyApp.of(context).userId.isEmpty)
              ? HomePage()
              : NavigationPage(),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            children: [
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage("images/nellicious.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Text(
                "Welcome to nellicious",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
