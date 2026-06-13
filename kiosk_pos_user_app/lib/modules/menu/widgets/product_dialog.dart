import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import '../../../config/theme.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/demo/demo_modifiers.dart';
import '../menu_controller.dart';

class ProductDialog {
  static void show(ProductModel product) {
    final size = MediaQuery.of(Get.context!).size;
    int quantity = 1;
    final selectedModifiers = <int, List<int>>{};
    final specialController = TextEditingController();

    for (final groupId in product.modifierGroupIds) {
      final group = DemoModifiers.getGroupById(groupId);
      if (group != null && group.isRequired && group.modifiers.isNotEmpty) {
        selectedModifiers[groupId] = [group.modifiers.first.id];
      }
    }

    double calcTotal() {
      double modTotal = 0;
      for (final entry in selectedModifiers.entries) {
        final group = DemoModifiers.getGroupById(entry.key);
        if (group != null) {
          for (final modId in entry.value) {
            try {
              final mod = group.modifiers.firstWhere((m) => m.id == modId);
              modTotal += mod.priceAdjustment;
            } catch (_) {}
          }
        }
      }
      return (product.basePrice + modTotal) * quantity;
    }

    Get.dialog(
      StatefulBuilder(
        builder: (context, setDialogState) {
          // Build modifier widgets list
          final List<Widget> modifierWidgets = [];
          for (final groupId in product.modifierGroupIds) {
            final group = DemoModifiers.getGroupById(groupId);
            if (group != null) {
              modifierWidgets.add(
                _buildModifierGroup(
                  group,
                  selectedModifiers[groupId] ?? [],
                      (ids) =>
                      setDialogState(() => selectedModifiers[groupId] = ids),
                  size,
                ),
              );
            }
          }

          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(size.width * 0.04),
            child: Container(
              constraints: BoxConstraints(maxHeight: size.height * 0.85),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header image
                  ClipRRect(
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                    child: Stack(
                      children: [
                        Container(
                          height: size.height * 0.2,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child:
                          Container(color: Colors.black.withOpacity(0.2)),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              padding: EdgeInsets.all(size.width * 0.02),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.close,
                                  color: Colors.white,
                                  size: size.width * 0.045),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Scrollable content
                  Flexible(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(size.width * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: TextStyle(
                                fontSize: size.width * 0.045,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: size.height * 0.005),
                          if (product.description != null)
                            Text(
                              product.description!,
                              style: TextStyle(
                                  fontSize: size.width * 0.03,
                                  color: Colors.grey.shade600),
                            ),
                          SizedBox(height: size.height * 0.02),
                          // Modifier groups
                          ...modifierWidgets,
                          SizedBox(height: size.height * 0.02),
                          Text(
                            'Special Instructions',
                            style: TextStyle(
                                fontSize: size.width * 0.032,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: size.height * 0.01),
                          TextField(
                            controller: specialController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: 'Any special requests?',
                              hintStyle:
                              TextStyle(fontSize: size.width * 0.03),
                            ),
                            style: TextStyle(fontSize: size.width * 0.033),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom bar
                  Container(
                    padding: EdgeInsets.all(size.width * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(24)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Quantity
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: quantity > 1
                                    ? () => setDialogState(() => quantity--)
                                    : null,
                                child: Padding(
                                  padding: EdgeInsets.all(size.width * 0.025),
                                  child: Icon(
                                    Icons.remove,
                                    size: size.width * 0.04,
                                    color: quantity > 1
                                        ? Colors.black
                                        : Colors.grey.shade300,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.04),
                                child: Text(
                                  '$quantity',
                                  style: TextStyle(
                                      fontSize: size.width * 0.04,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              InkWell(
                                onTap: () =>
                                    setDialogState(() => quantity++),
                                child: Padding(
                                  padding: EdgeInsets.all(size.width * 0.025),
                                  child: Icon(
                                    Icons.add,
                                    size: size.width * 0.04,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        // Add button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Close dialog FIRST
                              Get.back();

                              // Then add to cart
                              final mods = <SelectedModifier>[];
                              for (final entry
                              in selectedModifiers.entries) {
                                final group =
                                DemoModifiers.getGroupById(entry.key);
                                if (group != null) {
                                  for (final modId in entry.value) {
                                    try {
                                      final mod = group.modifiers
                                          .firstWhere((m) => m.id == modId);
                                      mods.add(SelectedModifier(
                                        modifierId: mod.id,
                                        groupName: group.name,
                                        modifierName: mod.name,
                                        priceAdjustment:
                                        mod.priceAdjustment,
                                      ));
                                    } catch (_) {}
                                  }
                                }
                              }
                              Get.find<MenuController>().addToCart(
                                CartItemModel(
                                  id: DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                                  productId: product.id,
                                  productName: product.name,
                                  basePrice: product.basePrice,
                                  quantity: quantity,
                                  selectedModifiers: mods,
                                  specialInstructions: specialController
                                      .text.isNotEmpty
                                      ? specialController.text
                                      : null,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              minimumSize:
                              Size(double.infinity, size.height * 0.06),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'ADD',
                                  style: TextStyle(
                                      fontSize: size.width * 0.035,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: size.width * 0.02),
                                Text(
                                  '\$${calcTotal().toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontSize: size.width * 0.035,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      barrierDismissible: true,
    );
  }

  static Widget _buildModifierGroup(
      dynamic group,
      List<int> selectedIds,
      Function(List<int>) onChanged,
      Size size,
      ) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                group.name,
                style: TextStyle(
                    fontSize: size.width * 0.034,
                    fontWeight: FontWeight.w600),
              ),
              if (group.isRequired)
                Text(
                  ' *',
                  style: TextStyle(
                      fontSize: size.width * 0.034,
                      color: AppColors.error),
                ),
            ],
          ),
          SizedBox(height: size.height * 0.01),
          Wrap(
            spacing: size.width * 0.02,
            runSpacing: size.width * 0.02,
            children: group.modifiers.map<Widget>((mod) {
              final isSelected = selectedIds.contains(mod.id);
              return GestureDetector(
                onTap: () {
                  List<int> newIds;
                  if (group.selectionType == 'single') {
                    newIds = [mod.id];
                  } else {
                    newIds = List.from(selectedIds);
                    if (isSelected) {
                      newIds.remove(mod.id);
                    } else {
                      newIds.add(mod.id);
                    }
                  }
                  onChanged(newIds);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.03,
                      vertical: size.height * 0.012),
                  decoration: BoxDecoration(
                    color:
                    isSelected ? AppColors.primary : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected
                        ? null
                        : Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    '${mod.name}${mod.priceAdjustment > 0 ? ' +\$${mod.priceAdjustment.toStringAsFixed(2)}' : ''}',
                    style: TextStyle(
                        fontSize: size.width * 0.028,
                        fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? Colors.white
                            : Colors.grey.shade700),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}