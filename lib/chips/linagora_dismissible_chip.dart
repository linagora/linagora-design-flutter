import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/chips/linagora_dismissible_chip_style.dart';

/// A chip with a label and a close button, such as "Viewing Nora Hale", used
/// to leave the account on screen.
///
/// Ellipsis needs a finite max width. In a [Row], wrap the chip in [Flexible].
/// A loose [Align] inside a sized box also works. Prefer [Flexible] over
/// [Expanded] so a short label does not stretch across the row.
///
/// The close control keeps a [LinagoraDismissibleChipStyle.dismissTargetSize]
/// hit box. The painted pill stays content-sized; the hit box may overhang
/// past the pill so taps still meet the Android 48dp target.
class LinagoraDismissibleChip extends StatelessWidget {
  static const Key dismissKey = ValueKey('linagora_dismissible_chip_dismiss');

  final String label;
  final Widget? leading;
  final VoidCallback onDismissed;

  /// Tooltip and screen-reader name of the close button.
  final String dismissTooltip;

  /// Overrides [dismissKey] when the host needs a product-specific finder.
  final Key? dismissButtonKey;

  final LinagoraDismissibleChipStyle? style;

  const LinagoraDismissibleChip({
    super.key,
    required this.label,
    required this.onDismissed,
    required this.dismissTooltip,
    this.leading,
    this.dismissButtonKey,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = style ?? LinagoraDismissibleChipStyle.material();
    final leading = this.leading;
    final textDirection = Directionality.of(context);
    final pillHeight = MediaQuery.textScalerOf(context).scale(tokens.height);
    final target = math.max(tokens.dismissTargetSize, pillHeight);
    final layoutHeight = math.max(pillHeight, target);
    final endPad = _endInset(tokens.padding, textDirection);
    // Centre the 48dp target on the icon slot. Overhang past the pill when
    // the slot is closer to the trailing edge than target/2, else inset the button.
    final iconCenterFromEnd = endPad + tokens.iconSize / 2;
    final overhang = math.max(0.0, target / 2 - iconCenterFromEnd);
    final dismissEnd = math.max(0.0, iconCenterFromEnd - target / 2);

    final pill = Container(
      height: pillHeight,
      padding: tokens.padding,
      decoration: BoxDecoration(
        color: tokens.color,
        borderRadius: BorderRadius.circular(tokens.radius),
        border: tokens.borderWidth <= 0
            ? null
            : Border.all(
                color: tokens.borderColor,
                width: tokens.borderWidth,
              ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            leading,
            SizedBox(width: tokens.gap),
          ],
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tokens.textStyle,
            ),
          ),
          SizedBox(width: tokens.gap),
          SizedBox(width: tokens.iconSize),
        ],
      ),
    );

    // Align drops a tight minWidth from Expanded/stretch so the Stack
    // shrink-wraps the pill and the close control stays on its end slot.
    return Align(
      alignment: AlignmentDirectional.centerStart,
      widthFactor: 1,
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width),
        child: SizedBox(
          height: layoutHeight,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(end: overhang),
                child: pill,
              ),
              PositionedDirectional(
                end: dismissEnd,
                top: (layoutHeight - target) / 2,
                width: target,
                height: target,
                child: IconButton(
                  key: dismissButtonKey ?? dismissKey,
                  tooltip: dismissTooltip,
                  onPressed: onDismissed,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tight(Size.square(target)),
                  style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: Size.square(target),
                  ),
                  iconSize: tokens.iconSize,
                  color: tokens.iconColor,
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static double _endInset(EdgeInsetsGeometry padding, TextDirection direction) {
    final resolved = padding.resolve(direction);
    return direction == TextDirection.rtl ? resolved.left : resolved.right;
  }
}
