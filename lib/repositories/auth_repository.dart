import 'package:ecommerce/common/common.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FacebookAuth? facebookAuth,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn(),
       _facebookAuth = facebookAuth ?? FacebookAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _storage = storage ?? FirebaseStorage.instance;

  Stream<UserModel?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null
          ? null
          : UserModel.fromFirebaseUser(firebaseUser);
    });
  }

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserModel?> signUpWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final user = UserModel(
          id: credential.user!.uid,
          email: email,
          role: UserRole.customer,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore
            .collection(FirebaseConstants.users)
            .doc(user.id)
            .set(user.toMap());
        return user;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }

  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        return await getUserData(credential.user!.uid);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null;

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      debugLog('Error signing in with Google: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
      _facebookAuth.logOut(),
    ]);
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _firebaseAuth.currentUser?.updatePassword(newPassword);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserModel?> getUserData(String userId) async {
    try {
      final doc =
          await _firestore
              .collection(FirebaseConstants.users)
              .doc(userId)
              .get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }

  Future<String?> uploadProfilePicture(String userId, File imageFile) async {
    try {
      final ref = _storage.ref().child(
        '${FirebaseConstants.profilePicturePath}/$userId.jpg',
      );
      await ref.putFile(imageFile);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateUserProfile(UserModel user, {File? imageFile}) async {
    try {
      String? photoUrl = user.photoUrl;

      // TODO: Upload profile picture to Firebase Storage (Paid service)
      // if (imageFile != null) {
      //   photoUrl = await uploadProfilePicture(user.id, imageFile);
      // }

      final updatedUser = user.copyWith(photoUrl: photoUrl);
      await _firestore
          .collection(FirebaseConstants.users)
          .doc(user.id)
          .update(updatedUser.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
