import 'package:flutter/material.dart';

import '../models/dish.dart';

class MenuCategory {
  const MenuCategory(this.name, this.icon);

  final String name;
  final IconData icon;
}

const allCategory = 'All';

const categories = [
  MenuCategory(allCategory, Icons.restaurant_menu),
  MenuCategory('Starters', Icons.tapas),
  MenuCategory('Mains', Icons.dinner_dining),
  MenuCategory('Biryani', Icons.rice_bowl),
  MenuCategory('Desserts', Icons.icecream),
  MenuCategory('Drinks', Icons.local_cafe),
];

const dishes = [
  Dish(
    name: 'Paneer Tikka',
    description: 'Char-grilled cottage cheese marinated in yoghurt and spices.',
    price: 249,
    imagePath: 'assets/images/dish1.jpg',
    category: 'Starters',
    isBestseller: true,
  ),
  Dish(
    name: 'Chicken 65',
    description: 'Crispy deep-fried chicken tossed with curry leaves and chillies.',
    price: 279,
    imagePath: 'assets/images/dish2.jpg',
    category: 'Starters',
    isVeg: false,
  ),
  Dish(
    name: 'Butter Chicken',
    description: 'Tandoori chicken simmered in a rich tomato and butter gravy.',
    price: 349,
    imagePath: 'assets/images/dish3.jpg',
    category: 'Mains',
    isBestseller: true,
    isVeg: false,
  ),
  Dish(
    name: 'Dal Makhani',
    description: 'Black lentils slow-cooked overnight with cream and butter.',
    price: 229,
    imagePath: 'assets/images/dish4.jpg',
    category: 'Mains',
  ),
  Dish(
    name: 'Hyderabadi Dum Biryani',
    description: 'Basmati rice and marinated mutton layered and cooked on dum.',
    price: 399,
    imagePath: 'assets/images/dish5.jpg',
    category: 'Biryani',
    isBestseller: true,
    isVeg: false,
  ),
  Dish(
    name: 'Veg Biryani',
    description: 'Fragrant rice with seasonal vegetables, saffron and fried onions.',
    price: 279,
    imagePath: 'assets/images/dish6.jpg',
    category: 'Biryani',
  ),
  Dish(
    name: 'Gulab Jamun',
    description: 'Soft milk dumplings soaked in warm cardamom syrup.',
    price: 119,
    imagePath: 'assets/images/dish7.jpg',
    category: 'Desserts',
  ),
  Dish(
    name: 'Masala Chai',
    description: 'Strong tea brewed with milk, ginger and cardamom.',
    price: 59,
    imagePath: 'assets/images/dish8.jpg',
    category: 'Drinks',
    isBestseller: true,
  ),
];
