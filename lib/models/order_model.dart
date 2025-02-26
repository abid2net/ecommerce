import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/models/address_model.dart';

enum OrderStatus { pending, processing, shipped, delivered, cancelled }

class OrderModel {
  final String id;
  final String userId;
  final List<ProductModel> products;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final String? discountCode;
  final double? discountPercentage;
  final AddressModel? shippingAddress;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.products,
    required this.total,
    required this.status,
    required this.createdAt,
    this.discountCode,
    this.discountPercentage,
    this.shippingAddress,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'products': products.map((p) => p.toMap()).toList(),
      'total': total,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'discountCode': discountCode,
      'discountPercentage': discountPercentage,
      'shippingAddress': shippingAddress?.toMap(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      products:
          (map['products'] as List)
              .map((p) => ProductModel.fromMap(p as Map<String, dynamic>))
              .toList(),
      total: (map['total'] as num).toDouble(),
      status: OrderStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => OrderStatus.pending,
      ),
      createdAt: DateTime.parse(map['createdAt'] as String),
      discountCode: map['discountCode'] as String?,
      discountPercentage: (map['discountPercentage'] as num?)?.toDouble(),
      shippingAddress:
          map['shippingAddress'] != null
              ? AddressModel.fromMap(
                map['shippingAddress'] as Map<String, dynamic>,
              )
              : null,
    );
  }
}
