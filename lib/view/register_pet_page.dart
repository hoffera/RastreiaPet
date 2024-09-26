import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/models/pet.dart';
import 'package:rastreia_pet_app/services/auth_services.dart';
import 'package:rastreia_pet_app/services/pet_services.dart';
import 'package:rastreia_pet_app/widgets/button/primary_button.dart';
import 'package:rastreia_pet_app/widgets/dialog/show_snackbar.dart';
import 'package:rastreia_pet_app/widgets/input/text_input.dart';
import 'package:rastreia_pet_app/widgets/logo/logo_widget.dart';

class RegisterPetPage extends StatefulWidget {
  final User user;
  const RegisterPetPage({super.key, required this.user});

  @override
  State<RegisterPetPage> createState() => _RegisterPetPageState();
}

class _RegisterPetPageState extends State<RegisterPetPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  PetService petService = PetService();
  AuthService authServices = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 70),
              const LogoWidget(),
              const SizedBox(height: 50.0),
              _inputs(),
              const SizedBox(height: 50.0),
              _registerButton(context),
              // const SizedBox(height: 20.0),
              // const Orwidget(color: Colors.black),
              // const SizedBox(height: 20.0),
              // const QrcodeCard(),
            ],
          ),
        ),
      ),
    );
  }

  _inputText(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  _inputs() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _nameInput(),
          const SizedBox(height: 20.0),
          _codeInput(),
        ],
      ),
    );
  }

  _nameInput() {
    return Column(
      children: [
        _inputText("Nome do Pet"),
        const SizedBox(height: 10.0),
        TextInput(
          off: false,
          password: false,
          text: 'Nome do Pet',
          controller: _nameController,
        ),
      ],
    );
  }

  _codeInput() {
    return Column(
      children: [
        _inputText("Código de cadastro"),
        const SizedBox(height: 10.0),
        TextInput(
          off: false,
          password: false,
          text: 'Código',
          controller: _codeController,
        ),
      ],
    );
  }

  _registerButton(context) {
    return SizedBox(
      height: 50,
      child: PrimaryButton(
        funds: false,
        color: AppColors.primary,
        textColor: Colors.white,
        text: "Finalizar cadastro",
        onPressed: () {
          _register(context);
        },
      ),
    );
  }

  _register(context) async {
    String name = _nameController.text;
    String code = _codeController.text;

    Pet? pet = await petService
        .getPetId(widget.user.uid); // Busca o pet associado ao uid

    if (pet?.id != null) {
      showSnackBar(
          context: context,
          mensagem: "Já existe um pet cadastrado!",
          isErro: true);
      Navigator.pushNamed(context, '/NavPage');
    } else if (_formKey.currentState!.validate()) {
      final result = await fromThingspeak(code);
      if (result != null) {
        final field1 = result['field1'];
        final field3 = result['field3'];
        Pet newPet = Pet(
          id: FirebaseAuth.instance.currentUser!.uid,
          nome: name,
          write: field1,
          read: field3,
        );
        await petService.addPet(pet: newPet);
        showSnackBar(
            context: context,
            mensagem: "Pet adicionado com sucesso!",
            isErro: false);
        Navigator.pushNamed(context, '/NavPage');
      } else {
        showSnackBar(
            context: context, mensagem: "Codigo nao cadastrado!", isErro: true);
      }
    }
    setState(() {}); // Atualiza a UI
  }

  Future<Map<String, dynamic>?> fromThingspeak(String code) async {
    final response = await http.get(Uri.parse(
        'https://api.thingspeak.com/channels/2627688/feeds.json?api_key=GGWWIRV8288GY3PV&results=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final feeds = data['feeds'];

      // Itera sobre os feeds para encontrar o código no field1
      for (var feed in feeds) {
        if (feed['field2'] == code) {
          print("code");
          print(code);

          final field1 = feed['field1'];
          final field3 = feed['field3'];

          // Retorna os valores dos fields 2 e 3
          return {
            'field1': field1,
            'field3': field3,
          };
        }
      }

      // Se não encontrou o código
      print('Código não encontrado.');
      return null;
    } else {
      throw Exception('Falha ao carregar os dados do ThingSpeak');
    }
  }

  void processValues(String code) async {
    final result = await fromThingspeak(code);

    if (result != null) {
      final field2 = result['field2'];
      final field3 = result['field3'];

      // Faça algo com os valores de field2 e field3
      print('Field 2: $field2');
      print('Field 3: $field3');
    } else {
      print('Código não encontrado ou erro ao buscar os dados.');
    }
  }
}
