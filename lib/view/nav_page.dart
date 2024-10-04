import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rastreia_pet_app/enum/enum.dart';
import 'package:rastreia_pet_app/view/home_page.dart';
import 'package:rastreia_pet_app/view/map_page.dart';
import 'package:rastreia_pet_app/view/user_page.dart';

class NavPage extends StatefulWidget {
  final User user;
  final int initialIndex; // Adicione esse parâmetro

  const NavPage({
    super.key,
    required this.user,
    this.initialIndex = 0, // Define um valor padrão
  });

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  late int _selectedIndex;
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // Use o índice inicial passado
    _widgetOptions = <Widget>[
      HomePage(
        user: widget.user,
      ),
      MapPage(
        user: widget.user,
      ),
      UserPage(
        user: widget.user,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        backgroundColor: AppColors.background,
        buttonBackgroundColor: AppColors.primary,
        color: AppColors.primary,
        animationDuration: const Duration(milliseconds: 500),
        items: const [
          Icon(Icons.home, size: 26, color: Colors.white),
          Icon(Icons.navigation, size: 26, color: Colors.white),
          Icon(Icons.person, size: 26, color: Colors.white),
        ],
        index: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
