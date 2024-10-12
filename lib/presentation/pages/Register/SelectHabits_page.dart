import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker_atomic/presentation/controllers/habit_controller.dart';
import 'package:habit_tracker_atomic/presentation/theme/app_colors.dart';
import 'package:habit_tracker_atomic/presentation/widgets/appbar/basic_appbar.dart';
import 'package:habit_tracker_atomic/presentation/pages/home/home_page.dart';

class SelectHabitsPage extends StatefulWidget {
  @override
  _SelectHabitsPageState createState() => _SelectHabitsPageState();
}

class _SelectHabitsPageState extends State<SelectHabitsPage> {
  // Lista de hábitos con emojis
  final List<Map<String, String>> habits = [
    {'emoji': '💧', 'name': 'Drink water'},
    {'emoji': '🏃‍♂️', 'name': 'Run'},
    {'emoji': '📚', 'name': 'Read books'},
    {'emoji': '🧘‍♂️', 'name': 'Meditate'},
    {'emoji': '📓', 'name': 'Journal'},
    {'emoji': '👨‍💻', 'name': 'Study'},
    {'emoji': '🌱', 'name': 'Gardening'},
    {'emoji': '💤', 'name': 'Sleep well'},
    {'emoji': '🚴‍♂️', 'name': 'Cycling'},
    {'emoji': '🍎', 'name': 'Eat healthy'},
    {'emoji': '🏋️‍♂️', 'name': 'Workout'},
    {'emoji': '🎨', 'name': 'Paint'},
    {'emoji': '🎸', 'name': 'Play guitar'},
    {'emoji': '✍️', 'name': 'Write'},
    {'emoji': '🎧', 'name': 'Listen to music'},
    {'emoji': '🎤', 'name': 'Sing'},
    {'emoji': '🧹', 'name': 'Clean house'},
    {'emoji': '🍳', 'name': 'Cook'},
    {'emoji': '🎮', 'name': 'Play games'},
    {'emoji': '🎻', 'name': 'Play violin'},
    {'emoji': '🚶‍♂️', 'name': 'Walk'},
    {'emoji': '📖', 'name': 'Study languages'},
    {'emoji': '📅', 'name': 'Plan your day'},
  ];

  // Lista de hábitos seleccionados
  final Set<String> selectedHabits = {};

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
            Text(
              "Choose your first habits",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "You may add more habits later",
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Lista de hábitos
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Dos columnas
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.5, // Ajuste para dar más espacio vertical
                ),
                itemCount: habits.length,
                itemBuilder: (context, index) {
                  final habit = habits[index];
                  final isSelected = selectedHabits.contains(habit['name']);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedHabits.remove(habit['name']);
                        } else {
                          selectedHabits.add(habit['name']!);
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primario.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primario
                              : AppColors.grisOscuro,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            habit['emoji']!,
                            style: TextStyle(
                              fontSize: 36,
                              fontFamily:
                                  null, // Para asegurar que los emojis se vean bien
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            habit['name']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDarkMode
                                  ? AppColors.fondoClaro
                                  : AppColors.grisOscuro,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),

            // Botón "Next"
            ElevatedButton(
              onPressed: () {
                if (selectedHabits.isNotEmpty) {
                  // Convertimos los hábitos seleccionados en objetos Habit
                  List<Habit> userSelectedHabits = habits.where((habit) {
                    return selectedHabits.contains(habit['name']);
                  }).map((habit) {
                    return Habit(
                      name: habit['name']!,
                      progress: 0,
                      target:
                          1, // Puedes ajustar el valor predeterminado de target aquí
                      unit: 'unit', // Puedes ajustar la unidad por defecto aquí
                      emoji: habit['emoji']!,
                    );
                  }).toList();

                  // Establecemos los hábitos seleccionados en el controlador
                  Get.find<HabitController>()
                      .setSelectedHabits(userSelectedHabits);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(username: 'User')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select at least one habit')),
                  );
                }
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
          : AppColors.fondoClaro, // Fondo dinámico según el tema
    );
  }
}
