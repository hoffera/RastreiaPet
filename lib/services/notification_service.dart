import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  static Future init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    final token = await _firebaseMessaging.getToken();
    print("Device: $token");

    // Configurar o listener para mensagens em primeiro plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Recebida uma mensagem: ${message.data}');
      if (message.notification != null) {
        _showLocalNotification(message.notification!);
      }
    });

    // Configurar o listener para mensagens em segundo plano
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A mensagem foi aberta: ${message.data}');
      // Aqui você pode navegar para uma tela específica se necessário
    });
  }

  static Future localNotInit() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);

    // Request notification permissions for Android 13 or above
    _flutterLocalNotificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    _flutterLocalNotificationPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  // Mostrar notificação local
  static Future<void> _showLocalNotification(
      RemoteNotification notification) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'pets_channel', // ID do canal
      'Pets Notifications', // Nome do canal
      channelDescription: 'Descrição do canal',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationPlugin.show(
      notification.hashCode, // ID da notificação
      notification.title, // Título
      notification.body, // Corpo
      platformChannelSpecifics,
      payload: 'item x', // Dados adicionais que podem ser passados
    );
  }

  // Ação ao tocar na notificação local
  static void onNotificationTap(NotificationResponse notificationResponse) {
    // Navegar ou realizar alguma ação com base na resposta da notificação
  }
}
