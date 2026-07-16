import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';

/// A compact, borderless icon button used for row-trailing actions (dismiss,
/// delete, etc.) — hover overlay derives from [color], shrink-wrapped tap
/// target sized to the icon plus a small padding.
class LinagoraIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double iconSize;
  final Color? overlayColor;

  /// Overrides the rendered icon with any widget (e.g. `SvgPicture.asset`,
  /// `Image.asset`) instead of the Material glyph from [icon]. When set,
  /// [icon] and [color] are ignored for rendering; size it via [iconSize]
  /// (applied through [SizedBox], not [IconTheme], since arbitrary widgets
  /// don't read [IconTheme]).
  final Widget? iconWidget;

  const LinagoraIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.tooltip,
    this.iconSize = 24,
    this.iconWidget,
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: iconWidget == null
          ? Icon(icon)
          : SizedBox.square(dimension: iconSize, child: iconWidget),
      iconSize: iconSize,
      color: iconWidget == null ? color : null,
      tooltip: tooltip,
      onPressed: onPressed,
      padding: const EdgeInsets.all(LinagoraSpacing.base / 2),
      constraints: const BoxConstraints(),
      visualDensity: VisualDensity.compact,
      style: IconButton.styleFrom(
        overlayColor: overlayColor ?? Colors.transparent,
      ),
    );
  }
}
