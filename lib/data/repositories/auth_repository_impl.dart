import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(this._firebaseAuth);

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  Future<void> signInWithGoogle() async {
    // Para web esta es la forma mas simple por ahora, una ventana emergente (notion)
    GoogleAuthProvider authProvider = GoogleAuthProvider();
    try {
      await _firebaseAuth.signInWithPopup(authProvider);
    } catch (e) {
      // solo imprimimos el error, luego manejamos
      print('Error en signInWithGoogle: $e');
      rethrow;
    }
}

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}