import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import '../../config/theme.dart';
import '../../app/routes.dart';
import '../../utils/formatters.dart';
import '../menu/menu_controller.dart';

class CartScreen extends GetView<MenuController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(size),
            Expanded(child: _buildItemsList(size)),
            _buildBottomSection(size),
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
            return Stack(
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
            );
          }),
        ],
      ),
    );
  }

  Widget _buildItemsList(Size size) {
    return Obx(() {
      final items = controller.cartItems;
      if (items.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt_long_outlined,
                  size: size.width * 0.15, color: Colors.grey.shade300),
              SizedBox(height: size.height * 0.02),
              Text('Your order is empty',
                  style: TextStyle(
                      fontSize: size.width * 0.04,
                      color: Colors.grey.shade500)),
              SizedBox(height: size.height * 0.02),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: Text('Back to Menu',
                    style: TextStyle(fontSize: size.width * 0.035)),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(size.width * 0.04),
            child: Row(
              children: [
                Icon(Icons.receipt_long_rounded,
                    size: size.width * 0.045, color: AppColors.primary),
                SizedBox(width: size.width * 0.02),
                Text('MY ORDERS',
                    style: TextStyle(
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              itemCount: items.length,
              itemBuilder: (context, index) =>
                  _buildItemCard(items[index], index, size),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildItemCard(item, int index, Size size) {
    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.015),
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width * 0.12,
                height: size.width * 0.12,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: NetworkImage(
                        'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.productName,
                        style: TextStyle(
                            fontSize: size.width * 0.036,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary)),
                    if (item.modifiersSummary.isNotEmpty) ...[
                      SizedBox(height: size.height * 0.005),
                      Text(item.modifiersSummary,
                          style: TextStyle(
                              fontSize: size.width * 0.028,
                              color: Colors.grey.shade500)),
                    ],
                    if (item.specialInstructions != null &&
                        item.specialInstructions!.isNotEmpty) ...[
                      SizedBox(height: size.height * 0.005),
                      Row(children: [
                        Text('📝 ',
                            style: TextStyle(fontSize: size.width * 0.026)),
                        Expanded(
                            child: Text(item.specialInstructions!,
                                style: TextStyle(
                                    fontSize: size.width * 0.026,
                                    color: Colors.orange.shade700,
                                    fontStyle: FontStyle.italic))),
                      ]),
                    ],
                  ],
                ),
              ),
              Text(Formatters.currency(item.totalPrice),
                  style: TextStyle(
                      fontSize: size.width * 0.036,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary)),
            ],
          ),
          SizedBox(height: size.height * 0.015),
          Container(height: 1, color: Colors.grey.shade200),
          SizedBox(height: size.height * 0.012),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (item.quantity > 1)
                          controller.updateQuantity(
                              index, item.quantity - 1);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: EdgeInsets.all(size.width * 0.025),
                        child: Icon(Icons.remove,
                            size: size.width * 0.04,
                            color: item.quantity > 1
                                ? AppColors.textPrimary
                                : Colors.grey.shade300),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04),
                      child: Text('${item.quantity}',
                          style: TextStyle(
                              fontSize: size.width * 0.038,
                              fontWeight: FontWeight.bold)),
                    ),
                    InkWell(
                      onTap: () => controller.updateQuantity(
                          index, item.quantity + 1),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: EdgeInsets.all(size.width * 0.025),
                        child: Icon(Icons.add,
                            size: size.width * 0.04,
                            color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => controller.removeFromCart(index),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.04,
                      vertical: size.height * 0.012),
                  decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    Icon(Icons.delete_outline_rounded,
                        size: size.width * 0.04, color: AppColors.error),
                    SizedBox(width: size.width * 0.015),
                    Text('Remove',
                        style: TextStyle(
                            fontSize: size.width * 0.03,
                            color: AppColors.error,
                            fontWeight: FontWeight.w500)),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(Size size) {
    return Obx(() {
      final items = controller.cartItems;
      if (items.isEmpty) return const SizedBox.shrink();

      final subtotal = controller.cartSubtotal;
      final tax = controller.cartTax;
      final total = controller.cartTotal;

      return Container(
        padding: EdgeInsets.all(size.width * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -3))
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTotalRow('Subtotal', subtotal, size),
              SizedBox(height: size.height * 0.008),
              _buildTotalRow('Tax (15%)', tax, size),
              SizedBox(height: size.height * 0.008),
              Container(height: 1, color: Colors.grey.shade200),
              SizedBox(height: size.height * 0.01),
              _buildTotalRow('TOTAL', total, size, isBold: true),
              SizedBox(height: size.height * 0.015),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showCancelDialog(size),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, size.height * 0.06),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text('CANCEL',
                        style: TextStyle(
                            fontSize: size.width * 0.035,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(width: size.width * 0.03),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.toNamed(AppRoutes.payment),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      minimumSize: Size(double.infinity, size.height * 0.06),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('PROCEED',
                          style: TextStyle(
                              fontSize: size.width * 0.038,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTotalRow(String label, double amount, Size size,
      {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: size.width * (isBold ? 0.04 : 0.032),
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: isBold
                    ? AppColors.textPrimary
                    : Colors.grey.shade600)),
        Text(Formatters.currency(amount),
            style: TextStyle(
                fontSize: size.width * (isBold ? 0.042 : 0.032),
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color:
                isBold ? AppColors.primary : AppColors.textPrimary)),
      ],
    );
  }

  void _showCancelDialog(Size size) {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Cancel Order?',
          style: TextStyle(fontSize: size.width * 0.04)),
      content: Text('Are you sure you want to clear all items?',
          style: TextStyle(fontSize: size.width * 0.033)),
      actions: [
        TextButton(
            onPressed: () => Get.back(),
            child: Text('No, Keep Order',
                style: TextStyle(fontSize: size.width * 0.033))),
        ElevatedButton(
            onPressed: () {
              controller.clearCart();
              Get.back();
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text('Yes, Cancel',
                style: TextStyle(
                    fontSize: size.width * 0.033, color: Colors.white))),
      ],
    ));
  }
}