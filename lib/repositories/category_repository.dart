import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/common/constants/firebase_constants.dart';
import 'package:ecommerce/models/category_model.dart';
import 'package:flutter/material.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _categoriesRef;

  CategoryRepository()
    : _categoriesRef = FirebaseFirestore.instance.collection(
        FirebaseConstants.categories,
      );

  Stream<List<CategoryModel>> getCategories() {
    return _categoriesRef
        .orderBy(FirebaseConstants.name)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => CategoryModel.fromMap({
                      'id': doc.id,
                      ...doc.data() as Map<String, dynamic>,
                    }),
                  )
                  .toList(),
        );
  }

  Future<void> addCategory(CategoryModel category) async {
    try {
      await _categoriesRef.doc(category.id).set({
        'name': category.name,
        'displayName': category.displayName,
        'icon': category.icon.codePoint,
        'isActive': category.isActive,
      });
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }

  Future<void> updateCategory(CategoryModel category) async {
    try {
      await _categoriesRef.doc(category.id).update({
        'name': category.name,
        'displayName': category.displayName,
        'icon': category.icon.codePoint,
        'isActive': category.isActive,
      });
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await _categoriesRef.doc(categoryId).delete();
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }

  // Initial categories to seed the database
  Future<void> seedInitialCategories() async {
    try {
      final categories = [
        CategoryModel(
          id: 'electronics',
          name: 'electronics',
          displayName: 'Electronics',
          icon: Icons.devices,
        ),
        CategoryModel(
          id: 'clothing',
          name: 'clothing',
          displayName: 'Clothing',
          icon: Icons.checkroom,
        ),
        CategoryModel(
          id: 'automotive',
          name: 'automotive',
          displayName: 'Automotive',
          icon: Icons.directions_car,
        ),
        CategoryModel(
          id: 'tyres',
          name: 'tyres',
          displayName: 'Tyres',
          icon: Icons.tire_repair,
        ),
      ];

      final batch = _firestore.batch();
      for (var category in categories) {
        batch.set(_categoriesRef.doc(category.id), {
          'name': category.name,
          'displayName': category.displayName,
          'icon': category.icon.codePoint,
          'isActive': category.isActive,
        }, SetOptions(merge: true));
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to seed categories: $e');
    }
  }
}
