import 'package:flutter/material.dart';
import 'package:habit_tracker_atomic/presentation/pages/home/home_page.dart';
import 'package:habit_tracker_atomic/presentation/theme/app_colors.dart';
import 'package:habit_tracker_atomic/presentation/widgets/appbar/basic_appbar.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
              'assets/images/logo.png', // Asegúrate de que la ruta sea correcta
              width: 100,
              height: 100,
            ),
            SizedBox(height: 40),
            Text(
              "Sign In",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {},
              child: Text(
                "If You Need Any Support Click Here",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primario,
                ),
              ),
            ),
            SizedBox(height: 30),

            // Campo para el nombre de usuario o email
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Enter Username Or Email',
                labelStyle: TextStyle(
                  color: isDarkMode ? AppColors.gris : AppColors.grisOscuro,
                ),
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

            // Campo para la contraseña
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                  color: isDarkMode ? AppColors.gris : AppColors.grisOscuro,
                ),
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

            // Botón "Sign In"
            ElevatedButton(
              onPressed: () {
                // Navegamos a la HomePage pasando el nombre de usuario
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HomePage(username: _usernameController.text),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primario,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
