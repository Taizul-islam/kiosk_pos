import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../config/theme.dart';
import '../../app/routes.dart';
import '../../data/services/auth_service.dart';
import '../../utils/formatters.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _revenueFilter = 'Daily';
  String _selectedTab = 'dashboard'; // dashboard, menu, staff, settings

  // Demo data
  final Map<String, List<double>> _revenueData = {
    'Daily': [420, 380, 450, 520, 480, 610, 550],
    'Weekly': [2450, 2680, 2890, 3120],
    'Monthly': [12450, 13890, 14200, 15670, 16200, 18100],
    'Yearly': [145000, 168000, 192000, 210000],
  };

  final Map<String, List<String>> _revenueLabels = {
    'Daily': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    'Weekly': ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
    'Monthly': ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
    'Yearly': ['2023', '2024', '2025', '2026'],
  };

  final List<Map<String, dynamic>> _topItems = [
    {'name': 'Classic Burger', 'sold': 42, 'revenue': 504.00, 'color': const Color(0xFFE74C3C)},
    {'name': 'French Fries', 'sold': 35, 'revenue': 175.00, 'color': const Color(0xFFF39C12)},
    {'name': 'Milkshake', 'sold': 28, 'revenue': 196.00, 'color': const Color(0xFF9B59B6)},
    {'name': 'Bacon Deluxe', 'sold': 22, 'revenue': 352.00, 'color': const Color(0xFFE74C3C)},
    {'name': 'Soda', 'sold': 18, 'revenue': 54.00, 'color': const Color(0xFF3498DB)},
  ];

  final List<Map<String, dynamic>> _peakHours = [
    {'hour': '11 AM', 'orders': 8},
    {'hour': '12 PM', 'orders': 15},
    {'hour': '1 PM', 'orders': 18},
    {'hour': '2 PM', 'orders': 10},
    {'hour': '5 PM', 'orders': 12},
    {'hour': '6 PM', 'orders': 22},
    {'hour': '7 PM', 'orders': 17},
    {'hour': '8 PM', 'orders': 14},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final AuthService authService = Get.find<AuthService>();
    final userName = authService.currentUser.value?.name ?? 'Admin';
    final currentData = _revenueData[_revenueFilter]!;
    final currentLabels = _revenueLabels[_revenueFilter]!;
    final maxRevenue = currentData.reduce((a, b) => a > b ? a : b);
    final totalRevenue = currentData.reduce((a, b) => a + b);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ============ HEADER ============

            Container(
              padding: EdgeInsets.all(size.width * 0.04),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF1A1A2E), Color(0xFF16213E)]),
              ),
              child: Column(children: [
                Row(children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: size.width * 0.08,
                      height: size.width * 0.08,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(Icons.arrow_back_ios_rounded,
                          color: Colors.white, size: size.width * 0.04),
                    ),
                  ),
                  SizedBox(width: size.width * 0.03),
                  Container(
                    width: size.width * 0.1, height: size.width * 0.1,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                    child: Center(child: Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: size.width * 0.055)),
                  ),
                  SizedBox(width: size.width * 0.04),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Welcome back,', style: TextStyle(fontSize: size.width * 0.03, color: Colors.white70)),
                    Text(userName, style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.bold, color: Colors.white)),
                  ]),
                ]),
                SizedBox(height: size.height * 0.02),
                // Quick stats row
                Row(children: [
                  _buildQuickStat(size, 'Today\'s Revenue', Formatters.currency(1245.50), '↑ 12%', AppColors.accent),
                  SizedBox(width: size.width * 0.03),
                  _buildQuickStat(size, 'Orders', '47', '↑ 8%', AppColors.reading),
                  SizedBox(width: size.width * 0.03),
                  _buildQuickStat(size, 'Avg Order', Formatters.currency(26.50), '↑ 3%', const Color(0xFF6C5CE7)),
                ]),
              ]),
            ),

            // ============ SCROLLABLE CONTENT ============
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(size.width * 0.04),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // ============ REVENUE CHART ============
                  Text('Revenue Overview', style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.bold)),
                  SizedBox(height: size.height * 0.015),
                  // Filter tabs
                  Row(children: ['Daily', 'Weekly', 'Monthly', 'Yearly'].map((filter) {
                    final isSelected = _revenueFilter == filter;
                    return GestureDetector(
                      onTap: () => setState(() => _revenueFilter = filter),
                      child: Container(
                        margin: EdgeInsets.only(right: size.width * 0.02),
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: size.height * 0.01),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
                        ),
                        child: Text(filter, style: TextStyle(fontSize: size.width * 0.028, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : Colors.grey.shade600)),
                      ),
                    );
                  }).toList()),
                  SizedBox(height: size.height * 0.02),
                  // Bar chart
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(size.width * 0.04),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: Column(children: [
                      Row(crossAxisAlignment: CrossAxisAlignment.end, children: currentData.asMap().entries.map((entry) {
                        final i = entry.key;
                        final value = entry.value;
                        final height = maxRevenue > 0 ? (value / maxRevenue * size.height * 0.15) : 0.0;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                            child: Column(children: [
                              Text(Formatters.currency(value).replaceAll('\$', ''), style: TextStyle(fontSize: size.width * 0.02, fontWeight: FontWeight.bold, color: AppColors.primary)),
                              SizedBox(height: size.height * 0.005),
                              Container(
                                height: height.clamp(20.0, size.height * 0.15),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [AppColors.primary, AppColors.primary.withOpacity(0.3)]),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              SizedBox(height: size.height * 0.005),
                              Text(currentLabels[i], style: TextStyle(fontSize: size.width * 0.022, color: Colors.grey.shade600)),
                            ]),
                          ),
                        );
                      }).toList()),
                      SizedBox(height: size.height * 0.015),
                      Text('Total: ${Formatters.currency(totalRevenue)}', style: TextStyle(fontSize: size.width * 0.032, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    ]),
                  ),
                  SizedBox(height: size.height * 0.03),

                  // ============ TOP SELLING ITEMS ============
                  Text('Top Selling Items', style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.bold)),
                  SizedBox(height: size.height * 0.015),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(size.width * 0.04),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: _topItems.asMap().entries.map((entry) {
                        final i = entry.key;
                        final item = entry.value;
                        final maxSold = _topItems.first['sold'] as int;
                        final barWidth = (item['sold'] as int) / maxSold;
                        return Padding(
                          padding: EdgeInsets.only(bottom: size.height * 0.012),
                          child: Row(children: [
                            Container(
                              width: size.width * 0.06, height: size.width * 0.06,
                              decoration: BoxDecoration(color: (item['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                              child: Center(child: Text('${i + 1}', style: TextStyle(fontSize: size.width * 0.03, fontWeight: FontWeight.bold, color: item['color'] as Color))),
                            ),
                            SizedBox(width: size.width * 0.03),
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(item['name'] as String, style: TextStyle(fontSize: size.width * 0.03, fontWeight: FontWeight.w600)),
                                SizedBox(height: size.height * 0.005),
                                Container(
                                  height: size.height * 0.015,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(children: [
                                    Flexible(
                                      flex: (barWidth * 100).toInt(),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [item['color'] as Color, (item['color'] as Color).withOpacity(0.5)]),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: ((1 - barWidth) * 100).toInt(),
                                      child: Container(color: Colors.grey.shade100),
                                    ),
                                  ]),
                                ),
                              ]),
                            ),
                            SizedBox(width: size.width * 0.03),
                            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                              Text('${item['sold']} sold', style: TextStyle(fontSize: size.width * 0.026, fontWeight: FontWeight.bold)),
                              Text(Formatters.currency((item['revenue'] as double)), style: TextStyle(fontSize: size.width * 0.024, color: AppColors.primary)),
                            ]),
                          ]),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),

                  // ============ PEAK HOURS + PAYMENT ============
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // Peak hours
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Peak Hours', style: TextStyle(fontSize: size.width * 0.035, fontWeight: FontWeight.bold)),
                        SizedBox(height: size.height * 0.015),
                        Container(
                          padding: EdgeInsets.all(size.width * 0.03),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            children: _peakHours.map((hour) {
                              final maxOrders = _peakHours.map((h) => h['orders'] as int).reduce((a, b) => a > b ? a : b);
                              final barW = (hour['orders'] as int) / maxOrders;
                              return Padding(
                                padding: EdgeInsets.only(bottom: size.height * 0.008),
                                child: Row(children: [
                                  SizedBox(width: size.width * 0.12, child: Text(hour['hour'] as String, style: TextStyle(fontSize: size.width * 0.024, color: Colors.grey.shade600))),
                                  Expanded(
                                    child: Container(
                                      height: size.height * 0.02,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [AppColors.primary, AppColors.primary.withOpacity(0.4)]),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      margin: EdgeInsets.only(right: (1 - barW) * size.width * 0.3),
                                    ),
                                  ),
                                  SizedBox(width: size.width * 0.02),
                                  Text('${hour['orders']}', style: TextStyle(fontSize: size.width * 0.024, fontWeight: FontWeight.bold)),
                                ]),
                              );
                            }).toList(),
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(width: size.width * 0.03),
                    // Payment breakdown
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Payments', style: TextStyle(fontSize: size.width * 0.035, fontWeight: FontWeight.bold)),
                        SizedBox(height: size.height * 0.015),
                        Container(
                          padding: EdgeInsets.all(size.width * 0.03),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                          child: Column(children: [
                            _buildPaymentRow(size, 'Card', 689.50, 55, AppColors.reading),
                            SizedBox(height: size.height * 0.012),
                            _buildPaymentRow(size, 'Cash', 456.00, 37, AppColors.accent),
                            SizedBox(height: size.height * 0.012),
                            _buildPaymentRow(size, 'Member', 100.00, 8, const Color(0xFF6C5CE7)),
                          ]),
                        ),
                      ]),
                    ),
                  ]),
                  SizedBox(height: size.height * 0.03),

                  // ============ QUICK ACTIONS ============
                  Text('Quick Actions', style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.bold)),
                  SizedBox(height: size.height * 0.015),
                  Row(children: [
                    _buildQuickAction(size, Icons.add_circle_rounded, 'New Order', AppColors.primary, () => Get.toNamed(AppRoutes.newOrder)),
                    SizedBox(width: size.width * 0.03),
                    _buildQuickAction(size, Icons.list_alt_rounded, 'Orders', AppColors.reading, () => Get.toNamed(AppRoutes.activeOrders)),
                    SizedBox(width: size.width * 0.03),
                    _buildQuickAction(size, Icons.restaurant_menu_rounded, 'Menu', const Color(0xFFE74C3C), () => Get.toNamed(AppRoutes.menuManagement)),
                    SizedBox(width: size.width * 0.03),
                    _buildQuickAction(size, Icons.settings_rounded, 'Settings', Colors.grey.shade700, () => Get.toNamed(AppRoutes.settings)),
                  ]),
                  SizedBox(height: size.height * 0.04),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(Size size, String label, String value, String change, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(size.width * 0.03),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: size.width * 0.022, color: Colors.white70)),
          SizedBox(height: size.height * 0.005),
          Text(value, style: TextStyle(fontSize: size.width * 0.035, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: size.height * 0.003),
          Text(change, style: TextStyle(fontSize: size.width * 0.022, color: color, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  Widget _buildPaymentRow(Size size, String label, double amount, int percent, Color color) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(fontSize: size.width * 0.028, fontWeight: FontWeight.w500)),
        Text('$percent%', style: TextStyle(fontSize: size.width * 0.026, fontWeight: FontWeight.bold, color: color)),
      ]),
      SizedBox(height: size.height * 0.005),
      Container(
        height: size.height * 0.015,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
        child: Row(children: [
          Flexible(flex: percent, child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)))),
          Flexible(flex: 100 - percent, child: Container(color: Colors.grey.shade100)),
        ]),
      ),
      SizedBox(height: size.height * 0.003),
      Text(Formatters.currency(amount), style: TextStyle(fontSize: size.width * 0.024, fontWeight: FontWeight.bold, color: color)),
    ]);
  }

  Widget _buildQuickAction(Size size, IconData icon, String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 6)]),
          child: Column(children: [
            Icon(icon, size: size.width * 0.06, color: color),
            SizedBox(height: size.height * 0.01),
            Text(label, style: TextStyle(fontSize: size.width * 0.026, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ]),
        ),
      ),
    );
  }
}