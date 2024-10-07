import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rastreia_pet_app/services/change_notifier.dart';
import 'package:rastreia_pet_app/services/notification_service.dart';
import 'package:rastreia_pet_app/services/token_services.dart';
import 'package:rastreia_pet_app/theme/theme_provider.dart';
import 'package:rastreia_pet_app/view/home_login_page.dart';
import 'package:rastreia_pet_app/view/home_page.dart';
import 'package:rastreia_pet_app/view/login_page.dart';
import 'package:rastreia_pet_app/view/message.dart';
import 'package:rastreia_pet_app/view/nav_page.dart';
import 'package:rastreia_pet_app/view/register_alert_page.dart';
import 'package:rastreia_pet_app/view/register_page.dart';
import 'package:rastreia_pet_app/view/register_pet_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("Recebeu alguma notificasaum");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PushNotifications.localNotInit(); // Chame aqui
  await PushNotifications.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

  // on background notification tapped
  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   if (message.notification != null) {
  //     print("Background Notification Tapped");
  //     navigatorKey.currentState!.pushNamed("/Message", arguments: message);
  //   }
  // });
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(
            create: (context) =>
                DataSender()..startSendingData()), // Inicia o envio de dados
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const RouteScreens(),
      navigatorKey: navigatorKey,
      routes: <String, WidgetBuilder>{
        '/HomeLoginPage': (BuildContext context) => const HomeLoginPage(),
        '/Message': (context) => MessagePage(),
        '/HomePage': (BuildContext context) => Builder(
              builder: (context) {
                return HomePage();
              },
            ),
        '/LoginPage': (BuildContext context) => LoginPage(),
        '/RegisterAlertPage': (BuildContext context) => Builder(
              builder: (context) {
                return RegisterAlertPage();
              },
            ),
        '/RegisterPage': (BuildContext context) => RegisterPage(),
        '/RegisterPetPage': (BuildContext context) => Builder(
              builder: (context) {
                return RegisterPetPage();
              },
            ),
        '/NavPage': (BuildContext context) => Builder(
              builder: (context) {
                0; // Pega o argumento ou 0 se não houver
                return NavPage(initialIndex: 0);
              },
            ),
        '/NavPage2': (BuildContext context) => Builder(
              builder: (context) {
                0; // Pega o argumento ou 0 se não houver
                return NavPage(initialIndex: 2);
              },
            ),
      },
    );
  }
}

class RouteScreens extends StatelessWidget {
  const RouteScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData) {
            final user =
                snapshot.data; // Obtenha o usuário a partir do snapshot
            _saveUserToken(user); // Chama o método para salvar o token
            return NavPage();
          } else {
            return const HomeLoginPage();
          }
        }
      },
    );
  }

  // Método separado para salvar o token do usuário
  Future<void> _saveUserToken(User? user) async {
    if (user != null) {
      final userId = user.uid; // Obtém o ID do usuário
      final tokenServices = TokenServices();
      await tokenServices.saveToken(userId); // Armazena o token no Firestore
    }
  }
}
