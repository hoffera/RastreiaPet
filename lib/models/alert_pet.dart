// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:deep_pick/deep_pick.dart';

class AlertPet {
  final String id;
  String latitude;
  String longitude;
  String distancia;

  AlertPet({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.distancia,
  });

  factory AlertPet.fromMap(Map<String, dynamic> json) {
    return AlertPet(
      id: pick(json, "id").asStringOrThrow(),
      latitude: pick(json, "latitude").asStringOrThrow(),
      longitude: pick(json, "longitude").asStringOrThrow(),
      distancia: pick(json, "distancia").asStringOrThrow(),
    );
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'distancia': distancia,
    };
  }
}
