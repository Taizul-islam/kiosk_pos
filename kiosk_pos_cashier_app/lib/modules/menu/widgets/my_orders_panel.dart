import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import '../../../config/theme.dart';
import '../../../app/routes.dart';
import '../../../utils/formatters.dart';
import '../menu_controller.dart';

class MyOrdersPanel extends GetView<MenuController> {
  const MyOrdersPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Obx(() {
      final items = controller.cartItems;
      final total = controller.cartTotal;
      final hasItems = items.isNotEmpty;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04,
                vertical: size.height * 0.008,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.receipt_long_rounded,
                          size: size.width * 0.035,
                          color: AppColors.primary),
                      SizedBox(width: size.width * 0.015),
                      Text(
                        'MY ORDERS',
                        style: TextStyle(
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      if (hasItems) ...[
                        SizedBox(width: size.width * 0.015),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.015,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${controller.cartItemCount}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * 0.02,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    'Total: ${Formatters.currency(total)}',
                    style: TextStyle(
                      fontSize: size.width * 0.032,
                      fontWeight: FontWeight.bold,
                      color:
                      hasItems ? AppColors.primary : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            if (hasItems)
              Container(height: 1, color: Colors.grey.shade200),

            // Empty state
            if (!hasItems)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: size.height * 0.008,
                ),
                child: Text(
                  'Select items from the menu to start your order',
                  style: TextStyle(
                    fontSize: size.width * 0.026,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),

            // Items list
            if (hasItems)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: size.height * 0.004,
                ),
                itemCount: items.length > 2 ? 2 : items.length,
                itemBuilder: (_, index) =>
                    _buildItem(items[index], index, size),
              ),

            // Buttons
            if (hasItems) ...[
              Container(height: 1, color: Colors.grey.shade200),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03,
                  vertical: size.height * 0.006,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showCancelDialog(size),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.012),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'CANCEL',
                          style: TextStyle(
                            fontSize: size.width * 0.028,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: size.width * 0.03),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.toNamed(AppRoutes.cart),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          minimumSize: Size.zero,
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.012),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'PLACE ORDER',
                          style: TextStyle(
                            fontSize: size.width * 0.028,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildItem(dynamic item, int index, Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.003),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  '${item.quantity}x',
                  style: TextStyle(
                    fontSize: size.width * 0.026,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(width: size.width * 0.015),
                Expanded(
                  child: Text(
                    item.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: size.width * 0.026,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                if (item.modifiersSummary.isNotEmpty) ...[
                  SizedBox(width: size.width * 0.01),
                  Flexible(
                    child: Text(
                      '(${item.modifiersSummary})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: size.width * 0.022,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: size.width * 0.02),
          Text(
            Formatters.currency(item.totalPrice),
            style: TextStyle(
              fontSize: size.width * 0.026,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: size.width * 0.015),
          GestureDetector(
            onTap: () => _showEditDialog(item, index, size),
            child: Icon(
              Icons.edit_outlined,
              size: size.width * 0.03,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(dynamic item, int index, Size size) {
    int qty = item.quantity;
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.05),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.productName,
                style: TextStyle(
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (qty > 1) qty--;
                      Get.back();
                      controller.updateQuantity(index, qty);
                    },
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text(
                    '$qty',
                    style: TextStyle(
                        fontSize: size.width * 0.06,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      qty++;
                      Get.back();
                      controller.updateQuantity(index, qty);
                    },
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),
              TextButton(
                onPressed: () {
                  controller.removeFromCart(index);
                  Get.back();
                },
                child: Text(
                  'Remove item',
                  style: TextStyle(
                      color: AppColors.error,
                      fontSize: size.width * 0.035),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(Size size) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Cancel Order?',
            style: TextStyle(fontSize: size.width * 0.04)),
        content: Text(
          'Clear all items from your order?',
          style: TextStyle(fontSize: size.width * 0.033),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('No', style: TextStyle(fontSize: size.width * 0.033)),
          ),
          ElevatedButton(
            onPressed: () {
              controller.clearCart();
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(
              'Yes, Clear All',
              style: TextStyle(
                  fontSize: size.width * 0.033, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}