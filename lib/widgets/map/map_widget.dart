import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/models/alert_pet.dart';
import 'package:rastreia_pet_app/models/pet.dart';
import 'package:rastreia_pet_app/services/pet_services.dart';
import 'package:rastreia_pet_app/widgets/dialog/map_dialog.dart';
import 'package:share_plus/share_plus.dart';

class MapWidget extends StatefulWidget {
  final String read;
  final AlertPet? alertPet;

  const MapWidget({
    super.key,
    required this.read,
    this.alertPet,
  });

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late GoogleMapController mapController;
  MarkerId? lastMarkerId;
  Map<MarkerId, Marker> markers = {};
  Timer? timer;
  LatLng? initialPosition;
  LatLng actualPosition = LatLng(0, 0);
  LatLng newPosition = LatLng(0, 0);
  Map<CircleId, Circle> circles = {};
  bool mapCreated = false;
  BitmapDescriptor customMarkerDescriptor = BitmapDescriptor.defaultMarker;
  User? user = FirebaseAuth.instance.currentUser;
  PetService petService = PetService();
  Pet? pet;
  @override
  void initState() {
    customMarkers();
    super.initState();
    if (widget.alertPet != null) {
      updateCircles();
    }
    _loadPet();
    fromThingspeak();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      fromThingspeak();
    });
  }

  Future<void> _loadPet() async {
    Pet? fetchedPet = await petService.getPetId(user!.uid);
    setState(() {
      pet = fetchedPet;
    });
    print(pet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        compassEnabled: true,
        onMapCreated: _onMapCreated,
        circles: Set<Circle>.of(circles.values),
        initialCameraPosition: initialPosition != null
            ? CameraPosition(
                target: initialPosition!,
                zoom: 20.0,
              )
            : const CameraPosition(
                target: LatLng(0, 0),
                zoom: 20.0,
              ),
        markers: Set<Marker>.of(markers.values),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _button(context),
    );
  }

  void customMarkers() {
    BitmapDescriptor.asset(const ImageConfiguration(size: Size(130, 130)),
            'lib/assets/images/newpin.png')
        .then((icon) {
      // Atualiza o estado com o novo ícone
      setState(() {
        customMarkerDescriptor = icon;
      });
    }).catchError((error) {
      print('Erro ao carregar o ícone: $error');
    });
  }

  void updateCircles() {
    if (widget.alertPet != null) {
      final position = LatLng(
        double.parse(widget.alertPet!.latitude),
        double.parse(widget.alertPet!.longitude),
      );
      actualPosition = position;
      final circleId = CircleId(position.toString());
      final circle = Circle(
        circleId: circleId,
        center: position,
        radius: double.parse(widget.alertPet!.distancia),
        fillColor: AppColors.primary.withOpacity(0.3),
        strokeColor: AppColors.primary,
        strokeWidth: 2,
      );

      setState(() {
        circles[circleId] = circle;
      });

      if (mapCreated) {
        mapController.animateCamera(
          CameraUpdate.newLatLng(position),
        );
      }
    } else {
      print('widget.alertPet é null');
    }
  }

  _button(context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          shareLocation(newPosition);
        },
        child:
            const Icon(Icons.ios_share_outlined, color: Colors.white, size: 28),
      ),
    );
  }

  void shareLocation(LatLng location) {
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}';

    Share.share(
        'Veja a localização atual do pet ${pet!.nome} no Google Maps: $googleMapsUrl');
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      mapCreated = true;
    });
    if (initialPosition != null) {
      mapController.animateCamera(
        CameraUpdate.newLatLng(initialPosition!),
      );
    }
  }

  @override
  void didUpdateWidget(covariant MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.alertPet != oldWidget.alertPet) {
      updateCircles();
    }
  }

  Future<void> fromThingspeak() async {
    try {
      final response = await http.get(Uri.parse(widget.read));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Verifica se o dado é realmente um Map
        if (data is Map<String, dynamic>) {
          await updateMarkers(data);
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

  // Future<void> updateMarkers(Map<String, dynamic> data) async {
  //   if (data['feeds'] != null && data['feeds'].isNotEmpty) {
  //     var lastFeed = data['feeds'].last; // Pega o último feed
  //     if (lastFeed['field1'] != null &&
  //         lastFeed['field2'] != null &&
  //         lastFeed['field3'] != null &&
  //         lastFeed['created_at'] != null) {
  //       var field1Value = double.parse(lastFeed['field1']);
  //       var field2Value = double.parse(lastFeed['field2']);
  //       var field3Value = double.parse(lastFeed['field3']);
  //       var createdAt = lastFeed['created_at']; // Timestamp do feed

  //       newPosition = LatLng(field1Value, field2Value);
  //       print("newPosition: $newPosition");

  //       // Crie um novo MarkerId para o último marcador, com base no entry_id
  //       final markerId = MarkerId('LocationMarker_${lastFeed['entry_id']}');
  //       final marker = Marker(
  //         markerId: markerId,
  //         icon: customMarkerDescriptor,
  //         position: newPosition,
  //         onTap: () {
  //           showDialog(
  //             context: context,
  //             builder: (BuildContext context) {
  //               // Formatar timestamp para exibir data e hora
  //               DateTime dateTime = DateTime.parse(createdAt);
  //               String formattedDateTime = "${dateTime.toLocal()}"
  //                   .split('.')[0]; // Remove microssegundos
  //               return MapDialog(
  //                 latitude: field1Value.toStringAsFixed(4),
  //                 longitude: field2Value.toStringAsFixed(4),
  //                 distance: field3Value,
  //                 dateTime: formattedDateTime,
  //               );
  //             },
  //           );
  //         },
  //       );

  //       // Adiciona o novo marcador ao mapa, sem apagar os anteriores
  //       setState(() {
  //         markers[markerId] = marker; // Adiciona o novo marcador
  //       });

  //       // Mover a câmera para o novo marcador
  //       if (mapCreated) {
  //         await mapController.animateCamera(
  //           CameraUpdate.newLatLng(newPosition),
  //         );
  //       }
  //       mapCreated = false;
  //     }
  //   }
  // }

  Future<void> updateMarkers(Map<String, dynamic> data) async {
    if (data['feeds'] != null && data['feeds'].isNotEmpty) {
      var firstFeed = data['feeds'][0];
      if (firstFeed['field1'] != null &&
          firstFeed['field2'] != null &&
          firstFeed['field3'] != null &&
          firstFeed['created_at'] != null) {
        var field1Value = double.parse(firstFeed['field1']);
        var field2Value = double.parse(firstFeed['field2']);
        var field3Value = double.parse(firstFeed['field3']);

        var createdAt = firstFeed['created_at']; // Timestamp do feed

        LatLng newPosition = LatLng(field1Value, field2Value);

        setState(() {
          initialPosition = newPosition;

          if (lastMarkerId != null) {
            markers.remove(lastMarkerId);
          }

          final markerId = MarkerId('LocationMarker_${firstFeed['entry_id']}');
          final marker = Marker(
            markerId: markerId,
            icon: customMarkerDescriptor,
            position: newPosition,
            anchor: Offset(0.5, 0.6),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // Formata o timestamp para exibir data e hora
                  DateTime dateTime = DateTime.parse(createdAt);
                  String formattedDateTime = "${dateTime.toLocal()}"
                      .split('.')[0]; // Remove microssegundos
                  return MapDialog(
                    latitude: field1Value.toStringAsFixed(4),
                    longitude: field2Value.toStringAsFixed(4),
                    distance: field3Value,
                    dateTime: formattedDateTime,
                  );
                },
              );
            },
          );

          markers[markerId] = marker;
          lastMarkerId = markerId;
        });

        if (mapCreated) {
          await mapController
              .animateCamera(CameraUpdate.newLatLng(newPosition));
        }
        mapCreated = false;
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
