class UserModel {
  final String id;
  final String name;
  final String pin;
  final String role; // 'cashier' or 'manager'
  final bool isActive;

  UserModel({
    required this.id,
    required this.name,
    required this.pin,
    required this.role,
    this.isActive = true,
  });
}