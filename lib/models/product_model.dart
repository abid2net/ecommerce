import 'package:equatable/equatable.dart';
import 'package:ecommerce/models/category_model.dart';
import 'package:flutter/material.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final String? description;
  final double price;
  final List<String> images;
  final CategoryModel category;
  final String brand;
  final int? quantity;
  final double rating;
  final int reviewCount;

  const ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.images = const [],
    required this.category,
    required this.brand,
    this.quantity,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    images,
    category,
    brand,
    quantity,
    rating,
    reviewCount,
  ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'images': images,
      'category': category.toMap(),
      'brand': brand,
      'quantity': quantity,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      price: (map['price'] as num).toDouble(),
      images: List<String>.from(map['images'] ?? []),
      category:
          map['category'] is String
              ? CategoryModel(
                id: '',
                name: map['category'],
                displayName: map['category'],
                icon: Icons.info,
              )
              : CategoryModel.fromMap(map['category'] as Map<String, dynamic>),
      brand: (map['brand'] ?? '') as String,
      quantity: map['quantity'] as int?,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (map['reviewCount'] as int?) ?? 0,
    );
  }

  ProductModel copyWith({
    String? id,
    String? name,
    double? price,
    List<String>? images,
    String? description,
    String? brand,
    CategoryModel? category,
    int? quantity,
    double? rating,
    int? reviewCount,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      images: images ?? this.images,
      description: description ?? this.description,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }
}
