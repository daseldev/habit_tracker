import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart'; // Librería para gráficos
import 'package:habit_tracker_atomic/presentation/controllers/auth_controller.dart';
import 'package:habit_tracker_atomic/presentation/controllers/habit_controller.dart';
import 'package:habit_tracker_atomic/presentation/pages/LoginORegister/LoginORegister_page.dart'; // Página a la que se redirige después del logout
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
              SizedBox(height: 30),
              _buildLogoutButton(context, isDarkMode), // Botón de cerrar sesión
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
        Expanded(
          // Usamos Expanded para que tome el ancho disponible
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color:
                      isDarkMode ? AppColors.fondoClaro : AppColors.grisOscuro,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Level ${authController.currentUser.value!.level}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue, // Azul para el nivel
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.arrow_upward, color: Colors.blue),
                ],
              ),
              SizedBox(height: 8),
              Obx(() {
                final user = authController.currentUser.value!;
                final progress =
                    user.experience / user.experienceForNextLevel();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Barra de experiencia
                    SizedBox(
                      width: double.infinity, // Ocupa todo el ancho disponible
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.grisOscuro.withOpacity(0.3),
                        color: Colors.blue, // Azul para la experiencia
                        minHeight: 8,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${user.experience}/${user.experienceForNextLevel()} XP',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue, // Azul para el texto de experiencia
                      ),
                    ),
                  ],
                );
              }),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.monetization_on,
                      color: Colors.amber), // Icono de moneda
                  SizedBox(width: 5),
                  Obx(() {
                    return Text(
                      '${authController.currentUser.value!.points} Gold Coins',
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

  // Botón de cerrar sesión
  Widget _buildLogoutButton(BuildContext context, bool isDarkMode) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          authController.logoutUser();
          // Redirigir a la página de inicio de sesión
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginORegisterPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              AppColors.primario, // Usamos el color primario para el botón
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        ),
        child: Text(
          'Log Out',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Texto blanco
          ),
        ),
      ),
    );
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
