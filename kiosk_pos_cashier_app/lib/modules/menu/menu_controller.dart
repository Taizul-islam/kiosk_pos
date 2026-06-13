import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme.dart';
import '../../data/models/product_model.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/demo/demo_products.dart';
import '../../data/demo/demo_categories.dart';

class MenuController extends GetxController {
  final products = <ProductModel>[].obs;
  final selectedCategory = 'All'.obs;
  final cartItems = <CartItemModel>[].obs;

  int get cartItemCount => cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get cartSubtotal => cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get cartTax => cartSubtotal * 0.15;
  double get cartTotal => cartSubtotal + cartTax;

  List<String> get categories {
    final cats = {'All'};
    for (var p in DemoProducts.products) {
      cats.add(p.categoryName);
    }
    return cats.toList();
  }

  List<ProductModel> get filteredProducts {
    if (selectedCategory.value == 'All') return products;
    return products.where((p) => p.categoryName == selectedCategory.value).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  void loadProducts() => products.assignAll(DemoProducts.products);
  void selectCategory(String cat) => selectedCategory.value = cat;

  void addToCart(CartItemModel item) {
    final index = cartItems.indexWhere((e) =>
    e.productId == item.productId &&
        _sameModifiers(e.selectedModifiers, item.selectedModifiers));
    if (index != -1) {
      cartItems[index].quantity += item.quantity;
      cartItems.refresh();
    } else {
      cartItems.add(item);
    }
  }

  void removeFromCart(int index) => cartItems.removeAt(index);
  void updateQuantity(int index, int qty) {
    if (qty <= 0) { cartItems.removeAt(index); } else { cartItems[index].quantity = qty; cartItems.refresh(); }
  }
  void clearCart() => cartItems.clear();

  bool _sameModifiers(a, b) {
    if (a.length != b.length) return false;
    final aIds = a.map((m) => m.modifierId).toSet();
    final bIds = b.map((m) => m.modifierId).toSet();
    return aIds.containsAll(bIds);
  }
}