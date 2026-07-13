import 'package:flutter/material.dart';

/// A compact, borderless icon button used for row-trailing actions (dismiss,
/// delete, etc.) — no hover/highlight color override, shrink-wrapped tap
/// target sized to the icon itself.
class LinagoraIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double iconSize;

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
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      visualDensity: VisualDensity.compact,
    );
  }
}
