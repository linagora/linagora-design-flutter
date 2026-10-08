import 'package:flutter/material.dart';

/// The default glyph in a file chip. Pass your own `leading` to the row for a
/// thumbnail or a type-specific icon.
class LinagoraFileTransferLeading extends StatelessWidget {
  static const double defaultSize = 20;
  static const double defaultRadius = 2;

  final double size;
  final double radius;
  final Color? color;

  const LinagoraFileTransferLeading({
    super.key,
    this.size = defaultSize,
    this.radius = defaultRadius,
    this.color,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: SizedBox.square(
          dimension: size,
          child: Icon(
            Icons.insert_drive_file_outlined,
            size: size,
            color: color ?? Theme.of(context).colorScheme.primary,
          ),
        ),
      );
}
