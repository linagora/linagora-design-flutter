import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_ref_colors.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';

/// The Figma "Checkboxes" mark sized to a 24 dp icon slot. The enclosing row
/// handles taps and semantics.
class LinagoraListCheckbox extends StatelessWidget {
  static const double size = 24;

  final bool value;
  final bool enabled;

  const LinagoraListCheckbox({
    super.key,
    required this.value,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final colors = LinagoraSysColors.material();
    final disabledColor = colors.onSurface.withValues(alpha: 0.38);
    final uncheckedBorder =
        LinagoraRefColors.material().tertiary[30] ?? const Color(0xFF99A0A9);

    return ExcludeSemantics(
      child: IgnorePointer(
        child: SizedBox.square(
          dimension: size,
          child: OverflowBox(
            maxWidth: double.infinity,
            maxHeight: double.infinity,
            child: Checkbox(
              value: value,
              onChanged: enabled ? (_) {} : null,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              fillColor: WidgetStateProperty.resolveWith((states) {
                if (!states.contains(WidgetState.selected)) {
                  return Colors.transparent;
                }
                return states.contains(WidgetState.disabled)
                    ? disabledColor
                    : colors.primary;
              }),
              checkColor: colors.onPrimary,
              side: WidgetStateBorderSide.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const BorderSide(color: Colors.transparent);
                }
                return BorderSide(
                  width: 2,
                  color: states.contains(WidgetState.disabled)
                      ? disabledColor
                      : uncheckedBorder,
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
