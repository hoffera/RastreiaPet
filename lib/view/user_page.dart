import 'package:flutter/material.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/services/auth_services.dart';
import 'package:rastreia_pet_app/widgets/logo_widget.dart';
import 'package:rastreia_pet_app/widgets/perfil_card.dart';
import 'package:rastreia_pet_app/widgets/primary_button.dart';

class UserPage extends StatelessWidget {
  UserPage({super.key});
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 70.0),
              const LogoWidget(),
              const SizedBox(height: 30.0),
              _title(),
              const SizedBox(height: 10.0),
              _nameUser(),
              const SizedBox(height: 30.0),
              _email(),
              const SizedBox(height: 30.0),
              _pet(),
              const SizedBox(height: 30.0),
              _editInfos(context),
              const SizedBox(height: 30.0),
              _editPassword(context),
              const SizedBox(height: 30.0),
              _logout(context),
            ],
          ),
        ),
      ),
    );
  }

  _title() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Perfil",
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  _nameUser() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: PerfilCard(
        controller: _nameController,
        icon: Icons.person,
        cardText: "Nome",
        infoText: "Nome",
      ),
    );
  }

  _email() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: PerfilCard(
        controller: _nameController,
        icon: Icons.email,
        cardText: "E-mail",
        infoText: "E-mail",
      ),
    );
  }

  _pet() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: PerfilCard(
        controller: _nameController,
        icon: Icons.pets,
        cardText: "Nome do Pet",
        infoText: "pet",
      ),
    );
  }

  _editInfos(context) {
    return SizedBox(
      height: 50,
      child: PrimaryButton(
        funds: false,
        color: AppColors.primary,
        textColor: Colors.white,
        text: "Edite seus dados",
        onPressed: () {
          Navigator.pushNamed(context, '/homepage');
        },
      ),
    );
  }

  _editPassword(context) {
    return SizedBox(
      height: 50,
      child: PrimaryButton(
        funds: false,
        color: AppColors.primary,
        textColor: Colors.white,
        text: "Alterar senha",
        onPressed: () {
          Navigator.pushNamed(context, '/homepage');
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
}
