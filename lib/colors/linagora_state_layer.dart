import 'dart:ui';

class LinagoraStateLayer {
  /// Opacity of the content of a disabled component.
  static const double disabledContentOpacity = 0.38;

  final Color opacityLayer1;
  final Color opacityLayer2;
  final Color opacityLayer3;

  LinagoraStateLayer(Color color, {double seedOpacity = 1})
      : opacityLayer1 = color.withOpacity(seedOpacity * 0.08),
        opacityLayer2 = color.withOpacity(seedOpacity * 0.12),
        opacityLayer3 = color.withOpacity(seedOpacity * 0.16);
}
