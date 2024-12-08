import 'package:flutter/material.dart';

class CategoryModel { 
  String name;
  String iconPath;
  Color boxColor;

  CategoryModel({
    required this.name,
    required this.iconPath,
    required this.boxColor
  });

  static List<CategoryModel> getCategories() {
    List<CategoryModel> categories = [];

    categories.add(
      CategoryModel(
        name: 'Salad', 
        iconPath: 'assets/icons/salad.svg', 
        boxColor: const Color.fromARGB(255, 120, 118, 255)
      )
    );

    categories.add(
      CategoryModel(
        name: 'Cake', 
        iconPath: 'assets/icons/cake.svg', 
        boxColor: const Color.fromARGB(255, 241, 118, 255)
      )
    );

    categories.add(
      CategoryModel(
        name: 'Hot Dog', 
        iconPath: 'assets/icons/hotdog.svg', 
        boxColor: const Color.fromARGB(255, 120, 118, 255)
      )
    );

    categories.add(
      CategoryModel(
        name: 'Sushi', 
        iconPath: 'assets/icons/sushi.svg', 
        boxColor: const Color.fromARGB(255, 241, 118, 255)
      )
    );

    return categories;
  }

}