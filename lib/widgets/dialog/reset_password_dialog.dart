// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/services/auth_services.dart';
import 'package:rastreia_pet_app/widgets/dialog/show_snackbar.dart';
import 'package:rastreia_pet_app/widgets/input/text_input.dart';

class PasswordResetDialog extends StatefulWidget {
  final bool? password;

  const PasswordResetDialog({
    super.key,
    this.password,
  });

  @override
  PasswordResetDialogState createState() =>
      PasswordResetDialogState(); // Renomeado para ser público
}

class PasswordResetDialogState extends State<PasswordResetDialog> {
  // Renomeado para ser público
  final TextEditingController _emailController = TextEditingController();
  final AuthService authServices = AuthService();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.primary,
      title: Column(
        children: [
          StyledText(
            "Redefina sua Senha.",
            style: Style(
              $text.style.color(AppColors.background),
              $text.style.fontSize(30),
              $text.style.fontWeight(FontWeight.bold),
              $text.textAlign.center(),
            ),
          ),
          StyledText(
            "Você receberá um e-mail com instruções para criar uma nova senha. ",
            style: Style(
              $text.style.color.black(),
              $text.style.fontSize(20),
              $text.style.fontWeight(FontWeight.w400),
              $text.textAlign.center(),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextInput(
            off: false,
            password: false,
            email: true,
            controller: _emailController,
            text: widget.password == true ? 'Senha' : 'E-mail',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (widget.password == true) {
              String email = _emailController.text;
              authServices.removerConta(password: email).then((error) {
                if (error == null) {
                  showSnackBar(
                      context: context,
                      mensagem: "Usuário removido com sucesso!",
                      isErro: false);
                  Navigator.pushNamed(context, '/homeloginpage');
                } else {
                  showSnackBar(
                      context: context,
                      mensagem: "Senha inválida!",
                      isErro: true);
                }
              });
            } else {
              String email = _emailController.text;
              authServices.resetPassword(email: email);
              Navigator.of(context).pop(); // Fecha o diálogo
            }
          },
          child: const Text(
            'Enviar',
            style: TextStyle(color: AppColors.background, fontSize: 20),
          ),
        ),
      ],
    );
  }
}

// Para mostrar o popup:
void showPasswordResetDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const PasswordResetDialog();
    },
  );
}
