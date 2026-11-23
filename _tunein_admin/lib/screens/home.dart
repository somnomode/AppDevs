import 'package:flutter/material.dart';

import '../models.dart';
import '../services/db.dart';
import '../theme/theme.dart';
import '../theme/tokens.dart';
import '../widgets.dart';
import 'player.dart';
import 'profile.dart';

/// Home (Figma: "menu inicio"): chips de categoría → filter chips de
/// género → Recientes → una fila por género.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _category = 'radio';
  String? _genre; // null = "Todos"

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        Store.stations,
        Store.recents,
        Store.error,
      ]),
      builder: (context, _) {
        final all = Store.stations.value;
        final inCategory = (all ?? [])
            .where((s) => s.category == _category)
            .toList();
        // Géneros de esta categoría, en el orden en que aparecen.
        final genres = {for (final s in inCategory) s.genre}.toList();
        final list = _genre == null
            ? inCategory
            : inCategory.where((s) => s.genre == _genre).toList();
        return ListView(
          children: [
            const AppHeader(),
            _chips(),
            if (genres.length > 1) _genreChips(genres),
            if (Store.error.value != null && all == null)
              EmptyState(
                'No se pudo conectar con Firestore:\n${Store.error.value}',
                icon: Icons.cloud_off,
              )
            else if (all == null)
              const Padding(
                padding: EdgeInsets.all(AppPadding.padding5xl48),
                child: loading,
              )
            else if (all.isEmpty)
              EmptyState(
                'Todavía no hay emisoras',
                action: FilledButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const ProfileScreen(),
                    ),
                  ),
                  child: const Text('CARGAR DATOS DEMO'),
                ),
              )
            else ...[
              const SectionTitle('Recientes'),
              _recentsGrid(list),
              for (final genre in {for (final s in list) s.genre}) ...[
                SectionTitle(genre),
                _row(list.where((s) => s.genre == genre).toList(), list),
              ],
            ],
          ],
        );
      },
    );
  }

  Widget _chips() => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: AppPadding.paddingL16,
      vertical: AppPadding.paddingS8,
    ),
    child: Row(
      children: [
        for (final c in categories.entries)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.paddingXs4,
              ),
              child: TuneInChip(
                c.value,
                selected: c.key == _category,
                onTap: () => setState(() {
                  _category = c.key;
                  _genre = null; // al cambiar de categoría, volver a "Todos"
                }),
              ),
            ),
          ),
      ],
    ),
  );

  /// Filter chips: Todos · Rock · Pop · Latino (según la categoría).
  Widget _genreChips(List<String> genres) => SizedBox(
    height: FilterChipTokens.touchTarget,
    child: ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.paddingXl20),
      children: [
        for (final g in [null, ...genres])
          Padding(
            padding: const EdgeInsets.only(right: FilterChipTokens.gap),
            child: GenreFilterChip(
              g ?? 'Todos',
              selected: _genre == g,
              onTap: () => setState(() => _genre = g),
            ),
          ),
      ],
    ),
  );

  /// Grilla 3×2 con lo último escuchado (o destacados si no hay).
  Widget _recentsGrid(List<Station> list) {
    final recents = Store.recentStations.where((s) => s.category == _category);
    final shown = (recents.isEmpty ? list : recents).take(6).toList();
    // Cards L (96) de Figma, 3 por fila.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.paddingXl20),
      child: Wrap(
        spacing: AppGap.gapM12,
        runSpacing: AppGap.gapM12,
        children: [
          for (final s in shown)
            GestureDetector(
              onTap: () => openStation(context, s, queue: list),
              child: Cover(s.imageUrl, size: CardTokens.l),
            ),
        ],
      ),
    );
  }

  /// Fila horizontal: portada + nombre + género.
  Widget _row(List<Station> stations, List<Station> queue) => SizedBox(
    height: CardTokens.rowHeight,
    child: ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.paddingXl20),
      children: [
        for (final s in stations)
          Padding(
            padding: const EdgeInsets.only(right: AppPadding.paddingS8),
            child: InkWell(
              onTap: () => openStation(context, s, queue: queue),
              child: SizedBox(
                width: CardTokens.m,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Cover(s.imageUrl, size: CardTokens.m),
                    const SizedBox(height: AppGap.gapXs4),
                    Text(
                      s.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.body2.copyWith(
                        color: AppSemanticColors.colorTextMain,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      s.genre,
                      maxLines: 1,
                      style: AppTypography.body2.copyWith(
                        color: AppColors.neutral200,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
