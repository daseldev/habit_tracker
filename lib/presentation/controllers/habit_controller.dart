import 'package:get/get.dart';
import 'package:habit_tracker_atomic/presentation/controllers/auth_controller.dart';

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

  @override
  String toString() {
    return 'Habit(name: $name, progress: $progress, target: $target, unit: $unit, emoji: $emoji, isCompleted: $isCompleted, isSkipped: $isSkipped, isFailed: $isFailed)';
  }
}

class HabitController extends GetxController {
  var habitsByUserAndDay =
      <String, List<Habit>>{}.obs; // Hábitos por usuario y día
  var selectedDay = DateTime.now().obs; // Día actualmente seleccionado
  var selectedHabits = <Habit>[].obs; // Lista de hábitos seleccionados

  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    // Inicializa los hábitos seleccionados para el día actual si no existen
    _initializeHabitsForDay(selectedDay.value);
  }

  // Función para obtener la clave compuesta de usuario y día
  String _getUserDayKey(DateTime date) {
    String username = authController.currentUser.value?.username ?? "unknown";
    return '$username-${date.toIso8601String()}';
  }

  // Función para transferir los hábitos predeterminados del usuario a un día específico
  void _initializeHabitsForDay(DateTime date) {
    String userDayKey = _getUserDayKey(date);

    if (!habitsByUserAndDay.containsKey(userDayKey)) {
      // Obtener los hábitos predeterminados del usuario actual desde el AuthController
      List<Habit> defaultHabits = authController.getDefaultHabits();

      // Clonar los hábitos predeterminados para que sean independientes por día
      habitsByUserAndDay[userDayKey] = defaultHabits.map((habit) {
        return Habit(
          name: habit.name,
          progress: 0,
          target: habit.target,
          unit: habit.unit,
          emoji: habit.emoji,
        );
      }).toList();
    }
  }

  // Cambiar el día seleccionado y asegurarse de inicializar los hábitos si no están asignados
  void changeSelectedDay(DateTime day) {
    selectedDay.value = day;
    _initializeHabitsForDay(
        day); // Asegurarse de que los hábitos existan para este día
  }

  // Obtener los hábitos para el usuario y el día seleccionado
  List<Habit> getHabitsForSelectedDay() {
    String userDayKey = _getUserDayKey(selectedDay.value);
    return habitsByUserAndDay[userDayKey] ?? [];
  }

  // Agregar un nuevo hábito al día seleccionado
  void addNewHabit(String name, double target, String unit, String emoji) {
    String userDayKey = _getUserDayKey(selectedDay.value);
    Habit newHabit = Habit(
      name: name,
      progress: 0,
      target: target,
      unit: unit,
      emoji: emoji,
    );
    habitsByUserAndDay[userDayKey]?.add(newHabit);
    habitsByUserAndDay.refresh();
  }

  // Función para agregar progreso a un hábito del día seleccionado
  void addProgress(Habit habit, double value) {
    habit.progress += value;
    if (habit.progress >= habit.target) {
      habit.isCompleted = true;
    }
    habitsByUserAndDay.refresh();
  }

  // Función para restablecer el progreso de un hábito
  void resetProgress(Habit habit) {
    habit.progress = 0;
    habit.isCompleted = false;
    habit.isSkipped = false;
    habit.isFailed = false;
    habitsByUserAndDay.refresh();
  }

  // Función para marcar un hábito como fallido
  void failHabit(Habit habit) {
    habit.isFailed = true;
    habit.isSkipped = false;
    habit.isCompleted = false;
    habitsByUserAndDay.refresh();
  }

  // Función para marcar un hábito como saltado
  void skipHabit(Habit habit) {
    habit.isSkipped = true;
    habit.isFailed = false;
    habit.isCompleted = true;
    habitsByUserAndDay.refresh();
  }

  // Calcular el porcentaje de hábitos completados para el día seleccionado
  double calculateCompletedPercentage() {
    var habits = getHabitsForSelectedDay();
    if (habits.isEmpty) return 0.0;

    int completedCount =
        habits.where((habit) => habit.isCompleted || habit.isSkipped).length;
    return completedCount / habits.length;
  }
}
