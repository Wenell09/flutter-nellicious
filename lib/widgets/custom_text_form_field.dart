import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nellicious/main.dart';

class CustomTextFormField extends StatelessWidget {
  final String name;
  final bool isEmail;
  final TextEditingController controller;
  final TextInputType inputType;
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.inputType,
    required this.name,
    required this.isEmail,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.green,
      controller: controller,
      keyboardType: inputType,
      validator: (value) {
        if (isEmail) {
          bool isEmailValid = EmailValidator.validate(value!);
          if (!isEmailValid || value.isEmpty) {
            return "Pastikan Email sesuai dan terisi!";
          }
          return null;
        } else {
          if (value!.isEmpty) {
            return "Pastikan $name terisi";
          }
          return null;
        }
      },
      decoration: InputDecoration(
        hintText: "Masukkan $name",
        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        errorStyle: TextStyle(
            color: (MyApp.of(context).isDarkMode) ? Colors.white : Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: (MyApp.of(context).isDarkMode) ? Colors.white : Colors.black,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: (MyApp.of(context).isDarkMode) ? Colors.white : Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.green),
        ),
      ),
    );
  }
}
