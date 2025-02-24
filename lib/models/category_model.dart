import 'package:flutter/material.dart';

enum ProductCategory {
  electronics,
  clothing,
  books,
  food,
  automotive,
  furniture,
  tyres,
  toys,
  tools,
  other;

  String get displayName => name[0].toUpperCase() + name.substring(1);

  IconData get categoryIcon {
    switch (this) {
      case ProductCategory.electronics:
        return Icons.devices;
      case ProductCategory.clothing:
        return Icons.checkroom;
      case ProductCategory.books:
        return Icons.book;
      case ProductCategory.food:
        return Icons.restaurant;
      case ProductCategory.automotive:
        return Icons.directions_car;
      case ProductCategory.furniture:
        return Icons.chair;
      case ProductCategory.tyres:
        return Icons.tire_repair;
      case ProductCategory.toys:
        return Icons.toys;
      case ProductCategory.tools:
        return Icons.handyman;
      default:
        return Icons.category;
    }
  }
}
