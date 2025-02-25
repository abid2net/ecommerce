import 'package:flutter/material.dart';
import 'package:ecommerce/models/review_model.dart';
import 'package:ecommerce/widgets/rating_bar.dart';
import 'package:intl/intl.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review.userName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                DateFormat.yMMMd().format(review.createdAt),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 4),
          RatingBar(rating: review.rating, size: 16),
          const SizedBox(height: 8),
          Text(review.comment, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
