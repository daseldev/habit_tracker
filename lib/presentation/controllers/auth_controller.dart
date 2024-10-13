import 'package:get/get.dart';
import 'package:habit_tracker_atomic/presentation/controllers/habit_controller.dart';
import 'package:habit_tracker_atomic/presentation/controllers/user_controller.dart';

class AuthController extends GetxController {
  var users = <String, User>{}
      .obs; // Simulación de base de datos de usuarios en memoria
  var currentUser = Rxn<User>(); // Usuario actualmente autenticado

  // Registro de usuario
  void registerUser(String username, String email, String password,
      String gender, String skinTone, String hairColor) {
    if (users.containsKey(username)) {
      Get.snackbar('Error', 'El nombre de usuario ya está en uso.');
      return;
    }

    User newUser = User(
      username: username,
      email: email,
      password: password,
      gender: gender,
      skinTone: skinTone,
      hairColor: hairColor,
      defaultHabits: [], // Inicializamos con una lista vacía de hábitos
    );

    users[username] = newUser;
    Get.snackbar('Éxito', 'Usuario registrado exitosamente.');
  }

  // Iniciar sesión
  void loginUser(String username, String password) {
    // Cerrar cualquier sesión activa antes de intentar iniciar una nueva
    logoutUser();

    if (!users.containsKey(username)) {
      Get.snackbar('Error', 'Usuario no encontrado.');
      return; // Detener la ejecución si el usuario no existe
    }

    User user = users[username]!;

    // Verifica que la contraseña sea correcta antes de autenticar
    if (user.password == password) {
      currentUser.value = user;
      Get.snackbar('Éxito', 'Sesión iniciada como $username');
    } else {
      Get.snackbar('Error', 'Contraseña incorrecta.');
      return; // Detener la ejecución si la contraseña es incorrecta
    }
  }

  // Cerrar sesión
  void logoutUser() {
    if (currentUser.value != null) {
      currentUser.value = null;
      Get.snackbar('Sesión cerrada', 'Has cerrado la sesión.');
    }
  }

  // Verificar si hay un usuario autenticado
  bool isLoggedIn() {
    return currentUser.value != null;
  }

  // Obtener los hábitos predeterminados del usuario
  List<Habit> getDefaultHabits() {
    return currentUser.value?.defaultHabits ?? [];
  }

  // Obtener los hábitos del usuario actual
  List<Habit> getCurrentUserHabits() {
    return currentUser.value?.defaultHabits ?? [];
  }

  // Agregar hábitos al usuario actual
  void addHabitToCurrentUser(Habit habit) {
    if (currentUser.value != null) {
      currentUser.value?.defaultHabits ??= [];
      currentUser.value?.defaultHabits.add(habit);
      users[currentUser.value!.username] = currentUser.value!;

      // Imprimir la lista actual de hábitos del usuario
      print(
          "Current user habits after adding: ${currentUser.value?.defaultHabits.map((h) => h.name).toList()}");
    } else {
      print("Error: No current user logged in");
    }
  }
}
