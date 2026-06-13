import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme.dart';
import '../../data/demo/demo_categories.dart';
import '../../data/demo/demo_products.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../../utils/formatters.dart';
import '../../app/routes.dart';

class MenuManagementScreen extends StatefulWidget {
  const MenuManagementScreen({super.key});

  @override
  State<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Local copies for demo editing
  late List<CategoryModel> _categories;
  late List<ProductModel> _products;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _categories = List.from(DemoCategories.categories.where((c) => c.name != 'All'));
    _products = List.from(DemoProducts.products);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ProductModel> get _filteredProducts {
    if (_searchQuery.isEmpty) return _products;
    return _products
        .where((p) =>
    p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        p.categoryName.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  // ==================== CATEGORY DIALOGS ====================
  void _addCategory() {
    final nameController = TextEditingController();
    final colorController = TextEditingController(text: '#FF6B35');

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Category', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  prefixIcon: Icon(Icons.category_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      setState(() {
                        _categories.add(CategoryModel(
                          id: _categories.length + 10,
                          name: nameController.text,
                          slug: nameController.text.toLowerCase().replaceAll(' ', '-'),
                          displayOrder: _categories.length + 1,
                        ));
                      });
                      Get.back();
                      Get.snackbar('Added!', 'Category "${nameController.text}" created',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.accent,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 12);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('ADD CATEGORY', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editCategory(CategoryModel category) {
    final nameController = TextEditingController(text: category.name);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit Category', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  prefixIcon: Icon(Icons.category_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 12),
              Text('${_products.where((p) => p.categoryName == category.name).length} products in this category',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
              SizedBox(height: 20),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: Text('CANCEL'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty) {
                        final oldName = category.name;
                        setState(() {
                          final index = _categories.indexWhere((c) => c.id == category.id);
                          if (index != -1) {
                            _categories[index] = CategoryModel(
                              id: category.id,
                              name: nameController.text,
                              slug: nameController.text.toLowerCase().replaceAll(' ', '-'),
                              displayOrder: category.displayOrder,
                            );
                            // Update products with this category
                            _products = _products.map((p) {
                              if (p.categoryName == oldName) {
                                return ProductModel(
                                  id: p.id,
                                  categoryId: p.categoryId,
                                  categoryName: nameController.text,
                                  name: p.name,
                                  description: p.description,
                                  basePrice: p.basePrice,
                                  modifierGroupIds: p.modifierGroupIds,
                                );
                              }
                              return p;
                            }).toList();
                          }
                        });
                        Get.back();
                        Get.snackbar('Updated!', 'Category renamed to "${nameController.text}"',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppColors.accent,
                            colorText: Colors.white,
                            margin: const EdgeInsets.all(16),
                            borderRadius: 12);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('SAVE', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteCategory(CategoryModel category) {
    final productCount = _products.where((p) => p.categoryName == category.name).length;
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Delete "${category.name}"?'),
        content: Text('This category has $productCount products. Deleting it will not delete the products, but they will need to be reassigned.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('CANCEL')),
          ElevatedButton(
            onPressed: () {
              setState(() => _categories.removeWhere((c) => c.id == category.id));
              Get.back();
              Get.snackbar('Deleted', 'Category "${category.name}" removed',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.error,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text('DELETE', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ==================== PRODUCT DIALOGS ====================
  void _toggleProductAvailability(ProductModel product) {
    setState(() {
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = ProductModel(
          id: product.id,
          categoryId: product.categoryId,
          categoryName: product.categoryName,
          name: product.name,
          description: product.description,
          basePrice: product.basePrice,
          isAvailable: !product.isAvailable,
          modifierGroupIds: product.modifierGroupIds,
        );
      }
    });
    Get.snackbar(
      product.isAvailable ? 'Unavailable' : 'Available',
      '${product.name} is now ${product.isAvailable ? "unavailable" : "available"}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: product.isAvailable ? AppColors.error : AppColors.accent,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void _deleteProduct(ProductModel product) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Delete "${product.name}"?'),
        content: Text('This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('CANCEL')),
          ElevatedButton(
            onPressed: () {
              setState(() => _products.removeWhere((p) => p.id == product.id));
              Get.back();
              Get.snackbar('Deleted', '${product.name} removed',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.error,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text('DELETE', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              height: size.height * 0.08,
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))
              ]),
              child: Row(children: [
                GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back_ios_rounded,
                        size: size.width * 0.045, color: AppColors.textPrimary)),
                SizedBox(width: size.width * 0.03),
                Text('Menu Management',
                    style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.bold)),
              ]),
            ),

            // Tabs
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey.shade500,
                indicatorColor: AppColors.primary,
                labelStyle: TextStyle(fontSize: size.width * 0.032, fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: 'Categories'),
                  Tab(text: 'Products'),
                ],
              ),
            ),

            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCategoriesTab(size),
                  _buildProductsTab(size),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== CATEGORIES TAB ====================
  Widget _buildCategoriesTab(Size size) {
    return Column(
      children: [
        // Header
        Container(
          padding: EdgeInsets.all(size.width * 0.04),
          color: Colors.white,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('${_categories.length} categories',
                style: TextStyle(fontSize: size.width * 0.032, color: Colors.grey.shade600)),
            GestureDetector(
              onTap: _addCategory,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: size.height * 0.012),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(25)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.add_rounded, color: Colors.white, size: size.width * 0.04),
                  SizedBox(width: size.width * 0.01),
                  Text('Add Category', style: TextStyle(color: Colors.white, fontSize: size.width * 0.03, fontWeight: FontWeight.w600)),
                ]),
              ),
            ),
          ]),
        ),

        // Category list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final productCount = _products.where((p) => p.categoryName == cat.name).length;
              return Container(
                margin: EdgeInsets.only(bottom: size.height * 0.01),
                padding: EdgeInsets.all(size.width * 0.035),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                child: Row(children: [
                  Container(
                    width: size.width * 0.12, height: size.width * 0.12,
                    decoration: BoxDecoration(
                        color: _getCategoryColor(cat.name).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                        child: Icon(_getCategoryIcon(cat.name),
                            size: size.width * 0.055, color: _getCategoryColor(cat.name))),
                  ),
                  SizedBox(width: size.width * 0.04),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(cat.name, style: TextStyle(fontSize: size.width * 0.036, fontWeight: FontWeight.bold)),
                      SizedBox(height: size.height * 0.004),
                      Text('$productCount products', style: TextStyle(fontSize: size.width * 0.028, color: Colors.grey.shade500)),
                    ]),
                  ),
                  GestureDetector(
                    onTap: () => _editCategory(cat),
                    child: Container(
                      padding: EdgeInsets.all(size.width * 0.025),
                      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
                      child: Icon(Icons.edit_rounded, size: size.width * 0.04, color: Colors.blue.shade700),
                    ),
                  ),
                  SizedBox(width: size.width * 0.015),
                  GestureDetector(
                    onTap: () => _deleteCategory(cat),
                    child: Container(
                      padding: EdgeInsets.all(size.width * 0.025),
                      decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(10)),
                      child: Icon(Icons.delete_outline_rounded, size: size.width * 0.04, color: AppColors.error),
                    ),
                  ),
                ]),
              );
            },
          ),
        ),
      ],
    );
  }

  // ==================== PRODUCTS TAB ====================
  Widget _buildProductsTab(Size size) {
    return Column(
      children: [
        // Search + Add (keep as is)
        Container(
          padding: EdgeInsets.all(size.width * 0.04),
          color: Colors.white,
          child: Row(children: [
            Expanded(
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: Icon(Icons.search_rounded, size: size.width * 0.045),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.012),
                ),
                style: TextStyle(fontSize: size.width * 0.033),
              ),
            ),
            SizedBox(width: size.width * 0.03),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.productForm, arguments: {
                'isNew': true,
                'categories': _categories.map((c) => c.name).toList(),
              }),
              child: Container(
                padding: EdgeInsets.all(size.width * 0.035),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.add_rounded, color: Colors.white, size: size.width * 0.05),
              ),
            ),
          ]),
        ),

        // Product count
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: size.height * 0.01),
          child: Row(children: [
            Text('${_filteredProducts.length} products',
                style: TextStyle(fontSize: size.width * 0.03, color: Colors.grey.shade600)),
          ]),
        ),

        // Product list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
              return Container(
                margin: EdgeInsets.only(bottom: size.height * 0.01),
                padding: EdgeInsets.all(size.width * 0.035),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: product.isAvailable ? null : Border.all(color: Colors.red.shade200),
                ),
                child: Row(children: [
                  Container(
                    width: size.width * 0.11, height: size.width * 0.11,
                    decoration: BoxDecoration(
                        color: _getCategoryColor(product.categoryName).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Icon(Icons.restaurant_rounded,
                            size: size.width * 0.045, color: _getCategoryColor(product.categoryName))),
                  ),
                  SizedBox(width: size.width * 0.035),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Expanded(
                          child: Text(product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: size.width * 0.032,
                                  fontWeight: FontWeight.w600,
                                  decoration: product.isAvailable ? null : TextDecoration.lineThrough,
                                  color: product.isAvailable ? AppColors.textPrimary : Colors.grey.shade400)),
                        ),
                      ]),
                      SizedBox(height: size.height * 0.003),
                      Row(children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.02, vertical: size.height * 0.002),
                          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                          child: Text(product.categoryName, style: TextStyle(fontSize: size.width * 0.022, color: Colors.grey.shade600)),
                        ),
                        SizedBox(width: size.width * 0.03),
                        Text(Formatters.currency(product.basePrice),
                            style: TextStyle(fontSize: size.width * 0.028, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        if (!product.isAvailable) ...[
                          SizedBox(width: size.width * 0.03),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.015, vertical: size.height * 0.002),
                            decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(4)),
                            child: Text('OFF', style: TextStyle(fontSize: size.width * 0.018, color: AppColors.error, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ]),
                    ]),
                  ),
                  // ============ EDIT BUTTON (NEW) ============
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.productForm, arguments: {
                      'isNew': false,
                      'product': product,
                      'categories': _categories.map((c) => c.name).toList(),
                    }),
                    child: Container(
                      padding: EdgeInsets.all(size.width * 0.022),
                      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                      child: Icon(Icons.edit_rounded, size: size.width * 0.035, color: Colors.blue.shade700),
                    ),
                  ),
                  SizedBox(width: size.width * 0.012),
                  // Toggle availability
                  GestureDetector(
                    onTap: () => _toggleProductAvailability(product),
                    child: Container(
                      width: size.width * 0.07, height: size.width * 0.07,
                      decoration: BoxDecoration(
                        color: product.isAvailable ? AppColors.accent.withOpacity(0.1) : Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        product.isAvailable ? Icons.check_rounded : Icons.close_rounded,
                        size: size.width * 0.035,
                        color: product.isAvailable ? AppColors.accent : AppColors.error,
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.012),
                  // Delete
                  GestureDetector(
                    onTap: () => _deleteProduct(product),
                    child: Container(
                      padding: EdgeInsets.all(size.width * 0.022),
                      decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                      child: Icon(Icons.delete_outline_rounded, size: size.width * 0.035, color: AppColors.error),
                    ),
                  ),
                ]),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String name) {
    switch (name) {
      case 'Meat': return const Color(0xFFE74C3C);
      case 'Fish & Chips': return const Color(0xFF3498DB);
      case 'Sides': return const Color(0xFFF39C12);
      case 'Drinks': return const Color(0xFF9B59B6);
      case 'Desserts': return const Color(0xFFE91E63);
      default: return AppColors.primary;
    }
  }

  IconData _getCategoryIcon(String name) {
    switch (name) {
      case 'Meat': return Icons.kebab_dining_rounded;
      case 'Fish & Chips': return Icons.set_meal_rounded;
      case 'Sides': return Icons.fastfood_rounded;
      case 'Drinks': return Icons.local_drink_rounded;
      case 'Desserts': return Icons.icecream_rounded;
      default: return Icons.category_rounded;
    }
  }
}