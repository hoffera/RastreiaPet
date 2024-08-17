// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapWidget extends StatefulWidget {
  final String read;
  const MapWidget({
    super.key,
    required this.read,
  });

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late GoogleMapController mapController;
  MarkerId? lastMarkerId;
  Map<MarkerId, Marker> markers = {};
  Timer? timer;

  @override
  void initState() {
    super.initState();
    fromThingspeak(); // Inicialmente busca os dados

    // Configura um temporizador para atualizar os dados a cada 5 segundos
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      fromThingspeak();
    });
  }

  @override
  void didUpdateWidget(covariant MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> fromThingspeak() async {
    final response = await http.get(Uri.parse(widget.read));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      await updateMarkers(data);
    } else {
      throw Exception('Falha ao carregar os dados do ThingSpeak');
    }
  }

  Future<void> updateMarkers(Map<String, dynamic> data) async {
    if (data['feeds'].isNotEmpty) {
      setState(() {
        // Remove o marcador anterior
        if (lastMarkerId != null) {
          markers.remove(lastMarkerId);
        }

        var field1Value = double.parse(data['feeds'][0]['field1']);
        var field2Value = double.parse(data['feeds'][0]['field2']);
        var field3Value = double.parse(data['feeds'][0]['field3']);

        print(field1Value);
        print(field2Value);
        print("distancia");
        print(field3Value);

        final markerId =
            MarkerId('LocationMarker_${data['feeds'][0]['entry_id']}');
        final marker = Marker(
          markerId: markerId,
          position: LatLng(field2Value, field1Value),
          onTap: () {
            _showCustomInfoWindow(
              context,
              LatLng(field2Value, field1Value),
              field2Value,
              field1Value,
              field3Value,
            );
          },
        );

        // Adiciona o novo marcador
        markers[markerId] = marker;

        // Move a câmera para a posição do novo marcador
        mapController.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(field2Value, field1Value), 15.0),
        );

        // Atualiza o ID do último marcador
        lastMarkerId = markerId;
      });
    }
  }

  void _showCustomInfoWindow(BuildContext context, LatLng position,
      double latitude, double longitude, double distance) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Detalhes da Coleira",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text("Latitude: ${latitude.toStringAsFixed(4)}"),
              Text("Longitude: ${longitude.toStringAsFixed(4)}"),
              Text("Distância: ${distance.toStringAsFixed(2)} km"),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Fechar"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0),
          zoom: 12.0,
        ),
        markers: Set<Marker>.of(markers.values),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancela o timer quando o widget é descartado
    super.dispose();
  }
}
