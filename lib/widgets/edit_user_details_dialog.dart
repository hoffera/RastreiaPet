// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/models/pet.dart';
import 'package:rastreia_pet_app/services/auth_services.dart';
import 'package:rastreia_pet_app/services/pet_services.dart';
import 'package:rastreia_pet_app/widgets/edit_detalis_card.dart';

class EditUserDetailsDialog extends StatefulWidget {
  final User user;
  final Pet? pet;
  const EditUserDetailsDialog({
    super.key,
    required this.user,
    this.pet,
  });

  @override
  EditUserDetailsDialogState createState() => EditUserDetailsDialogState();
}

class EditUserDetailsDialogState extends State<EditUserDetailsDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _petController = TextEditingController();
  final AuthService authServices = AuthService();

  PetService petService = PetService();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.primary,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _body(),
        ],
      ),
      actions: const [],
    );
  }

  _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _title(),
        const SizedBox(height: 10),
        _subtitle(),
        const SizedBox(height: 10),
        _nameUser(),
        const SizedBox(height: 10),
        _namePet(),
      ],
    );
  }

  _title() {
    return StyledText(
      "Edite seus dados",
      style: Style(
        $text.style.color.white(),
        $text.style.fontSize(30),
        $text.style.fontWeight(FontWeight.bold),
        $text.textAlign.start(),
      ),
    );
  }

  _subtitle() {
    return StyledText(
      "Atualize suas informações pessoais e mantenha seu perfil sempre atualizado.",
      style: Style(
        $text.style.color.black(),
        $text.style.fontSize(20),
        $text.style.fontWeight(FontWeight.w700),
        $text.textAlign.start(),
      ),
    );
  }

  _nameUser() {
    return EditDetalisCard(
      controller: _nameController,
      icon: Icons.person,
      cardText: "Nome",
      user: true,
      infoText: "${widget.user.displayName}",
    );
  }

  _namePet() {
    return EditDetalisCard(
      controller: _nameController,
      icon: Icons.pets,
      cardText: "Pet",
      user: false,
      pet: widget.pet,
      infoText: widget.pet != null ? widget.pet!.nome : "Sem Pets",
    );
  }

// Para mostrar o popup:
  void showEditUserDetailsDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditUserDetailsDialog(user: user);
      },
    );
  }
}
