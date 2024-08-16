// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mix/mix.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/models/pet.dart';
import 'package:rastreia_pet_app/services/pet_services.dart';
import 'package:rastreia_pet_app/widgets/map_widget.dart';

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
  late Future<bool> _petExistsFuture;

  @override
  void initState() {
    super.initState();
    _petExistsFuture = _existPet();
  }

  Future<bool> _existPet() async {
    Pet? pet = await petService
        .getPetId(widget.user.uid); // Busca o pet associado ao uid

    if (pet?.id != null) {
      print('existe pet');
      return true;
    } else {
      print('não existe pet');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FutureBuilder<bool>(
          future: _petExistsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data == true) {
              return _map();
            } else {
              return const Text('Nenhum pet encontrado.');
            }
          },
        ),
      ),
    );
  }

  Widget _map() {
    return Box(
      style: Style(
        $box.maxWidth(double.infinity),
        $box.maxHeight(900),
        $box.color(Colors.white),
      ),
      child: const MapWidget(),
    );
  }
}
