// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:deep_pick/deep_pick.dart';

class Pet {
  final String id;
  String nome;
  String write;
  String read;

  Pet({
    required this.id,
    required this.nome,
    required this.write,
    required this.read,
  });

  factory Pet.fromMap(Map<String, dynamic> json) {
    return Pet(
      nome: pick(json, "nome").asStringOrThrow(),
      id: pick(json, "id").asStringOrThrow(),
      write: pick(json, "write").asStringOrThrow(),
      read: pick(json, "read").asStringOrThrow(),
    );
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'write': write,
      'read': read,
    };
  }
}
