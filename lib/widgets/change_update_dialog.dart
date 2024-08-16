// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

Future<void> sendToThingspeak(String apiKey, Map<String, String> data) async {
  final url = Uri.parse('https://api.thingspeak.com/update.json');

  final response = await http.post(
    url,
    body: {
      'api_key': apiKey,
      ...data, // Insere os dados do Map como campos do corpo da requisição
    },
  );

  if (response.statusCode == 200) {
    print('Dados enviados com sucesso!');
  } else {
    throw Exception(
        'Falha ao enviar os dados para o ThingSpeak: ${response.body}');
  }
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
    onPress: () async {
      String apiKey = 'MQSFHANLRIA4AJ6O';
      Map<String, String> data = {
        'field1': '123456', // Valor para o campo 1
        'field2': '5VLHEQBMZEFPHP0G', // Valor para o campo 2
        'field3': 'SEAMNK2RIVQJ6BT7', // Valor para o campo 3
      };

      try {
        await sendToThingspeak(apiKey, data);
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

Future<void> processFields(String field1, String field2, String field3) async {
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
        $box.color.blue(),
      ),
      $on.hover(
        $box.color.green(),
      ),
    ),
    onPress: () async {
      const String code = '123456'; // Exemplo de código a ser buscado
      await fromThingspeak(code);
    },
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
