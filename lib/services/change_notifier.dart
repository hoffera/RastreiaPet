import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rastreia_pet_app/models/pet.dart';
import 'package:rastreia_pet_app/services/pet_services.dart'; // Certifique-se de que o PetService está importado

class DataSender extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Timer? _timer;
  final PetService petService = PetService(); // Instanciar o PetService

  // Acessa o UID do usuário atual
  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  // Função para buscar o Pet e obter o valor de 'read'
  Future<String?> _getPetRead() async {
    if (uid == null) {
      print('Usuário não autenticado.');
      return null;
    }

    try {
      // Obtém o pet com base no UID
      Pet? pet = await petService.getPetId(uid!);
      if (pet != null) {
        print('Pet encontrado: ${pet.nome}');
        return pet.read; // Retorna o valor de 'read' do Pet
      } else {
        print('Pet não encontrado.');
      }
    } catch (e) {
      print('Erro ao buscar Pet: $e');
    }
    return null;
  }

  Future<void> _sendData(Map<String, dynamic> data) async {
    if (uid == null) {
      print('Usuário não autenticado.');
      return;
    }

    try {
      // Envia os dados para o Firestore
      await _firestore.collection('location').doc(uid).set(data);
      print('Dados enviados para o Firestore: $data');
    } catch (e) {
      print('Erro ao enviar dados: $e');
    }
  }

  // Inicia o envio dos dados periodicamente
  void startSendingData() async {
    // Obtém o valor de 'read' do Pet
    String? read = await _getPetRead();

    _timer = Timer.periodic(Duration(seconds: 15), (timer) {
      if (read == null || read.isEmpty) {
        print('URL do ThingSpeak não fornecida. Enviando valor padrão.');
      } else {
        fromThingspeak(read);
      }
    });
  }

  void stopSendingData() {
    _timer?.cancel();
  }

  // Faz a requisição para o ThingSpeak usando a URL fornecida
  Future<void> fromThingspeak(String read) async {
    try {
      final response = await http.get(Uri.parse(read));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);

        // Verifica se o dado é realmente um Map
        if (data is Map<String, dynamic>) {
          // Verifica se existe uma lista 'feeds' com pelo menos um item
          if (data['feeds'] != null &&
              data['feeds'] is List &&
              (data['feeds'] as List).isNotEmpty) {
            var firstFeed = data['feeds'][0];

            // Verifica se todos os campos necessários estão presentes e não são nulos
            if (firstFeed['field1'] != null && firstFeed['field2'] != null) {
              // Tenta converter os valores para double
              try {
                var field1Value = double.parse(firstFeed['field1']);
                var field2Value = double.parse(firstFeed['field2']);

                // Cria um mapa com os valores a serem enviados para o Firestore
                Map<String, dynamic> dataToSend = {
                  'latitude': field1Value,
                  'longitude': field2Value,
                };

                // Envia os dados formatados para o Firestore
                await _sendData(dataToSend);
                print('Dados enviados para o Firestore: $dataToSend');
              } catch (e) {
                print('Erro ao converter valores de campo: $e');
              }
            } else {
              print('Campos necessários ausentes em firstFeed.');
            }
          } else {
            print('Estrutura de dados "feeds" inválida ou ausente.');
          }
        } else {
          throw Exception('Os dados retornados não são do tipo esperado');
        }
      } else {
        throw Exception('Falha ao carregar os dados do ThingSpeak');
      }
    } catch (e) {
      print('Erro ao carregar os dados: $e');
    }
  }

  // Envia um valor padrão se a URL de leitura não for fornecida
}
