import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/common/common.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<List<ProductModel>> getCart() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.cart)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => ProductModel.fromMap(doc.data()))
                  .toList(),
        );
  }

  Future<void> addToCart(ProductModel product, {int quantity = 1}) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final cartItem = {...product.toMap(), 'quantity': quantity};

    await _firestore
        .collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.cart)
        .doc(product.id)
        .set(cartItem);
  }

  Future<void> removeFromCart(String productId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.cart)
        .doc(productId)
        .delete();
  }

  Future<void> updateCart(List<ProductModel> products) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final batch = _firestore.batch();
    final cartRef = _firestore
        .collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.cart);

    // First delete all existing items
    final existingDocs = await cartRef.get();
    for (var doc in existingDocs.docs) {
      batch.delete(doc.reference);
    }

    // Then add all products with updated quantities
    for (var product in products) {
      final docRef = cartRef.doc(product.id);
      batch.set(docRef, {
        ...product.toMap(),
        'quantity': product.quantity ?? 1,
      });
    }

    await batch.commit();
  }
}
