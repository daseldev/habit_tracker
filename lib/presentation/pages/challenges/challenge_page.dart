import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker_atomic/presentation/controllers/task_controller.dart';
import 'package:habit_tracker_atomic/presentation/theme/app_colors.dart';

class ChallengeDetailPage extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());
  var hasJoinedChallenge =
      false.obs; // Estado para saber si el usuario ya se unió

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            isDarkMode ? AppColors.fondoOscuro : AppColors.fondoClaro,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Centramos todo el contenido
            children: [
              _buildHeader(isDarkMode), // Centrar encabezado
              SizedBox(height: 20),
              _buildJoinChallengeButton(),
              SizedBox(height: 20),
              _buildTasksSection(isDarkMode), // Mostrar la lista de tareas
            ],
          ),
        ),
      ),
    );
  }

  // Construir el encabezado del desafío centrado
  Widget _buildHeader(bool isDarkMode) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center, // Aseguramos que todo esté centrado
      children: [
        Text(
          "Best Runners!",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
          ),
          textAlign: TextAlign.center, // Texto centrado
        ),
        SizedBox(height: 5),
        Text(
          "May 28 to 4 June",
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode
                ? AppColors.fondoClaro.withOpacity(0.7)
                : AppColors.grisOscuro.withOpacity(0.7),
          ),
          textAlign: TextAlign.center, // Texto centrado
        ),
        SizedBox(height: 10),
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.primario,
          child: Icon(Icons.directions_run, color: Colors.white, size: 35),
        ),
      ],
    );
  }

  // Botón para unirse al desafío
  Widget _buildJoinChallengeButton() {
    return Center(
      child: Obx(() {
        return ElevatedButton(
          onPressed: hasJoinedChallenge.value
              ? null
              : () {
                  taskController.addTask("Run 5K", 5000, "METERS");
                  taskController.addTask("Stretch", 20, "MINUTES");
                  taskController.addTask("Hydrate", 2000, "ML");
                  taskController.addTask("Cool Down", 15, "MINUTES");
                  taskController.addTask("Rest", 8, "HOURS");
                  hasJoinedChallenge.value = true;
                  Get.snackbar("Success", "You have joined the challenge!",
                      snackPosition: SnackPosition.BOTTOM);
                },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            backgroundColor:
                hasJoinedChallenge.value ? Colors.grey : AppColors.primario,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            hasJoinedChallenge.value ? "You are in!" : "Join the Challenge",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        );
      }),
    );
  }

  // Sección de tareas
  Widget _buildTasksSection(bool isDarkMode) {
    return Obx(() {
      var tasks = taskController.tasks;
      if (tasks.isEmpty) {
        return Text(
          "No tasks yet. Join the challenge to start.",
          style: TextStyle(
            color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
          ),
          textAlign: TextAlign.center, // Texto centrado
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tasks",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
            ),
          ),
          SizedBox(height: 10),
          Column(
            children:
                tasks.map((task) => _buildTaskItem(task, isDarkMode)).toList(),
          ),
        ],
      );
    });
  }

  // Item individual de una tarea con emoji relevante
  Widget _buildTaskItem(Task task, bool isDarkMode) {
    double progressPercentage = task.getProgressPercentage();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.grisOscuro.withOpacity(0.2)
              : AppColors.gris.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: AppColors.primario,
              child: Text(
                _getEmojiForTask(task.name), // Añadir el emoji correspondiente
                style: TextStyle(fontSize: 24),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? AppColors.fondoClaro
                          : AppColors.grisOscuro,
                    ),
                  ),
                  SizedBox(height: 5),
                  LinearProgressIndicator(
                    value: progressPercentage,
                    backgroundColor: AppColors.grisOscuro.withOpacity(0.3),
                    color: AppColors.primario,
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${task.progress}/${task.target} ${task.unit}',
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.fondoClaro
                          : AppColors.grisOscuro,
                    ),
                  ),
                ],
              ),
            ),
            if (task.isFailed)
              Icon(Icons.close, color: Colors.red)
            else if (task.isCompleted || task.isSkipped)
              Icon(Icons.check, color: AppColors.primario)
            else
              IconButton(
                icon: Icon(Icons.add, color: AppColors.primario),
                onPressed: () {
                  _showTaskOptionsDialog(task);
                },
              ),
          ],
        ),
      ),
    );
  }

  // Función para obtener el emoji correspondiente a cada tarea
  String _getEmojiForTask(String taskName) {
    switch (taskName) {
      case "Run 5K":
        return "🏃‍♂️";
      case "Stretch":
        return "🧘‍♂️";
      case "Hydrate":
        return "💧";
      case "Cool Down":
        return "❄️";
      case "Rest":
        return "🛌";
      default:
        return "✅";
    }
  }

  // Diálogo para actualizar el progreso, fallar o saltar una tarea
  void _showTaskOptionsDialog(Task task) {
    final TextEditingController progressController = TextEditingController();

    Get.defaultDialog(
      title: 'Update Task',
      content: Column(
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
            taskController.failTask(task);
            Get.back();
          },
          child: Text('Fail'),
        ),
        TextButton(
          onPressed: () {
            taskController.skipTask(task);
            Get.back();
          },
          child: Text('Skip'),
        ),
        ElevatedButton(
          onPressed: () {
            if (progressController.text.isNotEmpty) {
              double progressValue =
                  double.tryParse(progressController.text) ?? 0;
              taskController.addProgress(task, progressValue);
              Get.back();
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
