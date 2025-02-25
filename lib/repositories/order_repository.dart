import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/common/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce/models/order_model.dart';

class OrderRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<List<OrderModel>> getOrders() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.orders)
        .orderBy(FirebaseConstants.createdAt, descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => OrderModel.fromMap(doc.data()))
                  .toList(),
        );
  }

  Future<void> createOrder(OrderModel order) async {
    await _firestore
        .collection(FirebaseConstants.users)
        .doc(order.userId)
        .collection(FirebaseConstants.orders)
        .doc(order.id)
        .set(order.toMap());
  }
}
