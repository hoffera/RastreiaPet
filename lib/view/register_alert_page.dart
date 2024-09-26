import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/models/pet.dart';
import 'package:rastreia_pet_app/services/pet_services.dart';
import 'package:rastreia_pet_app/widgets/logo/logo_widget.dart';
import 'package:rastreia_pet_app/widgets/map/map_alert_widget.dart';

class RegisterAlertPage extends StatefulWidget {
  final User user;
  const RegisterAlertPage({super.key, required this.user});

  @override
  State<RegisterAlertPage> createState() => _RegisterAlertPageState();
}

class _RegisterAlertPageState extends State<RegisterAlertPage> {
  PetService petService = PetService();
  late final Future<Pet?> _petExistsFuture =
      petService.getPetId(widget.user.uid);

  Pet? pet;

  @override
  void initState() {
    super.initState();

    _loadPet();
  }

  Future<void> _loadPet() async {
    Pet? fetchedPet = await petService.getPetId(widget.user.uid);
    setState(() {
      pet = fetchedPet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: FutureBuilder<Pet?>(
            future: _petExistsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error ?? 'Unknown error'}');
              } else if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return _register();
                } else {
                  return _petNull();
                }
              } else {
                return const Text('No data available');
              }
            },
          ),
        ),
      ),
    );
  }

  _register() {
    return Column(
      children: [
        const SizedBox(height: 50.0),
        _titleText(),
        const SizedBox(height: 10),
        _subtitleText(),
        const SizedBox(height: 30),
        _map(),
      ],
    );
  }

  _petNull() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LogoWidget(),
          const SizedBox(
            height: 50,
          ),
          StyledText(
            "Sem pet cadastrado ",
            style: Style(
              $text.style.color.black(),
              $text.style.fontSize(30),
              $text.style.fontWeight(FontWeight.bold),
              $text.textAlign.center(),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  _titleText() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Criar um alerta",
          style: TextStyle(
            fontSize: 32,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  _subtitleText() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Toque no mapa para selecionar o local e\ndefina um raio. Receba notificações caso\nseu animal saia dessa área. Mantenha seu\nPet seguro e sob controle!",
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  _map() {
    return Box(
      style: Style(
        $box.maxWidth(double.infinity),
        $box.borderRadius(20),
        $box.color(Colors.white),
      ),
      child: MapAlertWidget(
        read: pet!.read,
        // write: pet!.write,
      ),
    );
  }

  // _registerV(context) async {
  //   Pet? pet = await petService.getPetById(widget.user.uid);

  //   if (pet == null) {
  //     showSnackBar(
  //         context: context,
  //         mensagem: "Pet adicionado com sucesso!",
  //         isErro: false);
  //   }
  //   setState(() {}); // Atualiza a UI
  // }
}
