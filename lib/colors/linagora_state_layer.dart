import 'dart:ui';

class LinagoraStateLayer {
  final Color opacityLayer1;
  final Color opacityLayer2;
  final Color opacityLayer3;

  LinagoraStateLayer(Color color, {double seedOpacity = 1})
      : opacityLayer1 = color.withOpacity(seedOpacity * 0.08),
        opacityLayer2 = color.withOpacity(seedOpacity * 0.12),
        opacityLayer3 = color.withOpacity(seedOpacity * 0.16);
}
