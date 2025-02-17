// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_nellicious/data/const/base_url.dart';
import 'package:flutter_nellicious/main.dart';
import 'package:flutter_nellicious/pages/home_page.dart';
import 'package:flutter_nellicious/widgets/custom_text_form_field.dart';
import 'package:http/http.dart' as http;

class EditAccountPage extends StatefulWidget {
  final String username, email, password;
  const EditAccountPage({
    super.key,
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController inputUsername;
  late TextEditingController inputEmail;
  late TextEditingController inputPassword;
  bool hidePassword = true;
  bool isLoadingEditAccount = false;
  bool isLoadingDeleteAccount = false;

  Future<void> editAccount(
    String userId,
    String username,
    String email,
    String password,
  ) async {
    try {
      setState(() {
        isLoadingEditAccount = true;
      });
      final Map<String, dynamic> data = {
        "username": username,
        "email": email,
        "password": password,
      };
      final response = await http.patch(
        Uri.parse("$baseUrl/editAccount/$userId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        setState(() {
          isLoadingEditAccount = false;
        });
        debugPrint("result edit acc:${response.body}");
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          isLoadingEditAccount = false;
        });
        debugPrint("error edit:${response.body}");
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAccount(String userId) async {
    try {
      setState(() {
        isLoadingDeleteAccount = true;
      });
      final response =
          await http.delete(Uri.parse("$baseUrl/deleteAccount/$userId"));
      if (response.statusCode == 200) {
        debugPrint("result delete acc:${response.body}");
        setState(() {
          isLoadingDeleteAccount = false;
          MyApp.of(context).userId = "";
        });
        MyApp.of(context).saveUserId();
        MyApp.of(context).getCartUser();
        MyApp.of(context).getFavoriteUser();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 1),
            content: Text(
              "Hapus akun berhasil!",
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);
      } else {
        setState(() {
          isLoadingDeleteAccount = false;
        });
        debugPrint("error delete acc:${response.body}");
        throw Exception(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    inputUsername = TextEditingController(text: widget.username);
    inputEmail = TextEditingController(text: widget.email);
    inputPassword = TextEditingController(text: widget.password);
    super.initState();
  }

  @override
  void dispose() {
    inputUsername.dispose();
    inputEmail.dispose();
    inputPassword.dispose();
    super.dispose();
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
          "Edit Akun",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Text(
                "Username",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 5),
              CustomTextFormField(
                controller: inputUsername,
                inputType: TextInputType.name,
                name: "username",
                isEmail: false,
              ),
              SizedBox(height: 20),
              Text(
                "Email",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 5),
              CustomTextFormField(
                controller: inputEmail,
                inputType: TextInputType.emailAddress,
                name: "email",
                isEmail: true,
              ),
              SizedBox(height: 20),
              Text(
                "Password",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: inputPassword,
                obscureText: hidePassword,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Pastikan password sudah terisi!";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      icon: (hidePassword)
                          ? Icon(
                              Icons.visibility_off,
                              color: (MyApp.of(context).isDarkMode)
                                  ? Colors.white
                                  : Colors.black,
                            )
                          : Icon(
                              Icons.visibility,
                              color: (MyApp.of(context).isDarkMode)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                    ),
                  ),
                  hintText: "Masukkan password",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                  errorStyle: TextStyle(
                      color: (MyApp.of(context).isDarkMode)
                          ? Colors.white
                          : Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: (MyApp.of(context).isDarkMode)
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: (MyApp.of(context).isDarkMode)
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.green),
                  ),
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    deleteAccount(MyApp.of(context).userId);
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: (isLoadingDeleteAccount) ? Colors.grey : Colors.red,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: (isLoadingDeleteAccount)
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center(
                          child: Text(
                            "Hapus Akun",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    editAccount(
                      MyApp.of(context).userId,
                      inputUsername.text,
                      inputEmail.text,
                      inputPassword.text,
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: (isLoadingEditAccount) ? Colors.grey : Colors.green,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: (isLoadingEditAccount)
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center(
                          child: Text(
                            "Edit Akun",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
