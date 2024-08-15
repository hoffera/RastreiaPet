import 'package:flutter/material.dart';
import 'package:rastreia_pet_app/enum/enum.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _logo();
  }

  _logo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0), // Defina o raio da borda
      child: Container(
        width: double.infinity,
        color: AppColors.background,
        child: Center(
          child: Image.asset(
            'lib/assets/images/rastreiaPetLogo.png',
            height: 250, // Altura da imagem definida como 100
            fit: BoxFit.contain, // Ajusta a imagem para caber na altura
          ),
        ),
      ),
    );
  }
}
