import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';

/// A compact, borderless icon button used for row-trailing actions (dismiss,
/// delete, etc.) — hover overlay derives from [color], shrink-wrapped tap
/// target sized to the icon plus a small padding.
///
/// Provide either [icon] (a Material glyph) or [iconWidget] (an arbitrary
/// widget such as `SvgPicture.asset`). [icon] and [color] apply only to the
/// glyph path, so they are optional when [iconWidget] is used.
class LinagoraIconButton extends StatelessWidget {
  /// Material glyph to render. Required unless [iconWidget] is provided.
  final IconData? icon;

  /// Color for the [icon] glyph. Ignored when [iconWidget] is set; falls back
  /// to the ambient icon theme color when null.
  final Color? color;
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

  /// Defaults to [MaterialTapTargetSize.padded], which targets a 48px minimum.
  /// The default compact [visualDensity] reduces that to 40px. Pass
  /// [MaterialTapTargetSize.shrinkWrap] to fit a fixed row height.
  final MaterialTapTargetSize tapTargetSize;

  /// Defaults to [VisualDensity.compact], which shortens the box vertically
  /// and so renders the overlay as an ellipse. Pass [VisualDensity.standard]
  /// to keep it square, and the overlay circular.
  final VisualDensity visualDensity;

  const LinagoraIconButton({
    super.key,
    this.icon,
    this.color,
    required this.onPressed,
    this.tooltip,
    this.iconSize = 24,
    this.iconWidget,
    this.overlayColor,
    this.tapTargetSize = MaterialTapTargetSize.padded,
    this.visualDensity = VisualDensity.compact,
  }) : assert(
          icon != null || iconWidget != null,
          'Provide either icon or iconWidget',
        );

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
      constraints: _constraints(context),
      visualDensity: visualDensity,
      style: IconButton.styleFrom(
        overlayColor: overlayColor ?? Colors.transparent,
        tapTargetSize: tapTargetSize,
      ),
    );
  }

  BoxConstraints _constraints(BuildContext context) {
    if (
        Theme.of(context).useMaterial3 ||
        tapTargetSize == MaterialTapTargetSize.shrinkWrap) {
      return const BoxConstraints();
    }
    return const BoxConstraints(
      minWidth: kMinInteractiveDimension,
      minHeight: kMinInteractiveDimension,
    );
  }
}
