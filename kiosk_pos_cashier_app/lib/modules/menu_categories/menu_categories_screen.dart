import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes.dart';
import '../../config/theme.dart';
import '../../data/demo/demo_categories.dart';
import '../../data/demo/demo_products.dart';

class MenuCategoriesScreen extends StatefulWidget {
  const MenuCategoriesScreen({super.key});

  @override
  State<MenuCategoriesScreen> createState() => _MenuCategoriesScreenState();
}

class _MenuCategoriesScreenState extends State<MenuCategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this)
      ..forward();
    _fadeAnimation = CurvedAnimation(
        parent: _fadeController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  int _getItemCount(String categoryName) {
    if (categoryName == 'All') return DemoProducts.products.length;
    return DemoProducts.products
        .where((p) => p.categoryName == categoryName)
        .length;
  }

  String _getImage(String categoryName) {
    switch (categoryName) {
      case 'Meat':
        return 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500';
      case 'Fish & Chips':
        return 'https://images.unsplash.com/photo-1579208030886-b1f24c25cf60?w=500';
      case 'Sides':
        return 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=500';
      case 'Drinks':
        return 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=500';
      case 'Desserts':
        return 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=500';
      default:
        return 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500';
    }
  }

  Color _getColor(String categoryName) {
    switch (categoryName) {
      case 'Meat':
        return const Color(0xFFE74C3C);
      case 'Fish & Chips':
        return const Color(0xFF3498DB);
      case 'Sides':
        return const Color(0xFFF39C12);
      case 'Drinks':
        return const Color(0xFF9B59B6);
      case 'Desserts':
        return const Color(0xFFE91E63);
      default:
        return AppColors.primary;
    }
  }

  IconData _getIcon(String categoryName) {
    switch (categoryName) {
      case 'Meat':
        return Icons.kebab_dining_rounded;
      case 'Fish & Chips':
        return Icons.set_meal_rounded;
      case 'Sides':
        return Icons.fastfood_rounded;
      case 'Drinks':
        return Icons.local_drink_rounded;
      case 'Desserts':
        return Icons.icecream_rounded;
      default:
        return Icons.restaurant_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Filter out "All" category - only show specific categories
    final categories = DemoCategories.categories
        .where((c) => c.name != 'All')
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Top bar
              _buildTopBar(size),

              // Title
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.02),
                child: Row(
                  children: [
                    Icon(Icons.restaurant_menu_rounded,
                        size: size.width * 0.05, color: AppColors.primary),
                    SizedBox(width: size.width * 0.02),
                    Text('Select Your Menu',
                        style: TextStyle(
                            fontSize: size.width * 0.045,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary)),
                  ],
                ),
              ),

              // Category grid
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(size.width * 0.04),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: size.width * 0.04,
                    mainAxisSpacing: size.width * 0.04,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return _buildCategoryCard(cat, size);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(Size size) {
    return Container(
      height: size.height * 0.08,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios_rounded,
                size: size.width * 0.045, color: AppColors.textPrimary),
          ),
          SizedBox(width: size.width * 0.03),
          Container(
            width: size.width * 0.08,
            height: size.width * 0.08,
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8)),
            child: Center(
                child: Icon(Icons.restaurant_rounded,
                    color: Colors.white, size: size.width * 0.045)),
          ),
          SizedBox(width: size.width * 0.03),
          Text('BURGER HOUSE',
              style: TextStyle(
                  fontSize: size.width * 0.038,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(category, Size size) {
    final color = _getColor(category.name);
    final itemCount = _getItemCount(category.name);
    final imageUrl = _getImage(category.name);

    return GestureDetector(
      onTap: () {
        // Navigate to menu screen with selected category
        Get.toNamed(AppRoutes.menu, arguments: {
          'orderType': 'eat_in', // or pass actual order type
          'selectedCategory': category.name,
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: color.withOpacity(0.1)),
              ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              // Content
              Padding(
                padding: EdgeInsets.all(size.width * 0.04),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      width: size.width * 0.1,
                      height: size.width * 0.1,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(_getIcon(category.name),
                          size: size.width * 0.05, color: Colors.white),
                    ),
                    SizedBox(height: size.height * 0.015),
                    // Category name
                    Text(category.name,
                        style: TextStyle(
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    SizedBox(height: size.height * 0.005),
                    // Item count
                    Text('$itemCount items',
                        style: TextStyle(
                            fontSize: size.width * 0.028,
                            color: Colors.white.withOpacity(0.8))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}