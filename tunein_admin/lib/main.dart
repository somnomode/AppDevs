import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth/auth_gate.dart';
import 'firebase_options.dart';
import 'theme/theme.dart';
import 'theme/tokens.dart';
import 'widgets.dart';

void main() => runApp(const TuneInApp());

class TuneInApp extends StatelessWidget {
  const TuneInApp({super.key});

  // Firebase y Google Sign-In se inician DESPUÉS de mostrar la app, así
  // siempre se ve algo: el logo mientras conecta, o el error si algo falla.
  static final _firebase = _iniciar();

  static Future<void> _iniciar() async {
    // Inicializar Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Inicializar Google Sign-In (obligatorio en google_sign_in 7, slide 33).
    // Toma el ID de cliente desde android/app/google-services.json.
    await GoogleSignIn.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TuneIn',
      debugShowCheckedModeBanner: false,
      theme: tuneInAppTheme,
      home: FutureBuilder(
        future: _firebase,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done && !snap.hasError) {
            return const AuthGate(); // login o app, según la sesión
          }
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TuneInLogo(width: LogoTokens.splash),
                  if (snap.hasError)
                    Padding(
                      padding: const EdgeInsets.all(AppPadding.padding2xl24),
                      child: Text(
                        'Firebase no pudo conectar:\n${snap.error}',
                        textAlign: TextAlign.center,
                        style: AppTypography.body1.copyWith(
                          color: AppSemanticColors.colorErrorBorder,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
