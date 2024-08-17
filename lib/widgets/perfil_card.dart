// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/widgets/text_input.dart';

class PerfilCard extends StatelessWidget {
  const PerfilCard({
    super.key,
    required this.cardText,
    required this.infoText,
    required this.icon,
    required this.controller,
  });
  final String cardText;
  final String infoText;
  final IconData icon;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return _card();
  }

  _card() {
    return Box(
      style: Style(
        $box.maxWidth(double.infinity), // Largura máxima
        $box.color(Colors.white),
        $box.borderRadius(20),
        $box.padding(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _box(),
          _infoText(),
        ],
      ),
    );
  }

  _box() {
    return Row(
      children: [
        _icon(),
        const SizedBox(width: 20),
        _cardText(),
      ],
    );
  }

  _icon() {
    return Icon(
      icon, // Nome do ícone
      color: AppColors.primary,
      size: 30.0, // Tamanho do ícone
    );
  }

  _cardText() {
    return Text(
      cardText,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  _infoText() {
    return SizedBox(
      width: 250,
      child: TextInput(
        off: true,
        password: false,
        text: infoText,
        controller: controller,
      ),
    );
  }
}
