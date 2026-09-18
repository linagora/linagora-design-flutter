import 'package:flutter/material.dart';

/// The downward tail that turns a [LinagoraAlert] into a callout, centred on
/// the container's bottom edge and painted in the container's own fill.
///
/// Split out so a product can reuse the same tail on a surface of its own
/// without rebuilding the path. A translucent [color] composites over the
/// page exactly as the container above it does, so the two stay in step.
class LinagoraAlertPointer extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const LinagoraAlertPointer({
    super.key,
    required this.color,
    this.width = 24,
    this.height = 12,
  })  : assert(width > 0, 'Pointer width must be positive'),
        assert(height > 0, 'Pointer height must be positive');

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _LinagoraAlertPointerPainter(color),
    );
  }
}

class _LinagoraAlertPointerPainter extends CustomPainter {
  final Color color;

  const _LinagoraAlertPointerPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_LinagoraAlertPointerPainter oldDelegate) =>
      color != oldDelegate.color;
}
