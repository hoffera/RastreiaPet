import 'package:flutter/material.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/widgets/card_button.dart';
import 'package:rastreia_pet_app/widgets/change_update_dialog.dart';
import 'package:rastreia_pet_app/widgets/logo_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 70.0),
              const LogoWidget(),
              const SizedBox(height: 30.0),
              _helloText(),
              const SizedBox(height: 30.0),
              _registerPetCard(context),
              const SizedBox(height: 30.0),
              _registerAlert(context),
              const SizedBox(height: 30.0),
              _changeUpdate(context),
              const SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }

  _helloText() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Olá, Usuario",
          style: TextStyle(
            fontSize: 32,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  _registerPetCard(context) {
    return CardButton(
      icon: Icons.pets,
      text: "Cadastrar novo Pet",
      onPressed: () {
        Navigator.pushNamed(context, '/RegisterPetPage');
      },
    );
  }

  _registerAlert(context) {
    return CardButton(
      icon: Icons.add_alert,
      text: "Criar um alerta",
      onPressed: () {
        Navigator.pushNamed(context, '/RegisterAlertPage');
      },
    );
  }

  _changeUpdate(context) {
    return CardButton(
      icon: Icons.edit_location_sharp,
      text: "Alterar atualização da coleira",
      onPressed: () {
        _changeUpdateDialog(context);
      },
    );
  }

  void _changeUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ChangeUpdateDialog();
      },
    );
  }
}
