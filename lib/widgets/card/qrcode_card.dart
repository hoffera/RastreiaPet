import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:rastreia_pet_app/enum/enum.dart';

class QrcodeCard extends StatelessWidget {
  const QrcodeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _card();
  }

  _card() {
    return Box(
      style: Style(
        $box.borderRadius(20),
        $box.maxWidth(double.infinity), // Largura máxima
        $box.padding.vertical(20),
        $box.padding.horizontal(20),
        $box.height(96),
        $box.color(AppColors.primary),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _textCard(),
          _icon(),
        ],
      ),
    );
  }

  _icon() {
    return const Icon(
      Icons.qr_code_rounded, // Nome do ícone
      color: Colors.white,
      size: 50.0, // Tamanho do ícone
    );
  }

  _textCard() {
    return const Text(
      "Escaneie o QR Code",
      style: TextStyle(
        fontSize: 30,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
