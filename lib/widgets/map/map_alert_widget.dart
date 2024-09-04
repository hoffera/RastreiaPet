import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/models/alert_pet.dart';
import 'package:rastreia_pet_app/services/alert_services.dart';
import 'package:rastreia_pet_app/widgets/button/primary_button.dart';
import 'package:rastreia_pet_app/widgets/card/perfil_card.dart';
import 'package:rastreia_pet_app/widgets/dialog/show_snackbar.dart';

class MapAlertWidget extends StatefulWidget {
  final String read;
  const MapAlertWidget({
    super.key,
    required this.read,
  });

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapAlertWidget> {
  late GoogleMapController mapController;
  Map<CircleId, Circle> circles = {};
  double radius = 100.0; // Raio inicial padrão
  LatLng? initialPosition;
  AlertPetService alertPetService = AlertPetService();
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fromThingspeak();
    _inputController.addListener(_updateRadiusFromInput);
  }

  @override
  void dispose() {
    _inputController.removeListener(_updateRadiusFromInput);
    _inputController.dispose();
    super.dispose();
  }

  void _updateRadiusFromInput() {
    final inputValue = _inputController.text;
    if (inputValue.isNotEmpty) {
      final parsedValue = double.tryParse(inputValue);
      if (parsedValue != null) {
        setState(() {
          radius = parsedValue;
          if (initialPosition != null) {
            updateCircles(
                initialPosition!.latitude, initialPosition!.longitude);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (initialPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          _map(),
          const SizedBox(height: 20),
          _distance(),
          const SizedBox(height: 20),
          _registerButton(context),
        ],
      ),
    );
  }

  _registerButton(context) {
    return SizedBox(
      height: 50,
      child: PrimaryButton(
        funds: false,
        color: AppColors.primary,
        textColor: Colors.white,
        text: "Criar alerta",
        onPressed: () {
          _saveAlert();
        },
      ),
    );
  }

  _map() {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: GoogleMap(
        circles: Set<Circle>.of(circles.values),
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: initialPosition!,
          zoom: 17.0,
        ),
        onTap: _handleTap,
      ),
    );
  }

  _distance() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: PerfilCard(
        inputController: _inputController,
        map: true,
        icon: Icons.pin_drop_rounded,
        cardText: "Raio",
        infoText: "$radius metros",
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> fromThingspeak() async {
    try {
      final response = await http.get(Uri.parse(widget.read));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['feeds'].isNotEmpty) {
          var firstFeed = data['feeds'][0];
          if (firstFeed['field1'] != null && firstFeed['field2'] != null) {
            var field1Value = double.parse(firstFeed['field1']);
            var field2Value = double.parse(firstFeed['field2']);
            setState(() {
              initialPosition = LatLng(field2Value, field1Value);
              updateCircles(field2Value, field1Value);
            });
          }
        }
      } else {
        throw Exception('Falha ao carregar os dados do ThingSpeak');
      }
    } catch (e) {
      // Handle the error
    }
  }

  void updateCircles(double latitude, double longitude) {
    final position = LatLng(latitude, longitude);
    final circleId = CircleId(position.toString());
    final circle = Circle(
      circleId: circleId,
      center: position,
      radius: radius,
      fillColor: AppColors.primary.withOpacity(0.3),
      strokeColor: AppColors.primary,
      strokeWidth: 2,
    );

    setState(() {
      circles.clear();
      circles[circleId] = circle;
    });

    mapController.animateCamera(
      CameraUpdate.newLatLng(position),
    );
  }

  void _handleTap(LatLng tappedPoint) {
    final circleId = CircleId(tappedPoint.toString());
    final circle = Circle(
      circleId: circleId,
      center: tappedPoint,
      radius: radius,
      fillColor: Colors.blue.withOpacity(0.3),
      strokeColor: Colors.blue,
      strokeWidth: 1,
    );

    setState(() {
      circles.clear();
      circles[circleId] = circle;
    });
  }

  void _saveAlert() async {
    if (circles.isNotEmpty) {
      final circle = circles.values.first;

      AlertPet newAlert = AlertPet(
        id: FirebaseAuth.instance.currentUser!.uid,
        distancia: circle.radius.toString(),
        latitude: circle.center.latitude.toString(),
        longitude: circle.center.longitude.toString(),
      );
      await alertPetService.addAlertPet(alert: newAlert);
      showSnackBar(
          context: context,
          mensagem: "Alerta adicionado com sucesso!",
          isErro: false);
      Navigator.pushNamed(context, '/NavPage');

      // Você pode adicionar código para salvar as informações em um backend ou localmente
    } else {
      // Caso não haja círculos criados
      showSnackBar(context: context, mensagem: "Erro!", isErro: true);
    }
  }
}
