import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/screens/home/home_screen.dart';
import 'package:ecommerce/screens/product/product_management_screen.dart';
import 'package:ecommerce/screens/product/product_form_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String home = '/home';
  static const String productManagement = '/products';
  static const String productAdd = '/products/add';
  static const String productEdit = '/products/edit';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      productManagement: (context) => const ProductManagementScreen(),
      productAdd: (context) => const ProductFormScreen(),
      productEdit: (context) {
        final product =
            ModalRoute.of(context)!.settings.arguments as ProductModel;
        return ProductFormScreen(isEditing: true, product: product);
      },
    };
  }
}
