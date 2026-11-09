import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/chips/linagora_dismissible_chip_style.dart';

/// A chip with a label and a close button, such as "Viewing Nora Hale", used
/// to leave the account on screen.
///
/// Ellipsis needs a finite max width. In a [Row], wrap the chip in [Flexible]
/// (or [Expanded]); a loose [Align] inside a sized box also works.
///
/// The close control keeps a [LinagoraDismissibleChipStyle.dismissTargetSize]
/// hit box. When that is taller than the painted pill, the layout height grows
/// so taps above and below the pill still dismiss.
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
    final pillHeight = MediaQuery.textScalerOf(context).scale(tokens.height);
    final target = math.max(tokens.dismissTargetSize, pillHeight);
    final layoutHeight = math.max(pillHeight, target);

    return SizedBox(
      height: layoutHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final label = Text(
            this.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tokens.textStyle,
          );
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Center(
                  child: Container(
                    height: pillHeight,
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
                  ),
                ),
              ),
              Padding(
                padding: tokens.padding,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (leading != null) ...[
                      leading,
                      SizedBox(width: tokens.gap),
                    ],
                    if (constraints.hasBoundedWidth)
                      Flexible(child: label)
                    else
                      label,
                    _dismissButton(tokens, target),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _dismissButton(LinagoraDismissibleChipStyle tokens, double target) {
    return IconButton(
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
    );
  }
}
