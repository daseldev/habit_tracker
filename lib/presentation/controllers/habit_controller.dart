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

  String toString() {
    return 'Habit(name: $name, progress: $progress, target: $target, unit: $unit, emoji: $emoji, isCompleted: $isCompleted, isSkipped: $isSkipped, isFailed: $isFailed)';
  }
}

class HabitController extends GetxController {
  var habitsByDay = <String, List<Habit>>{}.obs;
  var selectedDay = DateTime.now()
      .obs; // Cambiado a DateTime para seleccionar días específicos
  var selectedHabits =
      <Habit>[].obs; // Lista de hábitos seleccionados por el usuario

  @override
  void onInit() {
    super.onInit();
    // Inicializa los hábitos seleccionados por defecto si no existen para el día actual
    _initializeHabitsForDay(selectedDay.value);
  }

  // Actualiza los hábitos seleccionados
  void setSelectedHabits(List<Habit> habits) {
    selectedHabits.value = habits;
  }

  // Inicializa los hábitos predeterminados para un día si aún no están establecidos
  void _initializeHabitsForDay(DateTime date) {
    String dayKey = date.toIso8601String();
    if (!habitsByDay.containsKey(dayKey)) {
      // Usa los hábitos seleccionados por el usuario si están disponibles
      habitsByDay[dayKey] = selectedHabits.isNotEmpty
          ? selectedHabits
              .map((habit) => Habit(
                  name: habit.name,
                  progress: 0,
                  target: habit.target,
                  unit: habit.unit,
                  emoji: habit.emoji))
              .toList()
          : [];
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

  double calculateCompletedPercentage() {
    var habits = getHabitsForSelectedDay();
    if (habits.isEmpty) return 0.0;

    int completedCount =
        habits.where((habit) => habit.isCompleted || habit.isSkipped).length;
    return completedCount / habits.length;
  }
}
