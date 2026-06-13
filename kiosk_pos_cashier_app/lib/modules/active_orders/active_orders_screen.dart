import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme.dart';
import '../../data/demo/demo_orders.dart';
import '../../data/models/order_model.dart';
import '../../utils/formatters.dart';
import '../../app/routes.dart';

class ActiveOrdersScreen extends StatefulWidget {
  const ActiveOrdersScreen({super.key});

  @override
  State<ActiveOrdersScreen> createState() => _ActiveOrdersScreenState();
}

class _ActiveOrdersScreenState extends State<ActiveOrdersScreen> {
  String _selectedFilter = 'All';

  List<OrderModel> get _filteredOrders {
    final orders = DemoOrders.orders;
    if (_selectedFilter == 'All') return orders;
    return orders.where((o) => o.status == _selectedFilter.toLowerCase()).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final filters = ['All', 'Pending', 'Preparing', 'Ready', 'Completed'];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              height: size.height * 0.08,
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))]),
              child: Row(children: [
                GestureDetector(onTap: () => Get.back(), child: Icon(Icons.arrow_back_ios_rounded, size: size.width * 0.045, color: AppColors.textPrimary)),
                SizedBox(width: size.width * 0.03),
                Text('Active Orders', style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              ]),
            ),

            // Filter tabs
            Container(
              height: size.height * 0.06,
              color: Colors.white,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: size.height * 0.01),
                itemCount: filters.length,
                separatorBuilder: (_, __) => SizedBox(width: size.width * 0.02),
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  final isSelected = _selectedFilter == filter;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = filter),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(child: Text(filter, style: TextStyle(fontSize: size.width * 0.03, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : Colors.grey.shade700))),
                    ),
                  );
                },
              ),
            ),

            // Orders list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(size.width * 0.04),
                itemCount: _filteredOrders.length,
                itemBuilder: (context, index) => _buildOrderCard(_filteredOrders[index], size),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order, Size size) {
    final Color statusColor = _getStatusColor(order.status);
    final String timeAgo = _getTimeAgo(order.createdAt);

    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.015),
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Text('#${order.orderNumber}', style: TextStyle(fontSize: size.width * 0.038, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              SizedBox(width: size.width * 0.02),
              Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.025, vertical: size.height * 0.005),
                decoration: BoxDecoration(color: order.source == 'kiosk' ? Colors.purple.shade50 : Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                child: Text(order.source.toUpperCase(), style: TextStyle(fontSize: size.width * 0.02, fontWeight: FontWeight.bold, color: order.source == 'kiosk' ? Colors.purple : Colors.blue)),
              ),
            ]),
            Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: size.height * 0.006),
              decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Text(order.status.toUpperCase(), style: TextStyle(fontSize: size.width * 0.025, fontWeight: FontWeight.bold, color: statusColor)),
            ),
          ]),
          SizedBox(height: size.height * 0.015),

          // Details
          Row(children: [
            Icon(Icons.person_outline_rounded, size: size.width * 0.035, color: Colors.grey.shade500),
            SizedBox(width: size.width * 0.01),
            Text(order.customerName ?? 'Walk-in', style: TextStyle(fontSize: size.width * 0.03, color: Colors.grey.shade700)),
            SizedBox(width: size.width * 0.04),
            if (order.tableNumber != null) ...[
              Icon(Icons.table_restaurant_rounded, size: size.width * 0.035, color: Colors.grey.shade500),
              SizedBox(width: size.width * 0.01),
              Text('Table ${order.tableNumber}', style: TextStyle(fontSize: size.width * 0.03, color: Colors.grey.shade700)),
            ],
            const Spacer(),
            Icon(Icons.access_time_rounded, size: size.width * 0.035, color: Colors.grey.shade500),
            SizedBox(width: size.width * 0.01),
            Text(timeAgo, style: TextStyle(fontSize: size.width * 0.028, color: Colors.grey.shade500)),
          ]),
          SizedBox(height: size.height * 0.012),

          // Total + payment
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(Formatters.currency(order.total), style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.bold, color: AppColors.primary)),
            Row(children: [
              _buildPaymentIcon(order.paymentMethod, size),
              SizedBox(width: size.width * 0.01),
              Text(order.paymentMethod.toUpperCase(), style: TextStyle(fontSize: size.width * 0.025, color: Colors.grey.shade600)),
            ]),
          ]),
          SizedBox(height: size.height * 0.015),

          // Action buttons
          Row(children: [
            if (order.status != 'completed')
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, minimumSize: Size.zero, padding: EdgeInsets.symmetric(vertical: size.height * 0.012), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: Text(_getNextStatus(order.status), style: TextStyle(fontSize: size.width * 0.028, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            SizedBox(width: size.width * 0.02),
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.symmetric(vertical: size.height * 0.012), side: BorderSide(color: Colors.grey.shade300), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: Text('REPRINT', style: TextStyle(fontSize: size.width * 0.028, color: Colors.grey.shade600)),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return AppColors.processing;
      case 'preparing': return AppColors.reading;
      case 'ready': return AppColors.accent;
      case 'completed': return Colors.grey;
      default: return Colors.grey;
    }
  }

  String _getNextStatus(String status) {
    switch (status) {
      case 'pending': return 'START PREPARING';
      case 'preparing': return 'MARK READY';
      case 'ready': return 'COMPLETE';
      default: return '';
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }

  Widget _buildPaymentIcon(String method, Size size) {
    switch (method) {
      case 'cash': return Icon(Icons.money_rounded, size: size.width * 0.04, color: AppColors.accent);
      case 'card': return Icon(Icons.credit_card_rounded, size: size.width * 0.04, color: AppColors.reading);
      case 'member': return Icon(Icons.card_membership_rounded, size: size.width * 0.04, color: const Color(0xFF6C5CE7));
      default: return const SizedBox.shrink();
    }
  }
}