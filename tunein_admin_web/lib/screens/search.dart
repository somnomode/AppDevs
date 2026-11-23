import 'package:flutter/material.dart';

import '../models.dart';
import '../services/db.dart';
import '../theme/theme.dart';
import '../theme/tokens.dart';
import '../widgets.dart';
import 'player.dart';
import 'shell.dart';

/// Búsqueda (Figma: "en busqueda"): Recientes + Recomendaciones, o resultados.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  /// Minúsculas y sin tildes, para que "musica" encuentre "Música".
  static String _norm(String s) {
    const from = 'áéíóúüñ', to = 'aeiouun';
    var r = s.toLowerCase();
    for (var i = 0; i < from.length; i++) {
      r = r.replaceAll(from[i], to[i]);
    }
    return r;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([Store.stations, Store.recents, _query]),
      builder: (context, _) {
        final all = Store.stations.value ?? <Station>[];
        final q = _norm(_query.text.trim());
        final results = q.isEmpty
            ? all
            : all
                  .where(
                    (s) =>
                        _norm('${s.name} ${s.genre} ${s.location}').contains(q),
                  )
                  .toList();
        final recents = Store.recentStations;
        return ListView(
          children: [
            _searchBar(),
            if (q.isEmpty && recents.isNotEmpty) ...[
              _label('Recientes'),
              SizedBox(
                height: CardTokens.s,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.paddingL16,
                  ),
                  children: [
                    for (final s in recents)
                      Padding(
                        padding: const EdgeInsets.only(
                          right: AppPadding.paddingS8,
                        ),
                        child: GestureDetector(
                          onTap: () => openStation(context, s, queue: recents),
                          child: Cover(s.imageUrl, size: CardTokens.s),
                        ),
                      ),
                  ],
                ),
              ),
            ],
            _label(q.isEmpty ? 'Recomendaciones' : 'Resultados'),
            if (results.isEmpty)
              EmptyState('Sin resultados', icon: Icons.search_off),
            for (final s in results)
              Padding(
                padding: const EdgeInsets.only(bottom: AppPadding.paddingS8),
                child: ItemTile(
                  filled: true,
                  title: s.name,
                  subtitle: s.subtitle,
                  imageUrl: s.imageUrl,
                  trailing: const Icon(Icons.play_arrow_outlined),
                  onTap: () => openStation(context, s, queue: results),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _searchBar() => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppPadding.paddingS8,
      AppPadding.paddingS8,
      AppPadding.paddingL16,
      AppPadding.paddingS8,
    ),
    child: Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: IconTokens.s),
          onPressed: () => AppNav.tab.value = AppNav.home,
        ),
        Expanded(
          child: TextField(
            controller: _query,
            style: AppTypography.body1.copyWith(color: AppColors.neutral900),
            decoration: InputDecoration(
              hintText: 'Busca emisoras, géneros o ciudades',
              filled: true,
              fillColor: AppColors.neutral50,
              suffixIcon: const Icon(Icons.search, color: AppColors.neutral900),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppRadius.radiusFull),
                ),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppPadding.paddingL16,
      AppPadding.paddingM12,
      AppPadding.paddingL16,
      AppPadding.paddingS8,
    ),
    child: Text(
      t,
      style: AppTypography.sub2.copyWith(
        color: AppSemanticColors.colorTextMain,
      ),
    ),
  );
}
