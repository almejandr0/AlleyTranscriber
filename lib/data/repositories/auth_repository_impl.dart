import 'package:firebase_auth/firebase_auth.dart';
// AGREGAMOS ESTOS DOS IMPORTS:
import 'package:flutter/foundation.dart' show kIsWeb; 
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(this._firebaseAuth);

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  Future<void> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // --- LÓGICA WEB (Lo que ya tenías) ---
        // En web se usa signInWithPopup
        GoogleAuthProvider authProvider = GoogleAuthProvider();
        await _firebaseAuth.signInWithPopup(authProvider);
      } else {
        // --- LÓGICA MÓVIL (Android/iOS) ---
        // En móvil se usa el plugin google_sign_in para obtener las credenciales primero
        final GoogleSignIn googleSignIn = GoogleSignIn();
        
        // 1. Abre la ventana nativa de Google
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        // Si el usuario cancela el login, googleUser será null
        if (googleUser != null) {
          // 2. Obtener los tokens de autenticación
          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

          // 3. Crear credencial para Firebase usando esos tokens
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          // 4. Mandar esa credencial a Firebase
          await _firebaseAuth.signInWithCredential(credential);
        }
      }
    } catch (e) {
      print('Error en signInWithGoogle: $e');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    // Cerramos sesión en Firebase
    await _firebaseAuth.signOut();
    
    // TIP: Si estás en móvil, también es bueno cerrar la sesión del plugin de Google
    // para que la próxima vez te pregunte qué cuenta usar.
    if (!kIsWeb) {
      await GoogleSignIn().signOut();
    }
  }
}