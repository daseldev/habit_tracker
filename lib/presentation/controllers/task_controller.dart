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
    if (target == 0) {
      return isCompleted ? 1.0 : 0.0; // Evitar división por 0
    }
    return progress / target;
  }
}

class TaskController extends GetxController {
  var tasks = <Task>[].obs;

  void addTask(String name, double target, String unit) {
    tasks.add(Task(name: name, progress: 0, target: target, unit: unit));
    tasks.refresh(); // Notificar cambio
  }

  void addProgress(Task task, double value) {
    task.progress += value;
    if (task.progress >= task.target) {
      task.isCompleted = true;
    }
    tasks.refresh(); // Notificar cambio
  }

  void failTask(Task task) {
    task.isFailed = true;
    task.isSkipped = false;
    task.isCompleted = false;
    tasks.refresh(); // Notificar cambio
  }

  void skipTask(Task task) {
    task.isSkipped = true;
    task.isFailed = false;
    task.isCompleted = true;
    tasks.refresh(); // Notificar cambio
  }
}
