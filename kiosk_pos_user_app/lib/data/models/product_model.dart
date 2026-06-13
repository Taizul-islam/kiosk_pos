class ProductModel {
  final int id;
  final int categoryId;
  final String categoryName;
  final String name;
  final String? description;
  final String? imageUrl;
  final double basePrice;
  final bool isAvailable;
  final int displayOrder;
  final List<int> modifierGroupIds;

  ProductModel({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.name,
    this.description,
    this.imageUrl,
    required this.basePrice,
    this.isAvailable = true,
    this.displayOrder = 0,
    this.modifierGroupIds = const [],
  });
}