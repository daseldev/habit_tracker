import 'package:habit_tracker_atomic/presentation/controllers/challenge_controller.dart';
import 'package:habit_tracker_atomic/presentation/controllers/habit_controller.dart';

class User {
  String username;
  String email;
  String password;
  String gender;
  String skinTone;
  String hairColor;
  List<Habit> defaultHabits;
  List<Challenge> challenges;
  int points;
  int level; // Nuevo campo para el nivel del usuario
  int experience; // Nuevo campo para la experiencia actual

  User({
    required this.username,
    required this.email,
    required this.password,
    required this.gender,
    required this.skinTone,
    required this.hairColor,
    this.defaultHabits = const [],
    this.challenges = const [],
    this.points = 0,
    this.level = 1, // Empezamos con el nivel 1
    this.experience = 0, // Empezamos con 0 puntos de experiencia
  });

  // Función para calcular la experiencia necesaria para el próximo nivel
  int experienceForNextLevel() {
    return 50 * (2 ^ (level - 1));
  }

  // Función para añadir experiencia
  void addExperience(int exp) {
    experience += exp;
    // Verificar si el usuario ha alcanzado suficiente experiencia para subir de nivel
    if (experience >= experienceForNextLevel()) {
      levelUp();
    }
  }

  // Función para subir de nivel
  void levelUp() {
    experience -= experienceForNextLevel(); // Restar la experiencia sobrante
    level++; // Aumentar el nivel
  }

  // Función para añadir monedas de oro
  void addGold() {
    points++;
  }
}
