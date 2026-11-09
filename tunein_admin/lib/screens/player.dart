import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models.dart';
import '../services/db.dart';
import '../services/player.dart';
import '../theme/theme.dart';
import '../theme/tokens.dart';
import '../widgets.dart';
import 'community.dart';
import 'shell.dart';

const _text = AppSemanticColors.colorTextMain;

/// Los íconos de 36 viven en un área tocable de 48 (mínimo recomendado):
/// sobran 6 por lado, que se descuentan del espacio para que la distancia
/// visible entre íconos sea exactamente controlsGap (48).
const _touchPad = (IconButtonTokens.m - IconTokens.m) / 2;

/// Reproduce una emisora y abre el reproductor.
Future<void> openStation(
  BuildContext context,
  Station s, {
  List<Station>? queue,
}) async {
  final done = Player.instance.playStation(s, queue: queue);
  PlayerScreen.open(context);
  await done;
  if (Player.instance.error case final e? when context.mounted) {
    showAlert(context, e, error: true);
  }
}

/// Reproductor con toggle Radio | Comunidad (Figma: "Reproductor", "soc2-4").
class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  static void open(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute<void>(builder: (_) => const PlayerScreen()),
  );

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  bool _community = false;

  @override
  Widget build(BuildContext context) {
    final p = Player.instance;
    return ListenableBuilder(
      listenable: p,
      builder: (context, _) {
        final np = p.now;
        return Scaffold(
          backgroundColor: PlayerTokens.bg,
          body: SafeArea(
            child: np == null
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_down),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Expanded(child: Center(child: _modeToggle())),
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () => _options(context, np.station),
                          ),
                        ],
                      ),
                      Expanded(
                        child: _community
                            ? CommunityView(
                                np.station,
                                key: ValueKey(np.station.id),
                              )
                            : _NowPlaying(np),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  /// Toggle [📻 | 👥]: radio activo = naranja, comunidad activa = teal.
  Widget _modeToggle() {
    Widget seg(bool community, IconData icon) {
      final on = community == _community;
      return GestureDetector(
        onTap: () => setState(() => _community = community),
        child: Container(
          width: ModeToggleTokens.segmentWidth,
          height: ModeToggleTokens.height,
          color: !on
              ? null
              : community
              ? ModeToggleTokens.communityActive
              : ModeToggleTokens.radioActive,
          child: Icon(
            icon,
            color: on
                ? ModeToggleTokens.iconActive
                : ModeToggleTokens.iconInactive,
          ),
        ),
      );
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        shape: StadiumBorder(
          side: BorderSide(
            color: _community
                ? ModeToggleTokens.communityActive
                : ModeToggleTokens.radioActive,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [seg(false, Icons.radio), seg(true, Icons.groups)],
      ),
    );
  }
}

/// Vista "Radio": portada, título, ♥, progreso, controles, recomendaciones.
class _NowPlaying extends StatelessWidget {
  const _NowPlaying(this.np);
  final NowPlaying np;

  @override
  Widget build(BuildContext context) {
    final p = Player.instance;
    final s = np.station;
    return LayoutBuilder(
      builder: (context, box) {
        // Portada como en Figma: todo el ancho menos el margen. En pantallas
        // bajas se achica para que quepan los controles (~300 de alto).
        final cover = (box.maxWidth - 2 * PlayerTokens.coverMargin).clamp(
          PlayerTokens.coverMin,
          (box.maxHeight - PlayerTokens.controlsReserve).clamp(
            PlayerTokens.coverMin,
            double.infinity,
          ),
        );
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PlayerTokens.coverMargin,
          ),
          child: Column(
            children: [
              const SizedBox(height: AppGap.gapL16),
              Cover(np.imageUrl, size: cover, radius: PlayerTokens.coverRadius),
              const SizedBox(height: PlayerTokens.infoGap),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: PlayerTokens.infoInset,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            np.moment == null
                                ? '${s.name} ${s.frequency}'
                                : np.title,
                            maxLines: 2,
                            style: AppTypography.h3.copyWith(color: _text),
                          ),
                          Text(
                            s.subtitle,
                            style: AppTypography.body2.copyWith(
                              color: AppSemanticColors.colorTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_outlined),
                      onPressed: () => _share(context, s),
                    ),
                    _FavoriteButton(s),
                  ],
                ),
              ),
              const SizedBox(height: AppGap.gapM12),
              _progress(p),
              const Spacer(),
              // Controles (Figma "Reproductor"): 36 · 48 · 88 · 48 · 36.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: PlayerTokens.controlIcon,
                    icon: const Icon(Icons.skip_previous_outlined),
                    onPressed: p.canSkip ? () => p.skip(-1) : null,
                  ),
                  const SizedBox(width: PlayerTokens.controlsGap - _touchPad),
                  IconButton.filled(
                    iconSize: PlayerTokens.playIcon,
                    style: IconButton.styleFrom(
                      backgroundColor: PlayerTokens.playButtonBg,
                      fixedSize: const Size.square(PlayerTokens.playButtonSize),
                    ),
                    onPressed: p.toggle,
                    icon: p.loading
                        ? const CircularProgressIndicator()
                        : Icon(
                            p.playing
                                ? Icons.pause_rounded
                                : Icons.play_arrow_outlined,
                            color: _text,
                          ),
                  ),
                  const SizedBox(width: PlayerTokens.controlsGap - _touchPad),
                  IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: PlayerTokens.controlIcon,
                    icon: const Icon(Icons.skip_next_outlined),
                    onPressed: p.canSkip ? () => p.skip(1) : null,
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _recommendations(context, s),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppPadding.paddingL16,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: PlayerTokens.handleWidth,
                        height: PlayerTokens.handleHeight,
                        color: PlayerTokens.handle,
                      ),
                      const SizedBox(height: AppGap.gapM12),
                      Text(
                        'Recomendaciones',
                        style: AppTypography.sub1.copyWith(color: _text),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Barra de progreso naranja + tiempos en Space Mono.
  Widget _progress(Player p) => StreamBuilder(
    stream: p.position,
    builder: (context, snap) {
      final total = p.currentDuration ?? Duration.zero;
      final pos = snap.data ?? Duration.zero;
      final max = total.inMilliseconds.toDouble();
      final time = AppTypography.data2.copyWith(color: _text);
      return Column(
        children: [
          Slider(
            value: pos.inMilliseconds.clamp(0, max).toDouble(),
            max: max == 0 ? 1 : max,
            onChanged: max == 0
                ? null
                : (v) => p.seek(Duration(milliseconds: v.round())),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(mmss(pos), style: time),
              Text(max == 0 ? '--:--' : mmss(total), style: time),
            ],
          ),
        ],
      );
    },
  );
}

/// ♥ de emisora: la guarda en la Librería.
class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton(this.s);
  final Station s;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: Store.favorites,
    builder: (context, favs, _) {
      final on = favs.contains(s.id);
      return IconButton(
        color: on ? ListItemTokens.favorite : null,
        icon: Icon(on ? Icons.favorite : Icons.favorite_border),
        onPressed: () async {
          await Db.setFavorite(s.id, !on);
          if (context.mounted) {
            showAlert(
              context,
              on ? 'Quitado de favoritos' : 'Agregado a favoritos',
            );
          }
        },
      );
    },
  );
}

void _share(BuildContext context, Station s) {
  Clipboard.setData(ClipboardData(text: 'Escuchando ${s.name} en TuneIn 📻'));
  showAlert(context, 'Copiado al portapapeles');
}

/// Hoja "Recomendaciones": las demás emisoras, primero las de su categoría.
void _recommendations(BuildContext context, Station current) {
  final all = Store.stations.value ?? [];
  final others = all.where((s) => s.id != current.id).toList()
    ..sort(
      (a, b) => (a.category == current.category ? 0 : 1).compareTo(
        b.category == current.category ? 0 : 1,
      ),
    );
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => SizedBox(
      height: MediaQuery.sizeOf(ctx).height * 0.75,
      child: ListView(
        children: [
          const SectionTitle('Recomendaciones'),
          for (final s in others)
            ItemTile(
              title: s.name,
              subtitle: s.subtitle,
              imageUrl: s.imageUrl,
              trailing: const Icon(Icons.play_arrow_outlined),
              onTap: () {
                Navigator.pop(ctx);
                Player.instance.playStation(s, queue: all);
              },
            ),
        ],
      ),
    ),
  );
}

/// Hoja "⋮" (Figma: "Frame 209").
void _options(BuildContext context, Station s) {
  final p = Player.instance;
  void soon(BuildContext ctx) {
    Navigator.pop(ctx);
    showAlert(context, 'Próximamente');
  }

  Widget tile(BuildContext ctx, IconData i, String t, [VoidCallback? onTap]) =>
      ListTile(
        leading: Icon(i),
        title: Text(t, style: AppTypography.sub2.copyWith(color: _text)),
        onTap: onTap ?? () => soon(ctx),
      );

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                s.name,
                style: AppTypography.h3.copyWith(color: _text),
              ),
              subtitle: Text(s.subtitle),
              trailing: _FavoriteButton(s),
            ),
            tile(ctx, Icons.directions_car_outlined, 'Modo auto'),
            tile(ctx, Icons.cast, 'Castear'),
            tile(ctx, Icons.share_outlined, 'Compartir', () {
              Navigator.pop(ctx);
              _share(context, s);
            }),
            tile(ctx, Icons.devices_outlined, 'Controlar dispositivos'),
            tile(ctx, Icons.info_outline, 'Información', () {
              Navigator.pop(ctx);
              showDialog<void>(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(s.name),
                  content: Text(
                    '${s.description}\n\n${s.genre} · ${s.location} · ${s.frequency}',
                  ),
                ),
              );
            }),
            tile(ctx, Icons.block, 'Bloquear'),
            tile(ctx, Icons.report_gmailerrorred, 'Reportar'),
            if (s.hasLocation)
              tile(ctx, Icons.location_on_outlined, 'Encontrar en el mapa', () {
                Navigator.of(context).popUntil((r) => r.isFirst);
                AppNav.showOnMap(s);
              }),
            tile(
              ctx,
              Icons.bedtime_outlined,
              p.sleepTimerOn
                  ? 'Timer de Sueño: apagar'
                  : 'Timer de Sueño (30 min)',
              () {
                Navigator.pop(ctx);
                p.sleepIn(p.sleepTimerOn ? null : const Duration(minutes: 30));
                showAlert(
                  context,
                  p.sleepTimerOn ? 'Se pausará en 30 minutos' : 'Timer apagado',
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}
