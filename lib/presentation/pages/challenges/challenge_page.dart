import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker_atomic/presentation/controllers/challenge_controller.dart';
import 'package:habit_tracker_atomic/presentation/controllers/task_controller.dart';
import 'package:habit_tracker_atomic/presentation/theme/app_colors.dart';

class ChallengePage extends StatelessWidget {
  final ChallengeController challengeController =
      Get.put(ChallengeController());
  final TaskController taskController = Get.put(TaskController());

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
        title: Text(
          'Challenges',
          style: TextStyle(
            color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
          ),
        ),
      ),
      body: Obx(() {
        var challenges = challengeController.userChallenges;

        if (challenges.isEmpty) {
          return Center(
            child: Text(
              "No Challenges Available",
              style: TextStyle(
                  color:
                      isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro),
            ),
          );
        }

        return ListView.builder(
          itemCount: challenges.length,
          itemBuilder: (context, index) {
            var challenge = challenges[index];

            return GestureDetector(
              onTap: () {
                if (!challengeController.isChallengeJoined(challenge)) {
                  challengeController.joinChallenge(challenge);
                }
              },
              child: Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                color: AppColors.grisClaro, // Cambié el color a gris claro
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? AppColors.fondoClaro
                              : AppColors.grisOscuro,
                        ),
                      ),
                      SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: challenge.calculateProgress(),
                        backgroundColor: AppColors.grisOscuro.withOpacity(0.3),
                        color: AppColors.primario,
                      ),
                      SizedBox(height: 5),
                      Text(
                        "${challenge.tasks.length} tasks",
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.fondoClaro
                              : AppColors.grisOscuro,
                        ),
                      ),
                      SizedBox(height: 5),
                      if (challenge.isCompleted)
                        Text(
                          "Challenge Completed!",
                          style: TextStyle(
                            color: AppColors.verdeCompletado,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else if (challengeController.isChallengeJoined(challenge))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "You have joined this challenge!",
                              style: TextStyle(
                                color: AppColors.primario,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            _buildTaskList(challenge, isDarkMode),
                          ],
                        )
                      else
                        ElevatedButton(
                          onPressed: () {
                            challengeController.joinChallenge(challenge);
                            Get.snackbar(
                              "Challenge Joined",
                              "You have successfully joined ${challenge.name}!",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                          child: Text("Join Challenge"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primario,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // Método que construye la lista de tareas para un desafío
  Widget _buildTaskList(Challenge challenge, bool isDarkMode) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: challenge.tasks.length,
      itemBuilder: (context, taskIndex) {
        var task = challenge.tasks[taskIndex];
        double progressPercentage = task.getProgressPercentage();

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors
                  .grisClaro, // Ajusté el color de las tareas a gris claro
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
                    _getEmojiForTask(task.name),
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
                          color: AppColors.grisOscuro,
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
                          color: AppColors.grisOscuro,
                        ),
                      ),
                    ],
                  ),
                ),
                if (task.isFailed)
                  Icon(Icons.close, color: AppColors.rojoError)
                else if (task.isCompleted || task.isSkipped)
                  Icon(Icons.check, color: AppColors.primario)
                else
                  IconButton(
                    icon: Icon(Icons.add, color: AppColors.primario),
                    onPressed: () {
                      _showTaskOptionsDialog(task, challenge);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Método para obtener el emoji correspondiente a una tarea
  String _getEmojiForTask(String taskName) {
    switch (taskName) {
      case "Run 5K":
        return "🏃‍♂️";
      case "Stretch":
        return "🧘‍♂️";
      case "Drink Water":
        return "💧";
      case "Rest":
        return "🛌";
      default:
        return "✅";
    }
  }

  // Diálogo para actualizar el progreso de una tarea
  void _showTaskOptionsDialog(Task task, Challenge challenge) {
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
            challengeController.checkChallengeCompletion(
                challenge); // Verificar si el challenge está completado
            Get.back();
          },
          child: Text('Fail', style: TextStyle(color: AppColors.rojoError)),
        ),
        TextButton(
          onPressed: () {
            taskController.skipTask(task);
            challengeController.checkChallengeCompletion(
                challenge); // Verificar si el challenge está completado
            Get.back();
          },
          child: Text('Skip', style: TextStyle(color: AppColors.gris)),
        ),
        ElevatedButton(
          onPressed: () {
            if (progressController.text.isNotEmpty) {
              double progressValue =
                  double.tryParse(progressController.text) ?? 0;
              taskController.addProgress(task, progressValue);
              challengeController.checkChallengeCompletion(
                  challenge); // Verificar si el challenge está completado
              Get.back();
            }
          },
          child: Text('Add'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primario,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          ),
        ),
      ],
    );
  }
}
