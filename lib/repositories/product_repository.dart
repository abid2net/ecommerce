import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/common/common.dart';
import 'package:ecommerce/models/product_model.dart';

class ProductRepository {
  final _firestore = FirebaseFirestore.instance;

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
    return _firestore.collection(FirebaseConstants.products).snapshots().map((
      snapshot,
    ) {
      debugLog(
        'Firestore snapshot received: ${snapshot.docs.length} documents',
      ); // Debug print
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Ensure ID is included
        debugLog('Processing document: ${doc.id}'); // Debug print
        return ProductModel.fromMap(data);
      }).toList();
    });
  }
}
