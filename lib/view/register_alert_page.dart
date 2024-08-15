import 'package:flutter/material.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/widgets/perfil_card.dart';
import 'package:rastreia_pet_app/widgets/primary_button.dart';

class RegisterAlertPage extends StatelessWidget {
  RegisterAlertPage({super.key});
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50.0),
              _titleText(),
              const SizedBox(height: 10),
              _subtitleText(),
              const SizedBox(height: 30),
              _map(),
              const SizedBox(height: 30),
              _distance(),
              const SizedBox(height: 30),
              _registerButton(context),
            ],
          ),
        ),
      ),
    );
  }

  _titleText() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Criar um alerta",
          style: TextStyle(
            fontSize: 32,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  _subtitleText() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Toque no mapa para selecionar o local e\ndefina um raio. Receba notificações caso\nseu animal saia dessa área. Mantenha seu\nPet seguro e sob controle!",
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  _map() {
    return Container(
      height: 400,
      width: double.infinity,
      color: Colors.red,
    );
  }

  _distance() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: PerfilCard(
        controller: _nameController,
        icon: Icons.pin_drop_rounded,
        cardText: "Raio",
        infoText: "0 metros",
      ),
    );
  }

  _registerButton(context) {
    return SizedBox(
      height: 50,
      child: PrimaryButton(
        funds: false,
        color: AppColors.primary,
        textColor: Colors.white,
        text: "Criar alerta",
        onPressed: () {
          Navigator.pushNamed(context, '/NavPage');
        },
      ),
    );
  }
}
