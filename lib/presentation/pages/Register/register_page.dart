import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker_atomic/presentation/controllers/auth_controller.dart';
import 'package:habit_tracker_atomic/presentation/pages/Register/GenderSkinHair_page.dart';
import 'package:habit_tracker_atomic/presentation/pages/signin/signin_page.dart';
import 'package:habit_tracker_atomic/presentation/theme/app_colors.dart';
import 'package:habit_tracker_atomic/presentation/widgets/appbar/basic_appbar.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const BasicAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 100,
              height: 100,
            ),
            SizedBox(height: 40),
            Text(
              "Register",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // Acción para "Click Here"
              },
              child: Text(
                "If You Need Any Support Click Here",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primario,
                ),
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle: TextStyle(
                    color: isDarkMode ? AppColors.gris : AppColors.grisOscuro),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: AppColors.gris),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: AppColors.primario),
                ),
              ),
              cursorColor: AppColors.primario,
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Enter Email',
                labelStyle: TextStyle(
                    color: isDarkMode ? AppColors.gris : AppColors.grisOscuro),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: AppColors.gris),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: AppColors.primario),
                ),
              ),
              cursorColor: AppColors.primario,
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                    color: isDarkMode ? AppColors.gris : AppColors.grisOscuro),
                suffixIcon:
                    Icon(Icons.visibility_off, color: AppColors.grisOscuro),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: AppColors.gris),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: AppColors.primario),
                ),
              ),
              cursorColor: AppColors.primario,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  Get.find<AuthController>().registerUser(
                    nameController.text,
                    emailController.text,
                    passwordController.text,
                    'Male', // Asumimos que se selecciona el género en una página anterior
                    '🧑🏻', // Asumimos que se selecciona el color de piel en una página anterior
                    '🧑‍🦳', // Asumimos que se selecciona el color de pelo en una página anterior
                  );
                  Get.find<AuthController>()
                      .loginUser(nameController.text, passwordController.text);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GenderSkinHairPage()),
                  );
                } else {
                  Get.snackbar('Error', 'Por favor complete todos los campos.');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primario,
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
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 30),
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
      backgroundColor:
          isDarkMode ? AppColors.fondoOscuro : AppColors.fondoClaro,
    );
  }
}
