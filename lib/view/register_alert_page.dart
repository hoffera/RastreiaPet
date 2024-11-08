import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/models/pet.dart';
import 'package:rastreia_pet_app/services/pet_services.dart';
import 'package:rastreia_pet_app/widgets/logo/logo_widget.dart';
import 'package:rastreia_pet_app/widgets/map/map_alert_widget.dart';

class RegisterAlertPage extends StatefulWidget {
  const RegisterAlertPage({super.key});

  @override
  State<RegisterAlertPage> createState() => _RegisterAlertPageState();
}

class _RegisterAlertPageState extends State<RegisterAlertPage> {
  User? user = FirebaseAuth.instance.currentUser;
  PetService petService = PetService();
  late final Future<Pet?> _petExistsFuture = petService.getPetId(user!.uid);

  Pet? pet;

  @override
  void initState() {
    super.initState();

    _loadPet();
  }

  Future<void> _loadPet() async {
    Pet? fetchedPet = await petService.getPetId(user!.uid);
    setState(() {
      pet = fetchedPet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RawScrollbar(
        thumbColor: AppColors.primary, // Cor do scrollbar
        thickness: 8, // Espessura do scrollbar

        padding: EdgeInsets.all(5),
        radius: Radius.circular(20), // Raio das bordas
        thumbVisibility: true, // Sempre aparente
        // padding: EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
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
        ),
      ),
    );
  }

  _register() {
    return Column(
      children: [
        SizedBox(height: 50),
        _titleText(),
        _subtitleText(),
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
          "Criar um alerta  ",
          style: TextStyle(
            fontSize: 28,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Icon(
          Icons.add_alert,
          size: 30,
          color: AppColors.primary,
        )
      ],
    );
  }

  _subtitleText() {
    return const Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text(
            "Toque no mapa para selecionar o local\n e defina um raio. Receba notificações caso seu animal saia dessa área. Mantenha seu Pet seguro e sob controle!",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
            textAlign:
                TextAlign.center, // Adicione isso para centralizar o texto
          ),
        ],
      ),
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
