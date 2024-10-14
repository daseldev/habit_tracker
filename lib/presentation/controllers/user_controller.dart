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
  List<Challenge> challenges; // Agregar desafíos al usuario

  User({
    required this.username,
    required this.email,
    required this.password,
    required this.gender,
    required this.skinTone,
    required this.hairColor,
    this.defaultHabits = const [],
    this.challenges = const [], // Inicializar con una lista vacía de desafíos
  });
}
