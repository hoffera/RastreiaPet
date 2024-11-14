import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/models/pet.dart';
import 'package:rastreia_pet_app/widgets/button/primary_button.dart';
import 'package:rastreia_pet_app/widgets/dialog/change_update_dialog.dart';
import 'package:rastreia_pet_app/widgets/dialog/show_snackbar.dart';
import 'package:rastreia_pet_app/widgets/input/text_input.dart';
import 'package:rastreia_pet_app/widgets/logo/logo_widget.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<StatefulWidget> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  Barcode? result;
  User? user = FirebaseAuth.instance.currentUser;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 400.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: AppColors.primary,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      print("Código escaneado: ${scanData.code}"); // Log do código escaneado
      setState(() {
        result = scanData;
      });
      // Navegar para a tela de registro de pet com o código do QR
      if (scanData.code != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterPetScreen(qrCode: scanData.code!),
          ),
        );
        showSnackBar(
            context: context, mensagem: "QrCode escaneado!", isErro: false);
      }
    }, onError: (error) {
      print("Erro no scanDataStream: $error"); // Log de erro
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class RegisterPetScreen extends StatelessWidget {
  final String qrCode;

  RegisterPetScreen({super.key, required this.qrCode});

  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<Map<String, dynamic>?> fromThingspeak(String code) async {
    final response = await http.get(Uri.parse(
        'https://api.thingspeak.com/channels/2627688/feeds.json?api_key=GGWWIRV8288GY3PV&results=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final feeds = data['feeds'];

      for (var feed in feeds) {
        if (feed['field2'] == code) {
          final field1 = feed['field1'];
          final field3 = feed['field3'];
          return {
            'field1': field1,
            'field3': field3,
          };
        }
      }
      print('Código não encontrado.');
      return null;
    } else {
      throw Exception('Falha ao carregar os dados do ThingSpeak');
    }
  }

  Future<void> _register(BuildContext context) async {
    String name = _nameController.text;
    User? user = FirebaseAuth.instance.currentUser;

    Pet? pet =
        await petService.getPetId(user!.uid); // Busca o pet associado ao uid

    if (pet?.id != null) {
      Navigator.pushNamed(context, '/NavPage');
      showSnackBar(
          context: context,
          mensagem: "Já existe um pet cadastrado!",
          isErro: true);
    } else if (_formKey.currentState!.validate()) {
      final result = await fromThingspeak(qrCode);
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
        Navigator.pushNamed(context, '/NavPage');
        showSnackBar(
            context: context,
            mensagem: "Pet adicionado com sucesso!",
            isErro: false);
      } else {
        showSnackBar(
            context: context, mensagem: "Código não cadastrado!", isErro: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          reverse: true,
          child: SizedBox(
            height: MediaQuery.of(context)
                .size
                .height, // Faz com que o container ocupe toda a altura da tela
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centraliza verticalmente
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Centraliza horizontalmente
              children: [
                const LogoWidget(),
                const SizedBox(height: 30),
                _title("Código escaneado"),
                const SizedBox(height: 10),
                _subtitle("Insira o nome do seu pet para finalizar o cadastro"),
                const SizedBox(height: 30),
                _inputs(),
                const SizedBox(height: 30),
                PrimaryButton(
                  funds: false,
                  color: AppColors.primary,
                  textColor: Colors.white,
                  text: "Registrar",
                  onPressed: () => _register(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _inputs() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _nameInput(),
        ],
      ),
    );
  }

  _nameInput() {
    return Column(
      children: [
        _inputText("Nome do pet"),
        const SizedBox(height: 10.0),
        TextInput(
          off: false,
          password: false,
          name: true,
          text: "Nome do pet",
          controller: _nameController,
        ),
      ],
    );
  }

  _title(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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

  _subtitle(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  _inputText(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
