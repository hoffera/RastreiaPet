import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rastreia_pet_app/firebase_options.dart';
import 'package:rastreia_pet_app/theme/theme_provider.dart';
import 'package:rastreia_pet_app/view/home_login_page.dart';
import 'package:rastreia_pet_app/view/home_page.dart';
import 'package:rastreia_pet_app/view/login_page.dart';
import 'package:rastreia_pet_app/view/navpage.dart';
import 'package:rastreia_pet_app/view/register_alert_page.dart';
import 'package:rastreia_pet_app/view/register_page.dart';
import 'package:rastreia_pet_app/view/register_pet_page.dart';
import 'package:rastreia_pet_app/view/user_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
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
      routes: <String, WidgetBuilder>{
        '/HomeLoginPage': (BuildContext context) => const HomeLoginPage(),
        '/HomePage': (BuildContext context) => const HomePage(),
        '/LoginPage': (BuildContext context) => LoginPage(),
        '/RegisterAlertPage': (BuildContext context) => RegisterAlertPage(),
        '/RegisterPage': (BuildContext context) => RegisterPage(),
        '/RegisterPetPage': (BuildContext context) => RegisterPetPage(),
        '/RegisUserPageterPetPage': (BuildContext context) => UserPage(),
        '/NavPage': (BuildContext context) => const NavPage(),
      },
    );
  }
}

class RouteScreens extends StatelessWidget {
  const RouteScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const HomeLoginPage();
          }
        }
      },
    );
  }
}
