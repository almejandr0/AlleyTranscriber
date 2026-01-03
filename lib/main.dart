import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'presentation/providers/auth_provider.dart';

void main() async {
  // 1. Aseguramos que el motor de Flutter esté listo
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Intentamos inicializar Firebase con seguridad
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Si sale el error de "duplicate-app", lo ignoramos y seguimos.
    // Esto evita la pantalla negra en los Hot Restarts.
    print("Firebase ya estaba inicializado: $e");
  }

  // 3. Arrancamos la App
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. MaterialApp: necesario para dar "Directionality" y temas
    return MaterialApp(
      title: 'Transcriber MVP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // 3. AuthWrapper: es el hijo del materialapp
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // escuchando el estado del usuario
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Bienvenido')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Hola, ${user.displayName ?? "Usuario"}'),
                  Text(user.email ?? ""),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => ref.read(authRepositoryProvider).signOut(),
                    child: const Text('Cerrar Sesión'),
                  ),
                ],
              ),
            ),
          );
        } else {
          // login
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mic, size: 80, color: Colors.deepPurple),
                  const SizedBox(height: 20),
                  const Text("Transcriber App", style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.login),
                    onPressed: () => ref.read(authRepositoryProvider).signInWithGoogle(),
                    label: const Text('Entrar con Google'),
                  ),
                ],
              ),
            ),
          );
        }
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, trace) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}