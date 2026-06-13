import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import '../../../config/theme.dart';
import '../menu_controller.dart';

class CategorySidebar extends GetView<MenuController> {
  const CategorySidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Obx(() {
      return Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
          children: controller.categories.map((category) {
            final isSelected = controller.selectedCategory.value == category;
            final color = _getColor(category);
            final imageUrl = _getImage(category);

            return GestureDetector(
              onTap: () => controller.selectCategory(category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(
                    horizontal: size.width * 0.02,
                    vertical: size.height * 0.005),
                height: size.height * 0.09,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: isSelected
                      ? Border.all(color: color, width: 2.5)
                      : Border.all(color: Colors.transparent, width: 2.5),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2))
                  ]
                      : [],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Full background image
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: color.withOpacity(0.15),
                        ),
                      ),

                      // Dark gradient overlay at bottom for text readability
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.1),
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),

                      // Category name at bottom
                      Positioned(
                        bottom: size.height * 0.008,
                        left: size.width * 0.02,
                        right: size.width * 0.02,
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: size.width * 0.03,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Selection indicator - small colored dot at top right
                      if (isSelected)
                        Positioned(
                          top: size.height * 0.008,
                          right: size.width * 0.015,
                          child: Container(
                            width: size.width * 0.025,
                            height: size.width * 0.025,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white, width: 1.5),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  String _getImage(String category) {
    switch (category) {
      case 'Meat':
        return 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200';
      case 'Fish & Chips':
        return 'https://images.unsplash.com/photo-1579208030886-b1f24c25cf60?w=200';
      case 'Sides':
        return 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=200';
      case 'Drinks':
        return 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=200';
      case 'Desserts':
        return 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=200';
      default:
        return 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=200';
    }
  }

  Color _getColor(String category) {
    switch (category) {
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
}