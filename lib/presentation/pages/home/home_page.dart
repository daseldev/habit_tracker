import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker_atomic/presentation/controllers/habit_controller.dart';
import 'package:habit_tracker_atomic/presentation/theme/app_colors.dart';

class HomePage extends StatelessWidget {
  final String username;

  HomePage({required this.username});

  final HabitController habitController = Get.put(HabitController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreetingSection(
                  context, isDarkMode), // Pasar el contexto aquí
              SizedBox(height: 20),
              _buildDateSelector(isDarkMode), // El selector de fechas
              SizedBox(height: 20),
              _buildProgressSection(isDarkMode),
              SizedBox(height: 20),
              _buildChallengeSection(isDarkMode),
              SizedBox(height: 20),
              _buildHabitsSection(
                  isDarkMode, context), // Los hábitos para el día seleccionado
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // AppBar personalizada
  AppBar _buildAppBar(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      backgroundColor:
          isDarkMode ? AppColors.fondoOscuro : AppColors.fondoClaro,
      elevation: 0,
      title: Row(
        children: [
          Text(
            'Hi, $username 👋',
            style: TextStyle(
              color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.notifications,
                color:
                    isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro),
            onPressed: () {
              // Acción de notificaciones
            },
          ),
        ],
      ),
    );
  }

  // Saludo personalizado con cambio a "Calendar"
  Widget _buildGreetingSection(BuildContext context, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Let’s make habits together!",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
          ),
        ),
        SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            _showDatePicker(context); // Abrir el calendario
          },
          child: Text(
            "Calendar",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primario,
            ),
          ),
        ),
      ],
    );
  }

  // Función para mostrar el selector de fechas (calendario)
  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ).then((selectedDate) {
      if (selectedDate != null) {
        habitController.changeSelectedDay(selectedDate);
      }
    });
  }

  // Selector de fechas
  Widget _buildDateSelector(bool isDarkMode) {
    return Obx(() {
      final DateTime selectedDate = habitController.selectedDay.value;
      final List<String> weekdays = [
        'SUN',
        'MON',
        'TUE',
        'WED',
        'THU',
        'FRI',
        'SAT'
      ];

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          final DateTime date =
              selectedDate.add(Duration(days: index - selectedDate.weekday));
          final String day = weekdays[date.weekday % 7];

          return GestureDetector(
            onTap: () {
              habitController.changeSelectedDay(date);
            },
            child: Column(
              children: [
                Text(
                  day,
                  style: TextStyle(
                    color: isDarkMode
                        ? AppColors.fondoClaro
                        : AppColors.grisOscuro,
                  ),
                ),
                SizedBox(height: 5),
                CircleAvatar(
                  backgroundColor: habitController.selectedDay.value == date
                      ? AppColors.primario
                      : AppColors.grisOscuro.withOpacity(0.3),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }),
      );
    });
  }

  // Sección de progreso diario
  Widget _buildProgressSection(bool isDarkMode) {
    return Obx(() {
      // Calculamos el porcentaje de hábitos completados
      double completedPercentage =
          habitController.calculateCompletedPercentage();
      String message = "No progress yet. Let's get started!";

      // Definir el mensaje según el porcentaje de progreso
      if (completedPercentage == 0.0) {
        message = "Let's get started! You haven't completed any habits yet.";
      } else if (completedPercentage > 0.0 && completedPercentage < 0.25) {
        message = "Good start! Keep going to reach your goals!";
      } else if (completedPercentage >= 0.25 && completedPercentage < 0.5) {
        message = "You're doing great! Keep the momentum going!";
      } else if (completedPercentage >= 0.5 && completedPercentage < 0.75) {
        message = "You're halfway there! Keep pushing!";
      } else if (completedPercentage >= 0.75 && completedPercentage < 1.0) {
        message = "Almost there! Just a few more to go!";
      } else if (completedPercentage == 1.0) {
        message = "Congratulations! You've completed all your habits today!";
      }

      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.grisOscuro.withOpacity(0.2)
              : AppColors.gris.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message, // Muestra el mensaje basado en el porcentaje
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
              ),
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value:
                  completedPercentage, // Valor del progreso basado en los hábitos completados
              backgroundColor: AppColors.grisOscuro.withOpacity(0.3),
              color: AppColors.primario,
            ),
            SizedBox(height: 5),
            Text(
              "${(completedPercentage * 100).toStringAsFixed(0)}% of your habits completed",
              style: TextStyle(
                color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
              ),
            ),
          ],
        ),
      );
    });
  }

  // Sección de desafíos
  Widget _buildChallengeSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Challenges",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: () {
                // Acción al ver todos los desafíos
              },
              child: Text(
                "View all",
                style: TextStyle(color: AppColors.primario),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.grisOscuro.withOpacity(0.2)
                : AppColors.gris.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Best Runners! 🏃‍♂️",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:
                      isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
                ),
              ),
              SizedBox(height: 10),
              LinearProgressIndicator(
                value: 0.5,
                backgroundColor: AppColors.grisOscuro.withOpacity(0.3),
                color: AppColors.primario,
              ),
              SizedBox(height: 5),
              Text(
                "5 days 13 hours left",
                style: TextStyle(
                  color:
                      isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Sección de hábitos
  Widget _buildHabitsSection(bool isDarkMode, BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Habits",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  // Acción al ver todos los hábitos
                },
                child: Text(
                  "View all",
                  style: TextStyle(color: AppColors.primario),
                ),
              ),
            ],
          ),
          Column(
            children: habitController.getHabitsForSelectedDay().map((habit) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.grisOscuro.withOpacity(0.2)
                        : AppColors.gris.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text(habit.emoji, style: TextStyle(fontSize: 30)),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              habit.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode
                                    ? AppColors.fondoClaro
                                    : AppColors.grisOscuro,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${habit.progress}/${habit.target} ${habit.unit}',
                              style: TextStyle(
                                color: isDarkMode
                                    ? AppColors.fondoClaro
                                    : AppColors.grisOscuro,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (habit.isFailed)
                        Icon(Icons.close, color: Colors.red)
                      else if (habit.isCompleted || habit.isSkipped)
                        Icon(Icons.check, color: AppColors.primario)
                      else
                        IconButton(
                          icon: Icon(Icons.add, color: AppColors.primario),
                          onPressed: () {
                            _showHabitOptionsDialog(context, habit);
                          },
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );
    });
  }

  // Mostrar opciones de agregar progreso, fallar o saltar hábito
  void _showHabitOptionsDialog(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController progressController =
            TextEditingController();

        return AlertDialog(
          title: Text('Update Habit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: progressController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Add Progress'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                habitController.failHabit(habit);
                Navigator.pop(context);
              },
              child: Text('Fail'),
            ),
            TextButton(
              onPressed: () {
                habitController.skipHabit(habit);
                Navigator.pop(context);
              },
              child: Text('Skip'),
            ),
            ElevatedButton(
              onPressed: () {
                if (progressController.text.isNotEmpty) {
                  habitController.addProgress(
                      habit, double.parse(progressController.text));
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Barra de navegación inferior
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: 0, // Página activa (Home por defecto)
      onTap: (index) {
        if (index == 1) {
          _showAddHabitDialog(); // Mostrar el diálogo de agregar hábito cuando se selecciona "Add"
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      selectedItemColor: AppColors.primario,
      unselectedItemColor: AppColors.grisOscuro,
      showUnselectedLabels: true,
    );
  }

  // Mostrar diálogo para agregar un nuevo hábito
  void _showAddHabitDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController targetController = TextEditingController();
    final TextEditingController unitController = TextEditingController();
    final TextEditingController emojiController =
        TextEditingController(); // Nuevo controlador para el emoji

    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Habit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Habit Name'),
              ),
              TextField(
                controller: targetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Target Value'),
              ),
              TextField(
                controller: unitController,
                decoration: InputDecoration(labelText: 'Unit'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: emojiController,
                decoration: InputDecoration(
                  labelText: 'Emoji',
                  hintText: 'Enter or paste an emoji',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Cerrar el diálogo sin agregar
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    targetController.text.isNotEmpty &&
                    unitController.text.isNotEmpty &&
                    emojiController.text.isNotEmpty) {
                  double? targetValue = double.tryParse(targetController.text);
                  if (targetValue != null) {
                    // Llamar a la función para agregar el nuevo hábito con el emoji ingresado por el usuario
                    habitController.addNewHabit(
                      nameController.text,
                      targetValue,
                      unitController.text,
                      emojiController.text,
                    );
                    Get.back(); // Cerrar el diálogo
                  } else {
                    Get.snackbar('Error', 'Please enter a valid target value');
                  }
                } else {
                  Get.snackbar('Error', 'All fields are required');
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
