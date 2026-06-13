import '../models/category_model.dart';

class DemoCategories {
  static List<CategoryModel> get categories => [
    CategoryModel(id: 0, name: 'All', slug: 'all', displayOrder: 0),
    CategoryModel(id: 1, name: 'Meat', slug: 'meat', displayOrder: 1),
    CategoryModel(id: 2, name: 'Fish & Chips', slug: 'fish-chips', displayOrder: 2),
    CategoryModel(id: 3, name: 'Sides', slug: 'sides', displayOrder: 3),
    CategoryModel(id: 4, name: 'Drinks', slug: 'drinks', displayOrder: 4),
    CategoryModel(id: 5, name: 'Desserts', slug: 'desserts', displayOrder: 5),
  ];
}