import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/view/qrcode_scanner_page.dart';

class QrcodeCard extends StatelessWidget {
  const QrcodeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _card(context);
  }

  _card(context) {
    return PressableBox(
      style: Style(
          $box.borderRadius(20),
          $box.maxWidth(double.infinity), // Largura máxima
          $box.padding.vertical(20),
          $box.padding.horizontal(20),
          $box.height(70),
          $box.color(AppColors.primary),
          $on.press(
            $box.color(AppColors.background
                .withOpacity(0.3)), // Efeito de sombra interna
          ),
          $on.hover(
            $box.color(AppColors.background
                .withOpacity(0.3)), // Efeito de sombra interna
          )),
      onPress: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const QrScannerPage(),
        ));
      },
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
      size: 40.0, // Tamanho do ícone
    );
  }

  _textCard() {
    return const Text(
      "Escaneie o QR Code",
      style: TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
