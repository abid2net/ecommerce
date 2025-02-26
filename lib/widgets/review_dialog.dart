import 'package:ecommerce/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/blocs/auth/auth_bloc.dart';
import 'package:ecommerce/blocs/auth/auth_state.dart';
import 'package:ecommerce/models/review_model.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/blocs/review/review_bloc.dart';

class ReviewDialog extends StatefulWidget {
  final String productId;

  const ReviewDialog({super.key, required this.productId});

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 0;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Write a Review'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rating'),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () {
                  setState(() {
                    _rating = index + 1.0;
                  });
                },
              );
            }),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              labelText: 'Your Review',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          onPressed: _rating == 0 ? null : _submitReview,
          child: const Text('Submit'),
        ),
      ],
    );
  }

  Future<void> _submitReview() async {
    final state = context.read<AuthBloc>().state;
    UserModel? currentUser;
    if (state is Authenticated) {
      currentUser = state.user;
    }
    if (currentUser == null) {
      Navigator.of(context).pop();
      if (mounted) {
        showErrorSnackBar(context, 'Please login to write a review');
      }
      return;
    }

    final review = ReviewModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser.id,
      userName: currentUser.displayName ?? 'Anonymous',
      productId: widget.productId,
      rating: _rating,
      comment: _commentController.text.trim(),
      createdAt: DateTime.now(),
    );

    try {
      context.read<ReviewBloc>().add(AddReview(review));
      if (mounted) {
        Navigator.of(context).pop();
        showSuccessSnackBar(context, 'Review submitted successfully');
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        showErrorSnackBar(context, 'Error: ${e.toString()}');
      }
    }
  }
}
