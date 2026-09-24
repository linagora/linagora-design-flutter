import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';
import 'package:linagora_design_flutter/style/linagora_divider_style.dart';
import 'package:linagora_design_flutter/style/linagora_hover_style.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// An option of a single-choice list.
class LinagoraRadioItem extends StatelessWidget {
  static const double _iconSize = LinagoraSpacing.base * 3;
  static const double _gap = LinagoraSpacing.base * 1.5;
  static const EdgeInsets _labelPadding = EdgeInsets.all(
    LinagoraSpacing.base * 2,
  );

  final String title;
  final bool selected;

  final VoidCallback? onTap;

  final bool showDivider;

  final bool enabled;

  const LinagoraRadioItem({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
    this.showDivider = true,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final hoverStyle = LinagoraHoverStyle.material();
    final dividerStyle = LinagoraDividerStyle.material();
    final isInteractive = enabled && onTap != null;

    return MergeSemantics(
      child: Semantics(
        inMutuallyExclusiveGroup: true,
        checked: selected,
        enabled: isInteractive,
        child: Material(
          color: Colors.transparent,
          borderRadius: hoverStyle.borderRadius,
          child: InkWell(
            onTap: isInteractive ? onTap : null,
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
                          child: Text(
                            title,
                            style: LinagoraTextTheme.material().titleMedium
                                ?.copyWith(
                                  color: LinagoraSysColors.material().onSurface,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
                  SizedBox(
                    width: _iconSize,
                    height: _iconSize,
                    child: selected
                        ? Icon(
                            Icons.check,
                            size: _iconSize,
                            color: LinagoraSysColors.material().primary,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
