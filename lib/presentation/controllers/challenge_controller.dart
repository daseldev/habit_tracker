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
}

class ChallengeController extends GetxController {
  var userChallenges =
      <Challenge>[].obs; // Lista observable de desafíos del usuario

  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    // Inicializar desafíos para el usuario actual
    _initializeChallengesForUser();
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
          ],
        ),
        Challenge(
          name: "Hydration Masters",
          startDate: DateTime.now(),
          endDate: DateTime.now().add(Duration(days: 7)),
          tasks: [
            Task(name: "Drink Water", progress: 0, target: 2000, unit: "ML"),
            Task(name: "Rest", progress: 0, target: 8, unit: "HOURS"),
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
}
