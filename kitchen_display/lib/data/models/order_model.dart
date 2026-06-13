class OrderModel {
  final String orderNumber;
  final String? customerName;
  final String? tableNumber;
  final String orderType;
  final List<dynamic> items;
  final double subtotal;
  final double tax;
  final double total;
  final String paymentMethod;
  final String status;
  final String source;
  final DateTime createdAt;

  OrderModel({
    required this.orderNumber,
    this.customerName,
    this.tableNumber,
    required this.orderType,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.paymentMethod,
    required this.status,
    required this.source,
    required this.createdAt,
  });
}