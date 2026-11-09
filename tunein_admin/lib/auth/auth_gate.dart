import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/shell.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Escuchar los cambios de autenticación
      stream: FirebaseAuth.instance.authStateChanges(),

      builder: (context, snapshot) {
        // Esperar mientras Firebase comprueba la sesión
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Mostrar la app (pestañas + mini player) si existe una sesión.
        // ARREGLO: antes devolvía TuneInApp(), que es la app completa
        // (con su propio MaterialApp), y se metía una app dentro de otra.
        if (snapshot.hasData) {
          return const MainShell();
        }

        // Mostrar el login si no existe una sesión
        return const LoginScreen();
      },
    );
  }
}
