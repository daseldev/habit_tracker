import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker_atomic/presentation/controllers/AuthController.dart';
import 'package:habit_tracker_atomic/presentation/controllers/habit_controller.dart';
import 'package:habit_tracker_atomic/presentation/controllers/theme_controller.dart';
import 'package:habit_tracker_atomic/presentation/pages/splash/splash_page.dart';
import 'package:habit_tracker_atomic/presentation/theme/app_theme.dart';

void main() {
  Get.put(AuthController());
  Get.put(
      HabitController()); // Inyecta el controlador antes de que la aplicación comience
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        theme: AppTheme.temaClaro,
        darkTheme: AppTheme.temaOscuro,
        themeMode:
            themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: SplashPage(),
      );
    });
  }
}
