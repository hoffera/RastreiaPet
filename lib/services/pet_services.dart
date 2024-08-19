import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rastreia_pet_app/models/pet.dart';

class PetService {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addPet({required Pet pet}) async {
    return firestore.collection('pets').doc(uid).set(pet.toMap());
  }

  Future<Pet?> getPet() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception('Usuário não autenticado.');
    }

    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('pets')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return Pet.fromMap(snapshot.docs.first.data());
    } else {
      print("Sem pets");
      return null;
    }
  }

  Future<Pet?> getPetId(String petId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('pets').doc(petId).get();

    if (snapshot.exists) {
      return Pet.fromMap(snapshot.data()!);
    } else {
      return null;
    }
  }

  Future<Pet?> getPetById(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('pets').doc(userId).get();

    if (snapshot.exists) {
      return Pet.fromMap(snapshot.data()!);
    } else {
      return null;
    }
  }

  Future<void> removePet({required String pet}) async {
    return firestore.collection('pets').doc(pet).delete();
  }

  Future<void> updatePetName({required String newName}) async {
    return firestore.collection('pets').doc(uid).update({
      'nome': newName,
    });
  }
}
