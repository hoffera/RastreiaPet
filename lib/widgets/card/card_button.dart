// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:rastreia_pet_app/enum/enum.dart';

class CardButton extends StatelessWidget {
  const CardButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });
  final String text;
  final IconData icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return PressableBox(
      onPress: onPressed,
      child: _card(),
    );
  }

  _card() {
    return Box(
      style: Style(
        $box.borderRadius(20),
        $box.maxWidth(double.infinity), // Largura máxima
        $box.padding.vertical(20),
        $box.padding.horizontal(20),
        $box.height(96),
        $box.color(Colors.white),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _icon(),
          _textCard(),
          _iconButton(),
        ],
      ),
    );
  }

  _icon() {
    return Icon(
      icon, // Nome do ícone
      color: AppColors.primary,
      size: 30.0, // Tamanho do ícone
    );
  }

  _textCard() {
    return StyledText(
      text,
      style: Style(
        $text.style.color.black(),
        $text.style.fontSize(19),
        $text.style.fontWeight(FontWeight.bold),
        $text.textAlign.center(),
      ),
    );
  }

  _iconButton() {
    return const Icon(
      Icons.arrow_forward_ios, // Nome do ícone
      color: Colors.grey,
      size: 20.0, // Tamanho do ícone
    );
  }
}
