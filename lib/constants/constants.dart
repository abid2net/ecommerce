import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'E-Commerce App';
  static const String appVersion = '1.0.0';

  // API Endpoints
  static const String baseUrl = 'https://api.example.com';

  // Storage Paths
  static const String profilePicturePath = 'profile_pictures';

  // Collection Names
  static const String usersCollection = 'users';
  static const String productsCollection = 'products';
  static const String ordersCollection = 'orders';

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

  // Sizes
  static const double borderRadius = 12.0;
  static const double defaultPadding = 16.0;
  static const double profilePictureSize = 100.0;

  // Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 2);

  // Validation
  static const int minPasswordLength = 6;
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phoneRegex = r'^\+?[0-9]{10,}$';

  // Error Messages
  static const String defaultErrorMessage = 'Something went wrong';
  static const String networkErrorMessage =
      'Please check your internet connection';
  static const String invalidEmailMessage =
      'Please enter a valid email address';
  static const String invalidPasswordMessage =
      'Password must be at least 6 characters';
  static const String passwordMismatchMessage = 'Passwords do not match';

  // Success Messages
  static const String profileUpdateSuccess = 'Profile updated successfully';
  static const String passwordUpdateSuccess = 'Password updated successfully';
}
