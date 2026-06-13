class IngredientModel {
  final String id;
  final String name;
  final String category;
  final String unit;
  final double currentStock;
  final double minStock;
  final double costPerUnit;
  final String supplierId;
  final DateTime lastRestocked;
  final bool isActive;

  IngredientModel({
    required this.id,
    required this.name,
    required this.category,
    required this.unit,
    required this.currentStock,
    required this.minStock,
    required this.costPerUnit,
    required this.supplierId,
    required this.lastRestocked,
    this.isActive = true,
  });

  bool get isLowStock => currentStock <= minStock;
  bool get isOutOfStock => currentStock <= 0;
  double get stockValue => currentStock * costPerUnit;
  double get stockPercent => (currentStock / (minStock * 3)).clamp(0.0, 1.0);
}

class SupplierModel {
  final String id;
  final String name;
  final String contactPerson;
  final String phone;
  final String email;
  final List<String> itemIds;

  SupplierModel({
    required this.id,
    required this.name,
    required this.contactPerson,
    required this.phone,
    required this.email,
    required this.itemIds,
  });
}

class PurchaseOrderModel {
  final String id;
  final String supplierId;
  final List<PurchaseOrderItem> items;
  final double totalCost;
  final String status;
  final DateTime orderedDate;
  final DateTime? receivedDate;

  PurchaseOrderModel({
    required this.id,
    required this.supplierId,
    required this.items,
    required this.totalCost,
    required this.status,
    required this.orderedDate,
    this.receivedDate,
  });
}

class PurchaseOrderItem {
  final String ingredientId;
  final double quantity;
  final double cost;

  PurchaseOrderItem({
    required this.ingredientId,
    required this.quantity,
    required this.cost,
  });
}