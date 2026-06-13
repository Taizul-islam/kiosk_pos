export type UserRole = 'admin' | 'manager' | 'cashier';

export interface User {
  id: string;
  name: string;
  pin: string;
  role: UserRole;
  isActive: boolean;
}

export interface Category {
  id: number;
  name: string;
  slug: string;
  displayOrder: number;
  isActive: boolean;
}

export interface Product {
  id: number;
  categoryId: number;
  categoryName: string;
  name: string;
  description?: string;
  imageUrl?: string;
  basePrice: number;
  isAvailable: boolean;
  modifierGroupIds: number[];
}

export interface Order {
  orderNumber: string;
  customerName?: string;
  tableNumber?: string;
  orderType: 'dine_in' | 'take_away';
  subtotal: number;
  tax: number;
  total: number;
  paymentMethod: string;
  status: 'pending' | 'preparing' | 'ready' | 'completed';
  source: 'kiosk' | 'cashier';
  createdAt: Date;
}

export interface MembershipCard {
  cardNumber: string;
  name: string;
  balance: number;
  points: number;
  visits: number;
}


export interface Ingredient {
  id: string;
  name: string;
  category: string;
  unit: string; // kg, g, pieces, liters, etc.
  currentStock: number;
  minStock: number; // low stock alert threshold
  costPerUnit: number;
  supplier: string;
  lastRestocked: Date;
  isActive: boolean;
}

export interface ProductIngredient {
  productId: number;
  ingredientId: string;
  quantityUsed: number; // how much of ingredient used per 1 product
}

export interface Supplier {
  id: string;
  name: string;
  contactPerson: string;
  phone: string;
  email: string;
  items: string[]; // ingredient IDs they supply
}

export interface PurchaseOrder {
  id: string;
  supplierId: string;
  items: { ingredientId: string; quantity: number; cost: number }[];
  totalCost: number;
  status: 'pending' | 'ordered' | 'received' | 'cancelled';
  orderedDate: Date;
  receivedDate?: Date;
}