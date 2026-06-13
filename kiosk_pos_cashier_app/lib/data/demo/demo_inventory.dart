import '../models/inventory_model.dart';

class DemoInventory {
  static List<IngredientModel> get ingredients => [
    IngredientModel(id: 'ING001', name: 'Beef Patty', category: 'Meat', unit: 'pieces', currentStock: 85, minStock: 20, costPerUnit: 2.50, supplierId: 'SUP001', lastRestocked: DateTime(2026, 6, 10)),
    IngredientModel(id: 'ING002', name: 'Chicken Breast', category: 'Meat', unit: 'pieces', currentStock: 45, minStock: 15, costPerUnit: 1.80, supplierId: 'SUP001', lastRestocked: DateTime(2026, 6, 9)),
    IngredientModel(id: 'ING003', name: 'Burger Buns', category: 'Bakery', unit: 'pieces', currentStock: 120, minStock: 30, costPerUnit: 0.40, supplierId: 'SUP002', lastRestocked: DateTime(2026, 6, 11)),
    IngredientModel(id: 'ING004', name: 'Cheddar Cheese', category: 'Dairy', unit: 'slices', currentStock: 200, minStock: 50, costPerUnit: 0.25, supplierId: 'SUP003', lastRestocked: DateTime(2026, 6, 8)),
    IngredientModel(id: 'ING005', name: 'Lettuce', category: 'Vegetables', unit: 'heads', currentStock: 15, minStock: 10, costPerUnit: 0.80, supplierId: 'SUP004', lastRestocked: DateTime(2026, 6, 12)),
    IngredientModel(id: 'ING006', name: 'Tomato', category: 'Vegetables', unit: 'pieces', currentStock: 8, minStock: 15, costPerUnit: 0.30, supplierId: 'SUP004', lastRestocked: DateTime(2026, 6, 12)),
    IngredientModel(id: 'ING007', name: 'Bacon Strips', category: 'Meat', unit: 'strips', currentStock: 60, minStock: 25, costPerUnit: 0.50, supplierId: 'SUP001', lastRestocked: DateTime(2026, 6, 10)),
    IngredientModel(id: 'ING008', name: 'Potatoes', category: 'Vegetables', unit: 'kg', currentStock: 40, minStock: 10, costPerUnit: 1.20, supplierId: 'SUP004', lastRestocked: DateTime(2026, 6, 11)),
    IngredientModel(id: 'ING009', name: 'Cooking Oil', category: 'Supplies', unit: 'liters', currentStock: 25, minStock: 5, costPerUnit: 3.00, supplierId: 'SUP005', lastRestocked: DateTime(2026, 6, 5)),
    IngredientModel(id: 'ING010', name: 'Soda Syrup', category: 'Beverages', unit: 'liters', currentStock: 18, minStock: 8, costPerUnit: 4.50, supplierId: 'SUP005', lastRestocked: DateTime(2026, 6, 7)),
    IngredientModel(id: 'ING011', name: 'Ice Cream', category: 'Dairy', unit: 'liters', currentStock: 12, minStock: 5, costPerUnit: 5.00, supplierId: 'SUP003', lastRestocked: DateTime(2026, 6, 8)),
    IngredientModel(id: 'ING012', name: 'Fish Fillet', category: 'Seafood', unit: 'pieces', currentStock: 30, minStock: 10, costPerUnit: 3.00, supplierId: 'SUP006', lastRestocked: DateTime(2026, 6, 9)),
  ];

  static List<SupplierModel> get suppliers => [
    SupplierModel(id: 'SUP001', name: 'Premium Meats Co.', contactPerson: 'John Smith', phone: '+1-784-111-2222', email: 'john@premiummeats.com', itemIds: ['ING001', 'ING002', 'ING007']),
    SupplierModel(id: 'SUP002', name: 'City Bakery', contactPerson: 'Sarah Lee', phone: '+1-784-222-3333', email: 'sarah@citybakery.com', itemIds: ['ING003']),
    SupplierModel(id: 'SUP003', name: 'Dairy Fresh Ltd.', contactPerson: 'Mike Brown', phone: '+1-784-333-4444', email: 'mike@dairyfresh.com', itemIds: ['ING004', 'ING011']),
    SupplierModel(id: 'SUP004', name: 'Green Valley Farms', contactPerson: 'Lisa Green', phone: '+1-784-444-5555', email: 'lisa@greenvalley.com', itemIds: ['ING005', 'ING006', 'ING008']),
    SupplierModel(id: 'SUP005', name: 'Restaurant Supply Co.', contactPerson: 'Tom Wilson', phone: '+1-784-555-6666', email: 'tom@restsupply.com', itemIds: ['ING009', 'ING010']),
    SupplierModel(id: 'SUP006', name: 'Ocean Fresh Seafood', contactPerson: 'David Fisher', phone: '+1-784-666-7777', email: 'david@oceanfresh.com', itemIds: ['ING012']),
  ];

  static List<PurchaseOrderModel> get purchaseOrders => [
    PurchaseOrderModel(
      id: 'PO001',
      supplierId: 'SUP001',
      items: [
        PurchaseOrderItem(ingredientId: 'ING001', quantity: 50, cost: 125.00),
        PurchaseOrderItem(ingredientId: 'ING002', quantity: 30, cost: 54.00),
        PurchaseOrderItem(ingredientId: 'ING007', quantity: 40, cost: 20.00),
      ],
      totalCost: 199.00,
      status: 'ordered',
      orderedDate: DateTime(2026, 6, 12),
    ),
    PurchaseOrderModel(
      id: 'PO002',
      supplierId: 'SUP004',
      items: [
        PurchaseOrderItem(ingredientId: 'ING005', quantity: 20, cost: 16.00),
        PurchaseOrderItem(ingredientId: 'ING006', quantity: 30, cost: 9.00),
      ],
      totalCost: 25.00,
      status: 'pending',
      orderedDate: DateTime(2026, 6, 13),
    ),
  ];
}