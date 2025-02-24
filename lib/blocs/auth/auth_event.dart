import 'package:ecommerce/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignUpWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  const SignUpWithEmailEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignInWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInWithEmailEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignInWithGoogleEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}

class UpdateProfileEvent extends AuthEvent {
  final UserModel user;
  final File? imageFile;

  const UpdateProfileEvent(this.user, {this.imageFile});

  @override
  List<Object?> get props => [user, imageFile];
}

class ResetPasswordEvent extends AuthEvent {
  final String email;

  const ResetPasswordEvent(this.email);

  @override
  List<Object> get props => [email];
}

class UpdatePasswordEvent extends AuthEvent {
  final String newPassword;

  const UpdatePasswordEvent(this.newPassword);

  @override
  List<Object> get props => [newPassword];
}

class AuthStateChangedEvent extends AuthEvent {
  final User? user;
  const AuthStateChangedEvent(this.user);
}
