import { User, Category, Product, Order, MembershipCard } from '@/types';

export const demoUsers: User[] = [
  { id: '0', name: 'Admin', pin: '1234', role: 'admin', isActive: true },
  { id: '1', name: 'Sarah (Manager)', pin: '0000', role: 'manager', isActive: true },
  { id: '2', name: 'John (Cashier)', pin: '1111', role: 'cashier', isActive: true },
  { id: '3', name: 'Lisa (Cashier)', pin: '2222', role: 'cashier', isActive: true },
];

export const demoCategories: Category[] = [
  { id: 1, name: 'Meat', slug: 'meat', displayOrder: 1, isActive: true },
  { id: 2, name: 'Fish & Chips', slug: 'fish-chips', displayOrder: 2, isActive: true },
  { id: 3, name: 'Sides', slug: 'sides', displayOrder: 3, isActive: true },
  { id: 4, name: 'Drinks', slug: 'drinks', displayOrder: 4, isActive: true },
  { id: 5, name: 'Desserts', slug: 'desserts', displayOrder: 5, isActive: true },
];

export const demoProducts: Product[] = [
  { id: 1, categoryId: 1, categoryName: 'Meat', name: 'Classic Burger', description: 'Beef patty with lettuce & special sauce', basePrice: 12.00, isAvailable: true, modifierGroupIds: [1, 2] },
  { id: 2, categoryId: 1, categoryName: 'Meat', name: 'Bacon Deluxe', description: 'Beef with crispy bacon & BBQ', basePrice: 16.00, isAvailable: true, modifierGroupIds: [1, 2] },
  { id: 3, categoryId: 1, categoryName: 'Meat', name: 'Steak Sandwich', description: 'Grilled steak with onions', basePrice: 18.00, isAvailable: true, modifierGroupIds: [1, 2] },
  { id: 4, categoryId: 1, categoryName: 'Meat', name: 'BBQ Ribs', description: 'Slow-cooked pork ribs', basePrice: 22.00, isAvailable: true, modifierGroupIds: [1] },
  { id: 5, categoryId: 2, categoryName: 'Fish & Chips', name: 'Classic Fish & Chips', description: 'Beer-battered cod with fries', basePrice: 14.00, isAvailable: true, modifierGroupIds: [3, 5] },
  { id: 6, categoryId: 2, categoryName: 'Fish & Chips', name: 'Grilled Salmon', description: 'Atlantic salmon with rice', basePrice: 19.00, isAvailable: true, modifierGroupIds: [3] },
  { id: 7, categoryId: 3, categoryName: 'Sides', name: 'French Fries', description: 'Crispy golden fries', basePrice: 5.00, isAvailable: true, modifierGroupIds: [3] },
  { id: 8, categoryId: 3, categoryName: 'Sides', name: 'Onion Rings', description: 'Beer-battered rings', basePrice: 6.00, isAvailable: true, modifierGroupIds: [3] },
  { id: 9, categoryId: 3, categoryName: 'Sides', name: 'Chicken Wings', description: '6 pieces with sauce', basePrice: 8.00, isAvailable: true, modifierGroupIds: [3, 4] },
  { id: 10, categoryId: 4, categoryName: 'Drinks', name: 'Soda', description: 'Coke, Sprite, Fanta', basePrice: 3.00, isAvailable: true, modifierGroupIds: [3] },
  { id: 11, categoryId: 4, categoryName: 'Drinks', name: 'Milkshake', description: 'Hand-spun thick shake', basePrice: 7.00, isAvailable: true, modifierGroupIds: [3, 4] },
  { id: 12, categoryId: 5, categoryName: 'Desserts', name: 'Ice Cream Sundae', description: 'With chocolate & nuts', basePrice: 6.00, isAvailable: true, modifierGroupIds: [] },
  { id: 13, categoryId: 5, categoryName: 'Desserts', name: 'Chocolate Brownie', description: 'Warm with ice cream', basePrice: 7.00, isAvailable: true, modifierGroupIds: [] },
];

export const demoOrders: Order[] = [
  { orderNumber: 'ORD-001', customerName: 'John Doe', tableNumber: '5', orderType: 'dine_in', subtotal: 28.00, tax: 4.20, total: 32.20, paymentMethod: 'card', status: 'preparing', source: 'kiosk', createdAt: new Date(Date.now() - 300000) },
  { orderNumber: 'ORD-002', customerName: 'Jane Smith', tableNumber: '3', orderType: 'dine_in', subtotal: 42.00, tax: 6.30, total: 48.30, paymentMethod: 'cash', status: 'pending', source: 'cashier', createdAt: new Date(Date.now() - 120000) },
  { orderNumber: 'ORD-003', customerName: undefined, tableNumber: undefined, orderType: 'take_away', subtotal: 15.00, tax: 2.25, total: 17.25, paymentMethod: 'member', status: 'completed', source: 'kiosk', createdAt: new Date(Date.now() - 1500000) },
  { orderNumber: 'ORD-004', customerName: 'Bob Johnson', tableNumber: '7', orderType: 'dine_in', subtotal: 56.00, tax: 8.40, total: 64.40, paymentMethod: 'card', status: 'preparing', source: 'cashier', createdAt: new Date(Date.now() - 480000) },
  { orderNumber: 'ORD-005', customerName: undefined, tableNumber: undefined, orderType: 'take_away', subtotal: 22.00, tax: 3.30, total: 25.30, paymentMethod: 'cash', status: 'ready', source: 'cashier', createdAt: new Date(Date.now() - 900000) },
];

export const demoCards: MembershipCard[] = [
  { cardNumber: 'MEM00123456', name: 'John Doe', balance: 25.00, points: 150, visits: 12 },
  { cardNumber: 'MEM00789012', name: 'Jane Smith', balance: 50.00, points: 320, visits: 28 },
];

export const revenueData = {
  daily: [
    { label: 'Mon', value: 420 },
    { label: 'Tue', value: 380 },
    { label: 'Wed', value: 450 },
    { label: 'Thu', value: 520 },
    { label: 'Fri', value: 480 },
    { label: 'Sat', value: 610 },
    { label: 'Sun', value: 550 },
  ],
  topItems: [
    { name: 'Classic Burger', sold: 42, revenue: 504 },
    { name: 'French Fries', sold: 35, revenue: 175 },
    { name: 'Milkshake', sold: 28, revenue: 196 },
    { name: 'Bacon Deluxe', sold: 22, revenue: 352 },
    { name: 'Soda', sold: 18, revenue: 54 },
  ],
  peakHours: [
    { hour: '11 AM', orders: 8 },
    { hour: '12 PM', orders: 15 },
    { hour: '1 PM', orders: 18 },
    { hour: '2 PM', orders: 10 },
    { hour: '5 PM', orders: 12 },
    { hour: '6 PM', orders: 22 },
    { hour: '7 PM', orders: 17 },
  ],
};