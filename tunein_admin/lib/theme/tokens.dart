import 'package:flutter/material.dart';

import 'theme.dart';

// =============================================================
// TOKENS DE COMPONENTE (tier 3) + temas de componentes de Material.
// Cada token de componente apunta a un semántico o de elevación de
// theme.dart. Las pantallas usan estos nombres, nunca hex directos.
// =============================================================

// ------------------------------------------------------------ TAMAÑOS
// Escalas tomadas de la documentación de Figma ("Botones", "Cards",
// "Reproductor"), redondeadas a la grilla de 4dp. Ver DECISIONES_DIMENSIONES.txt.

/// icon-size/* — tamaño del ícono (el dibujo).
class IconTokens {
  static const double xs = 16; // icon-size-xs-16
  static const double s = 24; // icon-size-s-24 (ícono Material estándar)
  static const double m = 36; // icon-size-m-36
  static const double l = 48; // icon-size-l-48 (Figma: 50)
}

/// icon-button-size/* — tamaño del botón (círculo o área tocable).
class IconButtonTokens {
  static const double xs = 24; // icon-button-size-xs-24
  static const double s = 36; // icon-button-size-s-36
  static const double m = 48; // icon-button-size-m-48
  static const double l = 88; // icon-button-size-l-88
}

/// card-size/* — portadas cuadradas.
class CardTokens {
  static const double xl = 144; // card-size-xl-144
  static const double l = 96; // card-size-l-96  (Home: Recientes)
  static const double m = 64; // card-size-m-64  (Home: filas por género)
  static const double s = 56; // card-size-s-56  (Búsqueda: Recientes)
  static const double xs = 48; // card-size-xs-48 (mini player)
  static const double bannerWidth = 316; // card-banner-width-316
  static const double bannerHeight = 152; // card-banner-height-152 (Figma: 154)
  // Home: fila por género = card m + nombre + género (+ aire).
  static const double rowHeight = 112;
}

/// logo/* — logo TUNE|IN. Medidas del dibujo en su tamaño base (208);
/// el widget las escala según el ancho pedido.
class LogoTokens {
  static const double splash = 240; // pantalla de carga
  static const double base = 208; // tamaño de diseño
  static const double header = 76; // header de las pestañas
  // Geometría del dibujo (a tamaño base)
  static const double height = 116;
  static const double fontSize = 36;
  static const double tuneTop = 32;
  static const double tuneWidth = 134;
  static const double boxHeight = 84;
  static const double inWidth = 76;
  static const double stroke = 3;
  static const double inTextAlignY = -0.45; // "IN" un poco arriba
}

/// map/* — pantalla Mapa.
class MapTokens {
  static const double markerHue = 16; // tono del pin ≈ primary-400
  static const double cardInset = AppSpacing.spacingL16; // tarjeta: lados
  static const double cardBottom = AppSpacing.spacing3xl32; // tarjeta: abajo
}

/// row/* — filas "en librería" y "recomended" (80 de alto, portada 64).
class RowTokens {
  static const double height = 80;
  static const double cover = CardTokens.m;
  static const double padding = AppSpacing.spacingM12;
  static const double gap = AppSpacing.spacingM12; // recomended (Figma: 10)
  static const double gapLibrary = AppSpacing.spacingL16; // en librería
}

/// audioclip/* — tarjeta "audio clip" (Audio Moments).
class ClipCardTokens {
  static const double minHeight = 88;
  static const double cover = CardTokens.m;
  static const double padding = AppSpacing.spacingM12;
  static const double gap = AppSpacing.spacingM12; // Figma: 10
  static const double playButton = IconButtonTokens.xs;
  static const double playIcon = IconTokens.xs;
}

/// post/* — tarjeta "post".
class PostCardTokens {
  static const double cover = 112; // Figma: 116 implícito
  static const double padding = AppSpacing.spacingL16;
  static const double gap = AppSpacing.spacingL16;
}

/// bottomnavbar/* — Figma: "Bottom Navigation Bar FINAL" (829:1721)
class BottomNavTokens {
  static const bg = AppColors.neutral800;
  static const itemActive = AppSemanticColors.colorBrandPrimary;
  static const itemInactive = AppSemanticColors.colorTextMain;
  static const double height = 72;
}

/// miniplayer/* — barra "Station Name · Genre · Live"
class MiniPlayerTokens {
  static const bg = AppElevation.elevation4;
  static const double height = 56; // Figma "mini player": 360×56
  static const double coverSize = 48;
  static const double playButton = IconButtonTokens.s; // 36
  static const double playIcon = IconTokens.s; // 24
}

/// player/* — pantalla "Reproductor"
class PlayerTokens {
  static const bg = AppElevation.elevation2;
  static const trackActive = AppSemanticColors.colorBrandPrimary;
  static const trackInactive = AppColors.neutral50;
  static const playButtonBg = AppElevation.elevation4;
  static const handle = AppColors.neutral100;
  static const double handleWidth = 172; // barra "Recomendaciones"
  static const double handleHeight = AppSpacing.spacingXs4;
  // Portada en pantallas bajas: mínimo, y alto reservado a los controles.
  static const double coverMin = 120;
  static const double controlsReserve = 300;
  static const double playButtonSize = IconButtonTokens.l; // 88
  static const double playIcon = IconTokens.l; // 48 (Figma: 50)
  static const double controlIcon = IconTokens.m; // 36: anterior / siguiente
  static const double controlsGap = AppSpacing.spacing5xl48; // Figma: 50
  // Portada: ocupa el ancho menos 20 a cada lado (Figma: 320 de 360).
  static const double coverMargin = AppSpacing.spacingXl20;
  static const double coverRadius = AppRadius.radiusM;
  static const double infoGap = AppSpacing.spacingM12; // portada → título
  static const double infoInset =
      AppSpacing.spacingS8; // título y ♥ hacia adentro
}

/// modetoggle/* — toggle Radio | Comunidad
class ModeToggleTokens {
  static const radioActive = AppSemanticColors.colorBrandPrimary;
  static const communityActive = AppSemanticColors.colorBrandSecondary;
  static const iconActive = AppSemanticColors.colorTextOnPrimary;
  static const iconInactive = AppSemanticColors.colorTextMain;
  static const double segmentWidth = 64; // Figma: 63 (toggle 126 → 128)
  static const double height = 48;
}

/// social/* — sección Comunidad (teal = secondary)
class SocialTokens {
  static const cardBg = AppElevation.elevation5;
  static const accent = AppSemanticColors.colorBrandSecondary;
  static const onAccent = AppSemanticColors.colorTextOnSecondary;
  static const trackInactive = AppColors.secondary100;
  static const divider = AppColors.neutral200;
  static const inputBg = AppColors.neutral300;
}

/// chip/* — filtros (Radio · Deporte · Podcast)
class ChipTokens {
  static const inactiveBg = AppColors.neutral50;
  static const inactiveText = AppColors.neutral900;
  static const outlinedBorder = AppColors.neutral200;
  static const double height = AppSpacing.spacing3xl32;
}

/// filterchip/* — chips de género (Todos · Rock · Pop …).
/// Sigue la spec de Material 3 "Filter chip" (versión flat), con los
/// tokens de TuneIn. Spec M3 → token nuestro:
///   container.height 32          → height (32)
///   container.shape corner.small → AppRadius.radiusS (8)
///   flat.container.elevation 0   → AppElevation.elevation0 (sin relleno)
///   unselected.outline 1dp outlineVariant → colorBorderSubtle
///   unselected.label onSurfaceVariant     → colorTextMuted
///   selected.outline.width 0     → sin borde al seleccionar
///   selected.container secondaryContainer → colorBrandPrimaryContainer
///       (cambio intencional: usamos el naranjo de marca, no el teal)
///   selected.label onSecondaryContainer   → colorTextOnPrimaryContainer
///   label-text labelLarge (14/20 medium)  → body1 en peso 500
///   icon.size 18                 → IconTokens.xs (16, grilla de 4)
///   padding 16 (8 con ícono) · ícono↔texto 8 · entre chips 8
///   touch target mínimo 48
class FilterChipTokens {
  static const double height = 32;
  static const double touchTarget = 48;
  static const double radius = AppRadius.radiusS;
  // Sin seleccionar (flat, elevation 0)
  static const bg = Colors.transparent; // deja ver elevation0 del fondo
  static const border = AppSemanticColors.colorBorderSubtle;
  static const double borderWidth = 1;
  static const text = AppSemanticColors.colorTextMuted;
  // Seleccionado
  static const bgSelected = AppSemanticColors.colorBrandPrimaryContainer;
  static const textSelected = AppSemanticColors.colorTextOnPrimaryContainer;
  // Estados (opacidad de la capa de estado, M3)
  static const double pressedOpacity = 0.10;
  static const double hoverOpacity = 0.08;
  // Medidas
  static const double paddingH = AppPadding.paddingL16;
  static const double paddingWithIcon = AppPadding.paddingS8;
  static const double iconGap = AppGap.gapS8;
  static const double iconSize = IconTokens.xs;
  static const double gap = AppGap.gapS8; // entre chips
}

/// listitem/* — filas de Librería, Búsqueda, Recomendaciones
class ListItemTokens {
  static const bg = AppElevation.elevation4;
  static const favorite = AppSemanticColors.colorBrandPrimary;
}

// ------------------------------------------------------------- TEMA FINAL

OutlineInputBorder _border(Color c, [double w = 1]) => OutlineInputBorder(
  borderRadius: BorderRadius.circular(AppRadius.radiusL),
  borderSide: BorderSide(color: c, width: w),
);

/// `tuneInTheme` (theme.dart) + temas de inputs, botones, sheets y slider.
final ThemeData tuneInAppTheme = tuneInTheme.copyWith(
  inputDecorationTheme: InputDecorationThemeData(
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppPadding.paddingXl20,
      vertical: AppPadding.paddingM12,
    ),
    hintStyle: AppTypography.body1.copyWith(color: AppColors.neutral300),
    enabledBorder: _border(AppSemanticColors.colorBrandPrimary),
    focusedBorder: _border(AppColors.primary300, 2),
    errorBorder: _border(AppSemanticColors.colorErrorBorder),
    focusedErrorBorder: _border(AppSemanticColors.colorErrorBorder, 2),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppSemanticColors.colorTextMain,
      side: const BorderSide(color: AppSemanticColors.colorBrandPrimary),
      shape: const StadiumBorder(),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppSemanticColors.colorTextMain,
    ),
  ),
  iconTheme: const IconThemeData(color: AppSemanticColors.colorTextMain),
  dividerTheme: const DividerThemeData(
    color: AppSemanticColors.colorBorderSubtle,
    space: 1,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: PlayerTokens.bg,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadius.radiusM),
      ),
    ),
  ),
  snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  dialogTheme: const DialogThemeData(backgroundColor: AppElevation.elevation3),
  sliderTheme: const SliderThemeData(
    trackHeight: 4,
    activeTrackColor: PlayerTokens.trackActive,
    inactiveTrackColor: PlayerTokens.trackInactive,
    thumbColor: PlayerTokens.trackActive,
    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
    overlayShape: RoundSliderOverlayShape(overlayRadius: 12),
  ),
);
