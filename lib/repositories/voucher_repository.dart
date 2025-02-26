import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/common/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce/models/voucher_model.dart';
import 'package:ecommerce/common/constants/firebase_constants.dart';

class VoucherRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<VoucherModel>> getVouchers() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    final snapshot =
        await _firestore.collection(FirebaseConstants.vouchers).get();

    return snapshot.docs
        .map((doc) => VoucherModel.fromMap(doc.data()))
        .toList();
  }

  Future<void> addVoucher(VoucherModel voucher) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection(FirebaseConstants.vouchers)
        .doc(voucher.id)
        .set(voucher.toMap());
  }

  Future<void> deleteVoucher(String voucherId) async {
    await _firestore
        .collection(FirebaseConstants.vouchers)
        .doc(voucherId)
        .delete();
  }

  Future<VoucherModel?> validateDiscount(String code) async {
    final snapshot =
        await _firestore
            .collection(FirebaseConstants.vouchers)
            .where('code', isEqualTo: code)
            .where('isActive', isEqualTo: true)
            .get();

    if (snapshot.docs.isNotEmpty) {
      final discount = VoucherModel.fromMap(snapshot.docs.first.data());

      // Check if discount is expired
      if (discount.expiryDate != null &&
          discount.expiryDate!.isBefore(DateTime.now())) {
        return null; // Discount is expired
      }

      return discount; // Return the valid discount
    }

    return null; // No valid discount found
  }
}
