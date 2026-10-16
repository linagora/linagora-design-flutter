import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_state_layer.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// A chip that toggles a filter, showing a check mark when selected.
class LinagoraFilterChip extends StatelessWidget {
  static const double _radius = LinagoraSpacing.base;
  static const double _borderWidth = 1;

  // The side is laid out around the chip. The padding takes it back
  // horizontally; vertically, one density step removes 2 px, which is the top
  // and bottom sides, so that the chip stays 32 high.
  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: LinagoraSpacing.base - _borderWidth,
    vertical: 6,
  );
  static const VisualDensity _visualDensity = VisualDensity(vertical: -1);
  static const EdgeInsets _labelPadding = EdgeInsets.symmetric(
    horizontal: LinagoraSpacing.base,
  );

  final String label;
  final bool selected;

  /// Null disables the chip.
  final ValueChanged<bool>? onSelected;

  const LinagoraFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final sysColors = LinagoraSysColors.material();
    final disabledLayer = LinagoraStateLayer(sysColors.onSurface).opacityLayer2;

    // The chip sits on a canvas-coloured Material, which would fill an
    // unselected chip.
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: onSelected,
        padding: _padding,
        labelPadding: _labelPadding,
        visualDensity: _visualDensity,
        elevation: 0,
        pressElevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        checkmarkColor: onSelected == null
            ? sysColors.onSurface.withValues(
                alpha: LinagoraStateLayer.disabledContentOpacity,
              )
            : sysColors.onSecondaryContainer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(_radius)),
        ),
        color: WidgetStateProperty.resolveWith((states) {
          if (!states.contains(WidgetState.selected)) return Colors.transparent;
          return states.contains(WidgetState.disabled)
              ? disabledLayer
              : sysColors.secondaryContainer;
        }),
        side: WidgetStateBorderSide.resolveWith((states) {
          // A transparent side keeps both styles the same size.
          if (states.contains(WidgetState.selected)) {
            return const BorderSide(
              color: Colors.transparent,
              width: _borderWidth,
            );
          }
          return BorderSide(
            width: _borderWidth,
            color: states.contains(WidgetState.disabled)
                ? disabledLayer
                : sysColors.outline,
          );
        }),
        labelStyle: LinagoraTextTheme.material().labelLarge?.copyWith(
          color: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return sysColors.onSurface.withValues(
                alpha: LinagoraStateLayer.disabledContentOpacity,
              );
            }
            return states.contains(WidgetState.selected)
                ? sysColors.onSecondaryContainer
                : sysColors.onSurfaceVariant;
          }),
        ),
      ),
    );
  }
}
