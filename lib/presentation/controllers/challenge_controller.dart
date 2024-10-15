import 'package:get/get.dart';
import 'package:habit_tracker_atomic/presentation/controllers/auth_controller.dart';
import 'package:habit_tracker_atomic/presentation/controllers/task_controller.dart';

class Challenge {
  String name;
  DateTime startDate;
  DateTime endDate;
  List<Task> tasks;
  bool isCompleted;
  bool hasJoined; // Campo para verificar si el usuario se ha unido al desafío

  Challenge({
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.tasks,
    this.isCompleted = false,
    this.hasJoined = false, // Inicializamos como falso
  });

  // Calcular el progreso del desafío
  double calculateProgress() {
    if (tasks.isEmpty) return 0.0;
    int completedTasks = tasks.where((task) => task.isCompleted).length;
    return completedTasks / tasks.length;
  }

  // Verificar si el desafío está completado
  bool checkIfCompleted() {
    return tasks
        .every((task) => task.isCompleted); // Todas las tareas completadas
  }
}

class ChallengeController extends GetxController {
  var userChallenges =
      <Challenge>[].obs; // Lista observable de desafíos del usuario

  final AuthController authController = Get.find<AuthController>();
  final TaskController taskController = Get.find<TaskController>();

  @override
  void onInit() {
    super.onInit();
    _initializeChallengesForUser();
    // Suscribirse a cambios en los tasks
    taskController.tasks.listen((tasks) {
      userChallenges.refresh(); // Actualizar la lista de challenges
    });
  }

  void _initializeChallengesForUser() {
    if (authController.currentUser.value != null) {
      userChallenges.value = [
        Challenge(
          name: "Best Runners!",
          startDate: DateTime.now(),
          endDate: DateTime.now().add(Duration(days: 7)),
          tasks: [
            Task(name: "Run 5K", progress: 0, target: 5000, unit: "METERS"),
            Task(name: "Stretch", progress: 0, target: 20, unit: "MINUTES"),
            Task(
                name: "Sprint Intervals",
                progress: 0,
                target: 10,
                unit: "SETS"),
            Task(name: "Cooldown", progress: 0, target: 15, unit: "MINUTES"),
          ],
        ),
        Challenge(
          name: "Hydration Masters",
          startDate: DateTime.now(),
          endDate: DateTime.now().add(Duration(days: 7)),
          tasks: [
            Task(name: "Drink Water", progress: 0, target: 2000, unit: "ML"),
            Task(name: "Rest", progress: 0, target: 8, unit: "HOURS"),
            Task(
                name: "Fruits and Veggies",
                progress: 0,
                target: 5,
                unit: "PORTIONS"),
            Task(
                name: "No Sugary Drinks",
                progress: 0,
                target: 1,
                unit: "TIMES"),
          ],
        ),
        Challenge(
          name: "Mindfulness",
          startDate: DateTime.now(),
          endDate: DateTime.now().add(Duration(days: 10)),
          tasks: [
            Task(name: "Meditate", progress: 0, target: 30, unit: "MINUTES"),
            Task(name: "Deep Breathing", progress: 0, target: 5, unit: "SETS"),
            Task(
                name: "Gratitude Journal",
                progress: 0,
                target: 1,
                unit: "ENTRY"),
            Task(name: "Unplug", progress: 0, target: 60, unit: "MINUTES"),
          ],
        ),
        Challenge(
          name: "Strength Builders",
          startDate: DateTime.now(),
          endDate: DateTime.now().add(Duration(days: 14)),
          tasks: [
            Task(name: "Push-ups", progress: 0, target: 100, unit: "REPS"),
            Task(name: "Squats", progress: 0, target: 100, unit: "REPS"),
            Task(name: "Planks", progress: 0, target: 10, unit: "MINUTES"),
            Task(name: "Rest Day", progress: 0, target: 1, unit: "DAY"),
          ],
        ),
        Challenge(
          name: "Healthy Eating",
          startDate: DateTime.now(),
          endDate: DateTime.now().add(Duration(days: 7)),
          tasks: [
            Task(
                name: "Eat Whole Grains",
                progress: 0,
                target: 3,
                unit: "SERVINGS"),
            Task(
                name: "No Processed Foods",
                progress: 0,
                target: 1,
                unit: "TIMES"),
            Task(name: "Meal Prep", progress: 0, target: 4, unit: "MEALS"),
            Task(
                name: "Snack on Nuts", progress: 0, target: 1, unit: "PORTION"),
          ],
        ),
      ];
    }
  }

  // Unirse a un desafío
  void joinChallenge(Challenge challenge) {
    challenge.hasJoined = true; // Marcar que el usuario se ha unido
    userChallenges.refresh(); // Refrescar la lista de desafíos
  }

  // Verificar si el usuario ya está unido a un desafío
  bool isChallengeJoined(Challenge challenge) {
    return challenge.hasJoined;
  }

  // Verificar si el desafío está completado
  void checkChallengeCompletion(Challenge challenge) {
    if (challenge.checkIfCompleted()) {
      challenge.isCompleted = true;
      authController.currentUser.value?.addGold(); // Añadir moneda de oro
      Get.snackbar(
          'Challenge Completed', '${challenge.name} has been completed!');
    }
    userChallenges.refresh();
  }

  // Método que se llama cuando el progreso de una tarea cambia
  void updateTaskProgress(Task task, Challenge challenge) {
    taskController.addProgress(task, task.progress);
    checkChallengeCompletion(
        challenge); // Revisar si el desafío está completado después de actualizar la tarea
  }
}
