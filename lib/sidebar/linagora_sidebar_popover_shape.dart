import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Side on which a sidebar popover points back to its trigger.
enum LinagoraSidebarPopoverArrowSide { start, end }

/// Clips a rounded sidebar popover with a small side arrow.
class LinagoraSidebarPopoverShape extends CustomClipper<Path> {
  const LinagoraSidebarPopoverShape({
    required this.arrowSide,
    this.arrowSize = 8,
    this.arrowOffset = 30,
    this.borderRadius = 16,
  }) : assert(
         arrowSize >= 0 && arrowOffset >= 0 && borderRadius >= 0,
         'Sidebar popover dimensions cannot be negative',
       );

  final LinagoraSidebarPopoverArrowSide arrowSide;
  final double arrowSize;
  final double arrowOffset;
  final double borderRadius;

  @override
  Path getClip(Size size) {
    if (size.isEmpty) return Path();
    final isStart = arrowSide == LinagoraSidebarPopoverArrowSide.start;
    final double arrowSize = math.min(
      this.arrowSize,
      math.min(size.width, size.height) / 2,
    ).toDouble();
    final double cardWidth = math.max(0, size.width - arrowSize).toDouble();
    final cardRect = isStart
        ? Rect.fromLTWH(arrowSize, 0, cardWidth, size.height)
        : Rect.fromLTWH(0, 0, cardWidth, size.height);
    final double radius = math.min(
      borderRadius,
      math.min(cardRect.width, cardRect.height) / 2,
    ).toDouble();
    final roundedCard = Path()
      ..addRRect(
        RRect.fromRectAndRadius(cardRect, Radius.circular(radius)),
      );
    final arrowX = isStart ? arrowSize : size.width - arrowSize;
    final double minimumCenter = arrowSize;
    final double maximumCenter =
        math.max(minimumCenter, size.height - arrowSize).toDouble();
    final double arrowCenterY = (size.height - arrowOffset - arrowSize)
        .clamp(minimumCenter, maximumCenter)
        .toDouble();
    final arrow = Path()
      ..moveTo(arrowX, arrowCenterY - arrowSize)
      ..lineTo(isStart ? 0 : size.width, arrowCenterY)
      ..lineTo(arrowX, arrowCenterY + arrowSize)
      ..close();
    return Path.combine(PathOperation.union, roundedCard, arrow);
  }

  @override
  bool shouldReclip(covariant LinagoraSidebarPopoverShape oldClipper) =>
      oldClipper.arrowSide != arrowSide ||
      oldClipper.arrowSize != arrowSize ||
      oldClipper.arrowOffset != arrowOffset ||
      oldClipper.borderRadius != borderRadius;
}
