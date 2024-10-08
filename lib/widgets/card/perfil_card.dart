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
          $box.border.color(AppColors.primary)
          // $box.padding(5),
          ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _box(),
            SizedBox(width: 10),
            if (widget.map == false) _infoText(),
            if (widget.map == true) _input(),
          ],
        ),
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
      size: 24.0, // Tamanho do ícone
    );
  }

  _cardText() {
    return Text(
      widget.cardText,
      style: const TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  _infoText() {
    return Expanded(
      // Remove o SizedBox e usa Expanded diretamente
      child: StyledText(
        widget.infoText,
        style: Style(
          $text.style.color.black(),
          $text.style.fontSize(16),
          $text.style.fontWeight(FontWeight.normal),
          $text.textAlign.start(),
          $text.overflow.ellipsis(), // Texto será cortado com '...'
        ),
        // Limita a uma linha
      ),
    );
  }

  _input() {
    return Form(
      key: _formKey,
      child: SizedBox(
        width: 200,
        height: 50,
        child: TextInput(
          number: true,
          off: false,
          password: false, // Corrigido para não ser uma senha
          text: widget.infoText,
          controller: widget.inputController!,
        ),
      ),
    );
  }
}
