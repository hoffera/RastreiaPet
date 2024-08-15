// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/services/auth_services.dart';

class ChangeUpdateDialog extends StatefulWidget {
  const ChangeUpdateDialog({
    super.key,
  });

  @override
  ChangeUpdateDialogState createState() =>
      ChangeUpdateDialogState(); // Renomeado para ser público
}

class ChangeUpdateDialogState extends State<ChangeUpdateDialog> {
  // Renomeado para ser público
  final TextEditingController _emailController = TextEditingController();
  final AuthService authServices = AuthService();

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
}

_body() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _title(),
      const SizedBox(height: 10),
      _subtitle(),
      const SizedBox(height: 10),
      _card15s(),
      const SizedBox(height: 10),
      _card5min(),
    ],
  );
}

_title() {
  return StyledText(
    "Ajuste o Tempo de Resposta da Coleira Inteligente",
    style: Style(
      $text.style.color.white(),
      $text.style.fontSize(30),
      $text.style.fontWeight(FontWeight.bold),
      $text.textAlign.center(),
    ),
  );
}

_subtitle() {
  return StyledText(
    "A escolha é sua! Ajuste o tempo de resposta de acordo com a situação para equilibrar a precisão com a vida útil da bateria da coleira.",
    style: Style(
      $text.style.color.black(),
      $text.style.fontSize(20),
      $text.style.fontWeight(FontWeight.w700),
      $text.textAlign.center(),
    ),
  );
}

_card15s() {
  return PressableBox(
    style: Style(
      $box.color(AppColors.background),
      $box.padding(15),
      $box.borderRadius(20),
      $on.press(
        $box.color.red(),
      ),
      $on.hover(
        $box.color.green(),
      ),
    ),
    onPress: () => print('Pressed!'),
    child: VBox(
      children: [
        StyledText(
          "Resposta Rápida (15 segundos) ",
          style: Style(
            $text.style.color.black(),
            $text.style.fontSize(24),
            $text.style.fontWeight(FontWeight.bold),
            $text.textAlign.center(),
          ),
        ),
        StyledText(
          "Ideal para monitoramento em tempo real, mas pode reduzir a duração da bateria mais rapidamente.",
          style: Style(
            $text.style.color.black(),
            $text.style.fontSize(20),
            $text.style.fontWeight(FontWeight.w400),
            $text.textAlign.center(),
          ),
        ),
      ],
    ),
  );
}

_card5min() {
  return PressableBox(
    style: Style(
      $box.color(AppColors.background),
      $box.padding(15),
      $box.borderRadius(20),
      $on.press(
        $box.color.blue(),
      ),
      $on.hover(
        $box.color.green(),
      ),
    ),
    onPress: () => print('Pressed!'),
    child: VBox(
      children: [
        StyledText(
          "Intervalos Maiores (5 minutos) ",
          style: Style(
            $text.style.color.black(),
            $text.style.fontSize(24),
            $text.style.fontWeight(FontWeight.bold),
            $text.textAlign.center(),
          ),
        ),
        StyledText(
          "Prolonga a duração da bateria, ótimo para uso contínuo, com atualizações menos frequentes.",
          style: Style(
            $text.style.color.black(),
            $text.style.fontSize(20),
            $text.style.fontWeight(FontWeight.w400),
            $text.textAlign.center(),
          ),
        ),
      ],
    ),
  );
}

// Para mostrar o popup:
void showChangeUpdateDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const ChangeUpdateDialog();
    },
  );
}
