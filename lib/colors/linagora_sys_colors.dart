import 'dart:ui';

import 'package:flutter/material.dart';

class LinagoraSysColors {
  final Color primary;

  final Color? _primaryDark;

  Color get primaryDark => _primaryDark ?? primary;

  final Color onPrimary;

  final Color? _onPrimaryDark;

  Color get onPrimaryDark => _onPrimaryDark ?? onPrimary;

  final Color primaryContainer;

  final Color? _primaryContainerDark;

  Color get primaryContainerDark => _primaryContainerDark ?? primaryContainer;

  final Color onPrimaryContainer;

  final Color? _onPrimaryContainerDark;

  Color get onPrimaryContainerDark =>
      _onPrimaryContainerDark ?? onPrimaryContainer;

  final Color inversePrimary;

  final Color? _inversePrimaryDark;

  Color get inversePrimaryDark => _inversePrimaryDark ?? inversePrimary;

  final Color secondary;

  final Color? _secondaryDark;

  Color get secondaryDark => _secondaryDark ?? secondary;

  final Color onSecondary;

  final Color? _onSecondaryDark;

  Color get onSecondaryDark => _onSecondaryDark ?? onSecondary;

  final Color secondaryContainer;

  final Color? _secondaryContainerDark;

  Color get secondaryContainerDark =>
      _secondaryContainerDark ?? secondaryContainer;

  final Color onSecondaryContainer;

  final Color? _onSecondaryContainerDark;

  Color get onSecondaryContainerDark =>
      _onSecondaryContainerDark ?? onSecondaryContainer;

  final Color tertiary;

  final Color? _tertiaryDark;

  Color get tertiaryDark => _tertiaryDark ?? tertiary;

  final Color onTertiary;

  final Color? _onTertiaryDark;

  Color get onTertiaryDark => _onTertiaryDark ?? onTertiary;

  final Color tertiaryContainer;

  final Color? _tertiaryContainerDark;

  Color get tertiaryContainerDark =>
      _tertiaryContainerDark ?? tertiaryContainer;

  final Color onTertiaryContainer;

  final Color? _onTertiaryContainerDark;

  Color get onTertiaryContainerDark =>
      _onTertiaryContainerDark ?? onTertiaryContainer;

  final Color error;

  final Color? _errorDark;

  Color get errorDark => _errorDark ?? error;

  final Color onError;

  final Color? _onErrorDark;

  Color get onErrorDark => _onErrorDark ?? onError;

  final Color errorContainer;

  final Color? _errorContainerDark;

  Color get errorContainerDark => _errorContainerDark ?? errorContainer;

  final Color onErrorContainer;

  final Color? _onErrorContainerDark;

  Color get onErrorContainerDark => _onErrorContainerDark ?? onErrorContainer;

  final Color background;

  final Color? _backgroundDark;

  Color get backgroundDark => _backgroundDark ?? background;

  final Color onBackground;

  final Color? _onBackgroundDark;

  Color get onBackgroundDark => _onBackgroundDark ?? onBackground;

  final Color surface;

  final Color? _surfaceDark;

  Color get surfaceDark => _surfaceDark ?? surface;

  final Color onSurface;

  final Color? _onSurfaceDark;

  Color get onSurfaceDark => _onSurfaceDark ?? onSurface;

  final Color surfaceVariant;

  final Color? _surfaceVariantDark;

  Color get surfaceVariantDark => _surfaceVariantDark ?? surfaceVariant;

  final Color onSurfaceVariant;

  final Color? _onSurfaceVariantDark;

  Color get onSurfaceVariantDark => _onSurfaceVariantDark ?? onSurfaceVariant;

  final Color inverseSurface;

  final Color? _inverseSurfaceDark;

  Color get inverseSurfaceDark => _inverseSurfaceDark ?? inverseSurface;

  final Color onInverseSurface;

  final Color? _onInverseSurfaceDark;

  Color get onInverseSurfaceDark => _onInverseSurfaceDark ?? onInverseSurface;

  final Color shadow;

  final Color? _shadowDark;

  Color get shadowDark => _shadowDark ?? shadow;

  final Color surfaceTint;

  final Color? _surfaceTintDark;

  Color get surfaceTintDark => _surfaceTintDark ?? surfaceTint;

  final Color outline;

  final Color? _outlineDark;

  Color get outlineDark => _outlineDark ?? outline;

  final Color outlineVariant;

  final Color? _outlineVariantDark;

  Color get outlineVariantDark => _outlineVariantDark ?? outlineVariant;

  LinagoraSysColors({
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.inversePrimary,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.shadow,
    required this.surfaceTint,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    primaryDark,
    onPrimaryDark,
    primaryContainerDark,
    onPrimaryContainerDark,
    inversePrimaryDark,
    secondaryDark,
    onSecondaryDark,
    secondaryContainerDark,
    onSecondaryContainerDark,
    tertiaryDark,
    onTertiaryDark,
    tertiaryContainerDark,
    onTertiaryContainerDark,
    errorDark,
    onErrorDark,
    errorContainerDark,
    onErrorContainerDark,
    backgroundDark,
    onBackgroundDark,
    surfaceDark,
    onSurfaceDark,
    inverseSurfaceDark,
    onInverseSurfaceDark,
    shadowDark,
    surfaceTintDark,
    surfaceVariantDark,
    onSurfaceVariantDark,
    outlineDark,
    outlineVariantDark,
  })  : _primaryDark = primaryDark,
        _onPrimaryDark = onPrimaryDark,
        _primaryContainerDark = primaryContainerDark,
        _onPrimaryContainerDark = onPrimaryContainerDark,
        _inversePrimaryDark = inversePrimaryDark,
        _secondaryDark = secondaryDark,
        _onSecondaryDark = onSecondaryDark,
        _secondaryContainerDark = secondaryContainerDark,
        _onSecondaryContainerDark = onSecondaryContainerDark,
        _tertiaryDark = tertiaryDark,
        _onTertiaryDark = onTertiaryDark,
        _tertiaryContainerDark = tertiaryContainerDark,
        _onTertiaryContainerDark = onTertiaryContainerDark,
        _errorDark = errorDark,
        _onErrorDark = onErrorDark,
        _errorContainerDark = errorContainerDark,
        _onErrorContainerDark = onErrorContainerDark,
        _backgroundDark = backgroundDark,
        _onBackgroundDark = onBackgroundDark,
        _surfaceDark = surfaceDark,
        _onSurfaceDark = onSurfaceDark,
        _inverseSurfaceDark = inverseSurfaceDark,
        _onInverseSurfaceDark = onInverseSurfaceDark,
        _shadowDark = shadowDark,
        _surfaceTintDark = surfaceTintDark,
        _surfaceVariantDark = surfaceVariantDark,
        _onSurfaceVariantDark = onSurfaceVariantDark,
        _outlineDark = outlineDark,
        _outlineVariantDark = outlineVariantDark;

  static final LinagoraSysColors _materialLinagoraColors =
      LinagoraSysColors._material();

  factory LinagoraSysColors.material() {
    return _materialLinagoraColors;
  }

  LinagoraSysColors._material()
      : primary = const Color(0xFF0A84FF),
        onPrimary = const Color(0xFFFFFFFF),
        primaryContainer = const Color(0xFFD2E9FF),
        onPrimaryContainer = const Color(0xFF0157AD),
        inversePrimary = const Color(0xFF9BC8FF),
        secondary = const Color(0xFF5C9CE6),
        onSecondary = const Color(0xFFFFFFFF),
        secondaryContainer = const Color(0xFFE8F0FA),
        onSecondaryContainer = const Color(0xFF243B55),
        tertiary = const Color(0xFF8C9CAF),
        onTertiary = const Color(0xFFFFFFFF),
        tertiaryContainer = const Color(0xFFF9FAFF),
        onTertiaryContainer = const Color(0xFF000000),
        error = const Color(0xFFFF3347),
        onError = const Color(0xFFFFFFFF),
        errorContainer = const Color(0xFFF9DEDC),
        onErrorContainer = const Color(0xFF410E0B),
        background = const Color(0xFFFFFBFE),
        onBackground = const Color(0xFF1C1B1F),
        surface = const Color(0xFFF4F4F4),
        onSurface = const Color(0xFF1C1B1F),
        inverseSurface = const Color(0xFF313033),
        onInverseSurface = const Color(0xFFF4EFF4),
        shadow = const Color(0xFF000000),
        surfaceTint = const Color(0xFF6750A4),
        surfaceVariant = const Color(0xFFF7F7F8),
        onSurfaceVariant = const Color(0xFF1C1B1F),
        outline = const Color(0xFFAEAEC0),
        outlineVariant = const Color(0xFFCAC4D0),
        _primaryDark = const Color(0xFF0A84FF),
        _onPrimaryDark = const Color(0xFFFFFFFF),
        _primaryContainerDark = const Color(0xFF2D2D2E),
        _onPrimaryContainerDark = const Color(0xFFC9CACC),
        _inversePrimaryDark = const Color(0xFF0A84FF),
        _secondaryDark = const Color(0xFFCCC2DC),
        _onSecondaryDark = const Color(0xFF332D41),
        _secondaryContainerDark = const Color(0xFF3F3F3F),
        _onSecondaryContainerDark = const Color(0xFFFFFFFF),
        _tertiaryDark = const Color(0xFFEFB8C8),
        _onTertiaryDark = const Color(0xFF492532),
        _tertiaryContainerDark = const Color(0xFFD7E2F5),
        _onTertiaryContainerDark = const Color(0xFF0A84FF),
        _errorDark = const Color(0xFFE64646),
        _onErrorDark = const Color(0xFFFFFFFF),
        _errorContainerDark = const Color(0xFF8C1D18),
        _onErrorContainerDark = const Color(0xFFF9DEDC),
        _backgroundDark = const Color(0xFF1C1B1F),
        _onBackgroundDark = const Color(0xFFE6E1E5),
        _surfaceDark = const Color(0xFF1C1B1F),
        _onSurfaceDark = const Color(0xFFE6E1E5),
        _inverseSurfaceDark = const Color(0xFFFFFFFF),
        _onInverseSurfaceDark = const Color(0xFF313033),
        _shadowDark = const Color(0xFF000000),
        _surfaceTintDark = const Color(0xFFD0BCFF),
        _surfaceVariantDark = const Color(0xFF3F3F3F),
        _onSurfaceVariantDark = const Color(0xFFCAC4D0),
        _outlineDark = const Color(0xFF525256),
        _outlineVariantDark = const Color(0xFF49454F);
}
