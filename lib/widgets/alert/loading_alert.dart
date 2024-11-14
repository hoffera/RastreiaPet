import 'package:flutter/material.dart';
import 'package:rastreia_pet_app/enum/enum.dart';

class LoadingAlert extends StatelessWidget {
  const LoadingAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      backgroundColor: AppColors.background,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
          ),
          SizedBox(height: 16),
          Text(
            "Carregando...",
            style: TextStyle(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
