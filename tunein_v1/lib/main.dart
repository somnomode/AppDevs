import 'package:flutter/material.dart';
 
import 'theme/theme.dart';
 
void main() => runApp(const TuneInApp());
 
class TuneInApp extends StatelessWidget {
  const TuneInApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TuneIn',
      debugShowCheckedModeBanner: false,
      theme: tuneInTheme,
      home: const MainScreen(),
    );
  }
}
 
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
 
  @override
  State<MainScreen> createState() => _MainScreenState();
}
 
class _MainScreenState extends State<MainScreen> {
  int _navIndex = 0;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            TuneInBottomNavBar.items[_navIndex].label,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
      bottomNavigationBar: TuneInBottomNavBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}
 
// =============================================================
// BOTTOM NAVIGATION BAR
// Figma: "Bottom Navigation Bar FINAL" (Componentes · 829:1721)
// Íconos: Material Icons de Google (incluidos en Flutter).
// Medidas ajustadas a una navbar real (M3: 80dp alto, tabs que
// se reparten todo el ancho, targets táctiles ≥ 48dp).
// =============================================================
 
/// Tokens de componente (bottomnavbar/*) mapeados a semánticos/primitivos.
class BottomNavTokens {
  static const bg = AppColors.neutral800; // bottom-navbar-bg #07091A
  static const itemActive = AppSemanticColors.colorBrandPrimary; // icon-*-active
  static const itemInactive = AppSemanticColors.colorTextMain; // icon-*-inactive
  static const double height = 72;
  static const double iconSize = 24;
  static const double iconLabelGap = AppGap.gapXs4;
  static const double paddingH = AppPadding.paddingS8;
  static const TextStyle label = TextStyle(
    fontFamily: AppTypography.fontFamilyOutfit,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 16 / 12,
  );
}
 
class NavItemData {
  const NavItemData(this.label, this.icon);
  final String label;
  final IconData icon;
}
 
class TuneInBottomNavBar extends StatelessWidget {
  const TuneInBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });
 
  final int currentIndex;
  final ValueChanged<int> onTap;
 
  static const items = [
    NavItemData('Home', Icons.home_outlined),
    NavItemData('Library', Icons.bookmarks_outlined),
    NavItemData('Map', Icons.location_on_outlined),
    NavItemData('Search', Icons.search),
  ];
 
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: BottomNavTokens.bg,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: BottomNavTokens.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: BottomNavTokens.paddingH,
            ),
            child: Row(
              children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(
                    child: _NavTabItem(
                      data: items[i],
                      selected: i == currentIndex,
                      onTap: () => onTap(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 
class _NavTabItem extends StatelessWidget {
  const _NavTabItem({
    required this.data,
    required this.selected,
    required this.onTap,
  });
 
  final NavItemData data;
  final bool selected;
  final VoidCallback onTap;
 
  @override
  Widget build(BuildContext context) {
    final color =
        selected ? BottomNavTokens.itemActive : BottomNavTokens.itemInactive;
 
    // GestureDetector en vez de InkWell: sin splash ni animación al cambiar.
    return Semantics(
      button: true,
      selected: selected,
      label: data.label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque, // toda la celda es tocable
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(data.icon, size: BottomNavTokens.iconSize, color: color),
            const SizedBox(height: BottomNavTokens.iconLabelGap),
            Text(
              data.label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: BottomNavTokens.label.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}