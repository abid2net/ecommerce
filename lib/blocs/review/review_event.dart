part of 'review_bloc.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

class LoadReviews extends ReviewEvent {
  final String productId;

  const LoadReviews(this.productId);

  @override
  List<Object> get props => [productId];
}

class AddReview extends ReviewEvent {
  final ReviewModel review;

  const AddReview(this.review);

  @override
  List<Object> get props => [review];
}

// New event for deleting a review
class DeleteReview extends ReviewEvent {
  final ReviewModel review;

  const DeleteReview(this.review);

  @override
  List<Object> get props => [review];
}
