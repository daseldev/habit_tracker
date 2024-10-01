import 'package:flutter/material.dart';
import 'package:habit_tracker_atomic/presentation/pages/Register/register_page.dart';
import 'package:habit_tracker_atomic/presentation/theme/app_colors.dart';
import 'package:habit_tracker_atomic/presentation/widgets/appbar/basic_appbar.dart';
import 'package:habit_tracker_atomic/presentation/pages/signin/signin_page.dart';

class LoginORegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const BasicAppBar(), // Usamos BasicAppBar
      body: Stack(
        children: [
          // Fondo de la pantalla con el color del tema actual
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),

          // Contenido centrado verticalmente
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo de tu proyecto
                  Image.asset(
                    'assets/images/logo.png', // Asegúrate de que esta ruta sea correcta
                    width: 220,
                    height: 220,
                  ),
                  SizedBox(height: 40),

                  // Título
                  Text(
                    "Start Your Adventure",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? AppColors.fondoClaro
                          : AppColors.grisOscuro, // Color dinámico
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),

                  // Subtítulo
                  Text(
                    "Track your habits, complete quests, and become the hero of your own story.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),

                  // Botón "Register"
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text('Register'),
                    style: Theme.of(context).elevatedButtonTheme.style,
                  ),
                  SizedBox(height: 20),

                  // Botón "Sign In" con redirección a la nueva página de inicio de sesión
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.grisOscuro,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    ),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Texto en blanco
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: isDarkMode
          ? AppColors.fondoOscuro
          : AppColors.fondoClaro, // Fondo dinámico según el tema
    );
  }
}
