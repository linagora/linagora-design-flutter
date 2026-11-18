import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_ref_colors.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/list_item/linagora_list_checkbox.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';
import 'package:linagora_design_flutter/style/linagora_divider_style.dart';
import 'package:linagora_design_flutter/style/linagora_hover_style.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// An option of a multiple-choice list: the checkbox counterpart of
/// [LinagoraRadioItem].
class LinagoraCheckboxItem extends StatelessWidget {
  static const double _gap = LinagoraSpacing.base * 1.5;
  static const EdgeInsets _labelPadding = EdgeInsets.all(
    LinagoraSpacing.base * 2,
  );

  final String title;
  final String? subtitle;

  /// Shown before [title], such as an avatar.
  final Widget? leading;

  final bool value;
  final ValueChanged<bool>? onChanged;

  final bool showDivider;
  final bool enabled;

  const LinagoraCheckboxItem({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.leading,
    this.showDivider = true,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final hoverStyle = LinagoraHoverStyle.material();
    final dividerStyle = LinagoraDividerStyle.material();
    final textTheme = LinagoraTextTheme.material();
    final onChanged = this.onChanged;
    final isInteractive = enabled && onChanged != null;
    final subtitle = this.subtitle;
    final leading = this.leading;

    return MergeSemantics(
      child: Semantics(
        checked: value,
        enabled: isInteractive,
        child: Material(
          color: Colors.transparent,
          borderRadius: hoverStyle.borderRadius,
          child: InkWell(
            onTap: isInteractive ? () => onChanged(!value) : null,
            borderRadius: hoverStyle.hoverBorderRadius,
            hoverColor: Colors.transparent,
            highlightColor: hoverStyle.selectedColor,
            splashColor: hoverStyle.selectedColor,
            child: Padding(
              padding: const EdgeInsets.only(right: LinagoraSpacing.base * 2),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: _labelPadding,
                          child: Row(
                            children: [
                              if (leading != null) ...[
                                leading,
                                const SizedBox(width: _gap),
                              ],
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      title,
                                      style: textTheme.titleMedium?.copyWith(
                                        color: LinagoraSysColors.material()
                                            .onSurface,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (subtitle != null)
                                      Text(
                                        subtitle,
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: LinagoraRefColors.material()
                                              .tertiary[30],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (showDivider)
                          Divider(
                            height: dividerStyle.thickness,
                            thickness: dividerStyle.thickness,
                            color: dividerStyle.color,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: _gap),
                  LinagoraListCheckbox(value: value, enabled: isInteractive),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
