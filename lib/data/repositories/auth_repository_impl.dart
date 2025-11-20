import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _ds;
  AuthRepositoryImpl(this._ds);

  @override
  Future<User?> signIn({required String email, required String password}) async {
    final cred = await _ds.signIn(email: email, password: password);
    return cred.user;
  }

  @override
  Future<User?> signUp({required String email, required String password, String? name}) async {
    final cred = await _ds.signUp(email: email, password: password);
    // optional: set displayName
    if (name != null && cred.user != null) {
      await cred.user!.updateDisplayName(name);
    }
    return cred.user;
  }

  @override
  Future<void> signOut() => _ds.signOut();

  @override
  User? get currentUser => _ds.currentUser;

  @override
  Stream<User?> authStateChanges() => _ds.authStateChanges();
}
