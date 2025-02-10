import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void initState() {
    loadUserId();
    loadDarkMode();
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
