import 'package:get/get.dart';

class Habit {
  String name;
  double progress; // Representa el progreso actual del hábito (0 a 1)
  double
      target; // Objetivo total del hábito (por ejemplo, 2000 ML o 10000 PASOS)
  String unit; // Unidad de medida del progreso (por ejemplo, ML, PASOS)
  bool isCompleted;
  bool isSkipped; // Indica si el hábito fue saltado
  bool isFailed; // Indica si el hábito fue fallido
  String emoji; // Agregar propiedad de emoji

  Habit({
    required this.name,
    required this.progress,
    required this.target,
    required this.unit,
    this.isCompleted = false,
    this.isSkipped = false,
    this.isFailed = false,
    this.emoji = '⚪',
  });

  // Función para calcular el porcentaje de progreso
  double getProgressPercentage() {
    return progress / target;
  }
}

class HabitController extends GetxController {
  var habitsByDay = <String, List<Habit>>{}.obs;
  var selectedDay = DateTime.now()
      .obs; // Cambiado a DateTime para seleccionar días específicos

  @override
  void onInit() {
    super.onInit();
    // Inicializa los hábitos predeterminados para el día actual si no existen
    _initializeHabitsForDay(selectedDay.value);
  }

  double calculateCompletedPercentage() {
    var habits = getHabitsForSelectedDay();
    if (habits.isEmpty) return 0.0;

    int completedCount =
        habits.where((habit) => habit.isCompleted || habit.isSkipped).length;
    return completedCount / habits.length;
  }

  // Inicializa los hábitos predeterminados para un día si aún no están establecidos
  void _initializeHabitsForDay(DateTime date) {
    String dayKey = date.toIso8601String();
    if (!habitsByDay.containsKey(dayKey)) {
      habitsByDay[dayKey] = [
        Habit(
            name: 'Drink the water',
            progress: 0,
            target: 2000,
            unit: 'ML',
            emoji: '💧'),
        Habit(
            name: 'Walk',
            progress: 0,
            target: 10000,
            unit: 'STEPS',
            emoji: '🚶'),
        Habit(
            name: 'Water Plants',
            progress: 0,
            target: 1,
            unit: 'TIMES',
            emoji: '🌿'),
      ];
    }
  }

  // Cambiar el día seleccionado y actualizar los hábitos visibles
  void changeSelectedDay(DateTime day) {
    selectedDay.value = day;
    _initializeHabitsForDay(
        day); // Asegurar que los hábitos existan para este día
  }

  // Obtener la lista de hábitos para el día seleccionado
  List<Habit> getHabitsForSelectedDay() {
    return habitsByDay[selectedDay.value.toIso8601String()] ?? [];
  }

  // Función para agregar un nuevo hábito al día seleccionado
  void addNewHabit(String name, double target, String unit, String emoji) {
    Habit newHabit = Habit(
      name: name,
      progress: 0,
      target: target,
      unit: unit,
      emoji: emoji,
    );
    habitsByDay[selectedDay.value.toIso8601String()]?.add(newHabit);
    habitsByDay
        .refresh(); // Refrescar la lista de hábitos para reflejar los cambios
  }

  // Función para agregar progreso a un hábito del día seleccionado
  void addProgress(Habit habit, double value) {
    habit.progress += value;
    if (habit.progress >= habit.target) {
      habit.isCompleted = true;
    }
    habitsByDay.refresh();
  }

  void resetProgress(Habit habit) {
    habit.progress = 0;
    habit.isCompleted = false;
    habit.isSkipped = false;
    habit.isFailed = false;
    habitsByDay.refresh();
  }

  void failHabit(Habit habit) {
    habit.isFailed = true;
    habit.isSkipped = false;
    habit.isCompleted = false;
    habitsByDay.refresh();
  }

  void skipHabit(Habit habit) {
    habit.isSkipped = true;
    habit.isFailed = false;
    habit.isCompleted = true;
    habitsByDay.refresh();
  }
}
