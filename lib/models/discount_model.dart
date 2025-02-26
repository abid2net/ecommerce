import 'package:ecommerce/models/product_model.dart';

class DiscountModel {
  final String code;
  final double percentage;
  final bool isActive;
  final DateTime? expiryDate;
  final List<String>
  validCategories; // List of category IDs where discount applies

  const DiscountModel({
    required this.code,
    required this.percentage,
    this.isActive = true,
    this.expiryDate,
    this.validCategories =
        const [], // Empty list means valid for all categories
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'percentage': percentage,
      'isActive': isActive,
      'expiryDate': expiryDate?.millisecondsSinceEpoch,
      'validCategories': validCategories,
    };
  }

  factory DiscountModel.fromMap(Map<String, dynamic> map) {
    return DiscountModel(
      code: map['code'] as String,
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
