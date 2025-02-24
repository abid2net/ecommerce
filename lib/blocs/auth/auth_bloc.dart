import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthInitial()) {
    on<SignUpWithEmailEvent>(_onSignUpWithEmail);
    on<SignInWithEmailEvent>(_onSignInWithEmail);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignOutEvent>(_onSignOut);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<ResetPasswordEvent>(_onResetPassword);
    on<UpdatePasswordEvent>(_onUpdatePassword);

    on<AuthStateChangedEvent>((event, emit) async {
      try {
        if (event.user != null) {
          final userData = await _authRepository.getUserData(event.user!.uid);
          if (userData != null) {
            emit(Authenticated(userData));
          } else {
            // Create basic user if data not found
            final basicUser = UserModel(
              id: event.user!.uid,
              email: event.user!.email!,
              role: UserRole.customer,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
            emit(Authenticated(basicUser));
          }
        } else {
          emit(Unauthenticated());
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(Unauthenticated());
      }
    });

    // Check initial auth state
    _checkInitialAuthState();

    // Listen to auth state changes
    _authRepository.authStateChanges.listen(
      (user) => add(AuthStateChangedEvent(user)),
    );
  }

  Future<void> _checkInitialAuthState() async {
    final currentUser = _authRepository.currentUser;
    if (currentUser != null) {
      add(AuthStateChangedEvent(currentUser));
    } else {
      add(AuthStateChangedEvent(null));
    }
  }

  Future<void> _onSignUpWithEmail(
    SignUpWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final user = await _authRepository.signUpWithEmail(
        event.email,
        event.password,
      );
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignInWithEmail(
    SignInWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final user = await _authRepository.signInWithEmail(
        event.email,
        event.password,
      );
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final user = await _authRepository.signInWithGoogle();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      await _authRepository.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! Authenticated) return;
    final currentUser = (state as Authenticated).user;

    try {
      emit(AuthLoading());
      await _authRepository.updateUserProfile(
        event.user,
        imageFile: event.imageFile,
      );

      // Get the updated user data
      final updatedUser = await _authRepository.getUserData(event.user.id);
      if (updatedUser != null) {
        emit(Authenticated(updatedUser));
      } else {
        emit(
          Authenticated(currentUser),
        ); // Fallback to current user if update fails
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Authenticated(currentUser)); // Revert to previous state on error
    }
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      await _authRepository.resetPassword(event.email);
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onUpdatePassword(
    UpdatePasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! Authenticated) return;
    final currentUser = (state as Authenticated).user;

    try {
      emit(AuthLoading());
      await _authRepository.updatePassword(event.newPassword);
      emit(Authenticated(currentUser));
    } catch (e) {
      emit(AuthError(e.toString()));
      // Revert back to authenticated state after error
      emit(Authenticated(currentUser));
    }
  }
}
