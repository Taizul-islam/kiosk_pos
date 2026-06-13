import '../models/modifier_model.dart';

class DemoModifiers {
  static ModifierGroupModel get sizeGroup => ModifierGroupModel(
    id: 1, name: 'Size', selectionType: 'single', isRequired: true, displayOrder: 1,
    modifiers: [
      ModifierModel(id: 1, groupId: 1, name: 'Regular', priceAdjustment: 0.00, displayOrder: 1),
      ModifierModel(id: 2, groupId: 1, name: 'Medium', priceAdjustment: 2.00, displayOrder: 2),
      ModifierModel(id: 3, groupId: 1, name: 'Large', priceAdjustment: 4.00, displayOrder: 3),
    ],
  );

  static ModifierGroupModel get toppingsGroup => ModifierGroupModel(
    id: 2, name: 'Extra Toppings', selectionType: 'multiple', isRequired: false, displayOrder: 2,
    modifiers: [
      ModifierModel(id: 4, groupId: 2, name: 'Extra Cheese', priceAdjustment: 1.50, displayOrder: 1),
      ModifierModel(id: 5, groupId: 2, name: 'Bacon', priceAdjustment: 2.00, displayOrder: 2),
      ModifierModel(id: 6, groupId: 2, name: 'Avocado', priceAdjustment: 2.50, displayOrder: 3),
      ModifierModel(id: 7, groupId: 2, name: 'Fried Egg', priceAdjustment: 1.50, displayOrder: 4),
      ModifierModel(id: 8, groupId: 2, name: 'Jalapeños', priceAdjustment: 0.50, displayOrder: 5),
    ],
  );

  static ModifierGroupModel get portionSizeGroup => ModifierGroupModel(
    id: 3, name: 'Size', selectionType: 'single', isRequired: true, displayOrder: 1,
    modifiers: [
      ModifierModel(id: 9, groupId: 3, name: 'Small', priceAdjustment: 0.00, displayOrder: 1),
      ModifierModel(id: 10, groupId: 3, name: 'Medium', priceAdjustment: 1.50, displayOrder: 2),
      ModifierModel(id: 11, groupId: 3, name: 'Large', priceAdjustment: 3.00, displayOrder: 3),
    ],
  );

  static ModifierGroupModel get flavorGroup => ModifierGroupModel(
    id: 4, name: 'Flavor', selectionType: 'single', isRequired: true, displayOrder: 2,
    modifiers: [
      ModifierModel(id: 12, groupId: 4, name: 'Original', priceAdjustment: 0.00, displayOrder: 1),
      ModifierModel(id: 13, groupId: 4, name: 'Spicy', priceAdjustment: 0.00, displayOrder: 2),
      ModifierModel(id: 14, groupId: 4, name: 'BBQ', priceAdjustment: 0.50, displayOrder: 3),
      ModifierModel(id: 15, groupId: 4, name: 'Garlic Parmesan', priceAdjustment: 0.50, displayOrder: 4),
    ],
  );

  static ModifierGroupModel get sauceGroup => ModifierGroupModel(
    id: 5, name: 'Dipping Sauce', selectionType: 'multiple', isRequired: false, displayOrder: 3,
    modifiers: [
      ModifierModel(id: 16, groupId: 5, name: 'Ketchup', priceAdjustment: 0.00, displayOrder: 1),
      ModifierModel(id: 17, groupId: 5, name: 'Mayo', priceAdjustment: 0.00, displayOrder: 2),
      ModifierModel(id: 18, groupId: 5, name: 'Ranch', priceAdjustment: 0.00, displayOrder: 3),
      ModifierModel(id: 19, groupId: 5, name: 'BBQ', priceAdjustment: 0.00, displayOrder: 4),
    ],
  );

  static List<ModifierGroupModel> get allGroups => [
    sizeGroup, toppingsGroup, portionSizeGroup, flavorGroup, sauceGroup,
  ];

  static ModifierGroupModel? getGroupById(int id) {
    try {
      return allGroups.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }
}