import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart'; // Librería para gráficos
import 'package:habit_tracker_atomic/presentation/controllers/auth_controller.dart';
import 'package:habit_tracker_atomic/presentation/controllers/habit_controller.dart';
import 'package:habit_tracker_atomic/presentation/theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final HabitController habitController = Get.find<HabitController>();

  final RxString selectedInterval = 'Weekly'.obs;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final user = authController.currentUser.value;

    return Scaffold(
      appBar: _buildAppBar(isDarkMode),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileSection(user!.username, isDarkMode),
              SizedBox(height: 20),
              _buildActivityTabs(isDarkMode),
              SizedBox(height: 20),
              _buildHabitStatistics(isDarkMode),
              SizedBox(height: 20),
              _buildHabitGraph(isDarkMode),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // AppBar personalizada
  AppBar _buildAppBar(bool isDarkMode) {
    return AppBar(
      backgroundColor:
          isDarkMode ? AppColors.fondoOscuro : AppColors.fondoClaro,
      elevation: 0,
      title: Text(
        'Your Profile',
        style: TextStyle(
          color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
        ),
      ),
      centerTitle: true,
    );
  }

  // Sección de perfil del usuario
  Widget _buildProfileSection(String username, bool isDarkMode) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(
            'https://example.com/profile-pic.jpg', // URL de ejemplo
          ),
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber),
                SizedBox(width: 5),
                Obx(() {
                  return Text(
                    '${authController.currentUser.value!.points} Points',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode
                          ? AppColors.fondoClaro
                          : AppColors.grisOscuro,
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Pestañas de actividad y logros
  Widget _buildActivityTabs(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTimeFilterButton('Daily', isDarkMode),
            _buildTimeFilterButton('Weekly', isDarkMode),
            _buildTimeFilterButton('Monthly', isDarkMode),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeFilterButton(String label, bool isDarkMode) {
    return Obx(() {
      return OutlinedButton(
        onPressed: () {
          selectedInterval.value = label;
          habitController.updateHabitSummary(label);
        },
        child: Text(
          label,
          style: TextStyle(
            color: selectedInterval.value == label
                ? AppColors.primario
                : isDarkMode
                    ? AppColors.fondoClaro
                    : AppColors.grisOscuro,
          ),
        ),
      );
    });
  }

  // Estadísticas de hábitos
  Widget _buildHabitStatistics(bool isDarkMode) {
    return Obx(() {
      final summary = habitController.habitSummary.value;
      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.grisOscuro.withOpacity(0.2)
              : AppColors.gris.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All Habits Summary',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatisticItem(
                    'Success Rate',
                    '${(summary.successRate * 100).toStringAsFixed(0)}%',
                    AppColors.primario),
                _buildStatisticItem(
                    'Completed', '${summary.completed}', AppColors.primario),
                _buildStatisticItem('Best Streak', '${summary.bestStreak} days',
                    AppColors.primario),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatisticItem('Failed', '${summary.failed}', Colors.red),
                _buildStatisticItem(
                    'Skipped', '${summary.skipped}', Colors.orange),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatisticItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.grisOscuro,
          ),
        ),
      ],
    );
  }

  // Gráfico de hábitos por intervalo (día, semana, mes)
  Widget _buildHabitGraph(bool isDarkMode) {
    return Obx(() {
      final graphData = habitController.habitGraphData;
      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.grisOscuro.withOpacity(0.2)
              : AppColors.gris.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Habits Comparison by ${selectedInterval.value}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: graphData,
                      isCurved: true,
                      color: AppColors.primario,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // Barra de navegación inferior
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: 1,
      onTap: (index) {
        if (index == 0) {
          Get.back(); // Regresar al Home
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      selectedItemColor: AppColors.primario,
      unselectedItemColor: AppColors.grisOscuro,
      showUnselectedLabels: true,
    );
  }
}
