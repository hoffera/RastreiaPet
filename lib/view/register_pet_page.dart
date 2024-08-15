import 'package:flutter/material.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/widgets/logo_widget.dart';
import 'package:rastreia_pet_app/widgets/or_widget.dart';
import 'package:rastreia_pet_app/widgets/primary_button.dart';
import 'package:rastreia_pet_app/widgets/qrcode_card.dart';
import 'package:rastreia_pet_app/widgets/text_input.dart';

class RegisterPetPage extends StatelessWidget {
  RegisterPetPage({super.key});
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 70),
              const LogoWidget(),
              const SizedBox(height: 10.0),
              _nameInput(),
              const SizedBox(height: 20.0),
              _codeInput(),
              const SizedBox(height: 30.0),
              _registerButton(context),
              const SizedBox(height: 20.0),
              const Orwidget(color: Colors.black),
              const SizedBox(height: 20.0),
              const QrcodeCard(),
            ],
          ),
        ),
      ),
    );
  }

  _inputText(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  _nameInput() {
    return Column(
      children: [
        _inputText("Nome do Pet"),
        const SizedBox(height: 10.0),
        TextInput(
          off: false,
          password: false,
          text: 'Nome completo',
          controller: _nameController,
        ),
      ],
    );
  }

  _codeInput() {
    return Column(
      children: [
        _inputText("Código de cadastro"),
        const SizedBox(height: 10.0),
        TextInput(
          off: false,
          password: false,
          text: 'Código',
          controller: _nameController,
        ),
      ],
    );
  }

  _registerButton(context) {
    return SizedBox(
      height: 50,
      child: PrimaryButton(
        funds: false,
        color: AppColors.primary,
        textColor: Colors.white,
        text: "Finalizar cadastro",
        onPressed: () {
          Navigator.pushNamed(context, '/NavPage');
        },
      ),
    );
  }
}
