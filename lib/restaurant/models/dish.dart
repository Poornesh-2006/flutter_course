class Dish {
  const Dish({
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.category,
    this.isBestseller = false,
    this.isVeg = true,
  });

  final String name;
  final String description;
  final double price;
  final String imagePath;
  final String category;
  final bool isBestseller;
  final bool isVeg;
}
