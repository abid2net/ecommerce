import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/common/common.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/models/review_model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProduct(ProductModel product) async {
    await _firestore
        .collection(FirebaseConstants.products)
        .doc(product.id)
        .set(product.toMap());
  }

  Future<void> updateProduct(ProductModel product) async {
    await _firestore
        .collection(FirebaseConstants.products)
        .doc(product.id)
        .update(product.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await _firestore.collection(FirebaseConstants.products).doc(id).delete();
  }

  Stream<List<ProductModel>> getProducts() {
    return _firestore
        .collection(FirebaseConstants.products)
        .snapshots()
        .asyncMap((snapshot) async {
          final products = await Future.wait(
            snapshot.docs.map((doc) async {
              final data = doc.data();
              data['id'] = doc.id;

              // Fetch reviews for this product
              final reviewsSnapshot =
                  await _firestore
                      .collection(FirebaseConstants.products)
                      .doc(doc.id)
                      .collection(FirebaseConstants.reviews)
                      .get();

              final reviews =
                  reviewsSnapshot.docs
                      .map((reviewDoc) => ReviewModel.fromMap(reviewDoc.data()))
                      .toList();

              // Calculate average rating and review count
              double avgRating = 0;
              if (reviews.isNotEmpty) {
                avgRating =
                    reviews.fold(
                      0.0,
                      (sumval, review) => sumval + review.rating,
                    ) /
                    reviews.length;
              }

              // Update product data with reviews info
              data['rating'] = avgRating;
              data['reviewCount'] = reviews.length;

              debugLog(
                'Processing product: ${doc.id} with ${reviews.length} reviews',
              );
              return ProductModel.fromMap(data);
            }),
          );

          debugLog('Loaded ${products.length} products with reviews');
          return products;
        });
  }
}
