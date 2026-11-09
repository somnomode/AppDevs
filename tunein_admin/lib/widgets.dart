import 'package:flutter/material.dart';

import 'screens/player.dart';
import 'screens/profile.dart';
import 'screens/shell.dart';
import 'services/player.dart';
import 'theme/theme.dart';
import 'theme/tokens.dart';

// Componentes reutilizables de TuneIn (todos con tokens del sistema).

const _text = AppSemanticColors.colorTextMain;
const _muted = AppSemanticColors.colorTextMuted;

/// Logo TUNE|IN dibujado con tokens. [width] escala todo.
class TuneInLogo extends StatelessWidget {
  const TuneInLogo({super.key, this.width = LogoTokens.base});
  final double width;

  @override
  Widget build(BuildContext context) {
    final s = width / LogoTokens.base;
    TextStyle style(Color c) => TextStyle(
      fontFamily: AppTypography.fontFamilyOutfit,
      fontWeight: FontWeight.w700,
      fontSize: LogoTokens.fontSize * s,
      height: 1,
      color: c,
    );
    return SizedBox(
      width: width,
      height: LogoTokens.height * s,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: LogoTokens.tuneTop * s,
            width: LogoTokens.tuneWidth * s,
            height: LogoTokens.boxHeight * s,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppSemanticColors.colorBrandPrimary,
                  width: LogoTokens.stroke * s,
                ),
              ),
              child: Text(
                'TUNE',
                style: style(AppSemanticColors.colorBrandPrimary),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            width: LogoTokens.inWidth * s,
            height: LogoTokens.boxHeight * s,
            child: Container(
              alignment: const Alignment(0, LogoTokens.inTextAlignY),
              color: AppSemanticColors.colorBrandPrimary,
              child: Text(
                'IN',
                style: style(AppSemanticColors.colorTextOnPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Imagen de portada redondeada, con placeholder mientras carga.
class Cover extends StatelessWidget {
  const Cover(
    this.url, {
    super.key,
    this.size,
    this.radius = AppRadius.radiusXs,
  });
  final String url;
  final double? size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    const empty = ColoredBox(
      color: AppElevation.elevation4,
      child: Center(child: Icon(Icons.radio, color: _muted)),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: size,
        height: size,
        child: url.isEmpty
            ? empty
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => empty,
                loadingBuilder: (_, child, p) => p == null ? child : empty,
              ),
      ),
    );
  }
}

/// Chip de filtro. Naranja (primary) o teal (secondary) cuando está activo.
class TuneInChip extends StatelessWidget {
  const TuneInChip(
    this.label, {
    super.key,
    required this.selected,
    required this.onTap,
    this.teal = false,
  });
  final String label;
  final bool selected, teal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active = teal
        ? SocialTokens.accent
        : AppSemanticColors.colorBrandPrimary;
    final bg = selected
        ? active
        : (teal ? Colors.transparent : ChipTokens.inactiveBg);
    final fg = selected || !teal ? ChipTokens.inactiveText : _text;
    return Material(
      color: bg,
      shape: StadiumBorder(
        side: teal && !selected
            ? const BorderSide(color: ChipTokens.outlinedBorder)
            : BorderSide.none,
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: SizedBox(
          height: ChipTokens.height,
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              style: AppTypography.body1.copyWith(color: fg),
            ),
          ),
        ),
      ),
    );
  }
}

/// Filter chip de género — Material 3 "Filter chip" (flat) con tokens
/// TuneIn. Sin seleccionar: borde sutil, sin relleno. Seleccionado:
/// relleno naranjo de marca + check, sin borde. Área táctil de 48.
class GenreFilterChip extends StatelessWidget {
  const GenreFilterChip(
    this.label, {
    super.key,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? FilterChipTokens.textSelected : FilterChipTokens.text;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(FilterChipTokens.radius),
      side: selected
          ? BorderSide.none
          : const BorderSide(
              color: FilterChipTokens.border,
              width: FilterChipTokens.borderWidth,
            ),
    );
    return Semantics(
      button: true,
      selected: selected,
      // El GestureDetector extiende el toque a 48 de alto (regla M3);
      // el chip visible mide 32.
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          height: FilterChipTokens.touchTarget,
          child: Center(
            child: Material(
              color: selected
                  ? FilterChipTokens.bgSelected
                  : FilterChipTokens.bg,
              shape: shape,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTap,
                overlayColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.pressed)) {
                    return fg.withValues(
                      alpha: FilterChipTokens.pressedOpacity,
                    );
                  }
                  if (states.contains(WidgetState.hovered) ||
                      states.contains(WidgetState.focused)) {
                    return fg.withValues(alpha: FilterChipTokens.hoverOpacity);
                  }
                  return null;
                }),
                child: Container(
                  height: FilterChipTokens.height,
                  padding: EdgeInsetsDirectional.only(
                    start: selected
                        ? FilterChipTokens.paddingWithIcon
                        : FilterChipTokens.paddingH,
                    end: FilterChipTokens.paddingH,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (selected) ...[
                        Icon(
                          Icons.check,
                          size: FilterChipTokens.iconSize,
                          color: fg,
                        ),
                        const SizedBox(width: FilterChipTokens.iconGap),
                      ],
                      Text(
                        label,
                        maxLines: 1,
                        style: AppTypography.body1.copyWith(
                          color: fg,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Título de sección ("Recientes", "Música"…).
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppPadding.paddingXl20,
      AppPadding.paddingL16,
      AppPadding.paddingXl20,
      AppPadding.paddingS8,
    ),
    child: Text(text, style: AppTypography.h2.copyWith(color: _text)),
  );
}

/// Fila con portada, título y subtítulo (Librería, Búsqueda…).
/// Medidas: RowTokens (80 de alto, portada 64, padding 12).
class ItemTile extends StatelessWidget {
  const ItemTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.trailing,
    this.onTap,
    this.filled = false,
    this.gap = RowTokens.gap,
  });
  final String title, subtitle, imageUrl;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool filled;
  final double gap;

  @override
  Widget build(BuildContext context) => Material(
    color: filled ? ListItemTokens.bg : Colors.transparent,
    child: InkWell(
      onTap: onTap,
      child: Container(
        height: RowTokens.height,
        padding: const EdgeInsets.symmetric(horizontal: RowTokens.padding),
        child: Row(
          children: [
            Cover(imageUrl, size: RowTokens.cover),
            SizedBox(width: gap),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.sub2.copyWith(color: _text),
                  ),
                  const SizedBox(height: AppGap.gapXs4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.body2.copyWith(color: _muted),
                  ),
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    ),
  );
}

/// Mensaje centrado para listas vacías o errores.
class EmptyState extends StatelessWidget {
  const EmptyState(
    this.title, {
    super.key,
    this.icon = Icons.radio,
    this.action,
  });
  final String title;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppPadding.padding3xl32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: IconTokens.l, color: _muted),
          const SizedBox(height: AppGap.gapL16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.sub1.copyWith(color: _text),
          ),
          if (action != null) ...[
            const SizedBox(height: AppGap.gapXl20),
            action!,
          ],
        ],
      ),
    ),
  );
}

const loading = Center(child: CircularProgressIndicator());

/// "02:33" — los tiempos usan Space Mono (AppTypography.data2).
String mmss(Duration? d) => d == null
    ? '--:--'
    : '${d.inMinutes.toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

/// Alerta estilo "Opción B": fondo oscuro + borde e ícono saturados.
void showAlert(BuildContext context, String msg, {bool error = false}) {
  final border = error
      ? AppSemanticColors.colorErrorBorder
      : AppSemanticColors.colorSuccessBorder;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: error
            ? AppSemanticColors.colorErrorBg
            : AppSemanticColors.colorSuccessBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusXs),
          side: BorderSide(color: border),
        ),
        content: Row(
          children: [
            Icon(
              error ? Icons.error_outline : Icons.check_circle_outline,
              color: border,
            ),
            const SizedBox(width: AppGap.gapS8),
            Expanded(
              child: Text(
                msg,
                style: AppTypography.body1.copyWith(
                  color: error
                      ? AppSemanticColors.colorTextOnError
                      : AppSemanticColors.colorTextOnSuccess,
                ),
              ),
            ),
          ],
        ),
      ),
    );
}

/// Header de las pestañas: logo + historial, ajustes y perfil.
class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    void profile() => Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppPadding.paddingXl20,
        AppPadding.paddingL16,
        AppPadding.paddingS8,
        AppPadding.paddingS8,
      ),
      child: Row(
        children: [
          const TuneInLogo(width: LogoTokens.header),
          const Spacer(),
          IconButton(
            tooltip: 'Recientes',
            icon: const Icon(Icons.history),
            onPressed: () => AppNav.tab.value = AppNav.search,
          ),
          IconButton(
            tooltip: 'Ajustes',
            icon: const Icon(Icons.settings_outlined),
            onPressed: profile,
          ),
          IconButton(
            tooltip: 'Perfil',
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: profile,
          ),
        ],
      ),
    );
  }
}

/// Bottom navigation bar — Figma "Bottom Navigation Bar FINAL".
class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.index, required this.onTap});
  final int index;
  final ValueChanged<int> onTap;

  static const _items = [
    ('Home', Icons.home_outlined),
    ('Library', Icons.bookmarks_outlined),
    ('Map', Icons.location_on_outlined),
    ('Search', Icons.search),
  ];

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: BottomNavTokens.bg,
    child: SafeArea(
      top: false,
      child: SizedBox(
        height: BottomNavTokens.height,
        child: Row(
          children: [
            for (var i = 0; i < _items.length; i++)
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_items[i].$2, color: _navColor(i)),
                      const SizedBox(height: AppGap.gapXs4),
                      Text(
                        _items[i].$1,
                        style: AppTypography.body2.copyWith(
                          color: _navColor(i),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );

  Color _navColor(int i) =>
      i == index ? BottomNavTokens.itemActive : BottomNavTokens.itemInactive;
}

/// Barra "Station Name · Genre · Live" sobre la navbar.
class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Player.instance;
    return ListenableBuilder(
      listenable: p,
      builder: (context, _) {
        final np = p.now;
        if (np == null) return const SizedBox.shrink();
        return Material(
          color: MiniPlayerTokens.bg,
          child: InkWell(
            onTap: () => PlayerScreen.open(context),
            child: SizedBox(
              height: MiniPlayerTokens.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.paddingXl20,
                ),
                child: Row(
                  children: [
                    Cover(np.imageUrl, size: MiniPlayerTokens.coverSize),
                    const SizedBox(width: AppGap.gapM12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            np.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.sub2.copyWith(color: _text),
                          ),
                          Text(
                            np.moment == null
                                ? '${np.station.genre} · Live'
                                : np.station.name,
                            style: AppTypography.body2.copyWith(color: _muted),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(
                        width: MiniPlayerTokens.playButton,
                        height: MiniPlayerTokens.playButton,
                      ),
                      iconSize: MiniPlayerTokens.playIcon,
                      onPressed: p.toggle,
                      icon: Icon(
                        p.playing
                            ? Icons.pause_rounded
                            : Icons.play_arrow_outlined,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Campo de formulario con etiqueta arriba (Studio).
class LabeledField extends StatelessWidget {
  const LabeledField(
    this.label,
    this.controller, {
    super.key,
    this.hint,
    this.required = false,
    this.number = false,
  });
  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool required, number;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppPadding.paddingL16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.sub2.copyWith(color: _text)),
        const SizedBox(height: AppGap.gapS8),
        TextFormField(
          controller: controller,
          style: AppTypography.body1.copyWith(color: _text),
          keyboardType: number
              ? const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                )
              : null,
          decoration: InputDecoration(hintText: hint),
          validator: (v) {
            final t = v?.trim() ?? '';
            if (required && t.isEmpty) return 'Campo obligatorio';
            if (number && t.isNotEmpty && double.tryParse(t) == null) {
              return 'Número inválido';
            }
            return null;
          },
        ),
      ],
    ),
  );
}
