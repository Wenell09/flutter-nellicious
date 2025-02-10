// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nellicious/data/const/base_url.dart';
import 'package:flutter_nellicious/main.dart';
import 'package:flutter_nellicious/pages/navigation_page.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController inputEmail = TextEditingController();
  TextEditingController inputPassword = TextEditingController();
  String errorText = "";
  bool hidePassword = true;
  bool isLoading = false;
  bool isErrorLogin = false;

  Future<void> loginUser(String email, String password) async {
    try {
      setState(() {
        isLoading = true;
      });
      Map<String, dynamic> data = {"email": email, "password": password};
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      String message = jsonDecode(response.body)["message"];
      if (response.statusCode == 200) {
        debugPrint("result login:${response.body}");
        String resultUserId = jsonDecode(response.body)["user_id"];
        setState(() {
          MyApp.of(context).userId = resultUserId;
          isLoading = false;
        });
        MyApp.of(context).saveUserId();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => NavigationPage()),
          (route) => false, // Menghapus semua halaman sebelumnya dari stack
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 1),
            content: Text(
              message,
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      } else {
        debugPrint("error login");
        setState(() {
          isErrorLogin = true;
          isLoading = false;
          errorText = message;
        });
        throw Exception(message);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back, color: Colors.white)),
      ),
      backgroundColor: Colors.green,
      body: GestureDetector(
        onPanDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              UnconstrainedBox(
                child: Container(
                  margin: const EdgeInsets.only(top: 50, bottom: 50),
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: AssetImage("images/nellicious.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 10),
                child: Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: TextFormField(
                  controller: inputEmail,
                  validator: (value) {
                    bool isEmailValid = EmailValidator.validate(value!);
                    if (!isEmailValid || value.isEmpty) {
                      return "Pastikan Email sesuai dan terisi!";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Masukkan email",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                    errorStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, bottom: 10),
                child: Text(
                  "Password",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: inputPassword,
                    obscureText: hidePassword,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Pastikan password sudah terisi!";
                      }
                      return null;
                    },
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          icon: (hidePassword)
                              ? const Icon(
                                  Icons.visibility_off,
                                  color: Colors.black,
                                )
                              : const Icon(
                                  Icons.visibility,
                                  color: Colors.black,
                                ),
                        ),
                      ),
                      hintText: "Masukkan password",
                      errorStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  )),
              const SizedBox(
                height: 40,
              ),
              (isLoading)
                  ? UnconstrainedBox(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(50)),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                    )
                  : UnconstrainedBox(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            loginUser(inputEmail.text, inputPassword.text);
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            ),
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 15),
              (isErrorLogin)
                  ? Center(
                      child: Text(
                        errorText,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
