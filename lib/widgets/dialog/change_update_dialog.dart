// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:mix/mix.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/models/pet.dart';
import 'package:rastreia_pet_app/services/pet_services.dart';

class ChangeUpdateDialog extends StatefulWidget {
  const ChangeUpdateDialog({
    super.key,
  });

  @override
  ChangeUpdateDialogState createState() => ChangeUpdateDialogState();
}

PetService petService = PetService();

class ChangeUpdateDialogState extends State<ChangeUpdateDialog> {
  Pet? pet;

  @override
  void initState() {
    super.initState();
    _loadPet();
  }

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

  Future<void> _loadPet() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      Pet? fetchedPet = await petService.getPetId(user!.uid);
      print("fetchedPet");

      pet = fetchedPet;
      print(pet!.read);
    } catch (e) {
      print('Error loading pet data: $e');
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
        $text.style.fontSize(24),
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
        $text.style.fontSize(16),
        $text.style.fontWeight(FontWeight.w700),
        $text.textAlign.center(),
      ),
    );
  }

  Future<void> sendToThingspeak(
      String apiKey, String data1, String data2) async {
    final url = Uri.parse(
        "https://api.thingspeak.com/update?api_key=$apiKey&field1=$data1&field2=$data2");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('Field1 e Field2 atualizados com sucesso para $data1 e $data2!');
    } else {
      throw Exception('Falha ao atualizar Field1 e Field2: ${response.body}');
    }
  }

  _card15s() {
    return PressableBox(
      style: Style(
          $box.color(AppColors.background),
          $box.padding(15),
          $box.borderRadius(20),
          $on.press(
            $box.color(AppColors.background
                .withOpacity(0.3)), // Efeito de sombra interna
          ),
          $on.hover(
            $box.color(AppColors.background
                .withOpacity(0.3)), // Efeito de sombra interna
          )),
      onPress: () async {
        // String apiKey = "7CUCVMS7J0USMUFU";
        // String data = '1';
        try {
          await sendToThingspeak("7CUCVMS7J0USMUFU", "10000", "0");
          print('Pressed and data sent!');
        } catch (e) {
          print(e);
        }
      },
      child: VBox(
        children: [
          StyledText(
            "Resposta Rápida (15 segundos) ",
            style: Style(
              $text.style.color.black(),
              $text.style.fontSize(17),
              $text.style.fontWeight(FontWeight.bold),
              $text.textAlign.center(),
            ),
          ),
          StyledText(
            "Ideal para monitoramento em tempo real, mas pode reduzir a duração da bateria mais rapidamente.",
            style: Style(
              $text.style.color.black(),
              $text.style.fontSize(14),
              $text.style.fontWeight(FontWeight.w400),
              $text.textAlign.center(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fromThingspeak(String code) async {
    final response = await http.get(Uri.parse(
        'https://api.thingspeak.com/channels/2627688/feeds.json?api_key=GGWWIRV8288GY3PV&results=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final feeds = data['feeds'];

      // Itera sobre os feeds para encontrar o código no field1
      for (var feed in feeds) {
        if (feed['field1'] == code) {
          final field1 = feed['field1'];
          final field2 = feed['field2'];
          final field3 = feed['field3'];

          // Faz o que precisar com os valores
          await processFields(field1, field2, field3);
          return; // Sai da função após encontrar o código
        }
      }

      // Se não encontrou o código
      print('Código não encontrado.');
    } else {
      throw Exception('Falha ao carregar os dados do ThingSpeak');
    }
  }

  Future<void> processFields(
      String field1, String field2, String field3) async {
    // Implemente o código para utilizar os valores recebidos
    print('Field 1: $field1');
    print('Field 2: $field2');
    print('Field 3: $field3');
  }

  _card5min() {
    return PressableBox(
      style: Style(
          $box.color(AppColors.background),
          $box.padding(15),
          $box.borderRadius(20),
          $on.press(
            $box.color(AppColors.background
                .withOpacity(0.3)), // Efeito de sombra interna
          ),
          $on.hover(
            $box.color(AppColors.background
                .withOpacity(0.3)), // Efeito de sombra interna
          )),
      onPress: () async {
        // String apiKey = "7CUCVMS7J0USMUFU";
        // String data = '1';
        try {
          await sendToThingspeak("7CUCVMS7J0USMUFU", "295000", "0");
          print('Pressed and data sent!');
        } catch (e) {
          print(e);
        }
      },
      child: VBox(
        children: [
          StyledText(
            "Intervalos Maiores (5 minutos) ",
            style: Style(
              $text.style.color.black(),
              $text.style.fontSize(17),
              $text.style.fontWeight(FontWeight.bold),
              $text.textAlign.center(),
            ),
          ),
          StyledText(
            "Prolonga a duração da bateria, ótimo para uso contínuo, com atualizações menos frequentes.",
            style: Style(
              $text.style.color.black(),
              $text.style.fontSize(14),
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
}
