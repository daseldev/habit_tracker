import 'package:flutter/material.dart';
import 'package:habit_tracker_atomic/presentation/pages/Register/GenderSkinHair_page.dart';
import 'package:habit_tracker_atomic/presentation/pages/signin/signin_page.dart';
import 'package:habit_tracker_atomic/presentation/theme/app_colors.dart';
import 'package:habit_tracker_atomic/presentation/widgets/appbar/basic_appbar.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const BasicAppBar(), // Usamos BasicAppBar
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo de la aplicación
            Image.asset(
              'assets/images/logo.png', // Asegúrate de que la ruta sea correcta
              width: 100,
              height: 100,
            ),
            SizedBox(height: 40),

            // Título "Register"
            Text(
              "Register",
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

            // Texto de ayuda
            GestureDetector(
              onTap: () {
                // Acción para "Click Here"
              },
              child: Text(
                "If You Need Any Support Click Here",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primario, // Usamos el color primario (oro)
                ),
              ),
            ),
            SizedBox(height: 30),

            // Campo para el nombre completo
            TextField(
              decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle: TextStyle(
                    color: isDarkMode ? AppColors.gris : AppColors.grisOscuro),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      BorderSide(color: AppColors.gris), // Borde gris claro
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      color: AppColors.primario), // Borde dorado al enfocarse
                ),
              ),
              cursorColor: AppColors.primario, // Cursor dorado
            ),
            SizedBox(height: 20),

            // Campo para el email
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter Email',
                labelStyle: TextStyle(
                    color: isDarkMode ? AppColors.gris : AppColors.grisOscuro),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      BorderSide(color: AppColors.gris), // Borde gris claro
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      color: AppColors.primario), // Borde dorado al enfocarse
                ),
              ),
              cursorColor: AppColors.primario, // Cursor dorado
            ),
            SizedBox(height: 20),

            // Campo para la contraseña
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                    color: isDarkMode ? AppColors.gris : AppColors.grisOscuro),
                suffixIcon:
                    Icon(Icons.visibility_off, color: AppColors.grisOscuro),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      BorderSide(color: AppColors.gris), // Borde gris claro
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      color: AppColors.primario), // Borde dorado al enfocarse
                ),
              ),
              cursorColor: AppColors.primario,
            ),
            SizedBox(height: 30),

            // Botón "Create Account"
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GenderSkinHairPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.primario, // Color dorado para el botón
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Texto en blanco
                ),
              ),
            ),

            SizedBox(height: 30),

            // Texto para redirigir a "Sign In"
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Do You Have An Account? ",
                  style: TextStyle(
                    color: isDarkMode ? AppColors.gris : AppColors.grisOscuro,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navegar a la página de inicio de sesión
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  },
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      color: AppColors.primario,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: isDarkMode
          ? AppColors.fondoOscuro
          : AppColors.fondoClaro, // Fondo dinámico según el tema
    );
  }
}
