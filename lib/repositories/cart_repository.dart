import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<List<ProductModel>> getCart() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
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
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(product.id)
        .set(cartItem);
  }

  Future<void> removeFromCart(String productId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(productId)
        .delete();
  }
}
