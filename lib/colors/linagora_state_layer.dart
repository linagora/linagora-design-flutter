
class LinagoraStateLayer {
  final double opacityLayer1;
  final double opacityLayer2;
  final double opacityLayer3;

  static final LinagoraStateLayer _materialStateLayer =
      LinagoraStateLayer._material();

  factory LinagoraStateLayer.material() {
    return _materialStateLayer;
  }

  LinagoraStateLayer._material()
      : opacityLayer1 = 0.08,
        opacityLayer2 = 0.12,
        opacityLayer3 = 0.16;
}
