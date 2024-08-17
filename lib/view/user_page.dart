import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/models/pet.dart';
import 'package:rastreia_pet_app/services/auth_services.dart';
import 'package:rastreia_pet_app/services/pet_services.dart';
import 'package:rastreia_pet_app/widgets/edit_user_details_dialog.dart';
import 'package:rastreia_pet_app/widgets/logo_widget.dart';
import 'package:rastreia_pet_app/widgets/perfil_card.dart';
import 'package:rastreia_pet_app/widgets/primary_button.dart';
import 'package:rastreia_pet_app/widgets/show_snackbar.dart';

class UserPage extends StatefulWidget {
  final User user;

  const UserPage({super.key, required this.user});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final TextEditingController _nameController = TextEditingController();

  PetService petService = PetService();
  Pet? pet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20.0),
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
              _removePetButton(context),
              const SizedBox(height: 30.0),
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
    Pet? fetchedPet = await petService.getPetId(widget.user.uid);
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
          "Perfil",
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
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
        infoText: "${widget.user.displayName}",
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
        infoText: "${widget.user.email}",
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
        cardText: "Pet",
        infoText: pet != null ? pet!.nome : "-",
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
          _changeUpdateDialog(context);
        },
      ),
    );
  }

  void _changeUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditUserDetailsDialog(
          user: widget.user,
          pet: pet,
        );
      },
    );
  }

  _removePetButton(context) {
    return SizedBox(
      height: 50,
      child: PrimaryButton(
        funds: false,
        color: Colors.red,
        textColor: Colors.white,
        text: "Remover Pet",
        onPressed: () {
          _removePet(context);
        },
      ),
    );
  }

  _removePet(context) async {
    Pet? pet = await petService
        .getPetId(widget.user.uid); // Busca o pet associado ao uid

    if (pet?.id != null) {
      await petService.removePet(pet: widget.user.uid); //
      showSnackBar(
          context: context,
          mensagem: "Pet removido com Sucesso!",
          isErro: false);
      _loadPet();
    } else {
      showSnackBar(
        context: context,
        mensagem: "Pet sem Pet cadastrado!",
        isErro: true,
      );
    }
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
