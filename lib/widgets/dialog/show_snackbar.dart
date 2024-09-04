import 'package:flutter/material.dart';

showSnackBar({
  required BuildContext context,
  required String mensagem,
  bool isErro = true,
}) {
  SnackBar snackBar = SnackBar(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    duration: const Duration(milliseconds: 1000),
    content: Text(
      mensagem,
      style: const TextStyle(
        fontSize: 24,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    backgroundColor: (isErro) ? Colors.red : Colors.green,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
