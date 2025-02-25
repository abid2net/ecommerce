import 'package:equatable/equatable.dart';

class ReviewModel extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String productId;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.productId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    userName,
    productId,
    rating,
    comment,
    createdAt,
  ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'productId': productId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      productId: map['productId'] as String,
      rating: (map['rating'] as num).toDouble(),
      comment: map['comment'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
