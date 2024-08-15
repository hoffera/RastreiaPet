import 'package:flutter/material.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/widgets/primary_button.dart';

class HomeLoginPage extends StatelessWidget {
  const HomeLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _logo(),
              const SizedBox(height: 10.0),
              _enterButton(context),
              const SizedBox(height: 10.0),
              _registerButton(context),
            ],
          ),
        ),
      ),
    );
  }

  _logo() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Image.asset(
        'lib/assets/images/rastreiaPetLogo.png',
      ),
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
          Navigator.pushNamed(context, '/LoginPage');
        },
      ),
    );
  }

  _registerButton(context) {
    return SizedBox(
      height: 50,
      child: PrimaryButton(
        funds: false,
        color: Colors.white,
        textColor: AppColors.primary,
        text: "Cadastre-se agora",
        onPressed: () {
          Navigator.pushNamed(context, '/RegisterPage');
        },
      ),
    );
  }
}
