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
  final User user;
  const MapPage({
    super.key,
    required this.user,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  PetService petService = PetService();
  AlertPetService alertPetService = AlertPetService();

  late final Future<Pet?> _petExistsFuture =
      petService.getPetId(widget.user.uid);

  Pet? pet;
  AlertPet? alertPet;

  @override
  void initState() {
    super.initState();
    _loadPet();
  }

  Future<void> _loadPet() async {
    try {
      AlertPet? fetchedAlert =
          await alertPetService.getAlertPetById(widget.user.uid);
      Pet? fetchedPet = await petService.getPetId(widget.user.uid);

      setState(() {
        pet = fetchedPet;
        alertPet = fetchedAlert;
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
        child: FutureBuilder<Pet?>(
          future: _petExistsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error ?? 'Unknown error'}');
            } else if (snapshot.hasData) {
              if (snapshot.data != null) {
                return _map();
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
                          $text.style.fontSize(30),
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
              return const Text('No data available');
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

  Widget _map() {
    if (pet == null) {
      return const Center(child: Text('Sem pet cadastrado'));
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
