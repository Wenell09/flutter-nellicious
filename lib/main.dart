import 'dart:convert';
import 'package:flutter_nellicious/data/const/base_url.dart';
import 'package:flutter_nellicious/data/models/favorite_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nellicious/data/models/cart_model.dart';
import 'package:flutter_nellicious/pages/home_page.dart';
import 'package:flutter_nellicious/pages/navigation_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  // ignore: library_private_types_in_public_api
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  bool isDarkMode = false;
  String userId = "";
  CartModel? cart;
  List<FavoriteModel> favorite = [];

  void loadUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userId = sharedPreferences.getString("userId") ?? "";
    });
    debugPrint("load userId:$userId");
  }

  void saveUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setString("userId", userId);
    });
    debugPrint("save userId:$userId");
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  void loadDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
    if (isDarkMode) {
      changeTheme(ThemeMode.dark);
    } else {
      changeTheme(ThemeMode.light);
    }
  }

  void toggleDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = !isDarkMode;
      prefs.setBool('isDarkMode', isDarkMode);
    });
    if (isDarkMode) {
      changeTheme(ThemeMode.dark);
    } else {
      changeTheme(ThemeMode.light);
    }
  }

  Future<void> getCartUser() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/cart/$userId"));
      if (response.statusCode == 200) {
        debugPrint("result cart: ${response.body}");
        final result = jsonDecode(response.body);
        setState(() {
          cart = CartModel.fromJson(result);
        });
      } else {
        setState(() {
          cart = null;
        });
        debugPrint("error get cart for user:$userId");
        throw Exception("error get cart for user:$userId");
      }
    } catch (e) {
      setState(() {
        cart = null;
      });
      rethrow;
    }
  }

  Future<void> getFavoriteUser() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/favorite/$userId"));
      if (response.statusCode == 200) {
        debugPrint("result favorite user:${response.body}");
        final List result = jsonDecode(response.body)["data"];
        setState(() {
          favorite =
              result.map((json) => FavoriteModel.fromJson(json)).toList();
        });
      } else {
        setState(() {
          favorite.clear();
        });
        debugPrint("Error get favorite user :$userId");
        throw Exception("Error get favorite user :$userId");
      }
    } catch (e) {
      setState(() {
        favorite.clear();
      });
      rethrow;
    }
  }

  @override
  void initState() {
    loadUserId();
    loadDarkMode();
    Future.delayed(Duration(seconds: 2), () {
      getFavoriteUser();
      getCartUser();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      title: "Nellicious App",
      home: (userId.isEmpty) ? HomePage() : NavigationPage(),
    );
  }
}
