import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker_atomic/presentation/controllers/auth_controller.dart';
import 'package:habit_tracker_atomic/presentation/controllers/habit_controller.dart';
import 'package:habit_tracker_atomic/presentation/pages/LoginORegister/LoginORegister_page.dart';
import 'package:habit_tracker_atomic/presentation/theme/app_colors.dart';
import 'package:habit_tracker_atomic/presentation/widgets/appbar/basic_appbar.dart';

class SelectHabitsPage extends StatefulWidget {
  @override
  _SelectHabitsPageState createState() => _SelectHabitsPageState();
}

class _SelectHabitsPageState extends State<SelectHabitsPage> {
  // Lista de hábitos con emojis, unidades y objetivos
  final List<Map<String, dynamic>> habits = [
    {'emoji': '💧', 'name': 'Drink water', 'unit': 'ML', 'target': 2000},
    {'emoji': '🏃‍♂️', 'name': 'Run', 'unit': 'Kilometers', 'target': 5},
    {'emoji': '📚', 'name': 'Read books', 'unit': 'Pages', 'target': 30},
    {'emoji': '🧘‍♂️', 'name': 'Meditate', 'unit': 'Minutes', 'target': 10},
    {'emoji': '📓', 'name': 'Journal', 'unit': 'Entries', 'target': 1},
    {'emoji': '👨‍💻', 'name': 'Study', 'unit': 'Hours', 'target': 2},
    {'emoji': '🌱', 'name': 'Gardening', 'unit': 'Minutes', 'target': 30},
    {'emoji': '💤', 'name': 'Sleep well', 'unit': 'Hours', 'target': 8},
    {'emoji': '🚴‍♂️', 'name': 'Cycling', 'unit': 'Kilometers', 'target': 10},
    {'emoji': '🍎', 'name': 'Eat healthy', 'unit': 'Meals', 'target': 3},
    {'emoji': '🏋️‍♂️', 'name': 'Workout', 'unit': 'Minutes', 'target': 45},
    {'emoji': '🎨', 'name': 'Paint', 'unit': 'Hours', 'target': 1},
    {'emoji': '🎸', 'name': 'Play guitar', 'unit': 'Minutes', 'target': 30},
    {'emoji': '✍️', 'name': 'Write', 'unit': 'Words', 'target': 500},
    {'emoji': '🎧', 'name': 'Listen to music', 'unit': 'Minutes', 'target': 20},
    {'emoji': '🎤', 'name': 'Sing', 'unit': 'Minutes', 'target': 15},
    {'emoji': '🧹', 'name': 'Clean house', 'unit': 'Rooms', 'target': 2},
    {'emoji': '🍳', 'name': 'Cook', 'unit': 'Meals', 'target': 2},
    {'emoji': '🎮', 'name': 'Play games', 'unit': 'Minutes', 'target': 60},
    {'emoji': '🎻', 'name': 'Play violin', 'unit': 'Minutes', 'target': 30},
    {'emoji': '🚶‍♂️', 'name': 'Walk', 'unit': 'Steps', 'target': 10000},
    {'emoji': '📖', 'name': 'Study languages', 'unit': 'Minutes', 'target': 30},
    {'emoji': '📅', 'name': 'Plan your day', 'unit': 'Tasks', 'target': 3},
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
                        print("Selected Habits: $selectedHabits");
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
                      target: habit['target']!,
                      unit: habit['unit']!,
                      emoji: habit['emoji']!,
                    );
                  }).toList();
                  // Guardar los hábitos seleccionados en el usuario actual
                  print("Selected Habits Objects: $userSelectedHabits");

                  for (var habit in userSelectedHabits) {
                    Get.find<AuthController>().addHabitToCurrentUser(habit);
                  }
                  Get.find<AuthController>().logoutUser();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginORegisterPage()),
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
