/// Design system font family constants.
///
/// Register fonts via pubspec.yaml pointing to `assets/fonts/`.
/// Consumers can use [LinagoraFonts.inter] as the `fontFamily` in their
/// [ThemeData] so that all text widgets inherit it without per-widget overrides.
class LinagoraFonts {
  LinagoraFonts._();

  /// The primary Latin font used across Twake / Linagora products.
  ///
  /// Map this to the `TwakeInter` family registered in pubspec.yaml, which is
  /// a patched build of Inter with emoji glyphs stripped to avoid overriding
  /// platform color-emoji on Flutter web.
  static const String twakeInter = 'TwakeInter';
}
