import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linagora_design_flutter/colors/linagora_ref_colors.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';
import 'package:linagora_design_flutter/style/linagora_typography.dart';

abstract class TwakeThemes {
  static const double iconSize = 24.0;

  static const double borderRadius = 20.0;

  static const Duration animationDuration = Duration(milliseconds: 250);
  static const Curve animationCurve = Curves.easeInOut;

  static ThemeData buildTheme(
    BuildContext context,
    Brightness brightness, [
    Color? seed,
  ]) {
    final textTheme = LinagoraTextTheme.material();
    return ThemeData(
      visualDensity: VisualDensity.standard,
      useMaterial3: true,
      textTheme: textTheme,
      extensions: [
        LinagoraTextThemeExtension.material(),
        LinagoraTypography.material(),
      ],
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      scaffoldBackgroundColor: LinagoraSysColors.material().onPrimary,
      dividerColor: brightness == Brightness.light
          ? Colors.blueGrey.shade50
          : Colors.blueGrey.shade900,
      highlightColor: LinagoraRefColors.material().tertiary[80],
      popupMenuTheme: PopupMenuThemeData(shape: _rounded(borderRadius)),
      dialogTheme: DialogThemeData(shape: _rounded(borderRadius / 2)),
      inputDecorationTheme: _inputDecorationTheme(textTheme),
      appBarTheme: _appBarTheme(brightness),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(shape: _rounded(borderRadius / 2)),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(shape: _rounded(borderRadius / 2)),
      ),
      elevatedButtonTheme: _elevatedButtonTheme(),
      colorScheme: _colorScheme(brightness, seed),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: _pick(brightness, (c) => c.primary, (c) => c.primaryDark),
      ),
      iconButtonTheme: _iconButtonTheme(brightness),
      iconTheme: IconThemeData(
        size: iconSize,
        color: _pick(
          brightness,
          (c) => c.onBackground,
          (c) => c.onBackgroundDark,
        ),
      ),
      switchTheme: _switchTheme(brightness),
      navigationBarTheme: _navigationBarTheme(brightness, textTheme),
      navigationRailTheme: NavigationRailThemeData(
        indicatorColor: _pick(
          brightness,
          (c) => c.inversePrimary,
          (c) => c.secondaryContainerDark,
        ),
      ),
      bottomSheetTheme: _bottomSheetTheme(brightness),
      bottomNavigationBarTheme: _bottomNavigationBarTheme(textTheme),
    );
  }

  /// Picks the light or dark member of a [LinagoraSysColors] pair, so each
  /// entry below reads as one line instead of a three-line conditional.
  static Color _pick(
    Brightness brightness,
    Color Function(LinagoraSysColors) light,
    Color Function(LinagoraSysColors) dark,
  ) {
    final colors = LinagoraSysColors.material();
    return brightness == Brightness.light ? light(colors) : dark(colors);
  }

  static RoundedRectangleBorder _rounded(double radius) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));

  static InputDecorationTheme _inputDecorationTheme(TextTheme textTheme) {
    return InputDecorationTheme(
      border: UnderlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(borderRadius / 2),
      ),
      hintStyle: textTheme.bodyLarge?.merge(
        TextStyle(
          fontSize: 17,
          color: LinagoraRefColors.material().neutralVariant[60],
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  static AppBarTheme _appBarTheme(Brightness brightness) {
    return AppBarTheme(
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: brightness.reversed,
        statusBarBrightness: brightness,
      ),
      foregroundColor: _pick(
        brightness,
        (c) => c.onBackground,
        (c) => c.onBackgroundDark,
      ),
      backgroundColor: LinagoraSysColors.material().onPrimary,
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        textStyle: const TextStyle(fontSize: 16),
        shape: _rounded(borderRadius),
      ),
    );
  }

  static ColorScheme _colorScheme(Brightness brightness, Color? seed) {
    Color of(
      Color Function(LinagoraSysColors) light,
      Color Function(LinagoraSysColors) dark,
    ) =>
        _pick(brightness, light, dark);

    return ColorScheme.fromSeed(
      seedColor: seed ?? LinagoraSysColors.material().onPrimary,
      brightness: brightness,
      primary: of((c) => c.primary, (c) => c.primaryDark),
      onPrimary: of((c) => c.onPrimary, (c) => c.onPrimaryDark),
      primaryContainer:
          of((c) => c.primaryContainer, (c) => c.primaryContainerDark),
      onPrimaryContainer:
          of((c) => c.onPrimaryContainer, (c) => c.onPrimaryContainerDark),
      inversePrimary: of((c) => c.inversePrimary, (c) => c.inversePrimaryDark),
      tertiary: of((c) => c.tertiary, (c) => c.tertiaryDark),
      onTertiary: of((c) => c.onTertiary, (c) => c.onTertiaryDark),
      tertiaryContainer:
          of((c) => c.tertiaryContainer, (c) => c.tertiaryContainerDark),
      onTertiaryContainer:
          of((c) => c.onTertiaryContainer, (c) => c.onTertiaryContainerDark),
      secondary: of((c) => c.secondary, (c) => c.secondaryDark),
      onSecondary: of((c) => c.onSecondary, (c) => c.onSecondaryDark),
      secondaryContainer:
          of((c) => c.secondaryContainer, (c) => c.secondaryContainerDark),
      onSecondaryContainer:
          of((c) => c.onSecondaryContainer, (c) => c.onSecondaryContainerDark),
      // TODO: remove when the color scheme is updated
      // ignore: deprecated_member_use
      background: of((c) => c.background, (c) => c.backgroundDark),
      // TODO: remove when the color scheme is updated
      // ignore: deprecated_member_use
      onBackground: of((c) => c.onBackground, (c) => c.onBackgroundDark),
      error: of((c) => c.error, (c) => c.errorDark),
      onError: of((c) => c.onError, (c) => c.onErrorDark),
      errorContainer: of((c) => c.errorContainer, (c) => c.errorContainerDark),
      onErrorContainer:
          of((c) => c.onErrorContainer, (c) => c.onErrorContainerDark),
      surface: of((c) => c.surface, (c) => c.surfaceDark),
      onSurface: of((c) => c.onSurface, (c) => c.onSurfaceDark),
      surfaceTint: of((c) => c.surfaceTint, (c) => c.surfaceTintDark),
      surfaceContainerHighest:
          of((c) => c.surfaceVariant, (c) => c.surfaceVariantDark),
      onSurfaceVariant:
          of((c) => c.onSurfaceVariant, (c) => c.onSurfaceVariantDark),
      inverseSurface: of((c) => c.inverseSurface, (c) => c.inverseSurfaceDark),
      onInverseSurface:
          of((c) => c.onInverseSurface, (c) => c.onInverseSurfaceDark),
      shadow: of((c) => c.shadow, (c) => c.shadowDark),
      outline: of((c) => c.outline, (c) => c.outlineDark),
    );
  }

  static IconButtonThemeData _iconButtonTheme(Brightness brightness) {
    return IconButtonThemeData(
      style: ButtonStyle(
        iconSize: WidgetStateProperty.all(iconSize),
        iconColor: WidgetStateProperty.all(
          _pick(brightness, (c) => c.onSurface, (c) => c.onSurfaceDark),
        ),
      ),
    );
  }

  static SwitchThemeData _switchTheme(Brightness brightness) {
    /// Each switch slot picks between a selected and an unselected colour,
    /// so they share one resolver instead of repeating the state check.
    WidgetStateProperty<Color?> selectable(
      Color Function(LinagoraSysColors) selectedLight,
      Color Function(LinagoraSysColors) selectedDark,
      Color Function(LinagoraSysColors) light,
      Color Function(LinagoraSysColors) dark,
    ) {
      return WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? _pick(brightness, selectedLight, selectedDark)
            : _pick(brightness, light, dark),
      );
    }

    return SwitchThemeData(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      overlayColor: selectable(
        (c) => c.primary,
        (c) => c.primaryDark,
        (c) => c.outline,
        (c) => c.outlineDark,
      ),
      thumbColor: selectable(
        (c) => c.onPrimary,
        (c) => c.onPrimaryDark,
        (c) => c.outline,
        (c) => c.outlineDark,
      ),
      trackColor: selectable(
        (c) => c.primary,
        (c) => c.primaryDark,
        (c) => c.surface,
        (c) => c.surfaceDark,
      ),
    );
  }

  static NavigationBarThemeData _navigationBarTheme(
    Brightness brightness,
    TextTheme textTheme,
  ) {
    return NavigationBarThemeData(
      height: 64,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => textTheme.labelSmall?.copyWith(
          fontSize: 11,
          color: states.contains(WidgetState.selected)
              ? LinagoraSysColors.material().primary
              : LinagoraSysColors.material().tertiary,
        ),
      ),
      backgroundColor: _pick(brightness, (c) => c.surface, (c) => c.surfaceDark),
      shadowColor: brightness == Brightness.light
          ? Colors.black.withValues(alpha: 0.15)
          : Colors.white.withValues(alpha: 0.15),
      elevation: 4.0,
      overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
    );
  }

  static BottomSheetThemeData _bottomSheetTheme(Brightness brightness) {
    final background =
        _pick(brightness, (c) => c.background, (c) => c.backgroundDark);
    return BottomSheetThemeData(
      backgroundColor: background,
      surfaceTintColor: background,
    );
  }

  static BottomNavigationBarThemeData _bottomNavigationBarTheme(
    TextTheme textTheme,
  ) {
    final colors = LinagoraSysColors.material();
    TextStyle? label(Color color) =>
        textTheme.labelSmall?.copyWith(fontSize: 11, color: color);

    return BottomNavigationBarThemeData(
      backgroundColor: colors.surface,
      selectedLabelStyle: label(colors.primary),
      unselectedLabelStyle: label(colors.tertiary),
      selectedItemColor: colors.primary,
      unselectedItemColor: colors.tertiary,
    );
  }
}

extension on Brightness {
  Brightness get reversed =>
      this == Brightness.dark ? Brightness.light : Brightness.dark;
}
