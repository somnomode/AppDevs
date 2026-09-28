import 'package:flutter/material.dart';

// =============================================================
// TUNEIN — THEME
// Traducción del sistema de diseño de Figma (TuneIn_Ver2) a Flutter.
// Nombres: iguales a Figma, en camelCase (Dart no acepta guiones).
//   primary-400      -> AppColors.primary400
//   spacing-l-16     -> AppSpacing.spacingL16
//   color-text-main  -> AppSemanticColors.colorTextMain
// Unidades Flutter:
//   - Tamaños, spacing, radius y letterSpacing: píxeles lógicos (dp).
//   - Line-height: Flutter usa un multiplicador (height = lineHeight / fontSize).
// =============================================================


// -------------------------------------------------------------
// 1. PRIMITIVOS DE COLOR (TuneIn / Colors → primitives)
// -------------------------------------------------------------

class AppColors {
  // PRIMARY — high / principal
  static const primary50 = Color(0xFFFAF3F1);
  static const primary100 = Color(0xFFF8DCD2);
  static const primary200 = Color(0xFFF7B7A0);
  static const primary300 = Color(0xFFFA916A);
  static const primary400 = Color(0xFFFF6B35); // BASE
  static const primary500 = Color(0xFFFF4400);
  static const primary600 = Color(0xFFCA3701);
  static const primary700 = Color(0xFF942B04);
  static const primary800 = Color(0xFF5E1E07);
  static const primary900 = Color(0xFF2C1006);

  // SECONDARY — mid / comunicaciones
  static const secondary50 = Color(0xFFF2FAF9);
  static const secondary100 = Color(0xFFDCF3F1);
  static const secondary200 = Color(0xFFB8E9E6);
  static const secondary300 = Color(0xFF86DED8);
  static const secondary400 = Color(0xFF4FD3C9);
  static const secondary500 = Color(0xFF2DB8AE); // BASE
  static const secondary600 = Color(0xFF25928A);
  static const secondary700 = Color(0xFF1D6B66);
  static const secondary800 = Color(0xFF144440);
  static const secondary900 = Color(0xFF0B2220);

  // NEUTRAL — grises
  static const neutral50 = Color(0xFFEFF0F6);
  static const neutral100 = Color(0xFFABADCA);
  static const neutral200 = Color(0xFF7678A8);
  static const neutral300 = Color(0xFF4E5182);
  static const neutral400 = Color(0xFF353868);
  static const neutral500 = Color(0xFF1F2249);
  static const neutral600 = Color(0xFF151839);
  static const neutral700 = Color(0xFF0D1028);
  static const neutral800 = Color(0xFF07091A);
  static const neutral900 = Color(0xFF03040D);

  // ERROR
  static const error50 = Color(0xFFFAF1F1);
  static const error100 = Color(0xFFF8D4D2);
  static const error200 = Color(0xFFF7A5A0);
  static const error300 = Color(0xFFFA736A);
  static const error400 = Color(0xFFFF5449);
  static const error500 = Color(0xFFFF0F00);
  static const error600 = Color(0xFFCA0D01);
  static const error700 = Color(0xFF830C04); // BASE
  static const error800 = Color(0xFF5E0C07);
  static const error900 = Color(0xFF2C0806);

  // WARNING — advertencia
  static const warning50 = Color(0xFFFAF8F1);
  static const warning100 = Color(0xFFF8EED2);
  static const warning200 = Color(0xFFF7E1A0);
  static const warning300 = Color(0xFFFAD66A);
  static const warning400 = Color(0xFFFDCB34);
  static const warning500 = Color(0xFFFFC107);
  static const warning600 = Color(0xFFCA9801);
  static const warning700 = Color(0xFF836304); // BASE
  static const warning800 = Color(0xFF5E4807);
  static const warning900 = Color(0xFF2C2206);

  // SUCCESS — éxito
  static const success50 = Color(0xFFF3F8F4);
  static const success100 = Color(0xFFD9F1DD);
  static const success200 = Color(0xFFAFE8B9);
  static const success300 = Color(0xFF83E193);
  static const success400 = Color(0xFF4CD964);
  static const success500 = Color(0xFF2CD248);
  static const success600 = Color(0xFF24A73A);
  static const success700 = Color(0xFF1A6D28); // BASE
  static const success800 = Color(0xFF164F20);
  static const success900 = Color(0xFF0D2511);

  // INFO — información
  static const info50 = Color(0xFFF2F5F9);
  static const info100 = Color(0xFFD7E4F3);
  static const info200 = Color(0xFFACC9EB);
  static const info300 = Color(0xFF7EAEE6);
  static const info400 = Color(0xFF4A90E2);
  static const info500 = Color(0xFF2378DB);
  static const info600 = Color(0xFF1D60AE);
  static const info700 = Color(0xFF153E6E); // BASE
  static const info800 = Color(0xFF133052);
  static const info900 = Color(0xFF0B1827);
}


// -------------------------------------------------------------
// 2. ELEVACIÓN (TuneIn / Colors → elevation)
// Interfaz oscura: la elevación se expresa con variaciones tonales,
// no con sombras. 0 = fondo, 5 = nivel más alto.
// -------------------------------------------------------------

class AppElevation {
  static const elevation0 = AppColors.neutral900;
  static const elevation1 = AppColors.neutral800;
  static const elevation2 = AppColors.neutral700;
  static const elevation3 = AppColors.neutral600;
  static const elevation4 = AppColors.neutral500;
  static const elevation5 = AppColors.neutral400;
}


// -------------------------------------------------------------
// 3. COLORES SEMÁNTICOS (TuneIn / Colors → Semantic)
// Cada token apunta a un primitivo, igual que en Figma.
// -------------------------------------------------------------

class AppSemanticColors {
  // BRAND
  static const colorBrandPrimary = AppColors.primary400;
  static const colorBrandPrimaryContainer = AppColors.primary600;
  static const colorBrandSecondary = AppColors.secondary500;
  static const colorBrandSecondaryContainer = AppColors.secondary300;

  // ACTION (estados de interacción)
  static const colorActionPrimaryDefault = AppColors.primary400;
  static const colorActionPrimaryPressed = AppColors.primary500;
  static const colorActionSecondaryDefault = AppColors.secondary500;
  static const colorActionSecondaryPressed = AppColors.secondary600;

  // TEXT
  static const colorTextMain = AppColors.neutral50;
  static const colorTextBody = AppColors.neutral50;
  static const colorTextMuted = AppColors.neutral100;
  static const colorTextDisabled = AppColors.neutral400;
  static const colorTextPrimary = AppColors.primary400;
  static const colorTextSecondary = AppColors.secondary500;
  static const colorTextOnPrimary = AppColors.neutral900;
  static const colorTextOnPrimaryContainer = AppColors.primary50;
  static const colorTextOnSecondary = AppColors.neutral900;
  static const colorTextOnSecondaryContainer = AppColors.secondary900;
  static const colorTextOnError = AppColors.error100;
  static const colorTextOnWarning = AppColors.warning100;
  static const colorTextOnInfo = AppColors.info100;
  static const colorTextOnSuccess = AppColors.success100;

  // SURFACE
  static const colorSurfaceBg = AppColors.neutral900;
  static const colorSurfaceRaised = AppElevation.elevation4;
  static const colorSurfaceEnabled = AppColors.neutral600;
  static const colorSurfaceDisabled = AppColors.neutral200;

  // BORDER
  static const colorBorderDefault = AppColors.neutral200;
  static const colorBorderSubtle = AppColors.neutral500;

  // STATUS (feedback: Material solo trae "error", el resto vive aquí)
  static const colorErrorBg = AppColors.error700;
  static const colorErrorBorder = AppColors.error400;
  static const colorWarningBg = AppColors.warning700;
  static const colorWarningBorder = AppColors.warning400;
  static const colorInfoBg = AppColors.info700;
  static const colorInfoBorder = AppColors.info400;
  static const colorSuccessBg = AppColors.success700;
  static const colorSuccessBorder = AppColors.success400;
}


// -------------------------------------------------------------
// 4. SPACING (TuneIn / Spacing) — escala base de 4dp
// -------------------------------------------------------------

class AppSpacing {
  static const double spacingNone0 = 0;
  static const double spacingXs4 = 4;
  static const double spacingS8 = 8;
  static const double spacingM12 = 12;
  static const double spacingL16 = 16;
  static const double spacingXl20 = 20;
  static const double spacing2xl24 = 24;
  static const double spacing3xl32 = 32;
  static const double spacing4xl40 = 40;
  static const double spacing5xl48 = 48;
  static const double spacing6xl52 = 52;
  static const double spacing7xl60 = 60;
  static const double spacing8xl64 = 64;
  static const double spacing9xl68 = 68;
  static const double spacing10xl72 = 72;
}

// Semánticos: apuntan a la escala base, igual que los alias de Figma.

// Padding: espacio interno de un componente.
class AppPadding {
  static const double paddingXs4 = AppSpacing.spacingXs4;
  static const double paddingS8 = AppSpacing.spacingS8;
  static const double paddingM12 = AppSpacing.spacingM12;
  static const double paddingL16 = AppSpacing.spacingL16;
  static const double paddingXl20 = AppSpacing.spacingXl20;
  static const double padding2xl24 = AppSpacing.spacing2xl24;
  static const double padding3xl32 = AppSpacing.spacing3xl32;
  static const double padding4xl40 = AppSpacing.spacing4xl40;
  static const double padding5xl48 = AppSpacing.spacing5xl48;
}

// Margin: espacio externo, separa del borde o de otros bloques.
class AppMargin {
  static const double marginXs4 = AppSpacing.spacingXs4;
  static const double marginS8 = AppSpacing.spacingS8;
  static const double marginM12 = AppSpacing.spacingM12;
  static const double marginL16 = AppSpacing.spacingL16;
  static const double margin2xl24 = AppSpacing.spacing2xl24;
  static const double margin3xl32 = AppSpacing.spacing3xl32;
  static const double margin4xl40 = AppSpacing.spacing4xl40;
  static const double margin5xl48 = AppSpacing.spacing5xl48;
}

// Gap: separación entre elementos hermanos.
class AppGap {
  static const double gapXs4 = AppSpacing.spacingXs4;
  static const double gapS8 = AppSpacing.spacingS8;
  static const double gapM12 = AppSpacing.spacingM12;
  static const double gapL16 = AppSpacing.spacingL16;
  static const double gapXl20 = AppSpacing.spacingXl20;
  static const double gap3xl32 = AppSpacing.spacing3xl32;
  static const double gap5xl48 = AppSpacing.spacing5xl48;
}


// -------------------------------------------------------------
// 5. RADIUS (TuneIn / Shape Primitives)
// -------------------------------------------------------------

class AppRadius {
  static const double radiusNone = 0;
  static const double radiusXs = 4;
  static const double radiusS = 8;
  static const double radiusM = 16;
  static const double radiusL = 24;
  static const double radiusFull = 9999; // botones y reproducción
}


// -------------------------------------------------------------
// 6. TIPOGRAFÍA (TuneIn / Typography)
// letterSpacing en px lógicos (Flutter no usa %).
// height = line-height / size → se escribe como división para que
// se vea el valor de Figma (ej: 40 / 32 = line-height 40 en h1).
// leadingDistribution.even reparte el interlineado arriba y abajo,
// igual que Figma.
// -------------------------------------------------------------

class AppTypography {
  static const String fontFamilyOutfit = 'Outfit';
  static const String fontFamilySpaceMono = 'Space Mono';

  // HEADING
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamilyOutfit,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.25,
    height: 40 / 32,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamilyOutfit,
    fontSize: 26,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    height: 32 / 26,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamilyOutfit,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 28 / 22,
    leadingDistribution: TextLeadingDistribution.even,
  );

  // SUBTITLE
  static const TextStyle sub1 = TextStyle(
    fontFamily: fontFamilyOutfit,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 24 / 18,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle sub2 = TextStyle(
    fontFamily: fontFamilyOutfit,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 24 / 16,
    leadingDistribution: TextLeadingDistribution.even,
  );

  // BODY
  static const TextStyle body1 = TextStyle(
    fontFamily: fontFamilyOutfit,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 20 / 14,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: fontFamilyOutfit,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 16 / 12,
    leadingDistribution: TextLeadingDistribution.even,
  );

  // BUTTON
  static const TextStyle btn = TextStyle(
    fontFamily: fontFamilyOutfit,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
    height: 16 / 12,
    leadingDistribution: TextLeadingDistribution.even,
  );

  // CAPTION / OVERLINE
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamilyOutfit,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 16 / 11,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: fontFamilyOutfit,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
    height: 16 / 11,
    leadingDistribution: TextLeadingDistribution.even,
  );

  // DATA (Space Mono: números de ancho fijo para tiempos y contadores)
  static const TextStyle data1 = TextStyle(
    fontFamily: fontFamilySpaceMono,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.75,
    height: 20 / 14,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle data2 = TextStyle(
    fontFamily: fontFamilySpaceMono,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 16 / 12,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle data3 = TextStyle(
    fontFamily: fontFamilySpaceMono,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 24 / 16,
    leadingDistribution: TextLeadingDistribution.even,
  );
}


// -------------------------------------------------------------
// 7. MATERIAL TEXT THEME
// Conecta la escala de TuneIn con los roles de texto de Material,
// para usar Theme.of(context).textTheme.headlineLarge, etc.
// data1, data2 y data3 no tienen equivalente: se usan directo
// (AppTypography.data1).
// -------------------------------------------------------------

const TextTheme appTextTheme = TextTheme(
  headlineLarge: AppTypography.h1,
  headlineMedium: AppTypography.h2,
  headlineSmall: AppTypography.h3,

  titleLarge: AppTypography.sub1,
  titleMedium: AppTypography.sub2,

  bodyLarge: AppTypography.body1,
  bodyMedium: AppTypography.body2,
  bodySmall: AppTypography.caption,

  labelLarge: AppTypography.btn,
  labelSmall: AppTypography.overline,
);


// -------------------------------------------------------------
// 8. TEMA TUNEIN (modo oscuro)
// Color mapping: cada rol de Material apunta a un token semántico.
// -------------------------------------------------------------

final ThemeData tuneInTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  colorScheme: const ColorScheme.dark(
    // MAPA PRIMARY
    primary: AppSemanticColors.colorBrandPrimary,
    onPrimary: AppSemanticColors.colorTextOnPrimary,
    primaryContainer: AppSemanticColors.colorBrandPrimaryContainer,
    onPrimaryContainer: AppSemanticColors.colorTextOnPrimaryContainer,

    // MAPA SECONDARY
    secondary: AppSemanticColors.colorBrandSecondary,
    onSecondary: AppSemanticColors.colorTextOnSecondary,
    secondaryContainer: AppSemanticColors.colorBrandSecondaryContainer,
    onSecondaryContainer: AppSemanticColors.colorTextOnSecondaryContainer,

    // MAPA ERROR
    // "error" se usa para texto e íconos sobre el fondo, así que va el
    // tono claro (border); el tono oscuro (bg) va como container.
    error: AppSemanticColors.colorErrorBorder,
    onError: AppColors.neutral900,
    errorContainer: AppSemanticColors.colorErrorBg,
    onErrorContainer: AppSemanticColors.colorTextOnError,

    // MAPA SURFACE (elevación tonal 0–5)
    surface: AppSemanticColors.colorSurfaceBg, // elevation-0
    onSurface: AppSemanticColors.colorTextMain,
    onSurfaceVariant: AppSemanticColors.colorTextMuted,
    surfaceDim: AppElevation.elevation0,
    surfaceBright: AppElevation.elevation5,
    surfaceContainerLowest: AppElevation.elevation1,
    surfaceContainerLow: AppElevation.elevation2,
    surfaceContainer: AppElevation.elevation3,
    surfaceContainerHigh: AppElevation.elevation4,
    surfaceContainerHighest: AppElevation.elevation5,

    // MAPA BORDER
    outline: AppSemanticColors.colorBorderDefault,
    outlineVariant: AppSemanticColors.colorBorderSubtle,
  ),

  scaffoldBackgroundColor: AppSemanticColors.colorSurfaceBg,

  // TIPOGRAFÍA
  // bodyColor/displayColor dan el color de texto por defecto.
  textTheme: appTextTheme.apply(
    bodyColor: AppSemanticColors.colorTextBody,
    displayColor: AppSemanticColors.colorTextMain,
  ),

  // APP BAR
  appBarTheme: AppBarTheme(
    backgroundColor: AppSemanticColors.colorSurfaceBg,
    foregroundColor: AppSemanticColors.colorTextMain,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    titleTextStyle: AppTypography.h2.copyWith(
      color: AppSemanticColors.colorTextMain,
    ),
  ),

  // BOTÓN PRINCIPAL (usa los tokens de action: default y pressed)
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppSemanticColors.colorSurfaceDisabled;
        }
        if (states.contains(WidgetState.pressed)) {
          return AppSemanticColors.colorActionPrimaryPressed;
        }
        return AppSemanticColors.colorActionPrimaryDefault;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppSemanticColors.colorTextDisabled;
        }
        return AppSemanticColors.colorTextOnPrimary;
      }),
      textStyle: const WidgetStatePropertyAll(AppTypography.btn),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: AppPadding.padding2xl24,
          vertical: AppPadding.paddingM12,
        ),
      ),
      shape: const WidgetStatePropertyAll(StadiumBorder()), // radius-full
    ),
  ),
);
