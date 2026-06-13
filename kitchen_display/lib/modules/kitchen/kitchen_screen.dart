import 'dart:async';
import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../data/demo/demo_orders.dart';
import '../../data/models/order_model.dart';
import '../../utils/formatters.dart';

class KitchenScreen extends StatefulWidget {
  const KitchenScreen({super.key});

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  late List<OrderModel> _orders;
  Timer? _refreshTimer;
  int _tick = 0;
  String _lastSoundOrder = '';

  @override
  void initState() {
    super.initState();
    _orders = List.from(DemoOrders.orders.where((o) => o.status != 'completed'));

    // Simulate real-time updates + new orders
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _tick++);

      // Simulate new order arriving every ~15 seconds
      if (_tick % 15 == 0 && _tick > 0) {
        _simulateNewOrder();
      }
    });
  }

  void _simulateNewOrder() {
    final newOrder = OrderModel(
      orderNumber: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      customerName: ['Mike', 'Sarah', 'Tom', null][DateTime.now().second % 4],
      tableNumber: DateTime.now().second % 2 == 0 ? '${DateTime.now().second % 10}' : null,
      orderType: DateTime.now().second % 3 == 0 ? 'take_away' : 'dine_in',
      items: [
        {'name': ['Classic Burger', 'Bacon Deluxe', 'French Fries', 'Milkshake'][DateTime.now().second % 4], 'qty': 1, 'modifiers': 'Regular'},
      ],
      subtotal: 15.00,
      tax: 2.25,
      total: 17.25,
      paymentMethod: 'card',
      status: 'pending',
      source: DateTime.now().second % 2 == 0 ? 'kiosk' : 'cashier',
      createdAt: DateTime.now(),
    );

    setState(() {
      _orders.insert(0, newOrder);
      _lastSoundOrder = newOrder.orderNumber;
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  List<OrderModel> get _newOrders => _orders.where((o) => o.status == 'pending').toList();
  List<OrderModel> get _preparingOrders => _orders.where((o) => o.status == 'preparing').toList();
  List<OrderModel> get _readyOrders => _orders.where((o) => o.status == 'ready').toList();

  void _updateStatus(OrderModel order, String newStatus) {
    setState(() {
      final index = _orders.indexWhere((o) => o.orderNumber == order.orderNumber);
      if (index != -1) {
        final updated = _createUpdatedOrder(_orders[index], newStatus);
        if (newStatus == 'completed') {
          // Remove after 3 seconds
          _orders[index] = updated;
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() => _orders.removeWhere((o) => o.orderNumber == order.orderNumber));
            }
          });
        } else {
          _orders[index] = updated;
        }
      }
    });
  }

  OrderModel _createUpdatedOrder(OrderModel order, String newStatus) {
    return OrderModel(
      orderNumber: order.orderNumber,
      customerName: order.customerName,
      tableNumber: order.tableNumber,
      orderType: order.orderType,
      items: order.items,
      subtotal: order.subtotal,
      tax: order.tax,
      total: order.total,
      paymentMethod: order.paymentMethod,
      status: newStatus,
      source: order.source,
      createdAt: order.createdAt,
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    return '${diff.inHours}h';
  }

  bool _isUrgent(OrderModel order) {
    if (order.status != 'pending') return false;
    return DateTime.now().difference(order.createdAt).inMinutes > 3;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: SafeArea(
        child: Column(
          children: [
            // ============ HEADER ============
            Container(
              height: size.height * 0.08,
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 8, offset: const Offset(0, 2))
                ],
              ),
              child: Row(children: [
                // Logo
                Container(
                  width: size.height * 0.05,
                  height: size.height * 0.05,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.restaurant_rounded, color: Colors.white, size: size.height * 0.03),
                ),
                SizedBox(width: size.width * 0.02),
                Text('KITCHEN DISPLAY',
                    style: TextStyle(
                        fontSize: size.width * 0.025,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 3)),
                const Spacer(),
                // Active count
                Container(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.025, vertical: size.height * 0.008),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      width: size.height * 0.015,
                      height: size.height * 0.015,
                      decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                    ),
                    SizedBox(width: size.width * 0.01),
                    Text('${_newOrders.length + _preparingOrders.length} ACTIVE',
                        style: TextStyle(fontSize: size.width * 0.018, fontWeight: FontWeight.bold, color: Colors.white)),
                  ]),
                ),
                SizedBox(width: size.width * 0.02),
                // Clock
                Text(
                  '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: size.width * 0.025, fontWeight: FontWeight.bold, color: Colors.white54, fontFamily: 'monospace'),
                ),
              ]),
            ),

            // ============ ORDER COLUMNS ============
            Expanded(
              child: Row(
                children: [
                  // NEW
                  _buildColumn(
                    size: size,
                    title: 'NEW',
                    orders: _newOrders,
                    headerColor: AppColors.error,
                    cardColor: const Color(0xFF2D1A1A),
                    icon: Icons.fiber_new_rounded,
                    emptyIcon: Icons.inbox_rounded,
                    showTimer: true,
                    primaryAction: (order) => _updateStatus(order, 'preparing'),
                    primaryLabel: 'START',
                    primaryColor: AppColors.processing,
                  ),
                  _buildColumnDivider(),
                  // PREPARING
                  _buildColumn(
                    size: size,
                    title: 'PREPARING',
                    orders: _preparingOrders,
                    headerColor: AppColors.processing,
                    cardColor: const Color(0xFF2D251A),
                    icon: Icons.cookie_rounded,
                    emptyIcon: Icons.restaurant_rounded,
                    showTimer: true,
                    primaryAction: (order) => _updateStatus(order, 'ready'),
                    primaryLabel: 'READY',
                    primaryColor: AppColors.accent,
                  ),
                  _buildColumnDivider(),
                  // READY
                  _buildColumn(
                    size: size,
                    title: 'READY',
                    orders: _readyOrders,
                    headerColor: AppColors.accent,
                    cardColor: const Color(0xFF1A2D21),
                    icon: Icons.check_circle_rounded,
                    emptyIcon: Icons.done_all_rounded,
                    showTimer: false,
                    primaryAction: (order) => _updateStatus(order, 'completed'),
                    primaryLabel: 'PICKED UP',
                    primaryColor: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumnDivider() {
    return Container(width: 2, color: Colors.white.withOpacity(0.03));
  }

  Widget _buildColumn({
    required Size size,
    required String title,
    required List<OrderModel> orders,
    required Color headerColor,
    required Color cardColor,
    required IconData icon,
    required IconData emptyIcon,
    required bool showTimer,
    required Function(OrderModel) primaryAction,
    required String primaryLabel,
    required Color primaryColor,
  }) {
    return Expanded(
      child: Column(children: [
        // Column header
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: size.height * 0.012),
          decoration: BoxDecoration(
            color: headerColor.withOpacity(0.1),
            border: Border(bottom: BorderSide(color: headerColor.withOpacity(0.3), width: 2)),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, color: headerColor, size: size.width * 0.025),
            SizedBox(width: size.width * 0.01),
            Text(title,
                style: TextStyle(fontSize: size.width * 0.02, fontWeight: FontWeight.bold, color: headerColor, letterSpacing: 2)),
            SizedBox(width: size.width * 0.015),
            Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.015, vertical: size.height * 0.003),
              decoration: BoxDecoration(color: headerColor, borderRadius: BorderRadius.circular(10)),
              child: Text('${orders.length}',
                  style: TextStyle(fontSize: size.width * 0.018, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ]),
        ),

        // Orders
        Expanded(
          child: orders.isEmpty
              ? Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(emptyIcon, size: size.width * 0.06, color: Colors.white.withOpacity(0.06)),
              SizedBox(height: size.height * 0.01),
              Text('No orders',
                  style: TextStyle(fontSize: size.width * 0.018, color: Colors.white.withOpacity(0.1))),
            ]),
          )
              : ListView.builder(
            padding: EdgeInsets.all(size.width * 0.015),
            itemCount: orders.length,
            // Find the order card builder (inside _buildColumn > ListView.builder > itemBuilder)
// Replace the entire itemBuilder with this:

            itemBuilder: (context, index) {
              final order = orders[index];
              final isUrgent = _isUrgent(order);
              final isNewOrder = order.orderNumber == _lastSoundOrder;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.only(bottom: size.height * 0.01),
                padding: EdgeInsets.all(size.width * 0.02),
                decoration: BoxDecoration(
                  color: isNewOrder ? headerColor.withOpacity(0.15) : cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isUrgent ? headerColor : (isNewOrder ? headerColor : Colors.white.withOpacity(0.05)),
                    width: isUrgent ? 2 : (isNewOrder ? 2 : 1),
                  ),
                  boxShadow: isNewOrder
                      ? [BoxShadow(color: headerColor.withOpacity(0.3), blurRadius: 10, spreadRadius: 1)]
                      : [],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // IMPORTANT: prevent overflow
                  children: [
                    // Order number + Source
                    // FIXED: Compact order header
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      // Left side: Order number + NEW badge
                      Flexible(
                        flex: 3,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text('#${order.orderNumber}',
                                  style: TextStyle(fontSize: size.width * 0.02, fontWeight: FontWeight.bold, color: Colors.white),
                                  overflow: TextOverflow.ellipsis),
                            ),
                            if (isNewOrder) ...[
                              SizedBox(width: size.width * 0.008),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: size.width * 0.01, vertical: size.height * 0.001),
                                decoration: BoxDecoration(color: headerColor, borderRadius: BorderRadius.circular(6)),
                                child: Text('NEW', style: TextStyle(fontSize: size.width * 0.012, fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(width: size.width * 0.015),
                      // Right side: Source badge - smaller
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.01, vertical: size.height * 0.001),
                        decoration: BoxDecoration(
                          color: order.source == 'kiosk' ? Colors.purple.withOpacity(0.2) : Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(order.source == 'kiosk' ? 'K' : 'C',
                            style: TextStyle(fontSize: size.width * 0.012, color: Colors.white60)),
                      ),
                    ]),

                    // Table / Customer
                    if (order.tableNumber != null || order.customerName != null)
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.003),
                        child: Row(children: [
                          if (order.tableNumber != null)
                            Text('T${order.tableNumber}',
                                style: TextStyle(fontSize: size.width * 0.016, fontWeight: FontWeight.bold, color: Colors.white60)),
                          if (order.tableNumber != null && order.customerName != null)
                            Text(' • ', style: TextStyle(color: Colors.white30, fontSize: size.width * 0.014)),
                          if (order.customerName != null)
                            Flexible(child: Text(order.customerName!, style: TextStyle(fontSize: size.width * 0.015, color: Colors.white70), overflow: TextOverflow.ellipsis)),
                        ]),
                      ),

                    // Items - FIXED: shorter, compact
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: size.height * 0.004),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: (order.items as List<dynamic>).take(3).map((item) { // Max 3 items shown
                          final itemMap = item as Map<String, dynamic>;
                          return Padding(
                            padding: EdgeInsets.only(bottom: size.height * 0.001),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${itemMap['qty']}×',
                                    style: TextStyle(fontSize: size.width * 0.016, fontWeight: FontWeight.bold, color: Colors.white)),
                                SizedBox(width: size.width * 0.008),
                                Flexible(
                                  child: Text(
                                    itemMap['name'] as String,
                                    style: TextStyle(fontSize: size.width * 0.016, color: Colors.white70),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // Show "+X more" if more than 3 items
                    if ((order.items as List<dynamic>).length > 3)
                      Text('+${(order.items as List<dynamic>).length - 3} more items',
                          style: TextStyle(fontSize: size.width * 0.013, color: Colors.white70)),

                    SizedBox(height: size.height * 0.004),

                    // Timer + Action
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.timer_rounded, size: size.width * 0.02, color: isUrgent ? headerColor : Colors.white30),
                        SizedBox(width: size.width * 0.006),
                        Text(_getTimeAgo(order.createdAt),
                            style: TextStyle(fontSize: size.width * 0.018, fontWeight: FontWeight.bold, color: isUrgent ? headerColor : Colors.white70)),
                        if (isUrgent) ...[
                          SizedBox(width: size.width * 0.008),
                          Icon(Icons.priority_high_rounded, size: size.width * 0.02, color: headerColor),
                        ],
                      ]),
                      GestureDetector(
                        onTap: () => primaryAction(order),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.025, vertical: size.height * 0.006),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.4), blurRadius: 6)],
                          ),
                          child: Text(primaryLabel,
                              style: TextStyle(fontSize: size.width * 0.016, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                    ]),
                  ],
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}