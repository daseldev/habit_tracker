import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker_atomic/presentation/controllers/auth_controller.dart';
import 'package:habit_tracker_atomic/presentation/controllers/challenge_controller.dart';
import 'package:habit_tracker_atomic/presentation/controllers/habit_controller.dart';
import 'package:habit_tracker_atomic/presentation/controllers/theme_controller.dart';
import 'package:habit_tracker_atomic/presentation/pages/challenges/challenge_page.dart';
import 'package:habit_tracker_atomic/presentation/pages/profile/profile_page.dart';
import 'package:habit_tracker_atomic/presentation/theme/app_colors.dart';

class HomePage extends StatelessWidget {
  final String username;

  HomePage({required this.username});

  final HabitController habitController = Get.put(HabitController());
  final ChallengeController challengeController =
      Get.put(ChallengeController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    habitController.changeSelectedDay(DateTime.now());

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreetingSection(context, isDarkMode),
              SizedBox(height: 20),
              _buildDateSelector(isDarkMode),
              SizedBox(height: 20),
              _buildProgressSection(isDarkMode),
              SizedBox(height: 20),
              _buildChallengeSection(
                  isDarkMode), // Aquí añadimos la sección de challenges
              SizedBox(height: 20),
              _buildHabitsSection(isDarkMode, context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // AppBar personalizada
  AppBar _buildAppBar(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final ThemeController themeController = Get.find<ThemeController>();

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
            icon: Icon(
              isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
            ),
            onPressed: () {
              // Alternar entre modo claro y oscuro
              themeController.toggleTheme();
            },
          ),
        ],
      ),
    );
  }

  // Sección de saludo
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

  // Mostrar selector de fechas
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

// Selector de fechas corregido
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

      // Corregir el cálculo del primer día de la semana
      final DateTime startOfWeek =
          selectedDate.subtract(Duration(days: selectedDate.weekday % 7));

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          final DateTime date = startOfWeek.add(Duration(days: index));
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
      double completedPercentage =
          habitController.calculateCompletedPercentage();
      String message = "No progress yet. Let's get started!";

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
              message,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
              ),
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: completedPercentage,
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

  // Sección de desafíos (challenges)
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
                // Navegación a la página de challenges
                Get.to(() => ChallengePage());
              },
              child: Text(
                "View all",
                style: TextStyle(color: AppColors.primario),
              ),
            ),
          ],
        ),
        Obx(() {
          var joinedChallenges = challengeController.userChallenges
              .where((challenge) => challenge.hasJoined)
              .toList();

          if (joinedChallenges.isEmpty) {
            return Text(
              "You haven't joined any challenges yet.",
              style: TextStyle(
                color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
              ),
            );
          }

          return Column(
            children: joinedChallenges.map((challenge) {
              return GestureDetector(
                onTap: () {
                  // Aquí podrías añadir la lógica para abrir detalles de un challenge
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
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
                        challenge.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? AppColors.fondoClaro
                              : AppColors.grisOscuro,
                        ),
                      ),
                      SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: challenge.calculateProgress(),
                        backgroundColor: AppColors.grisOscuro.withOpacity(0.3),
                        color: AppColors.primario,
                      ),
                      SizedBox(height: 5),
                      Text(
                        "${challenge.tasks.length} tasks",
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
            }).toList(),
          );
        }),
      ],
    );
  }

  // Sección de hábitos
  Widget _buildHabitsSection(bool isDarkMode, BuildContext context) {
    return Obx(() {
      var habits = habitController
          .getHabitsForSelectedDay(habitController.selectedDay.value);
      if (habits.isEmpty) {
        return Text(
          "No habits for today",
          style: TextStyle(
            color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Habits",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
            ),
          ),
          SizedBox(height: 10),
          Column(
            children: habits.map((habit) {
              return GestureDetector(
                onTap: () {
                  _showEditHabitDialog(context, habit);
                },
                child: Padding(
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
                ),
              );
            }).toList(),
          ),
        ],
      );
    });
  }

  // Mostrar diálogo para editar un hábito
  void _showEditHabitDialog(BuildContext context, Habit habit) {
    final TextEditingController nameController =
        TextEditingController(text: habit.name);
    final TextEditingController targetController =
        TextEditingController(text: habit.target.toString());
    final TextEditingController unitController =
        TextEditingController(text: habit.unit);
    final TextEditingController emojiController =
        TextEditingController(text: habit.emoji);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Habit'),
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
              TextField(
                controller: emojiController,
                decoration: InputDecoration(labelText: 'Emoji'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    targetController.text.isNotEmpty &&
                    unitController.text.isNotEmpty &&
                    emojiController.text.isNotEmpty) {
                  habit.name = nameController.text;
                  habit.target = double.parse(targetController.text);
                  habit.unit = unitController.text;
                  habit.emoji = emojiController.text;

                  habitController.habitsByUserAndDay.refresh();
                  Get.back();
                } else {
                  Get.snackbar('Error', 'All fields are required');
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Mostrar diálogo con opciones para el hábito
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
  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {
        if (index == 0) {
          // Home
        } else if (index == 1) {
          _showAddHabitDialog(context);
        } else if (index == 2) {
          Get.to(() => ProfilePage());
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
  void _showAddHabitDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController targetController = TextEditingController();
    final TextEditingController unitController = TextEditingController();
    final TextEditingController emojiController = TextEditingController();

    showDialog(
      context: context,
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
              TextField(
                controller: emojiController,
                decoration: InputDecoration(labelText: 'Emoji'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
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
                    habitController.addNewHabit(
                      nameController.text,
                      targetValue,
                      unitController.text,
                      emojiController.text,
                    );
                    Get.back();
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
