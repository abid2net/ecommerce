import 'package:ecommerce/models/product_model.dart';

class VoucherModel {
  final String id;
  final String code;
  final String description;
  final double percentage;
  final bool isActive;
  final DateTime? expiryDate;
  final List<String>
  validCategories; // List of category IDs where discount applies

  const VoucherModel({
    required this.id,
    required this.code,
    required this.description,
    required this.percentage,
    this.isActive = true,
    this.expiryDate,
    this.validCategories =
        const [], // Empty list means valid for all categories
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'description': description,
      'percentage': percentage,
      'isActive': isActive,
      'expiryDate': expiryDate?.millisecondsSinceEpoch,
      'validCategories': validCategories,
    };
  }

  factory VoucherModel.fromMap(Map<String, dynamic> map) {
    return VoucherModel(
      id: map['id'] as String,
      code: map['code'] as String,
      description: map['description'] as String,
      percentage: (map['percentage'] as num).toDouble(),
      isActive: map['isActive'] as bool,
      expiryDate:
          map['expiryDate'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['expiryDate'] as int)
              : null,
      validCategories: List<String>.from(map['validCategories'] ?? []),
    );
  }

  bool isValidForProducts(List<ProductModel> products) {
    if (validCategories.isEmpty) return true; // Valid for all categories
    return products.any(
      (product) => validCategories.contains(product.category.id),
    );
  }
}
