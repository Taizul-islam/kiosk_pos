import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import '../../../config/theme.dart';
import '../menu_controller.dart';
import 'product_dialog.dart';

class ProductGrid extends GetView<MenuController> {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Obx(() {
      final items = controller.filteredProducts;
      if (items.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.restaurant_menu_rounded,
                  size: size.width * 0.1, color: Colors.grey.shade300),
              SizedBox(height: size.height * 0.02),
              Text('No items in this category',
                  style: TextStyle(
                      fontSize: size.width * 0.035,
                      color: Colors.grey.shade500)),
            ],
          ),
        );
      }

      return GridView.builder(
        padding: EdgeInsets.all(size.width * 0.04),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Always 2 columns
          childAspectRatio: 0.72,
          crossAxisSpacing: size.width * 0.04,
          mainAxisSpacing: size.width * 0.04,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) => _buildCard(items[index], size),
      );
    });
  }

  Widget _buildCard(product, Size size) {
    final color = _getColor(product.categoryName);
    final images = {
      'Meat':
      'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500',
      'Fish & Chips':
      'https://images.unsplash.com/photo-1579208030886-b1f24c25cf60?w=500',
      'Sides':
      'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=500',
      'Drinks':
      'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=500',
      'Desserts':
      'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=500',
    };

    // Card width = (available width - padding - spacing) / 2
    final cardWidth = (size.width * 0.72 - size.width * 0.12) / 2;
    // Card height based on aspect ratio
    final cardHeight = cardWidth / 0.72;

    return GestureDetector(
      onTap: () => ProductDialog.show(product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      images[product.categoryName] ??
                          'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: color.withOpacity(0.1),
                        child: Center(
                            child: Icon(_getIcon(product.categoryName),
                                size: cardWidth * 0.2, color: color)),
                      ),
                    ),
                    // Price tag
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: cardWidth * 0.05,
                            vertical: cardHeight * 0.008),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4)
                          ],
                        ),
                        child: Text(
                          '\$${product.basePrice.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: cardWidth * 0.09,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary),
                        ),
                      ),
                    ),
                    // Category badge at bottom left
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: cardWidth * 0.04,
                            vertical: cardHeight * 0.006),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          product.categoryName,
                          style: TextStyle(
                            fontSize: cardWidth * 0.06,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(cardWidth * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: cardWidth * 0.08,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.2),
                    ),
                    if (product.description != null) ...[
                      SizedBox(height: cardHeight * 0.01),
                      Text(
                        product.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: cardWidth * 0.065,
                            color: Colors.grey.shade500),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor(String cat) {
    switch (cat) {
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

  IconData _getIcon(String cat) {
    switch (cat) {
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
}