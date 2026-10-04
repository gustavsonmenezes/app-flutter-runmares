import 'package:firebase_auth/firebase_auth.dart';
import 'package:runmares/features/auth/data/firebase_auth_error_codes.dart';
import 'package:runmares/features/auth/domain/auth_failure.dart';
import 'package:runmares/features/auth/domain/auth_repository.dart';
import 'package:runmares/features/auth/domain/auth_user.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository([FirebaseAuth? auth])
    : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  @override
  AuthUser? get currentUser => _toUser(_auth.currentUser);

  @override
  Stream<AuthUser?> authStateChanges() => _auth.authStateChanges().map(_toUser);

  @override
  Future<void> signIn({required String email, required String password}) {
    return _run(
      () => _auth.signInWithEmailAndPassword(email: email, password: password),
    );
  }

  @override
  Future<void> signUp({required String email, required String password}) {
    return _run(
      () => _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<void> signOut() => _auth.signOut();

  Future<void> _run(Future<Object?> Function() action) async {
    try {
      await action();
    } on FirebaseAuthException catch (error) {
      throw AuthException(authFailureFromFirebaseCode(error.code));
    }
  }

  AuthUser? _toUser(User? user) {
    if (user == null) return null;
    return AuthUser(uid: user.uid, email: user.email);
  }
}
