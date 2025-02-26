import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/common/common.dart';
import 'package:ecommerce/models/review_model.dart';

class ReviewRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ReviewModel>> getReviews(String productId) {
    return _firestore
        .collection(FirebaseConstants.products)
        .doc(productId)
        .collection(FirebaseConstants.reviews)
        .orderBy(FirebaseConstants.createdAt, descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => ReviewModel.fromMap(doc.data()))
                  .toList(),
        );
  }

  Future<void> addReview(ReviewModel review) async {
    await _firestore
        .collection(FirebaseConstants.products)
        .doc(review.productId)
        .collection(FirebaseConstants.reviews)
        .doc(review.id)
        .set(review.toMap());
  }
}
