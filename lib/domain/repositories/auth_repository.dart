import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  //un stream para saber si el usuario esta logueado o no en tiempo real

  Stream<User?> get authStateChanges;

  //metodos de accion
  Future<void> signInWithGoogle();
  Future<void> signOut();
}