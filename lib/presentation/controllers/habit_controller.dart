import 'package:get/get.dart';
import 'package:habit_tracker_atomic/presentation/controllers/auth_controller.dart';
import 'package:fl_chart/fl_chart.dart';

class Habit {
  String name;
  double progress;
  double target;
  String unit;
  bool isCompleted;
  bool isSkipped;
  bool isFailed;
  String emoji;

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
  var habitsByUserAndDay = <String, List<Habit>>{}.obs;
  var selectedDay = DateTime.now().obs;
  var habitSummary = HabitSummary().obs;
  var habitGraphData = <FlSpot>[].obs;

  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    _initializeHabitsForDay(selectedDay.value);
  }

  String _getUserDayKey(DateTime date) {
    String username = authController.currentUser.value?.username ?? "unknown";
    return '$username-${date.toIso8601String()}';
  }

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

  void changeSelectedDay(DateTime day) {
    selectedDay.value = day;
    _initializeHabitsForDay(day);
  }

  List<Habit> getHabitsForSelectedDay(DateTime date) {
    String userDayKey = _getUserDayKey(date);
    return habitsByUserAndDay[userDayKey] ?? [];
  }

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

  HabitSummary _calculateDailySummaryForDate(DateTime date) {
    List<Habit> habits = getHabitsForSelectedDay(date);
    if (habits.isEmpty) return HabitSummary();

    int completed = habits.where((habit) => habit.isCompleted).length;
    int failed = habits.where((habit) => habit.isFailed).length;
    int skipped = habits.where((habit) => habit.isSkipped).length;
    double successRate = (completed - skipped) / habits.length;

    return HabitSummary(
      successRate: successRate,
      completed: completed,
      failed: failed,
      skipped: skipped,
    );
  }

  // Resumen semanal
  HabitSummary _calculateWeeklySummary() {
    DateTime now = DateTime.now();
    int totalCompleted = 0;
    int totalFailed = 0;
    int totalSkipped = 0;
    int totalHabits = 0;

    for (int i = 0; i < 7; i++) {
      DateTime currentDate = now.subtract(Duration(days: i));
      List<Habit> habits = getHabitsForSelectedDay(currentDate);

      totalCompleted += habits.where((habit) => habit.isCompleted).length;
      totalFailed += habits.where((habit) => habit.isFailed).length;
      totalSkipped += habits.where((habit) => habit.isSkipped).length;
      totalHabits += habits.length;
    }

    double successRate = totalHabits > 0 ? totalCompleted / totalHabits : 0.0;

    return HabitSummary(
      successRate: successRate,
      completed: totalCompleted,
      failed: totalFailed,
      skipped: totalSkipped,
      bestStreak: _calculateBestStreak(7),
    );
  }

  // Resumen mensual
  HabitSummary _calculateMonthlySummary() {
    DateTime now = DateTime.now();
    int totalCompleted = 0;
    int totalFailed = 0;
    int totalSkipped = 0;
    int totalHabits = 0;

    for (int i = 0; i < 30; i++) {
      DateTime currentDate = now.subtract(Duration(days: i));
      List<Habit> habits = getHabitsForSelectedDay(currentDate);

      totalCompleted += habits.where((habit) => habit.isCompleted).length;
      totalFailed += habits.where((habit) => habit.isFailed).length;
      totalSkipped += habits.where((habit) => habit.isSkipped).length;
      totalHabits += habits.length;
    }

    double successRate = totalHabits > 0 ? totalCompleted / totalHabits : 0.0;

    return HabitSummary(
      successRate: successRate,
      completed: totalCompleted,
      failed: totalFailed,
      skipped: totalSkipped,
      bestStreak: _calculateBestStreak(30),
    );
  }

  // Calcular la mejor racha (streak)
  int _calculateBestStreak(int days) {
    int currentStreak = 0;
    int bestStreak = 0;
    DateTime now = DateTime.now();

    for (int i = 0; i < days; i++) {
      DateTime currentDate = now.subtract(Duration(days: i));
      List<Habit> habits = getHabitsForSelectedDay(currentDate);
      bool allCompleted = habits.every((habit) => habit.isCompleted);

      if (allCompleted) {
        currentStreak++;
      } else {
        bestStreak = currentStreak > bestStreak ? currentStreak : bestStreak;
        currentStreak = 0;
      }
    }

    return bestStreak;
  }

  // Gráficos diarios, semanales y mensuales
  List<FlSpot> _calculateDailyGraphData() {
    final habits = getHabitsForSelectedDay(selectedDay.value);

    List<FlSpot> dailyData = [];
    for (int hour = 0; hour < 24; hour++) {
      int habitsCompleted = habits
          .where((habit) => habit.getProgressPercentage() >= (hour / 24))
          .length;
      dailyData.add(FlSpot(hour.toDouble(), habitsCompleted.toDouble()));
    }
    return dailyData;
  }

  List<FlSpot> _calculateWeeklyGraphData() {
    List<FlSpot> weeklyData = [];
    DateTime now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      DateTime day = now.subtract(Duration(days: i));
      final habits = getHabitsForSelectedDay(day);
      int habitsCompleted = habits.where((habit) => habit.isCompleted).length;
      weeklyData.add(FlSpot(i.toDouble(), habitsCompleted.toDouble()));
    }
    return weeklyData.reversed.toList();
  }

  List<FlSpot> _calculateMonthlyGraphData() {
    List<FlSpot> monthlyData = [];
    DateTime now = DateTime.now();
    for (int i = 0; i < 4; i++) {
      DateTime startOfWeek = now.subtract(Duration(days: i * 7));
      DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
      int habitsCompleted = 0;

      for (int j = 0; j < 7; j++) {
        DateTime currentDay = startOfWeek.add(Duration(days: j));
        final habits = getHabitsForSelectedDay(currentDay);
        habitsCompleted += habits.where((habit) => habit.isCompleted).length;
      }

      monthlyData.add(FlSpot(i.toDouble(), habitsCompleted.toDouble()));
    }
    return monthlyData.reversed.toList();
  }

  // Agregar nuevo hábito
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

  // Añadir progreso
  void addProgress(Habit habit, double value) {
    habit.progress += value;
    if (habit.progress >= habit.target) {
      habit.isCompleted = true;
      authController.currentUser.value?.addExperience(10); // Añadir experiencia
    }
    habitsByUserAndDay.refresh();
  }

  void resetProgress(Habit habit) {
    habit.progress = 0;
    habit.isCompleted = false;
    habit.isSkipped = false;
    habit.isFailed = false;
    habitsByUserAndDay.refresh();
  }

  void failHabit(Habit habit) {
    habit.isFailed = true;
    habit.isSkipped = false;
    habit.isCompleted = false;
    habitsByUserAndDay.refresh();
  }

  void skipHabit(Habit habit) {
    habit.isSkipped = true;
    habit.isFailed = false;
    habit.isCompleted = true;
    habitsByUserAndDay.refresh();
  }

  double calculateCompletedPercentage() {
    var habits = getHabitsForSelectedDay(selectedDay.value);
    if (habits.isEmpty) return 0.0;

    int completedCount =
        habits.where((habit) => habit.isCompleted || habit.isSkipped).length;
    return completedCount / habits.length;
  }
}
