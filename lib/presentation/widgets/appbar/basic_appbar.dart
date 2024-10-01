import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Si estás usando GetX para manejo de estado y navegación.

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BasicAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // Fondo transparente
      elevation: 0, // Sin sombra o elevación
      leading: IconButton(
        onPressed: () {
          // Acción cuando se presiona el botón de regreso
          Navigator.pop(
              context); // Esto navega hacia atrás en la pila de navegación.
        },
        icon: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: context.isDarkMode
                ? Colors.white.withOpacity(0.03)
                : Colors.black
                    .withOpacity(0.03), // Color dinámico según el modo
            shape: BoxShape.circle, // Forma circular
          ),
          child: Icon(
            Icons.arrow_back_ios_new, // Icono de flecha hacia atrás
            size: 15,
            color: context.isDarkMode
                ? Colors.white
                : Colors.black, // Color del icono según el modo
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // Altura estándar de AppBar
}
