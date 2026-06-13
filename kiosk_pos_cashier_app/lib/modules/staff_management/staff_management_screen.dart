import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme.dart';
import '../../data/services/auth_service.dart';
import '../../data/demo/demo_users.dart';
import '../../data/models/user_model.dart';

class StaffManagementScreen extends StatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  State<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  late List<UserModel> _users;
  final AuthService _authService = Get.find<AuthService>();

  // Get current user's role
  String get _myRole => _authService.currentUser.value?.role ?? 'cashier';
  String get _myId => _authService.currentUser.value?.id ?? '';

  // Who I can manage
  bool get _isSuperAdmin => _myRole == 'admin';
  bool get _isAdmin => _myRole == 'admin' || _myRole == 'manager'; // admin IS super admin here
  bool get _isManager => _myRole == 'manager';

  @override
  void initState() {
    super.initState();
    _users = List.from(DemoUsers.users);

    // If cashier tries to access, redirect
    if (_myRole == 'cashier') {
      Future.delayed(Duration.zero, () {
        Get.back();
        Get.snackbar('Access Denied', 'Only managers and admins can manage staff',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.error,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 12);
      });
    }
  }

  // Get available roles I can assign
  List<Map<String, dynamic>> get _availableRoles {
    if (_isSuperAdmin) {
      return [
        {'role': 'admin', 'label': 'Admin', 'color': const Color(0xFFE74C3C), 'icon': Icons.admin_panel_settings_rounded},
        {'role': 'manager', 'label': 'Manager', 'color': const Color(0xFF6C5CE7), 'icon': Icons.manage_accounts_rounded},
        {'role': 'cashier', 'label': 'Cashier', 'color': AppColors.primary, 'icon': Icons.point_of_sale_rounded},
      ];
    } else if (_isManager) {
      return [
        {'role': 'cashier', 'label': 'Cashier', 'color': AppColors.primary, 'icon': Icons.point_of_sale_rounded},
      ];
    }
    return [];
  }

  // Check if I can manage this user
  bool _canManage(UserModel user) {
    if (_isSuperAdmin) return user.id != _myId; // Can't edit/delete self
    if (_isManager) {
      // Manager can only manage cashiers and staff
      return user.role == 'cashier' || user.role == 'staff';
    }
    return false;
  }

  // Get role display info
  Map<String, dynamic> _getRoleInfo(String role) {
    switch (role) {
      case 'admin':
        return {'color': const Color(0xFFE74C3C), 'icon': Icons.admin_panel_settings_rounded, 'label': 'ADMIN'};
      case 'manager':
        return {'color': const Color(0xFF6C5CE7), 'icon': Icons.manage_accounts_rounded, 'label': 'MANAGER'};
      case 'cashier':
        return {'color': AppColors.primary, 'icon': Icons.point_of_sale_rounded, 'label': 'CASHIER'};
      default:
        return {'color': Colors.grey, 'icon': Icons.person_outline_rounded, 'label': role.toUpperCase()};
    }
  }

  // ==================== ADD STAFF ====================
  void _addStaff() {
    final nameController = TextEditingController();
    final pinController = TextEditingController();
    String selectedRole = _availableRoles.first['role'];

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
            maxWidth: MediaQuery.of(context).size.width * 0.85,
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title (fixed)
                Row(children: [
                  Icon(Icons.person_add_rounded, color: AppColors.primary, size: 22),
                  SizedBox(width: 8),
                  Text('Add New Staff',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ]),
                SizedBox(height: 4),
                Text('You can add: ${_availableRoles.map((r) => r['label']).join(', ')}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                SizedBox(height: 12),

                // Scrollable content
                Flexible(
                  child: SingleChildScrollView(
                    child: StatefulBuilder(
                      builder: (context, setDialogState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                  labelText: 'Full Name',
                                  prefixIcon: Icon(Icons.person_outline, size: 20),
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12)),
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: pinController,
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              decoration: const InputDecoration(
                                  labelText: 'PIN (4 digits)',
                                  prefixIcon: Icon(Icons.lock_outline, size: 20),
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12)),
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 8),
                            Text('Role', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
                            SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: _availableRoles.map((roleData) {
                                final isSelected = selectedRole == roleData['role'];
                                final color = roleData['color'] as Color;
                                return GestureDetector(
                                  onTap: () => setDialogState(() => selectedRole = roleData['role']),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected ? color : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: isSelected ? color : Colors.grey.shade300,
                                          width: isSelected ? 2 : 1),
                                    ),
                                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                                      Icon(roleData['icon'] as IconData, size: 16, color: isSelected ? Colors.white : color),
                                      SizedBox(width: 5),
                                      Text(roleData['label'] as String,
                                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : color)),
                                    ]),
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (nameController.text.isNotEmpty && pinController.text.length == 4) {
                                    setState(() {
                                      _users.add(UserModel(
                                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                                        name: nameController.text,
                                        pin: pinController.text,
                                        role: selectedRole,
                                      ));
                                    });
                                    Get.back();
                                    Get.snackbar('✅ Added!', '${nameController.text} has been added as ${selectedRole.toUpperCase()}',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: AppColors.accent,
                                        colorText: Colors.white,
                                        margin: const EdgeInsets.all(16),
                                        borderRadius: 12);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.symmetric(vertical: 12)),
                                child: Text('ADD STAFF',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==================== EDIT STAFF ====================
  void _editStaff(UserModel user) {
    final nameController = TextEditingController(text: user.name);
    final pinController = TextEditingController(text: user.pin);
    String selectedRole = user.role;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
            maxWidth: MediaQuery.of(context).size.width * 0.85,
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title (fixed)
                Row(children: [
                  Icon(Icons.edit_rounded, color: Colors.blue.shade700, size: 22),
                  SizedBox(width: 8),
                  Text('Edit ${user.name}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ]),
                SizedBox(height: 12),

                // Scrollable content
                Flexible(
                  child: SingleChildScrollView(
                    child: StatefulBuilder(
                      builder: (context, setDialogState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                  labelText: 'Name',
                                  prefixIcon: Icon(Icons.person_outline, size: 20),
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12)),
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: pinController,
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              decoration: const InputDecoration(
                                  labelText: 'PIN (4 digits)',
                                  prefixIcon: Icon(Icons.lock_outline, size: 20),
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12)),
                              style: TextStyle(fontSize: 15),
                            ),
                            if (_isSuperAdmin || (_isManager && user.role != 'manager')) ...[
                              SizedBox(height: 8),
                              Text('Role', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
                              SizedBox(height: 6),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: _availableRoles.map((roleData) {
                                  final isSelected = selectedRole == roleData['role'];
                                  final color = roleData['color'] as Color;
                                  return GestureDetector(
                                    onTap: () => setDialogState(() => selectedRole = roleData['role']),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isSelected ? color : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: isSelected ? color : Colors.grey.shade300,
                                            width: isSelected ? 2 : 1),
                                      ),
                                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                                        Icon(roleData['icon'] as IconData, size: 16, color: isSelected ? Colors.white : color),
                                        SizedBox(width: 5),
                                        Text(roleData['label'] as String,
                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : color)),
                                      ]),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                            SizedBox(height: 16),
                            Row(children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Get.back(),
                                  style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      padding: EdgeInsets.symmetric(vertical: 12)),
                                  child: Text('CANCEL', style: TextStyle(fontSize: 13)),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (nameController.text.isNotEmpty && pinController.text.length == 4) {
                                      setState(() {
                                        final index = _users.indexWhere((u) => u.id == user.id);
                                        if (index != -1) {
                                          _users[index] = UserModel(
                                            id: user.id,
                                            name: nameController.text,
                                            pin: pinController.text,
                                            role: selectedRole,
                                          );
                                        }
                                      });
                                      Get.back();
                                      Get.snackbar('✅ Updated!', '${nameController.text} has been updated',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: AppColors.accent,
                                          colorText: Colors.white,
                                          margin: const EdgeInsets.all(16),
                                          borderRadius: 12);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      padding: EdgeInsets.symmetric(vertical: 12)),
                                  child: Text('SAVE', style: TextStyle(fontSize: 13, color: Colors.white)),
                                ),
                              ),
                            ]),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==================== DELETE STAFF ====================
  void _deleteStaff(UserModel user) {
    final roleInfo = _getRoleInfo(user.role);
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 28),
          SizedBox(width: 8),
          Text('Delete ${user.name}?'),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('This action cannot be undone.'),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                Icon(roleInfo['icon'] as IconData, color: roleInfo['color'] as Color, size: 20),
                SizedBox(width: 8),
                Text('${user.name} (${roleInfo['label']})',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ]),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('CANCEL')),
          ElevatedButton(
            onPressed: () {
              setState(() => _users.removeWhere((u) => u.id == user.id));
              Get.back();
              Get.snackbar('🗑️ Deleted', '${user.name} has been removed',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.error,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text('DELETE', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // If cashier, show nothing (already redirected)
    if (_myRole == 'cashier') {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.lock_outline, size: size.width * 0.2, color: Colors.grey.shade300),
              SizedBox(height: size.height * 0.02),
              Text('Access Denied', style: TextStyle(fontSize: size.width * 0.05, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
              SizedBox(height: size.height * 0.01),
              Text('Only managers and admins can access this section',
                  style: TextStyle(fontSize: size.width * 0.03, color: Colors.grey.shade400)),
              SizedBox(height: size.height * 0.03),
              ElevatedButton(onPressed: () => Get.back(), child: Text('GO BACK')),
            ]),
          ),
        ),
      );
    }

    final adminCount = _users.where((u) => u.role == 'admin').length;
    final managerCount = _users.where((u) => u.role == 'manager').length;
    final cashierCount = _users.where((u) => u.role == 'cashier').length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              height: size.height * 0.08,
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))
              ]),
              child: Row(children: [
                GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back_ios_rounded, size: size.width * 0.045, color: AppColors.textPrimary)),
                SizedBox(width: size.width * 0.03),
                Text('Staff Management',
                    style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.bold)),
                const Spacer(),
                GestureDetector(
                  onTap: _addStaff,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: size.height * 0.012),
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(25)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.add_rounded, color: Colors.white, size: size.width * 0.04),
                      SizedBox(width: size.width * 0.01),
                      Text('Add', style: TextStyle(color: Colors.white, fontSize: size.width * 0.03, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ),
              ]),
            ),

            // Summary cards
            Container(
              padding: EdgeInsets.all(size.width * 0.04),
              child: Row(children: [
                if (_isSuperAdmin)
                  _buildSummaryChip(size, 'Admin', adminCount, const Color(0xFFE74C3C)),
                if (_isSuperAdmin || _isManager)
                  _buildSummaryChip(size, 'Manager', managerCount, const Color(0xFF6C5CE7)),
                _buildSummaryChip(size, 'Cashier', cashierCount, AppColors.primary),
              ].expand((w) => [w, SizedBox(width: size.width * 0.02)]).toList()..removeLast()),
            ),

            // Staff list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  final roleInfo = _getRoleInfo(user.role);
                  final isMe = user.id == _myId;
                  final canManage = _canManage(user);

                  return Container(
                    margin: EdgeInsets.only(bottom: size.height * 0.01),
                    padding: EdgeInsets.all(size.width * 0.035),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: isMe ? Border.all(color: AppColors.accent, width: 1.5) : null,
                    ),
                    child: Row(children: [
                      // Role icon
                      Container(
                        width: size.width * 0.12,
                        height: size.width * 0.12,
                        decoration: BoxDecoration(
                          color: (roleInfo['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Icon(
                            roleInfo['icon'] as IconData,
                            size: size.width * 0.055,
                            color: roleInfo['color'] as Color,
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.04),
                      // Info
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Text(user.name,
                                style: TextStyle(fontSize: size.width * 0.035, fontWeight: FontWeight.bold)),
                            if (isMe) ...[
                              SizedBox(width: size.width * 0.02),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: size.width * 0.02, vertical: size.height * 0.003),
                                decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                                child: Text('YOU', style: TextStyle(fontSize: size.width * 0.02, fontWeight: FontWeight.bold, color: AppColors.accent)),
                              ),
                            ],
                          ]),
                          SizedBox(height: size.height * 0.004),
                          Row(children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: size.width * 0.02, vertical: size.height * 0.003),
                              decoration: BoxDecoration(
                                color: (roleInfo['color'] as Color).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(roleInfo['label'] as String,
                                  style: TextStyle(
                                      fontSize: size.width * 0.022,
                                      fontWeight: FontWeight.bold,
                                      color: roleInfo['color'] as Color)),
                            ),
                            SizedBox(width: size.width * 0.03),
                            Text('PIN: ${user.pin}',
                                style: TextStyle(fontSize: size.width * 0.026, color: Colors.grey.shade500, fontFamily: 'monospace')),
                          ]),
                        ]),
                      ),
                      // Actions (only if can manage)
                      if (canManage) ...[
                        GestureDetector(
                          onTap: () => _editStaff(user),
                          child: Container(
                            padding: EdgeInsets.all(size.width * 0.022),
                            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                            child: Icon(Icons.edit_rounded, size: size.width * 0.038, color: Colors.blue.shade700),
                          ),
                        ),
                        SizedBox(width: size.width * 0.015),
                        GestureDetector(
                          onTap: () => _deleteStaff(user),
                          child: Container(
                            padding: EdgeInsets.all(size.width * 0.022),
                            decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                            child: Icon(Icons.delete_outline_rounded, size: size.width * 0.038, color: AppColors.error),
                          ),
                        ),
                      ],
                      // If can't manage, show lock
                      if (!canManage && !isMe)
                        Icon(Icons.lock_outline, size: size.width * 0.04, color: Colors.grey.shade300),
                    ]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryChip(Size size, String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.012),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(children: [
          Text('$count', style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: size.width * 0.024, color: Colors.grey.shade600)),
        ]),
      ),
    );
  }
}