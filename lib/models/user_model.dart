import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum UserRole { admin, customer }

class UserModel extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? phone;
  final String? address;
  final UserRole role;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.phone,
    this.address,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String?,
      photoUrl: map['photoUrl'] as String?,
      phone: map['phone'] as String?,
      address: map['address'] as String?,
      role: UserRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => UserRole.customer,
      ),
      createdAt:
          (map['createdAt'] is String)
              ? DateTime.parse(map['createdAt'])
              : DateTime.fromMillisecondsSinceEpoch(map['createdAt'] * 1000),
      updatedAt:
          (map['updatedAt'] is String)
              ? DateTime.parse(map['updatedAt'])
              : DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] * 1000),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'phone': phone,
      'address': address,
      'role': role.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? displayName,
    String? photoUrl,
    String? phone,
    String? address,
  }) {
    return UserModel(
      id: id,
      email: email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      role: role,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  bool get isAdmin => role == UserRole.admin;

  factory UserModel.fromFirebaseUser(User firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email!,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      role: UserRole.customer,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    displayName,
    photoUrl,
    phone,
    address,
    role,
    createdAt,
    updatedAt,
  ];
}
