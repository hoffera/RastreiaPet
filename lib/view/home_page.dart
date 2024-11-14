// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:provider/provider.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/models/pet.dart';
import 'package:rastreia_pet_app/services/change_notifier.dart';
import 'package:rastreia_pet_app/widgets/card/card_button.dart';
import 'package:rastreia_pet_app/widgets/dialog/change_update_dialog.dart';
import 'package:rastreia_pet_app/widgets/dialog/show_snackbar.dart';
import 'package:rastreia_pet_app/widgets/logo/logo_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  late final Future<Pet?> _petExistsFuture = petService.getPetId(user!.uid);

  Pet? pet;
  @override
  void initState() {
    super.initState();
    _loadPet();
    Provider.of<DataSender>(context, listen: false).startSendingData();
  }

  @override
  void dispose() {
    Provider.of<DataSender>(context, listen: false).stopSendingData();
    super.dispose();
  }

  Future<void> _loadPet() async {
    try {
      Pet? fetchedPet = await petService.getPetId(user!.uid);

      setState(() {
        pet = fetchedPet;
      });
    } catch (e) {
      print('Error loading pet data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: RawScrollbar(
          thumbColor: AppColors.primary, // Cor do scrollbar
          thickness: 8, // Espessura do scrollbar

          padding: const EdgeInsets.all(5),

          radius: const Radius.circular(20), // Raio das bordas
          thumbVisibility: true, //
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const LogoWidget(),
                  const SizedBox(height: 10.0),
                  _helloText(),
                  const SizedBox(height: 20.0),
                  _helpPageCard(context),
                  const SizedBox(height: 10.0),
                  _registerPetCard(context),
                  const SizedBox(height: 10.0),
                  _registerAlert(context),
                  const SizedBox(height: 10.0),
                  _changeUpdate(context),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _helloText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          // Remove o SizedBox e usa Expanded diretamente
          child: StyledText(
            "Olá, ${user!.displayName}",
            style: Style(
              $text.style.color.black(),
              $text.style.fontSize(24),
              $text.style.fontWeight(FontWeight.bold),
              $text.textAlign.start(),
              $text.overflow.ellipsis(), // Texto será cortado com '...'
            ),
            // Limita a uma linha
          ),
        ),
      ],
    );
  }

  _helpPageCard(context) {
    return CardButton(
      icon: Icons.live_help_outlined,
      text: "Tutorial",
      onPressed: () {
        Navigator.pushNamed(context, '/HelpPage');
      },
    );
  }

  _registerPetCard(context) {
    return CardButton(
      icon: Icons.pets,
      text: "Cadastrar novo Pet",
      onPressed: () {
        Navigator.pushNamed(context, '/RegisterPetPage');
      },
    );
  }

  _registerAlert(context) {
    return CardButton(
      icon: Icons.add_alert,
      text: "Criar uma Zona Segura",
      onPressed: () {
        _petExistsFuture.then((exists) {
          if (exists != null) {
            Navigator.pushNamed(context, '/RegisterAlertPage');
          } else {
            showSnackBar(
                context: context,
                mensagem: "Cadastre um Pet primeiro!",
                isErro: true);
          }
        });
      },
    );
  }

  _changeUpdate(context) {
    return CardButton(
      icon: Icons.edit_location_sharp,
      text: "Alterar atualização\nda coleira",
      onPressed: () {
        _petExistsFuture.then((exists) {
          if (exists != null) {
            _changeUpdateDialog(context);
          } else {
            showSnackBar(
                context: context,
                mensagem: "Cadastre um Pet primeiro!",
                isErro: true);
          }
        });
      },
    );
  }

  void _changeUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ChangeUpdateDialog();
      },
    );
  }
}
