import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/common/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce/models/address_model.dart';

class AddressRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAddress(AddressModel address) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.addresses)
        .doc(address.id)
        .set(address.toMap());
  }

  Stream<List<AddressModel>> getAddresses() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.addresses)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => AddressModel.fromMap(doc.data()))
                  .toList(),
        );
  }

  Future<void> deleteAddress(String addressId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.addresses)
        .doc(addressId)
        .delete();
  }
}
