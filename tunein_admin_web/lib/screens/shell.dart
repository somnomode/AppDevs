import 'package:flutter/material.dart';

import '../models.dart';
import '../services/db.dart';
import '../widgets.dart';
import 'home.dart';
import 'library.dart';
import 'map.dart';
import 'search.dart';

/// Pestaña activa y emisora a centrar en el mapa ("Encontrar en el mapa").
class AppNav {
  static const home = 0, library = 1, map = 2, search = 3;
  static final tab = ValueNotifier<int>(home);
  static final mapFocus = ValueNotifier<Station?>(null);

  static void showOnMap(Station s) {
    mapFocus.value = s;
    tab.value = map;
  }
}

/// Estructura principal: pestaña activa + mini player + bottom nav.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  @override
  void initState() {
    super.initState();
    AppNav.tab.value = AppNav.home; // al iniciar sesión, partir en Home
    Store.start(); // empieza a escuchar Firestore
  }

  @override
  void dispose() {
    Store.stop(); // al cerrar sesión
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: AppNav.tab,
      builder: (context, tab, _) => Scaffold(
        // Solo se construye la pestaña visible (el mapa no corre escondido).
        body: SafeArea(
          bottom: false,
          child: switch (tab) {
            AppNav.library => const LibraryScreen(),
            AppNav.map => const MapScreen(),
            AppNav.search => const SearchScreen(),
            _ => const HomeScreen(),
          },
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MiniPlayer(),
            BottomNav(index: tab, onTap: (i) => AppNav.tab.value = i),
          ],
        ),
      ),
    );
  }
}
