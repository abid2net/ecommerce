import 'package:equatable/equatable.dart';
import 'package:ecommerce/models/category_model.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  final ProductCategory category;

  const ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    required this.category,
  });

  @override
  List<Object?> get props => [id, name, description, price, imageUrl, category];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category.name,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      price: (map['price'] as num).toDouble(),
      imageUrl: map['imageUrl'] as String?,
      category: ProductCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => ProductCategory.tyres,
      ),
    );
  }
}
