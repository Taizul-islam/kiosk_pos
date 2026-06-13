import '../models/user_model.dart';

class DemoUsers {
  static List<UserModel> get users => [
    // ADMIN
    UserModel(id: '0', name: 'Admin', pin: '1234', role: 'admin'),

    // MANAGERS
    UserModel(id: '1', name: 'Sarah (Manager)', pin: '0000', role: 'manager'),
    UserModel(id: '4', name: 'Mike (Manager)', pin: '4444', role: 'manager'),

    // CASHIERS
    UserModel(id: '2', name: 'John (Cashier)', pin: '1111', role: 'cashier'),
    UserModel(id: '3', name: 'Lisa (Cashier)', pin: '2222', role: 'cashier'),
  ];
}