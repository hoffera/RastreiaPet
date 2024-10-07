// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:rastreia_pet_app/enum/enum.dart';

class MapDialog extends StatelessWidget {
  final String latitude;
  final String longitude;
  final String distance;
  final String dateTime;

  const MapDialog({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.primary,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _title(),
          const SizedBox(height: 10),
          _subtitle(),
          const SizedBox(height: 20),
          _info(),
        ],
      ),
      actions: const [],
    );
  }

  _title() {
    return const Text(
      "Detalhes da Coleira",
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  _subtitle() {
    return const Text(
      "Aqui aparecem as coordenadas e mais informações do seu Pet",
      textAlign: TextAlign.center, // Centraliza o texto
      style: TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  _info() {
    Style style = Style(
      $text.style.color.black(),
      $text.style.fontSize(18),
      $text.style.fontWeight(FontWeight.bold),
      $text.textAlign.start(),
    );
    Style styleInfo = Style(
      $text.style.color.black(),
      $text.style.fontSize(16),
      $text.style.fontWeight(FontWeight.normal),
      $text.textAlign.start(),
    );
    Style hStyle = Style(
      $box.alignment.topLeft(),
    );

    return Box(
      style: Style(
        $box.borderRadius(20),
        $box.color(AppColors.background),
        $box.padding.all(10),
        $box.width(double.infinity),
      ),
      child: VBox(
        style: Style(
          $box.alignment.topLeft(), // Alinha o conteúdo ao topo e à esquerda
        ),
        children: [
          HBox(
            style: hStyle,
            children: [
              StyledText("Latitude:", style: style),
              const SizedBox(width: 10),
              StyledText(latitude, style: styleInfo),
            ],
          ),
          HBox(
            style: hStyle,
            children: [
              StyledText("Longitude:", style: style),
              const SizedBox(width: 10),
              StyledText(longitude, style: styleInfo),
            ],
          ),
          HBox(
            style: hStyle,
            children: [
              StyledText("Data e Hora:", style: style),
              const SizedBox(width: 10),
              StyledText("$dateTime", style: styleInfo),
            ],
          ),
          HBox(
            style: hStyle,
            children: [
              StyledText("Bateria:", style: style),
              const SizedBox(width: 10),
              StyledText("100%", style: styleInfo),
            ],
          ),
        ],
      ),
    );
  }
}
