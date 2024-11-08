import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mix/mix.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/models/alert_pet.dart';
import 'package:rastreia_pet_app/models/pet.dart';
import 'package:rastreia_pet_app/services/alert_services.dart';
import 'package:rastreia_pet_app/services/pet_services.dart';
import 'package:rastreia_pet_app/widgets/card/card_button.dart';
import 'package:rastreia_pet_app/widgets/logo/logo_widget.dart';
import 'package:rastreia_pet_app/widgets/map/map_widget.dart';

class MapPage extends StatefulWidget {
  const MapPage({
    super.key,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  User? user = FirebaseAuth.instance.currentUser;
  late GoogleMapController mapController;
  PetService petService = PetService();
  AlertPetService alertPetService = AlertPetService();

  late final Future<Pet?> _petExistsFuture = petService.getPetId(user!.uid);

  Pet? pet;
  AlertPet? alertPet;

  @override
  void initState() {
    super.initState();
    _loadPet();
    _loadAlert();
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

  Future<void> _loadAlert() async {
    try {
      AlertPet? fetchedAlert = await alertPetService.getAlertPetById(user!.uid);

      setState(() {
        alertPet = fetchedAlert;
      });
    } catch (e) {
      print('Error loading alert data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FutureBuilder<Pet?>(
          future: _petExistsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return _noPet(context);
            } else if (snapshot.hasData) {
              if (snapshot.data != null) {
                return _map(context);
              } else {
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
                        "Sem pet cadastrado",
                        style: Style(
                          $text.style.color.black(),
                          $text.style.fontSize(24),
                          $text.style.fontWeight(FontWeight.bold),
                          $text.textAlign.center(),
                        ),
                      ),
                      const SizedBox(height: 100),
                      _registerPetCard(context),
                    ],
                  ),
                );
              }
            } else {
              return _noPet(context);
            }
          },
        ),
      ),
    );
  }

  Widget _registerPetCard(BuildContext context) {
    return CardButton(
      icon: Icons.pets,
      text: "Cadastrar novo Pet",
      onPressed: () {
        Navigator.pushNamed(context, '/RegisterPetPage');
      },
    );
  }

  Widget _noPet(context) {
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
            "Sem pet cadastrado",
            style: Style(
              $text.style.color.black(),
              $text.style.fontSize(30),
              $text.style.fontWeight(FontWeight.bold),
              $text.textAlign.center(),
            ),
          ),
          const SizedBox(height: 10),
          StyledText(
            "Cadastre um pet para ter acesso ao mapa, cadastre aqui:",
            style: Style(
              $text.style.color.black(),
              $text.style.fontSize(20),
              $text.style.fontWeight(FontWeight.normal),
              $text.textAlign.center(),
            ),
          ),
          const SizedBox(height: 30),
          _registerPetCard(context),
        ],
      ),
    );
  }

  Widget _map(context) {
    if (pet == null) {
      return _noPet(context);
    }

    return SizedBox(
      child: MapWidget(
        alertPet: alertPet,
        read: pet!.read,
        // write: pet!.write,
      ),
    );
  }
}
