import '../models/product_model.dart';

class DemoProducts {
  static List<ProductModel> get products => [
    ProductModel(id: 1, categoryId: 1, categoryName: 'Meat', name: 'Classic Burger', description: 'Beef patty with lettuce, tomato & special sauce', basePrice: 12.00, modifierGroupIds: [1, 2]),
    ProductModel(id: 2, categoryId: 1, categoryName: 'Meat', name: 'Bacon Deluxe', description: 'Beef with crispy bacon & BBQ sauce', basePrice: 16.00, modifierGroupIds: [1, 2]),
    ProductModel(id: 3, categoryId: 1, categoryName: 'Meat', name: 'Steak Sandwich', description: 'Grilled steak with caramelized onions', basePrice: 18.00, modifierGroupIds: [1, 2]),
    ProductModel(id: 4, categoryId: 1, categoryName: 'Meat', name: 'BBQ Ribs', description: 'Slow-cooked pork ribs with BBQ glaze', basePrice: 22.00, modifierGroupIds: [1]),
    ProductModel(id: 5, categoryId: 2, categoryName: 'Fish & Chips', name: 'Classic Fish & Chips', description: 'Beer-battered cod with crispy fries', basePrice: 14.00, modifierGroupIds: [3, 5]),
    ProductModel(id: 6, categoryId: 2, categoryName: 'Fish & Chips', name: 'Grilled Salmon', description: 'Atlantic salmon with rice & veggies', basePrice: 19.00, modifierGroupIds: [3]),
    ProductModel(id: 7, categoryId: 2, categoryName: 'Fish & Chips', name: 'Fish Tacos', description: '3 soft tacos with slaw & lime', basePrice: 13.00, modifierGroupIds: [3, 4]),
    ProductModel(id: 8, categoryId: 3, categoryName: 'Sides', name: 'French Fries', description: 'Crispy golden fries with sea salt', basePrice: 5.00, modifierGroupIds: [3]),
    ProductModel(id: 9, categoryId: 3, categoryName: 'Sides', name: 'Onion Rings', description: 'Beer-battered rings with dipping sauce', basePrice: 6.00, modifierGroupIds: [3, 5]),
    ProductModel(id: 10, categoryId: 3, categoryName: 'Sides', name: 'Chicken Wings', description: '6 crispy wings with your choice of sauce', basePrice: 8.00, modifierGroupIds: [3, 4]),
    ProductModel(id: 11, categoryId: 4, categoryName: 'Drinks', name: 'Soda', description: 'Coca-Cola, Sprite, Fanta, or Ginger Ale', basePrice: 3.00, modifierGroupIds: [3]),
    ProductModel(id: 12, categoryId: 4, categoryName: 'Drinks', name: 'Milkshake', description: 'Thick & creamy hand-spun shake', basePrice: 7.00, modifierGroupIds: [3, 4]),
    ProductModel(id: 13, categoryId: 4, categoryName: 'Drinks', name: 'Fresh Juice', description: 'Freshly squeezed orange or pineapple', basePrice: 5.00, modifierGroupIds: [3]),
    ProductModel(id: 14, categoryId: 5, categoryName: 'Desserts', name: 'Ice Cream Sundae', description: 'Vanilla ice cream with chocolate & nuts', basePrice: 6.00, modifierGroupIds: []),
    ProductModel(id: 15, categoryId: 5, categoryName: 'Desserts', name: 'Chocolate Brownie', description: 'Warm brownie with vanilla ice cream', basePrice: 7.00, modifierGroupIds: []),
    ProductModel(id: 16, categoryId: 5, categoryName: 'Desserts', name: 'Cheesecake', description: 'NY style with berry compote', basePrice: 8.00, modifierGroupIds: []),
  ];
}