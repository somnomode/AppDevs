import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../theme/theme.dart';
import '../widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final correoController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool cargando = false;
  bool mostrarPassword = false;

  // AGREGADO: la misma pantalla sirve para iniciar sesión o crear cuenta.
  bool creandoCuenta = false;

  // Iniciar sesión (o crear cuenta) con correo y contraseña
  Future<void> iniciarSesionCorreo() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => cargando = true);

    try {
      final auth = FirebaseAuth.instance;
      final correo = correoController.text.trim();
      final password = passwordController.text;
      if (creandoCuenta) {
        await auth.createUserWithEmailAndPassword(
          email: correo,
          password: password,
        );
      } else {
        await auth.signInWithEmailAndPassword(
          email: correo,
          password: password,
        );
      }
      // No hay que navegar: AuthGate ve la sesión nueva y muestra la app.
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      showAlert(context, mensajeError(e.code), error: true);
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  // Iniciar sesión con Google
  Future<void> iniciarSesionGoogle() async {
    setState(() => cargando = true);

    try {
      final googleUser = await GoogleSignIn.instance.authenticate();

      final googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      if (!mounted) return;

      if (e.code != GoogleSignInExceptionCode.canceled) {
        showAlert(
          context,
          'Error al ingresar con Google: ${e.code.name}',
          error: true,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      showAlert(context, mensajeError(e.code), error: true);
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  // AGREGADO: "¿Olvidaste tu contraseña?" (Figma) — envía un correo.
  Future<void> recuperarPassword() async {
    final correo = correoController.text.trim();
    if (!correo.contains('@')) {
      showAlert(context, 'Escribe tu correo primero', error: true);
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: correo);
      if (mounted) showAlert(context, 'Te enviamos un correo para recuperarla');
    } on FirebaseAuthException catch (e) {
      if (mounted) showAlert(context, mensajeError(e.code), error: true);
    }
  }

  // AGREGADO: mensajes en español en vez del código de Firebase.
  String mensajeError(String code) => switch (code) {
    'invalid-email' => 'El correo no es válido',
    'invalid-credential' ||
    'wrong-password' ||
    'user-not-found' => 'Correo o contraseña incorrectos',
    'email-already-in-use' => 'Ya existe una cuenta con ese correo',
    'weak-password' => 'La contraseña debe tener al menos 6 caracteres',
    'network-request-failed' => 'Sin conexión a internet',
    'too-many-requests' => 'Demasiados intentos, espera un momento',
    _ => 'No se pudo continuar ($code)',
  };

  @override
  void dispose() {
    correoController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.spacing2xl24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // AGREGADO: logo TUNE|IN como en el Figma
                const Center(child: TuneInLogo()),

                const SizedBox(height: AppSpacing.spacing3xl32),

                Text(
                  creandoCuenta ? 'Crear cuenta' : 'Bienvenido',
                  style: textos.headlineLarge,
                ),

                const SizedBox(height: AppSpacing.spacing2xl24),

                // Correo electrónico
                TextFormField(
                  controller: correoController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Ingresa tu correo electrónico';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppSpacing.spacingL16),

                // Contraseña
                TextFormField(
                  controller: passwordController,
                  obscureText: !mostrarPassword,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          mostrarPassword = !mostrarPassword;
                        });
                      },
                      icon: Icon(
                        mostrarPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'Ingresa tu contraseña';
                    }
                    if (creandoCuenta && valor.length < 6) {
                      return 'Mínimo 6 caracteres';
                    }
                    return null;
                  },
                ),

                if (!creandoCuenta)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: cargando ? null : recuperarPassword,
                      child: const Text('¿Olvidaste tu contraseña?'),
                    ),
                  ),

                const SizedBox(height: AppSpacing.spacing2xl24),

                // Ingresar (o crear cuenta) con correo
                FilledButton(
                  onPressed: cargando ? null : iniciarSesionCorreo,
                  child: Text(
                    creandoCuenta ? 'Crear cuenta' : 'Iniciar sesión',
                  ),
                ),

                const SizedBox(height: AppSpacing.spacingL16),

                // Ingresar con Google
                OutlinedButton.icon(
                  onPressed: cargando ? null : iniciarSesionGoogle,
                  icon: const Icon(Icons.account_circle_outlined),
                  label: const Text('Continuar con Google'),
                ),

                // AGREGADO: cambiar entre "Iniciar sesión" y "Crear cuenta"
                TextButton(
                  onPressed: cargando
                      ? null
                      : () => setState(() => creandoCuenta = !creandoCuenta),
                  child: Text(
                    creandoCuenta
                        ? '¿Ya tienes cuenta? Inicia sesión'
                        : '¿No tienes cuenta? Regístrate',
                  ),
                ),

                if (cargando) ...[
                  const SizedBox(height: AppSpacing.spacingL16),
                  const Center(child: CircularProgressIndicator()),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
