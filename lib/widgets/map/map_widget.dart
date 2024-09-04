import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/models/alert_pet.dart';
import 'package:rastreia_pet_app/widgets/dialog/map_dialog.dart';

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
  Map<CircleId, Circle> circles = {};
  bool mapCreated = false;
  BitmapDescriptor customMarkerDescriptor = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    if (widget.alertPet != null) {
      updateCircles();
    }
    customMarkers();

    fromThingspeak();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      customMarkers();
      fromThingspeak();
    });
  }

  void customMarkers() {
    BitmapDescriptor.asset(const ImageConfiguration(size: Size(50, 60)),
            'lib/assets/images/dog.png')
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        circles: Set<Circle>.of(circles.values),
        initialCameraPosition: initialPosition != null
            ? CameraPosition(
                target: initialPosition!,
                zoom: 15.0,
              )
            : const CameraPosition(
                target: LatLng(0, 0),
                zoom: 15.0,
              ),
        markers: Set<Marker>.of(markers.values),
      ),
    );
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
        await updateMarkers(data);
      } else {
        throw Exception('Falha ao carregar os dados do ThingSpeak');
      }
    } catch (e) {
      print('Erro ao carregar os dados: $e');
    }
  }

  Future<void> updateMarkers(Map<String, dynamic> data) async {
    if (data['feeds'] != null && data['feeds'].isNotEmpty) {
      var firstFeed = data['feeds'][0];
      if (firstFeed['field1'] != null &&
          firstFeed['field2'] != null &&
          firstFeed['field3'] != null) {
        setState(() async {
          var field1Value = double.parse(firstFeed['field1']);
          var field2Value = double.parse(firstFeed['field2']);
          var field3Value = double.parse(firstFeed['field3']);

          initialPosition = LatLng(field2Value, field1Value);

          if (lastMarkerId != null) {
            markers.remove(lastMarkerId);
          }

          final markerId = MarkerId('LocationMarker_${firstFeed['entry_id']}');
          final marker = Marker(
            markerId: markerId,
            icon: customMarkerDescriptor,
            position: LatLng(field2Value, field1Value),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return MapDialog(
                    latitude: field1Value.toStringAsFixed(4),
                    longitude: field2Value.toStringAsFixed(4),
                    distance: field3Value.toStringAsFixed(2),
                  );
                },
              );
            },
          );

          markers[markerId] = marker;
          lastMarkerId = markerId;

          if (mapCreated) {
            mapController.animateCamera(CameraUpdate.newLatLng(
              LatLng(field2Value, field1Value),
            ));
          }
        });
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
