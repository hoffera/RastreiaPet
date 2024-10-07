import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/models/pet.dart';
import 'package:rastreia_pet_app/services/alert_services.dart';
import 'package:rastreia_pet_app/services/auth_services.dart';
import 'package:rastreia_pet_app/services/pet_services.dart';
import 'package:rastreia_pet_app/widgets/button/primary_button.dart';
import 'package:rastreia_pet_app/widgets/dialog/show_snackbar.dart';
import 'package:rastreia_pet_app/widgets/logo/logo_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  User? user = FirebaseAuth.instance.currentUser;
  PetService petService = PetService();
  AlertPetService alertPetService = AlertPetService();
  Pet? pet;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            children: [
              LogoWidget(),
              const SizedBox(height: 10.0),
              _title(),
              const SizedBox(height: 50.0),
              _removePetButton(context),
              const SizedBox(height: 10.0),
              _deletButton(context),
              const SizedBox(height: 10.0),
              _logout(context),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadPet(); // Chama a função assíncrona aqui
  }

  Future<void> _loadPet() async {
    Pet? fetchedPet = await petService.getPetId(user!.uid);
    setState(() {
      pet = fetchedPet;
    });
    print(pet);
  }

  _title() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Configurações",
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  _removePetButton(context) {
    return SizedBox(
      height: 50,
      child: PrimaryButton(
        funds: false,
        color: AppColors.primary,
        textColor: Colors.white,
        text: "Remover Pet",
        onPressed: () {
          _removePet(context);
        },
      ),
    );
  }

  _removePet(context) async {
    await petService.removePet(pet: user!.uid);
    showSnackBar(
        context: context, mensagem: "Pet removido com Sucesso!", isErro: false);
    _loadPet();
  }

  _deletButton(context) {
    return SizedBox(
      height: 50,
      child: PrimaryButton(
        funds: false,
        color: AppColors.primary,
        textColor: Colors.white,
        text: "Deletar alerta",
        onPressed: () {
          _deleteAlert(context, user!.uid);
        },
      ),
    );
  }

  _logout(context) {
    return SizedBox(
      height: 50,
      child: PrimaryButton(
        funds: false,
        color: Colors.grey,
        textColor: Colors.white,
        text: "Sair",
        onPressed: () {
          AuthService().deslogar().then((error) {
            if (error == null) {
              Navigator.pushNamed(context, '/HomeLoginPage');
            }
          });
        },
      ),
    );
  }

  void _deleteAlert(context, String alertId) async {
    try {
      await alertPetService.removeAlertPet(alert: alertId);
      showSnackBar(
          context: context,
          mensagem: "Alerta deletado com sucesso!",
          isErro: false);
    } catch (e) {
      showSnackBar(
          context: context, mensagem: "Erro ao deletar alerta!", isErro: true);
    }
  }
}
