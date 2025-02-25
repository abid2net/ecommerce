import 'package:equatable/equatable.dart';
import 'package:ecommerce/models/category_model.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final String? description;
  final double price;
  final List<String> images;
  final ProductCategory category;
  final int? quantity;

  const ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.images = const [],
    required this.category,
    this.quantity,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    images,
    category,
    quantity,
  ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'images': images,
      'category': category.name,
      'quantity': quantity,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      price: (map['price'] as num).toDouble(),
      images: List<String>.from(map['images'] ?? []),
      category: ProductCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => ProductCategory.tyres,
      ),
      quantity: map['quantity'] as int?,
    );
  }
}
