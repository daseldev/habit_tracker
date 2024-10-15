import 'package:get/get.dart';
import 'package:habit_tracker_atomic/presentation/controllers/auth_controller.dart';
import 'package:fl_chart/fl_chart.dart';

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

class HabitSummary {
  double successRate;
  int completed;
  int failed;
  int skipped;
  int bestStreak;

  HabitSummary({
    this.successRate = 0.0,
    this.completed = 0,
    this.failed = 0,
    this.skipped = 0,
    this.bestStreak = 0,
  });
}

class HabitController extends GetxController {
  var habitsByUserAndDay =
      <String, List<Habit>>{}.obs; // Hábitos por usuario y día
  var selectedDay = DateTime.now().obs; // Día actualmente seleccionado
  var habitSummary = HabitSummary().obs; // Resumen de hábitos
  var habitGraphData = <FlSpot>[].obs; // Datos para la gráfica de hábitos

  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    _initializeHabitsForDay(selectedDay.value);
  }

  // Función para obtener la clave compuesta de usuario y día
  String _getUserDayKey(DateTime date) {
    String username = authController.currentUser.value?.username ?? "unknown";
    return '$username-${date.toIso8601String()}';
  }

  // Función para inicializar los hábitos del día seleccionado
  void _initializeHabitsForDay(DateTime date) {
    String userDayKey = _getUserDayKey(date);

    if (!habitsByUserAndDay.containsKey(userDayKey)) {
      List<Habit> defaultHabits = authController.getDefaultHabits();
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

  // Cambiar el día seleccionado y asegurarse de inicializar los hábitos
  void changeSelectedDay(DateTime day) {
    selectedDay.value = day;
    _initializeHabitsForDay(day);
  }

  // Obtener los hábitos para el día seleccionado
  List<Habit> getHabitsForSelectedDay(DateTime date) {
    String userDayKey = _getUserDayKey(date);
    return habitsByUserAndDay[userDayKey] ?? [];
  }

  // Resumen de hábitos para un intervalo de tiempo seleccionado (día, semana, mes)
  void updateHabitSummary(String interval) {
    if (interval == 'Daily') {
      habitSummary.value = _calculateDailySummaryForDate(selectedDay.value);
      habitGraphData.value = _calculateDailyGraphData();
    } else if (interval == 'Weekly') {
      habitSummary.value = _calculateWeeklySummary();
      habitGraphData.value = _calculateWeeklyGraphData();
    } else if (interval == 'Monthly') {
      habitSummary.value = _calculateMonthlySummary();
      habitGraphData.value = _calculateMonthlyGraphData();
    }
  }

  // Función para calcular el resumen diario de hábitos
  HabitSummary _calculateDailySummaryForDate(DateTime date) {
    List<Habit> habits = getHabitsForSelectedDay(
        date); // Método que obtiene hábitos para una fecha específica
    if (habits.isEmpty) return HabitSummary();

    int completed = habits.where((habit) => habit.isCompleted).length;
    int failed = habits.where((habit) => habit.isFailed).length;
    int skipped = habits.where((habit) => habit.isSkipped).length;

    return HabitSummary(
      completed: completed,
      failed: failed,
      skipped: skipped,
    );
  }

  // Función para calcular la mejor racha de hábitos completados
  int _calculateBestStreak() {
    // Implementar lógica para calcular la mejor racha de hábitos
    return 5; // Cambia esto a la lógica adecuada para calcular la racha
  }

  // Función para calcular el resumen semanal de hábitos
  HabitSummary _calculateWeeklySummary() {
    // Obtener la fecha actual
    DateTime now = DateTime.now();

    // Inicializar contadores
    int totalCompleted = 0;
    int totalFailed = 0;
    int totalSkipped = 0;

    // Recorrer los últimos 7 días
    for (int i = 0; i < 7; i++) {
      DateTime currentDate = now.subtract(Duration(days: i));

      // Obtener resumen diario para el día actual
      HabitSummary dailySummary = _calculateDailySummaryForDate(currentDate);

      // Sumar los datos diarios al total semanal
      totalCompleted += dailySummary.completed;
      totalFailed += dailySummary.failed;
      totalSkipped += dailySummary.skipped;
    }

    // Calcular la tasa de éxito semanal
    double successRate = (totalCompleted + totalSkipped > 0)
        ? totalCompleted / (totalCompleted + totalSkipped)
        : 0.0;

    return HabitSummary(
        successRate: successRate,
        completed: totalCompleted,
        failed: totalFailed,
        skipped: totalSkipped,
        bestStreak:
            _calculateBestStreakForWeekly() // Aquí puedes calcular la mejor racha semanal
        );
  }

  int _calculateBestStreakForWeekly() {
    // Aquí deberías implementar la lógica para calcular la mejor racha de hábitos completados en la última semana
    return 5; // Cambia esto a la lógica adecuada para calcular la racha
  }

  // Función para calcular el resumen mensual de hábitos
  HabitSummary _calculateMonthlySummary() {
    // Similar a la función semanal, pero aquí agruparías los hábitos por el mes
    return HabitSummary(
      successRate: 0.85, // Ejemplo, reemplaza con cálculos reales
      completed: 90,
      failed: 10,
      skipped: 5,
      bestStreak: 15,
    );
  }

  // Datos del gráfico diario
  List<FlSpot> _calculateDailyGraphData() {
    // Datos del gráfico, por ejemplo, del progreso en cada hora del día
    return [
      FlSpot(0, 1), // Ejemplo: 1 hábito completado en la primera hora
      FlSpot(1, 0.5),
      FlSpot(2, 0.8),
      FlSpot(3, 0.3),
    ];
  }

  // Datos del gráfico semanal
  List<FlSpot> _calculateWeeklyGraphData() {
    return [
      FlSpot(0, 5), // Ejemplo: 5 hábitos completados en el primer día
      FlSpot(1, 4),
      FlSpot(2, 3),
      FlSpot(3, 6),
      FlSpot(4, 7),
      FlSpot(5, 8),
      FlSpot(6, 5),
    ];
  }

  // Datos del gráfico mensual
  List<FlSpot> _calculateMonthlyGraphData() {
    return [
      FlSpot(0, 20), // Ejemplo: 20 hábitos completados en la primera semana
      FlSpot(1, 25),
      FlSpot(2, 15),
      FlSpot(3, 30),
    ];
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
    var habits = getHabitsForSelectedDay(selectedDay.value);
    if (habits.isEmpty) return 0.0;

    int completedCount =
        habits.where((habit) => habit.isCompleted || habit.isSkipped).length;
    return completedCount / habits.length;
  }
}
