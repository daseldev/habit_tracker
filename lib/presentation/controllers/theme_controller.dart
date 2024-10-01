import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Observable para manejar el tema actual (claro u oscuro)
  var isDarkMode = false.obs;

  // Método para alternar entre tema claro y oscuro
  void toggleTheme() {
    if (isDarkMode.value) {
      Get.changeThemeMode(ThemeMode.light);
    } else {
      Get.changeThemeMode(ThemeMode.dark);
    }
    isDarkMode.value = !isDarkMode.value;
  }
}
