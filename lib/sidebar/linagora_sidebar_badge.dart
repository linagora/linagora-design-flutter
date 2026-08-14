import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_style.dart';

/// The counter pill at the end of a [LinagoraSidebarItem].
///
/// [label] arrives already formatted: capping and localisation are product
/// concerns. The pill never grows past the width of [widestLabel], so a label
/// longer than a capped count ellipsises instead of pushing the row.
class LinagoraSidebarBadge extends StatelessWidget {
  /// The widest label a counter can produce, and so the pill's width ceiling.
  static const String widestLabel = '999+';

  final String label;

  final Color? backgroundColor;
  final Color? foregroundColor;

  final LinagoraSidebarStyle? style;

  const LinagoraSidebarBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? LinagoraSidebarStyle.of(context);
    final textStyle = style.badgeTextStyle.copyWith(
      color: foregroundColor ?? style.badgeForeground,
    );
    final counter = _measureCounter(context, textStyle, style.badgeHeight);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: counter.width + style.badgeHorizontalPadding * 2,
      ),
      child: Container(
        // No alignment on the Container: it would fill the constraints it
        // is given rather than hug its counter. The minimum keeps a single
        // digit round.
        constraints: BoxConstraints(
          minWidth: style.badgeHeight,
          minHeight: style.badgeHeight,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: style.badgeHorizontalPadding,
        ),
        decoration: ShapeDecoration(
          color: backgroundColor ?? style.badgeBackground,
          shape: const StadiumBorder(),
        ),
        // The factors hug the counter and centre it across a pill the
        // minimum has widened. Down the pill the inset places it, so this
        // alignment stays at the top.
        child: Align(
          alignment: Alignment.topCenter,
          widthFactor: 1,
          heightFactor: 1,
          child: Padding(
            padding: EdgeInsets.only(top: counter.topInset),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              textHeightBehavior: LinagoraSidebarStyle.middleAligned,
              style: textStyle,
            ),
          ),
        ),
      ),
    );
  }

  /// The pill's width ceiling, and how far its counter is dropped inside it.
  ///
  /// The inset centres the digits' *ink*. Centring the paragraph box instead
  /// lands them low, by the font's descent plus whatever the engine rounds off
  /// the ascent — most of a pixel on a pill only 16 tall.
  ({double width, double topInset}) _measureCounter(
    BuildContext context,
    TextStyle textStyle,
    double pillHeight,
  ) {
    final textScaler = MediaQuery.textScalerOf(context);
    final painter = TextPainter(
      // Measured on the glyphs, as the counter is drawn: the line height
      // would otherwise report a baseline pushed down by its leading.
      text: TextSpan(
        text: widestLabel,
        style: textStyle.copyWith(height: kTextHeightNone),
      ),
      textDirection: Directionality.of(context),
      textScaler: textScaler,
      maxLines: 1,
    );
    // TextPainter owns a native paragraph, so it is released even if layout
    // throws.
    try {
      painter.layout();
      final capHeight = textScaler.scale(textStyle.fontSize ?? 0) *
          LinagoraSidebarStyle.badgeCapHeightRatio;
      // Where the baseline leaves the ink centred.
      final baseline = (pillHeight + capHeight) / 2;
      final ascent = _paintedAscent(painter);
      return (
        width: painter.width,
        // A counter larger than the pill grows it, and then sits at its top
        // rather than being pulled up out of the stadium.
        topInset: math.max(0, baseline - ascent),
      );
    } finally {
      painter.dispose();
    }
  }

  /// How far below its box a paragraph puts the baseline it draws on.
  ///
  /// The engine may snap that ascent to a whole pixel while
  /// [LineMetrics.ascent] still reports the font's own — a third of a pixel
  /// apart at a counter's size. The paragraph's height gives away which.
  static double _paintedAscent(TextPainter painter) {
    final line = painter.computeLineMetrics().single;
    final snapped =
        (painter.height - (line.ascent + line.descent)).abs() > 0.01;
    return snapped ? line.ascent.roundToDouble() : line.ascent;
  }
}
