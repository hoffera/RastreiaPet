import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/widgets/input/text_input.dart';

class PerfilCard extends StatefulWidget {
  const PerfilCard({
    super.key,
    required this.cardText,
    required this.infoText,
    required this.icon,
    this.map = false,
    this.inputController,
  });

  final String cardText;
  final String infoText;
  final IconData icon;
  final bool? map;
  final TextEditingController? inputController;

  @override
  State<PerfilCard> createState() => _PerfilCardState();
}

class _PerfilCardState extends State<PerfilCard> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

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
          if (widget.map == false) _infoText(),
          if (widget.map == true) _input(),
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
      widget.icon, // Nome do ícone
      color: AppColors.primary,
      size: 30.0, // Tamanho do ícone
    );
  }

  _cardText() {
    return Text(
      widget.cardText,
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
      child: StyledText(
        widget.infoText,
        style: Style(
          $text.style.color.black(),
          $text.style.fontSize(18),
          $text.style.fontWeight(FontWeight.normal),
          $text.textAlign.start(),
        ),
      ),
    );
  }

  _input() {
    return Form(
      key: _formKey,
      child: SizedBox(
        width: 250,
        child: TextInput(
          off: false,
          password: false, // Corrigido para não ser uma senha
          text: widget.infoText,
          controller: widget.inputController!,
        ),
      ),
    );
  }
}
