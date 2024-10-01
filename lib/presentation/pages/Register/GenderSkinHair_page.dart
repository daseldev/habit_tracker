import 'package:flutter/material.dart';
import 'package:habit_tracker_atomic/presentation/pages/Register/SelectHabits_page.dart';
import 'package:habit_tracker_atomic/presentation/theme/app_colors.dart';
import 'package:habit_tracker_atomic/presentation/widgets/appbar/basic_appbar.dart';

class GenderSkinHairPage extends StatefulWidget {
  @override
  _GenderSkinHairPageState createState() => _GenderSkinHairPageState();
}

class _GenderSkinHairPageState extends State<GenderSkinHairPage> {
  String selectedGender = 'Male'; // Valor por defecto
  String selectedSkinTone = '🧑🏻'; // Emoji de color de piel por defecto
  String selectedHairColor = '🧑‍🦳'; // Emoji de color de pelo por defecto

  // Listas de emojis para cada género
  final Map<String, List<String>> skinTones = {
    'Male': ['🧑🏻', '🧑🏼', '🧑🏽', '🧑🏾', '🧑🏿'],
    'Female': ['👩🏻', '👩🏼', '👩🏽', '👩🏾', '👩🏿'],
  };

  final Map<String, List<String>> hairColors = {
    'Male': ['🧑‍🦳', '🧑‍🦰', '🧑‍🦱', '🧑‍🦲'],
    'Female': ['👩‍🦳', '👩‍🦰', '👩‍🦱', '👩‍🦲'],
  };

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const BasicAppBar(), // Usamos BasicAppBar
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sección de Género
            Text(
              "Choose your gender",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGender = 'Male';
                        selectedSkinTone =
                            skinTones['Male']![0]; // Reinicia la selección
                        selectedHairColor =
                            hairColors['Male']![0]; // Reinicia la selección
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: selectedGender == 'Male'
                            ? AppColors.primario.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selectedGender == 'Male'
                              ? AppColors.primario
                              : Colors.grey,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.male, size: 50),
                          SizedBox(height: 10),
                          Text(
                            'Male',
                            style: TextStyle(
                              color: isDarkMode
                                  ? AppColors.fondoClaro
                                  : AppColors.grisOscuro,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGender = 'Female';
                        selectedSkinTone =
                            skinTones['Female']![0]; // Reinicia la selección
                        selectedHairColor =
                            hairColors['Female']![0]; // Reinicia la selección
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: selectedGender == 'Female'
                            ? AppColors.primario.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selectedGender == 'Female'
                              ? AppColors.primario
                              : Colors.grey,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.female, size: 50),
                          SizedBox(height: 10),
                          Text(
                            'Female',
                            style: TextStyle(
                              color: isDarkMode
                                  ? AppColors.fondoClaro
                                  : AppColors.grisOscuro,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),

            // Sección de color de piel
            Text(
              "Choose your skin tone",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: skinTones[selectedGender]!.map((emoji) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSkinTone = emoji;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: selectedSkinTone == emoji
                            ? AppColors.primario.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selectedSkinTone == emoji
                              ? AppColors.primario
                              : Colors.grey,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: TextStyle(fontSize: 36),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 40),

            // Sección de color de pelo
            Text(
              "Choose your hair color",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: hairColors[selectedGender]!.map((emoji) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedHairColor = emoji;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: selectedHairColor == emoji
                            ? AppColors.primario.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selectedHairColor == emoji
                              ? AppColors.primario
                              : Colors.grey,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: TextStyle(fontSize: 36),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 40),

            // Botón "Next"
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectHabitsPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primario, // Botón con color primario
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: Text(
                'Next',
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
      backgroundColor: isDarkMode
          ? AppColors.fondoOscuro
          : AppColors.fondoClaro, // Fondo dinámico
    );
  }
}
