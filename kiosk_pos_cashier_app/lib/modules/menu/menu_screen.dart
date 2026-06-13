import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import '../../config/theme.dart';
import '../../app/routes.dart';
import 'menu_controller.dart';
import 'widgets/category_sidebar.dart';
import 'widgets/product_grid.dart';
import 'widgets/my_orders_panel.dart';

class MenuScreen extends GetView<MenuController> {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Get selected category from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['selectedCategory'] != null) {
      controller.selectCategory(args['selectedCategory']);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(size),
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                      width: size.width * 0.28,
                      child: const CategorySidebar()),
                  Container(width: 1, color: Colors.grey.shade200),
                  const Expanded(child: ProductGrid()),
                ],
              ),
            ),
            const MyOrdersPanel(),
          ],
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
          const Spacer(),
          Obx(() {
            final count = controller.cartItemCount;
            return GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.cart),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.shopping_bag_outlined,
                      size: size.width * 0.055, color: AppColors.textPrimary),
                  if (count > 0)
                    Positioned(
                      right: -6,
                      top: -4,
                      child: Container(
                        padding: EdgeInsets.all(size.width * 0.008),
                        decoration: const BoxDecoration(
                            color: AppColors.primary, shape: BoxShape.circle),
                        child: Text('$count',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.022,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}