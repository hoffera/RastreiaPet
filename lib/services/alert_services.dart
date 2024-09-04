import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rastreia_pet_app/models/alert_pet.dart';

class AlertPetService {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addAlertPet({required AlertPet alert}) async {
    return firestore.collection('alerts').doc(uid).set(alert.toMap());
  }

  Future<AlertPet?> getAlertPet() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception('Usuário não autenticado.');
    }

    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('alerts')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return AlertPet.fromMap(snapshot.docs.first.data());
    } else {
      print("Sem alerts");
      return null;
    }
  }

  Future<AlertPet?> getAlertPetId(String alertId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('alerts').doc(alertId).get();

    if (snapshot.exists) {
      return AlertPet.fromMap(snapshot.data()!);
    } else {
      return null;
    }
  }

  Future<AlertPet?> getAlertPetById(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('alerts').doc(userId).get();

    if (snapshot.exists) {
      return AlertPet.fromMap(snapshot.data()!);
    } else {
      return null;
    }
  }

  Future<void> removeAlertPet({required String alert}) async {
    return firestore.collection('alerts').doc(alert).delete();
  }
}
