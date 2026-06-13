import 'package:get/get.dart';
import '../models/user_model.dart';
import '../demo/demo_users.dart';

class AuthService extends GetxService {
  final currentUser = Rxn<UserModel>();
  final isLoggedIn = false.obs;

  UserModel? login(String pin) {
    try {
      final user = DemoUsers.users.firstWhere(
            (u) => u.pin == pin && u.isActive,
      );
      currentUser.value = user;
      isLoggedIn.value = true;
      return user;
    } catch (_) {
      return null;
    }
  }

  void logout() {
    currentUser.value = null;
    isLoggedIn.value = false;
  }

  bool get isAdmin => currentUser.value?.role == 'admin';
  bool get isManager => currentUser.value?.role == 'manager' || isAdmin;
  bool get isCashier => currentUser.value?.role == 'cashier';
}