import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ecommerce/models/review_model.dart';
import 'package:ecommerce/repositories/review_repository.dart';
import 'package:ecommerce/blocs/product/product_bloc.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository _reviewRepository;
  final ProductBloc _productBloc;

  ReviewBloc({
    required ReviewRepository reviewRepository,
    required ProductBloc productBloc,
  }) : _reviewRepository = reviewRepository,
       _productBloc = productBloc,
       super(ReviewInitial()) {
    on<LoadReviews>(_onLoadReviews);
    on<AddReview>(_onAddReview);
    on<DeleteReview>(_onDeleteReview);
  }

  Future<void> _onLoadReviews(
    LoadReviews event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());
    try {
      await emit.forEach(
        _reviewRepository.getReviews(event.productId),
        onData: (List<ReviewModel> reviews) => ReviewLoaded(reviews),
        onError: (error, stackTrace) => ReviewError(error.toString()),
      );
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> _onAddReview(AddReview event, Emitter<ReviewState> emit) async {
    try {
      await _reviewRepository.addReview(event.review);
      _productBloc.add(LoadProducts());
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> _onDeleteReview(
    DeleteReview event,
    Emitter<ReviewState> emit,
  ) async {
    try {
      await _reviewRepository.deleteReview(event.review);
      _productBloc.add(LoadProducts());
      // emit(LoadReviews(event.review.productId));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
}
