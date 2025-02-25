import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'E-Commerce App';
  static const String currency = '\$';

  // Route names
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String profile = '/profile';
  static const String products = '/products';
  static const String categories = '/categories';

  // Asset paths
  static const String defaultProductImage = 'assets/images/placeholder.png';
  static const String logoPath = 'assets/images/logo.png';

  // API endpoints
  static const int pageSize = 10;

  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const double maxPrice = 999999.99;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  // Loading Animation
  static const List<Color> loadingColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];
}
