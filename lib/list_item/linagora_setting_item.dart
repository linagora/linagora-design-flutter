import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_ref_colors.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';
import 'package:linagora_design_flutter/style/linagora_divider_style.dart';
import 'package:linagora_design_flutter/style/linagora_hover_style.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// A settings row with a leading icon, title/subtitle, and a trailing
/// chevron (or a spinner while [loading]), matching the Figma "Setting item"
/// component (node 58604:6126).
class LinagoraSettingItem extends StatelessWidget {
  static const double minHeight = 92;
  static const EdgeInsets _padding = EdgeInsets.only(
    left: LinagoraSpacing.base,
    top: LinagoraSpacing.base * 2,
    bottom: LinagoraSpacing.base * 2,
  );
  static const double _iconSize = LinagoraSpacing.base * 3;
  static const double _gap = LinagoraSpacing.base;
  static const double _textGap = LinagoraSpacing.base / 2;

  /// Divider left inset: icon width + left padding + icon-to-text gap.
  static const double _dividerInset = _iconSize + LinagoraSpacing.base * 2;

  final String title;
  final String subtitle;

  /// Leading glyph. Ignored when [leading] is set.
  final IconData? leadingIcon;

  /// Overrides [leadingIcon] with any widget, sized to match the icon slot.
  final Widget? leading;

  final VoidCallback? onTap;

  /// Overrides the default trailing chevron. Ignored while [loading] is
  /// true, which always shows a spinner.
  final Widget? trailing;

  /// Shows a spinner instead of the trailing chevron/[trailing] and
  /// disables [onTap].
  final bool loading;

  final bool showDivider;
  final bool enabled;

  /// Background shown while pressed/tapped. Defaults to
  /// [LinagoraHoverStyle.selectedColor].
  final Color? pressedColor;

  /// Background color override. Null means transparent.
  final Color? itemDecorationColor;

  const LinagoraSettingItem({
    super.key,
    required this.title,
    required this.subtitle,
    this.leadingIcon,
    this.leading,
    this.onTap,
    this.trailing,
    this.loading = false,
    this.showDivider = false,
    this.enabled = true,
    this.pressedColor,
    this.itemDecorationColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = LinagoraSysColors.material();
    final textThemeExtension = LinagoraTextThemeExtension.material();
    final textTheme = LinagoraTextTheme.material();
    final subtitleColor = LinagoraRefColors.material().tertiary[30] ??
        const Color(0xFF99A0A9);
    final iconColor = subtitleColor;

    final hoverStyle = LinagoraHoverStyle.material();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: hoverStyle.borderRadius,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: hoverStyle.borderRadius,
              color: itemDecorationColor,
            ),
            child: InkWell(
              onTap: enabled && !loading ? onTap : null,
              borderRadius: hoverStyle.hoverBorderRadius,
              hoverColor: Colors.transparent,
              highlightColor: pressedColor ?? hoverStyle.selectedColor,
              splashColor: pressedColor ?? hoverStyle.selectedColor,
              child: IntrinsicHeight(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: minHeight),
                  child: Padding(
                    padding: _padding,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: _iconSize,
                          height: _iconSize,
                          child: leading ??
                              Icon(
                                leadingIcon,
                                size: _iconSize,
                                color: iconColor,
                              ),
                        ),
                        const SizedBox(width: _gap),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                title,
                                style: textThemeExtension.bodyMedium2
                                    .copyWith(color: colors.onSurface),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: _textGap),
                              Text(
                                subtitle,
                                style: textTheme.bodyMedium
                                    ?.copyWith(color: subtitleColor),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: _gap),
                        if (loading)
                          SizedBox(
                            width: _iconSize,
                            height: _iconSize,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: iconColor,
                            ),
                          )
                        else
                          trailing ??
                              Icon(
                                Icons.chevron_right,
                                size: _iconSize,
                                color: iconColor,
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: _dividerInset),
            child: Divider(
              height: LinagoraDividerStyle.material().thickness,
              thickness: LinagoraDividerStyle.material().thickness,
              color: LinagoraDividerStyle.material().color,
            ),
          ),
      ],
    );
  }
}
