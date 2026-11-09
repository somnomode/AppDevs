import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/db.dart';
import '../services/player.dart';
import '../services/seed.dart';
import '../theme/theme.dart';
import '../widgets.dart';
import 'studio.dart';

/// Perfil: Studio de emisora, datos demo y cerrar sesión.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget tile(IconData icon, String title, String sub, VoidCallback onTap) =>
        Card(
          color: AppElevation.elevation2,
          child: ListTile(
            leading: Icon(icon, color: AppSemanticColors.colorBrandPrimary),
            title: Text(title),
            subtitle: Text(sub),
            trailing: const Icon(Icons.chevron_right),
            onTap: onTap,
          ),
        );

    return Scaffold(
      appBar: AppBar(title: Text(CurrentUser.username)),
      body: ListView(
        padding: const EdgeInsets.all(AppPadding.paddingL16),
        children: [
          tile(
            Icons.mic_none,
            'Studio de emisora',
            'Crea tu emisora y publica posts y clips',
            () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const StudioScreen()),
            ),
          ),
          tile(
            Icons.dataset_outlined,
            'Cargar datos demo',
            '8 emisoras con posts y audio moments',
            () async {
              try {
                final n = await seedDemoData();
                if (context.mounted) showAlert(context, n);
              } catch (e) {
                if (context.mounted) {
                  showAlert(context, 'Error: $e', error: true);
                }
              }
            },
          ),
          tile(Icons.logout, 'Cerrar sesión', CurrentUser.email, () async {
            await Player.instance.stop();
            await GoogleSignIn.instance.signOut(); // por si entró con Google
            await FirebaseAuth.instance.signOut();
            // AuthGate muestra el login; cerramos esta pantalla.
            if (context.mounted) {
              Navigator.of(context).popUntil((r) => r.isFirst);
            }
          }),
        ],
      ),
    );
  }
}
