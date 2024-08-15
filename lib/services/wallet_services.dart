import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rastreia_pet_app/models/wallet.dart';

class WalletService {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addWallet({required Wallet wallet}) async {
    return firestore.collection(uid).doc(wallet.id).set(wallet.toMap());
  }

  Future<List<Wallet>> getWallet() async {
    List<Wallet> temp = [];

    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection(uid).get();

    for (var doc in snapshot.docs) {
      temp.add(Wallet.fromMap(doc.data()));
    }

    return temp;
  }

  Future<Wallet?> getWalletById(String walletId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection(uid).doc(walletId).get();

    if (snapshot.exists) {
      return Wallet.fromMap(snapshot.data()!);
    } else {
      return null;
    }
  }

  Future<void> removeWallet({required String walletId}) async {
    return firestore.collection(uid).doc(walletId).delete();
  }

  Future<void> updateWalletBalance({
    required String walletId,
    required String newBalance,
  }) async {
    try {
      await firestore
          .collection(uid)
          .doc(walletId)
          .update({'balance': newBalance});
    } catch (e) {
      throw Exception('Failed to update wallet balance: $e');
    }
  }
}
