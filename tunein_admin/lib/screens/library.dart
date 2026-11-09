import 'package:flutter/material.dart';

import '../services/db.dart';
import '../theme/tokens.dart';
import '../widgets.dart';
import 'player.dart';

/// Librería (Figma: "librerias") — emisoras guardadas con ♥.
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([Store.stations, Store.favorites]),
      builder: (context, _) {
        final favs = Store.favoriteStations;
        return ListView(
          children: [
            const AppHeader(),
            const SectionTitle('Librería'),
            if (favs.isEmpty)
              const EmptyState(
                'Toca ♥ en el reproductor para guardar emisoras',
                icon: Icons.favorite_border,
              ),
            for (final s in favs)
              ItemTile(
                gap: RowTokens.gapLibrary,
                title: s.name,
                subtitle: s.subtitle,
                imageUrl: s.imageUrl,
                onTap: () => openStation(context, s, queue: favs),
                trailing: IconButton(
                  color: ListItemTokens.favorite,
                  icon: const Icon(Icons.favorite),
                  onPressed: () => Db.setFavorite(s.id, false),
                ),
              ),
          ],
        );
      },
    );
  }
}
