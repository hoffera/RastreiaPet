import 'package:flutter/material.dart';
import 'package:rastreia_pet_app/enum/enum.dart';

class TextInput extends StatelessWidget {
  final bool? email;
  final bool? name;
  final bool? number;
  final bool off;
  final String text;
  final bool password;
  final TextEditingController controller;

  const TextInput({
    super.key,
    this.email,
    this.name,
    required this.off,
    required this.text,
    required this.password,
    required this.controller,
    this.number = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        readOnly: off,
        controller: controller,
        keyboardType:
            number == true ? TextInputType.number : TextInputType.text,
        validator: (value) {
          if (name == true) {
            if (value == null || value == "") {
              return "O valor do nome deve ser preenchido";
            }
          }

          if (email == true) {
            if (value == null || value == "") {
              return "O valor de e-mail deve ser preenchido";
            }
            if (!value.contains("@") ||
                !value.contains(".") ||
                value.length < 4) {
              return "O valor do e-mail deve ser válido";
            }
          } else if (password == true) {
            if (value == null || value.length < 4) {
              return "Insira uma senha válida.";
            }
          }

          return null;
        },
        obscureText: password,
        cursorColor: AppColors.primary,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primary), // Cor cinza
            borderRadius: BorderRadius.circular(20.0),
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: text,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        style: const TextStyle(color: Colors.black, fontSize: 12.0),
      ),
    );
  }
}
