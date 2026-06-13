class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final int displayOrder;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.displayOrder = 0,
    this.isActive = true,
  });
}