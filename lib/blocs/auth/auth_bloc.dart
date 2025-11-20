import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  StreamSubscription? _sub;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);

    // Keep the bloc in sync with FirebaseAuth changes. When Firebase changes
    // we trigger an internal check or sign-out so UI can react.
    _sub = authRepository.authStateChanges().listen((user) {
      if (user != null) add(AuthCheckRequested());
      else add(SignOutRequested());
    });
  }

  Future<void> _onAuthCheckRequested(AuthCheckRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = authRepository.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(user.uid));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignInRequested(SignInRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.signIn(email: e.email, password: e.password);
      if (user != null) emit(AuthAuthenticated(user.uid));
      else emit(AuthUnauthenticated());
    } catch (err) {
      emit(AuthFailure(err.toString()));
    }
  }

  /// UPDATED: emit AuthSignUpSuccess after successful sign-up so UI can
  /// navigate back to Login (or show a message) instead of auto-signing-in.
  Future<void> _onSignUpRequested(SignUpRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.signUp(email: e.email, password: e.password, name: e.name);
      if (user != null) {
        emit(AuthSignUpSuccess('Account created successfully. Please login.'));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (err) {
      emit(AuthFailure(err.toString()));
    }
  }

  Future<void> _onSignOutRequested(SignOutRequested e, Emitter<AuthState> emit) async {
    await authRepository.signOut();
    emit(AuthUnauthenticated());
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
