import 'package:flutter/material.dart';

class RatingBar extends StatelessWidget {
  final double rating;
  final double size;
  final Color? color;

  const RatingBar({
    super.key,
    required this.rating,
    this.size = 16,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star, size: size, color: color ?? Colors.amber);
        }
        if (index == rating.floor() && rating % 1 != 0) {
          return Icon(
            Icons.star_half,
            size: size,
            color: color ?? Colors.amber,
          );
        }
        return Icon(
          Icons.star_border,
          size: size,
          color: color ?? Colors.amber,
        );
      }),
    );
  }
}
