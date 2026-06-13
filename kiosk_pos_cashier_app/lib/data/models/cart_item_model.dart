class SelectedModifier {
  final int modifierId;
  final String groupName;
  final String modifierName;
  final double priceAdjustment;

  SelectedModifier({
    required this.modifierId,
    required this.groupName,
    required this.modifierName,
    required this.priceAdjustment,
  });
}

class CartItemModel {
  final String id;
  final int productId;
  final String productName;
  final String? productImage;
  final double basePrice;
  int quantity;
  final List<SelectedModifier> selectedModifiers;
  final String? specialInstructions;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    this.productImage,
    required this.basePrice,
    this.quantity = 1,
    this.selectedModifiers = const [],
    this.specialInstructions,
  });

  double get totalPrice {
    final modTotal =
    selectedModifiers.fold(0.0, (sum, m) => sum + m.priceAdjustment);
    return (basePrice + modTotal) * quantity;
  }

  String get modifiersSummary {
    if (selectedModifiers.isEmpty) return '';
    return selectedModifiers.map((m) => m.modifierName).join(', ');
  }
}