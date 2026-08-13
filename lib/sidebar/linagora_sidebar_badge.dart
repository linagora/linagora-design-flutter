import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/sidebar/linagora_sidebar_style.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

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
    final textStyle = LinagoraTextTheme.material().labelSmall?.copyWith(
      color: foregroundColor ?? style.badgeForeground,
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: _widestWidth(context, textStyle) +
            style.badgeHorizontalPadding * 2,
      ),
      child: Container(
        // No alignment: a centred Container fills the constraints it is given
        // rather than hugging its label — vertically that stretched the pill
        // to the row height, horizontally to the cap. The minimum keeps a
        // single digit round; [Text.textAlign] centres it inside that.
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
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ),
    );
  }

  double _widestWidth(BuildContext context, TextStyle? textStyle) {
    final painter = TextPainter(
      text: TextSpan(text: widestLabel, style: textStyle),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    );
    // TextPainter owns a native paragraph, so it is released even if layout
    // throws.
    try {
      painter.layout();
      return painter.width;
    } finally {
      painter.dispose();
    }
  }
}
