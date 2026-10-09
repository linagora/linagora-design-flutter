import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_ref_colors.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// Caption above a section of a list, with an optional trailing action.
class LinagoraSectionHeader extends StatelessWidget {
  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: LinagoraSpacing.base,
  );
  static const EdgeInsets _labelPadding = EdgeInsets.all(LinagoraSpacing.base);
  static const EdgeInsets _actionPadding = EdgeInsets.symmetric(
    horizontal: LinagoraSpacing.base * 1.5,
    vertical: 6,
  );

  /// Displayed in upper case.
  final String label;

  final String? actionLabel;

  final VoidCallback? onActionTap;

  const LinagoraSectionHeader({
    super.key,
    required this.label,
    this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = LinagoraTextTheme.material();
    final color = LinagoraRefColors.material().tertiary[20];
    final actionLabel = this.actionLabel;

    return Padding(
      padding: _padding,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: _labelPadding,
              child: Semantics(
                header: true,
                child: Text(
                  label.toUpperCase(),
                  style: textTheme.bodySmall?.copyWith(color: color),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onActionTap,
              style: TextButton.styleFrom(
                foregroundColor: color,
                textStyle: textTheme.labelMedium,
                padding: _actionPadding,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: const StadiumBorder(),
              ),
              child: Text(actionLabel),
            ),
        ],
      ),
    );
  }
}
