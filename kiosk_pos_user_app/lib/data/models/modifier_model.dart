class ModifierGroupModel {
  final int id;
  final String name;
  final String selectionType;
  final bool isRequired;
  final int displayOrder;
  final List<ModifierModel> modifiers;

  ModifierGroupModel({
    required this.id,
    required this.name,
    required this.selectionType,
    this.isRequired = false,
    this.displayOrder = 0,
    this.modifiers = const [],
  });
}

class ModifierModel {
  final int id;
  final int groupId;
  final String name;
  final double priceAdjustment;
  final int displayOrder;

  ModifierModel({
    required this.id,
    required this.groupId,
    required this.name,
    this.priceAdjustment = 0.00,
    this.displayOrder = 0,
  });
}