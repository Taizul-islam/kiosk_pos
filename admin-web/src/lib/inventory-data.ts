import { Ingredient, Supplier, ProductIngredient, PurchaseOrder } from '@/types';

export const demoIngredients: Ingredient[] = [
  { id: 'ING001', name: 'Beef Patty', category: 'Meat', unit: 'pieces', currentStock: 85, minStock: 20, costPerUnit: 2.50, supplier: 'SUP001', lastRestocked: new Date('2026-06-10'), isActive: true },
  { id: 'ING002', name: 'Chicken Breast', category: 'Meat', unit: 'pieces', currentStock: 45, minStock: 15, costPerUnit: 1.80, supplier: 'SUP001', lastRestocked: new Date('2026-06-09'), isActive: true },
  { id: 'ING003', name: 'Burger Buns', category: 'Bakery', unit: 'pieces', currentStock: 120, minStock: 30, costPerUnit: 0.40, supplier: 'SUP002', lastRestocked: new Date('2026-06-11'), isActive: true },
  { id: 'ING004', name: 'Cheddar Cheese', category: 'Dairy', unit: 'slices', currentStock: 200, minStock: 50, costPerUnit: 0.25, supplier: 'SUP003', lastRestocked: new Date('2026-06-08'), isActive: true },
  { id: 'ING005', name: 'Lettuce', category: 'Vegetables', unit: 'heads', currentStock: 15, minStock: 10, costPerUnit: 0.80, supplier: 'SUP004', lastRestocked: new Date('2026-06-12'), isActive: true },
  { id: 'ING006', name: 'Tomato', category: 'Vegetables', unit: 'pieces', currentStock: 8, minStock: 15, costPerUnit: 0.30, supplier: 'SUP004', lastRestocked: new Date('2026-06-12'), isActive: true },
  { id: 'ING007', name: 'Bacon Strips', category: 'Meat', unit: 'strips', currentStock: 60, minStock: 25, costPerUnit: 0.50, supplier: 'SUP001', lastRestocked: new Date('2026-06-10'), isActive: true },
  { id: 'ING008', name: 'Potatoes', category: 'Vegetables', unit: 'kg', currentStock: 40, minStock: 10, costPerUnit: 1.20, supplier: 'SUP004', lastRestocked: new Date('2026-06-11'), isActive: true },
  { id: 'ING009', name: 'Cooking Oil', category: 'Supplies', unit: 'liters', currentStock: 25, minStock: 5, costPerUnit: 3.00, supplier: 'SUP005', lastRestocked: new Date('2026-06-05'), isActive: true },
  { id: 'ING010', name: 'Soda Syrup', category: 'Beverages', unit: 'liters', currentStock: 18, minStock: 8, costPerUnit: 4.50, supplier: 'SUP005', lastRestocked: new Date('2026-06-07'), isActive: true },
  { id: 'ING011', name: 'Ice Cream', category: 'Dairy', unit: 'liters', currentStock: 12, minStock: 5, costPerUnit: 5.00, supplier: 'SUP003', lastRestocked: new Date('2026-06-08'), isActive: true },
  { id: 'ING012', name: 'Fish Fillet', category: 'Seafood', unit: 'pieces', currentStock: 30, minStock: 10, costPerUnit: 3.00, supplier: 'SUP006', lastRestocked: new Date('2026-06-09'), isActive: true },
];

export const demoSuppliers: Supplier[] = [
  { id: 'SUP001', name: 'Premium Meats Co.', contactPerson: 'John Smith', phone: '+1-784-111-2222', email: 'john@premiummeats.com', items: ['ING001', 'ING002', 'ING007'] },
  { id: 'SUP002', name: 'City Bakery', contactPerson: 'Sarah Lee', phone: '+1-784-222-3333', email: 'sarah@citybakery.com', items: ['ING003'] },
  { id: 'SUP003', name: 'Dairy Fresh Ltd.', contactPerson: 'Mike Brown', phone: '+1-784-333-4444', email: 'mike@dairyfresh.com', items: ['ING004', 'ING011'] },
  { id: 'SUP004', name: 'Green Valley Farms', contactPerson: 'Lisa Green', phone: '+1-784-444-5555', email: 'lisa@greenvalley.com', items: ['ING005', 'ING006', 'ING008'] },
  { id: 'SUP005', name: 'Restaurant Supply Co.', contactPerson: 'Tom Wilson', phone: '+1-784-555-6666', email: 'tom@restsupply.com', items: ['ING009', 'ING010'] },
  { id: 'SUP006', name: 'Ocean Fresh Seafood', contactPerson: 'David Fisher', phone: '+1-784-666-7777', email: 'david@oceanfresh.com', items: ['ING012'] },
];

export const demoProductIngredients: ProductIngredient[] = [
  { productId: 1, ingredientId: 'ING001', quantityUsed: 1 }, // Classic Burger: 1 beef patty
  { productId: 1, ingredientId: 'ING003', quantityUsed: 1 }, // 1 bun
  { productId: 1, ingredientId: 'ING004', quantityUsed: 1 }, // 1 cheese slice
  { productId: 1, ingredientId: 'ING005', quantityUsed: 0.25 }, // 1/4 lettuce
  { productId: 1, ingredientId: 'ING006', quantityUsed: 0.5 }, // 1/2 tomato
  { productId: 2, ingredientId: 'ING001', quantityUsed: 1 },
  { productId: 2, ingredientId: 'ING003', quantityUsed: 1 },
  { productId: 2, ingredientId: 'ING007', quantityUsed: 3 }, // 3 bacon strips
  { productId: 3, ingredientId: 'ING002', quantityUsed: 1 }, // Steak Sandwich: chicken
  { productId: 3, ingredientId: 'ING003', quantityUsed: 1 },
  { productId: 5, ingredientId: 'ING012', quantityUsed: 1 }, // Fish & Chips
  { productId: 5, ingredientId: 'ING008', quantityUsed: 0.3 }, // potatoes for fries
  { productId: 7, ingredientId: 'ING008', quantityUsed: 0.2 }, // French Fries
  { productId: 7, ingredientId: 'ING009', quantityUsed: 0.1 }, // oil
  { productId: 10, ingredientId: 'ING010', quantityUsed: 0.3 }, // Soda
  { productId: 12, ingredientId: 'ING011', quantityUsed: 0.2 }, // Ice Cream
];

export const demoPurchaseOrders: PurchaseOrder[] = [
  {
    id: 'PO001',
    supplierId: 'SUP001',
    items: [
      { ingredientId: 'ING001', quantity: 50, cost: 125.00 },
      { ingredientId: 'ING002', quantity: 30, cost: 54.00 },
      { ingredientId: 'ING007', quantity: 40, cost: 20.00 },
    ],
    totalCost: 199.00,
    status: 'ordered',
    orderedDate: new Date('2026-06-12'),
  },
  {
    id: 'PO002',
    supplierId: 'SUP004',
    items: [
      { ingredientId: 'ING005', quantity: 20, cost: 16.00 },
      { ingredientId: 'ING006', quantity: 30, cost: 9.00 },
    ],
    totalCost: 25.00,
    status: 'pending',
    orderedDate: new Date('2026-06-13'),
  },
];