import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class TokenServices {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para obter o token FCM
  Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Método para salvar o token FCM no Firestore
  Future<void> saveToken(String userId) async {
    String? token = await getFCMToken();
    if (token != null) {
      await _firestore.collection('users').doc(userId).set({
        'fcmToken': token,
      }, SetOptions(merge: true)); // merge: true para atualizar o token
    }
  }

  // Método para atualizar o token FCM
  Future<void> updateToken(String userId) async {
    String? token = await getFCMToken();
    if (token != null) {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': token,
      });
    }
  }

  // Método para escutar mudanças no token
  void listenToTokenChanges(String userId) {
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      // Atualiza o token no Firestore quando o token muda
      updateToken(userId);
    });
  }
}
