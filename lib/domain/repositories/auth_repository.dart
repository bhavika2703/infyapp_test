import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<User?> signIn({required String email, required String password});
  Future<User?> signUp({required String email, required String password, String? name});
  Future<void> signOut();
  User? get currentUser;
  Stream<User?> authStateChanges();
}
