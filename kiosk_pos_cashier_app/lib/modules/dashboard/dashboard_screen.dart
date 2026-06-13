import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme.dart';
import '../../app/routes.dart';
import '../../data/services/auth_service.dart';
import '../../utils/formatters.dart';
import 'admin_dashboard_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();
    final role = authService.currentUser.value?.role ?? 'cashier';
    final isAdmin = role == 'admin';

    // Everyone uses the same button dashboard
    // Admin gets an extra banner at the top
    return _ButtonDashboard(isAdmin: isAdmin);
  }
}

// ============ BUTTON-BASED DASHBOARD (All Roles) ============
class _ButtonDashboard extends StatelessWidget {
  final bool isAdmin;
  const _ButtonDashboard({required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final AuthService authService = Get.find<AuthService>();
    final user = authService.currentUser.value;
    final userName = user?.name ?? 'Staff';
    final role = user?.role ?? 'cashier';
    final isManager = role == 'manager' || isAdmin;
    final isCashier = role == 'cashier';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ============ HEADER ============
            Container(
              padding: EdgeInsets.all(size.width * 0.05),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2))
                ],
              ),
              child: Row(children: [
                Container(
                  width: size.width * 0.1,
                  height: size.width * 0.1,
                  decoration: BoxDecoration(
                    color: _getRoleColor(role),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                      child: Icon(
                        _getRoleIcon(role),
                        color: Colors.white,
                        size: size.width * 0.055,
                      )),
                ),
                SizedBox(width: size.width * 0.04),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('BURGER HOUSE',
                        style: TextStyle(
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.bold)),
                    Row(children: [
                      Text(userName,
                          style: TextStyle(
                              fontSize: size.width * 0.03,
                              color: Colors.grey.shade500)),
                      SizedBox(width: size.width * 0.02),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.025,
                            vertical: size.height * 0.004),
                        decoration: BoxDecoration(
                            color: _getRoleColor(role).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(role.toUpperCase(),
                            style: TextStyle(
                                fontSize: size.width * 0.022,
                                fontWeight: FontWeight.bold,
                                color: _getRoleColor(role))),
                      ),
                    ]),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    authService.logout();
                    Get.offAllNamed(AppRoutes.login);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                        vertical: size.height * 0.012),
                    decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text('LOGOUT',
                        style: TextStyle(
                            fontSize: size.width * 0.028,
                            color: AppColors.error,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ]),
            ),
            SizedBox(height: size.height * 0.03),

            // ============ DASHBOARD CONTENT ============
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Column(
                  children: [
                    // ============ ADMIN BANNER (Admin only) ============
                    if (isAdmin) ...[
                      GestureDetector(
                        onTap: () => Get.to(() => const AdminDashboardScreen()),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(size.width * 0.04),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xFF1A1A2E).withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4))
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Container(
                                  width: size.width * 0.08,
                                  height: size.width * 0.08,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Icon(Icons.dashboard_rounded,
                                      color: Colors.white, size: size.width * 0.045),
                                ),
                                SizedBox(width: size.width * 0.04),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('ADMIN PANEL',
                                          style: TextStyle(
                                              fontSize: size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              letterSpacing: 1)),
                                      SizedBox(height: size.height * 0.004),
                                      Text('View analytics & business insights',
                                          style: TextStyle(
                                              fontSize: size.width * 0.026,
                                              color: Colors.white70)),
                                    ],
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded,
                                    color: Colors.white.withOpacity(0.7),
                                    size: size.width * 0.04),
                              ]),
                              SizedBox(height: size.height * 0.02),
                              // Quick stats in banner
                              Row(children: [
                                _buildMiniStat(size, 'Revenue', '\$1,245', AppColors.accent),
                                SizedBox(width: size.width * 0.03),
                                _buildMiniStat(size, 'Orders', '47', AppColors.reading),
                                SizedBox(width: size.width * 0.03),
                                _buildMiniStat(size, 'Avg', '\$26.50', const Color(0xFF6C5CE7)),
                              ]),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.025),
                    ],

                    // ============ SHARED BUTTONS (All roles) ============
                    _buildButton(
                      size: size,
                      icon: Icons.add_circle_rounded,
                      title: 'NEW ORDER',
                      subtitle: 'Create a new order for a customer',
                      color: AppColors.primary,
                      onTap: () => Get.toNamed(AppRoutes.newOrder),
                    ),
                    SizedBox(height: size.height * 0.02),
                    _buildButton(
                      size: size,
                      icon: Icons.list_alt_rounded,
                      title: 'ACTIVE ORDERS',
                      subtitle: 'View and manage current orders',
                      color: AppColors.reading,
                      onTap: () => Get.toNamed(AppRoutes.activeOrders),
                    ),

                    // ============ MANAGER + ADMIN ============
                    if (isManager) ...[
                      SizedBox(height: size.height * 0.02),
                      _buildButton(
                        size: size,
                        icon: Icons.bar_chart_rounded,
                        title: 'REPORTS',
                        subtitle: 'Daily sales, revenue & summaries',
                        color: AppColors.accent,
                        onTap: () => Get.toNamed(AppRoutes.reports),
                      ),
                      SizedBox(height: size.height * 0.02),
                      _buildButton(
                        size: size,
                        icon: Icons.restaurant_menu_rounded,
                        title: 'MENU MANAGEMENT',
                        subtitle: 'Edit categories, products & prices',
                        color: const Color(0xFFE74C3C),
                        onTap: () => Get.toNamed(AppRoutes.menuManagement),
                      ),
                      SizedBox(height: size.height * 0.02),
                      _buildButton(
                        size: size,
                        icon: Icons.people_rounded,
                        title: 'STAFF MANAGEMENT',
                        subtitle: isAdmin
                            ? 'Manage managers & cashiers'
                            : 'Manage cashiers',
                        color: const Color(0xFFF39C12),
                        onTap: () => Get.toNamed(AppRoutes.staffManagement),
                      ),
                      SizedBox(height: size.height * 0.02),
                      _buildButton(
                        size: size,
                        icon: Icons.card_membership_rounded,
                        title: 'CARD MANAGEMENT',
                        subtitle: 'Issue, top up & manage loyalty cards',
                        color: const Color(0xFF9B59B6),
                        onTap: () => Get.toNamed(AppRoutes.cardIssuance),
                      ),
                      SizedBox(height: size.height * 0.02),
                      _buildButton(
                        size: size,
                        icon: Icons.inventory_2_rounded,
                        title: 'INVENTORY',
                        subtitle: 'Stock levels, suppliers & purchase orders',
                        color: const Color(0xFF00BCD4),
                        onTap: () => Get.toNamed(AppRoutes.inventory),
                      ),
                      SizedBox(height: size.height * 0.02),
                      _buildButton(
                        size: size,
                        icon: Icons.settings_rounded,
                        title: 'SETTINGS',
                        subtitle: 'Store info, printers & tax configuration',
                        color: Colors.grey.shade700,
                        onTap: () => Get.toNamed(AppRoutes.settings),
                      ),
                    ],

                    SizedBox(height: size.height * 0.04),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(Size size, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: size.height * 0.012, horizontal: size.width * 0.02),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8)),
        child: Column(children: [
          Text(value,
              style: TextStyle(
                  fontSize: size.width * 0.035,
                  fontWeight: FontWeight.bold,
                  color: color)),
          Text(label,
              style: TextStyle(
                  fontSize: size.width * 0.022, color: Colors.white60)),
        ]),
      ),
    );
  }

  Widget _buildButton({
    required Size size,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            vertical: size.height * 0.022, horizontal: size.width * 0.05),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 3))
          ],
        ),
        child: Row(children: [
          Container(
            width: size.width * 0.13,
            height: size.width * 0.13,
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, size: size.width * 0.065, color: color),
          ),
          SizedBox(width: size.width * 0.05),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: size.width * 0.036,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary)),
                  SizedBox(height: size.height * 0.004),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: size.width * 0.028,
                          color: Colors.grey.shade500)),
                ]),
          ),
          Icon(Icons.arrow_forward_ios_rounded,
              size: size.width * 0.04, color: Colors.grey.shade400),
        ]),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return const Color(0xFFE74C3C);
      case 'manager':
        return const Color(0xFF6C5CE7);
      case 'cashier':
        return AppColors.primary;
      default:
        return AppColors.primary;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'admin':
        return Icons.admin_panel_settings_rounded;
      case 'manager':
        return Icons.manage_accounts_rounded;
      case 'cashier':
        return Icons.point_of_sale_rounded;
      default:
        return Icons.store_rounded;
    }
  }
}