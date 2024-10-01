import 'package:flutter/material.dart';
import 'package:habit_tracker_atomic/presentation/theme/app_colors.dart';

class AppTheme {
  static final temaClaro = ThemeData(
    primaryColor: AppColors.primario,
    scaffoldBackgroundColor: AppColors.fondoClaro,
    brightness: Brightness.light,
    fontFamily: 'Satoshi',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primario,
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 40, // Ajusta el valor para el ancho
          vertical: 20, // Ajusta el valor para la altura
        ),
        minimumSize: const Size(200, 60), // Ancho y alto mínimo del botón
      ),
    ),
  );
  static final temaOscuro = ThemeData(
    primaryColor: AppColors.primario,
    scaffoldBackgroundColor: AppColors.fondoOscuro,
    fontFamily: 'Satoshi',
    brightness: Brightness.dark,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primario,
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 40, // Ajusta el valor para el ancho
          vertical: 20, // Ajusta el valor para la altura
        ),
        minimumSize: const Size(200, 60), // Ancho y alto mínimo del botón
      ),
    ),
  );
}
