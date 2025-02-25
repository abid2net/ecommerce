import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/common/common.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WishlistRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<List<ProductModel>> getWishlist() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.wishlist)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => ProductModel.fromMap(doc.data()))
                  .toList(),
        );
  }

  Future<void> addToWishlist(ProductModel product) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.wishlist)
        .doc(product.id)
        .set(product.toMap());
  }

  Future<void> removeFromWishlist(String productId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.wishlist)
        .doc(productId)
        .delete();
  }
}
