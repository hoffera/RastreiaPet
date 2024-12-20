import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/services/auth_services.dart';
import 'package:rastreia_pet_app/widgets/alert/loading_alert.dart';
import 'package:rastreia_pet_app/widgets/button/primary_button.dart';
import 'package:rastreia_pet_app/widgets/dialog/reset_password_dialog.dart';
import 'package:rastreia_pet_app/widgets/dialog/show_snackbar.dart';
import 'package:rastreia_pet_app/widgets/input/text_input.dart';
import 'package:rastreia_pet_app/widgets/logo/logo_widget.dart';
import 'package:rastreia_pet_app/widgets/logo/or_widget.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  AuthService authServices = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                const LogoWidget(),
                const SizedBox(height: 10.0),
                _enterText(),
                const SizedBox(height: 10.0),
                _inputs(),
                const SizedBox(height: 20.0),
                _enterButton(context),
                const SizedBox(height: 10.0),
                _resetPasswordButton(context),
                const Orwidget(color: Colors.black),
                const SizedBox(height: 20.0),
                _registerPageButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _enterText() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Entrar",
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  _inputs() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _emailInput(),
          const SizedBox(height: 10.0),
          _passwordInput(),
        ],
      ),
    );
  }

  _emailInput() {
    return TextInput(
      off: false,
      password: false,
      text: 'Seu e-mail',
      controller: _emailController,
    );
  }

  _passwordInput() {
    return TextInput(
      off: false,
      password: true,
      text: 'Sua senha',
      controller: _passwordController,
    );
  }

  _enterButton(context) {
    return SizedBox(
      height: 50,
      child: PrimaryButton(
        funds: false,
        color: AppColors.primary,
        textColor: Colors.white,
        text: "Entrar",
        onPressed: () {
          _loginButtonPressed(context);
        },
      ),
    );
  }

  _loginButtonPressed(context) {
    String email = _emailController.text;
    String senha = _passwordController.text;

    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible:
            false, // Impedir que o diálogo seja fechado ao tocar fora dele
        builder: (BuildContext context) {
          return const LoadingAlert();
        },
      );
      authServices.loginUser(email: email, password: senha).then((error) {
        Navigator.pop(context);
        if (error == null) {
          Navigator.pushNamed(context, '/NavPage');
          showSnackBar(
              context: context, mensagem: "Logado com sucesso!", isErro: false);
        } else {
          showSnackBar(
              context: context, mensagem: "Verifique seus dados", isErro: true);
        }
      });
    }
  }

  _resetPasswordButton(context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: VBox(
        style: Style(
          $box.alignment(Alignment.bottomRight),
        ),
        children: [
          GestureDetector(
            onTap: () {
              showPasswordResetDialog(context);
            },
            child: const Text(
              "Esqueci minha senha",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ],
      ),
    );
  }

  _registerPageButton(context) {
    return SizedBox(
      height: 50,
      child: PrimaryButton(
        funds: false,
        color: AppColors.primary,
        textColor: Colors.white,
        text: "Cadastre-se agora",
        onPressed: () {
          Navigator.pushNamed(context, '/RegisterPage');
        },
      ),
    );
  }
}
