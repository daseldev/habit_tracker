import 'package:get/get.dart';

class Task {
  String name;
  double progress;
  double target;
  String unit;
  bool isCompleted;
  bool isSkipped;
  bool isFailed;

  Task({
    required this.name,
    required this.progress,
    required this.target,
    required this.unit,
    this.isCompleted = false,
    this.isSkipped = false,
    this.isFailed = false,
  });

  // Función para calcular el porcentaje de progreso
  double getProgressPercentage() {
    return progress / target;
  }
}

class TaskController extends GetxController {
  var tasks = <Task>[].obs;

  // Agregar tarea al challenge
  void addTask(String name, double target, String unit) {
    tasks.add(Task(name: name, progress: 0, target: target, unit: unit));
  }

  // Agregar progreso a una tarea
  void addProgress(Task task, double value) {
    task.progress += value;
    if (task.progress >= task.target) {
      task.isCompleted = true;
    }
    tasks.refresh();
  }

  // Marcar una tarea como fallida
  void failTask(Task task) {
    task.isFailed = true;
    task.isSkipped = false;
    task.isCompleted = false;
    tasks.refresh();
  }

  // Marcar una tarea como saltada
  void skipTask(Task task) {
    task.isSkipped = true;
    task.isFailed = false;
    task.isCompleted = true;
    tasks.refresh();
  }

  // Calcular el porcentaje de tareas completadas
  double calculateCompletedPercentage() {
    if (tasks.isEmpty) return 0.0;
    int completedCount =
        tasks.where((task) => task.isCompleted || task.isSkipped).length;
    return completedCount / tasks.length;
  }
}
