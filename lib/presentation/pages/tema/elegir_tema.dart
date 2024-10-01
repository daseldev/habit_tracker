import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker_atomic/presentation/controllers/theme_controller.dart';
import 'package:habit_tracker_atomic/presentation/pages/LoginORegister/LoginORegister_page.dart';

class ElegirTema extends StatelessWidget {
  const ElegirTema({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    // Obtener el color de fondo del tema actual
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor:
          backgroundColor, // Usar el color de fondo del tema actual
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 40,
              horizontal: 40,
            ),
            color: backgroundColor, // Usar el color de fondo del tema actual
          ),
          Container(
            color: Colors.black.withOpacity(0.15),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 40,
              horizontal: 40,
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/images/logo.png', width: 220,
                    height: 220, // Ruta de la imagen en tu proyecto
                  ),
                ),
                const Spacer(),
                const Text(
                  'Choose Mode',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            themeController
                                .toggleTheme(); // Cambiar a modo oscuro o claro
                          },
                          child: ClipOval(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xff30393C).withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.dark_mode, // Icono propio de Flutter
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Dark Mode',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 40),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            themeController
                                .toggleTheme(); // Cambiar a modo claro o oscuro
                          },
                          child: ClipOval(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xff30393C).withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.light_mode, // Icono propio de Flutter
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Light Mode',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => LoginORegisterPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Continue',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
