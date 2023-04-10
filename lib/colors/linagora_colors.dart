import 'dart:ui';

import 'package:flutter/material.dart';

class LinagoraColors {
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

  final Color outline;

  final Color? _outlineDark;

  Color get outlineDark => _outlineDark ?? outline;

  final Color outlineVariant;

  final Color? _outlineVariantDark;

  Color get outlineVariantDark => _outlineVariantDark ?? outlineVariant;

  LinagoraColors({
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
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
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    primaryDark,
    onPrimaryDark,
    primaryContainerDark,
    onPrimaryContainerDark,
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
    surfaceVariantDark,
    onSurfaceVariantDark,
    outlineDark,
    outlineVariantDark,
  })  : _primaryDark = primaryDark,
        _onPrimaryDark = onPrimaryDark,
        _primaryContainerDark = primaryContainerDark,
        _onPrimaryContainerDark = onPrimaryContainerDark,
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
        _surfaceVariantDark = surfaceVariantDark,
        _onSurfaceVariantDark = onSurfaceVariantDark,
        _outlineDark = outlineDark,
        _outlineVariantDark = outlineVariantDark;

  static final LinagoraColors _default = LinagoraColors._defaultColor();

  factory LinagoraColors.defaultColor() {
    return _default;
  }

  LinagoraColors._defaultColor()
      : primary = const Color(0xFF0A84FF),
        onPrimary = const Color(0xFFFFFFFF),
        primaryContainer = const Color(0xFFF4F0F4),
        onPrimaryContainer = const Color(0xFF0A84FF),
        secondary = const Color(0xFF5C9CE6),
        onSecondary = const Color(0xFFFFFFFF),
        secondaryContainer = const Color(0xFFC8E2FF),
        onSecondaryContainer = const Color(0xFF1D192B),
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
        surfaceVariant = const Color(0xFFF7F7F8),
        onSurfaceVariant = const Color(0xFF1C1B1F),
        outline = const Color(0xFFAEAEC0),
        outlineVariant = const Color(0xFFCAC4D0),
        _primaryDark = const Color(0xFF0A84FF),
        _onPrimaryDark = const Color(0xFFFFFFFF),
        _primaryContainerDark = const Color(0xFF2D2D2E),
        _onPrimaryContainerDark = const Color(0xFFC9CACC),
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
        _surfaceVariantDark = const Color(0xFF3F3F3F),
        _onSurfaceVariantDark = const Color(0xFFCAC4D0),
        _outlineDark = const Color(0xFF525256),
        _outlineVariantDark = const Color(0xFF49454F);
}
