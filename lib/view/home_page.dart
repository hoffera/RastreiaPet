// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/models/pet.dart';
import 'package:rastreia_pet_app/services/pet_services.dart';
import 'package:rastreia_pet_app/widgets/card/card_button.dart';
import 'package:rastreia_pet_app/widgets/dialog/change_update_dialog.dart';
import 'package:rastreia_pet_app/widgets/dialog/show_snackbar.dart';
import 'package:rastreia_pet_app/widgets/logo/logo_widget.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({
    super.key,
    required this.user,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PetService petService = PetService();
  late final Future<Pet?> _petExistsFuture =
      petService.getPetId(widget.user.uid);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Olá, ${widget.user.displayName}",
          style: const TextStyle(
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
        _petExistsFuture.then((exists) {
          if (exists != null) {
            Navigator.pushNamed(context, '/RegisterAlertPage');
          } else {
            showSnackBar(
                context: context,
                mensagem: "Cadastre um Pet primeiro!",
                isErro: true);
          }
        });
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
