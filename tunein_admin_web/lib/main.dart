import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'; // kIsWeb: saber si corre en Chrome
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth/auth_gate.dart';
import 'firebase_options.dart';
import 'theme/theme.dart';
import 'theme/tokens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Mientras esto carga se ve el splash NATIVO (flutter_native_splash,
  // configurado en pubspec.yaml). Ya no hay pantalla de carga en Flutter.
  try {
    // Inicializar Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Inicializar Google Sign-In (obligatorio en google_sign_in 7, slide 33).
    // WEB: en Chrome no se usa GoogleSignIn (se usa signInWithPopup en el
    // login), así que solo se inicializa en Android.
    if (!kIsWeb) {
      await GoogleSignIn.instance.initialize();
    }
  } catch (e) {
    // Si Firebase no conecta, mostrar el error en vez de una pantalla negra.
    runApp(_ErrorApp(error: e));
    return;
  }

  runApp(const TuneInApp());
}

class TuneInApp extends StatelessWidget {
  const TuneInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TuneIn',
      debugShowCheckedModeBanner: false,
      theme: tuneInAppTheme,
      // Si el teléfono tiene la letra muy grande (Ajustes → Pantalla%),
      // la limitamos un poco para que el diseño no se desarme.
      builder: (context, child) => MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.15,
        child: child!,
      ),
      home: const AuthGate(), // login o app, según la sesión
    );
  }
}

/// Solo aparece si Firebase falla al iniciar.
class _ErrorApp extends StatelessWidget {
  const _ErrorApp({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: tuneInAppTheme,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.padding2xl24),
            child: Text(
              'Firebase no pudo conectar:\n$error',
              textAlign: TextAlign.center,
              style: AppTypography.body1.copyWith(
                color: AppSemanticColors.colorErrorBorder,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
