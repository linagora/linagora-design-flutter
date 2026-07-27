import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/buttons/linagora_button.dart';
import 'package:linagora_design_flutter/buttons/linagora_button_size.dart';
import 'package:linagora_design_flutter/buttons/linagora_icon_button.dart';
import 'package:linagora_design_flutter/colors/linagora_ref_colors.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/list_item/session_device_avatar.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';
import 'package:linagora_design_flutter/style/linagora_divider_style.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// A row describing one logged-in device/session (e.g. in account settings),
/// with a platform-icon avatar, device name, last-active time, an optional
/// "Verify"/"Unverified" state, and a trailing delete action.
///
/// Adapts between a wider "web" layout (56px avatar, roomier Verify button)
/// and a narrower "mobile" layout (44px avatar, compact Verify button, and
/// an optional bottom divider inset past the avatar) based on the available
/// width rather than shipping as two separate widgets.
class SessionDeviceListItem extends StatelessWidget {
  /// Breakpoint below which the compact mobile layout is used.
  static const double mobileBreakpoint = 480;

  final String deviceName;
  final String lastActiveText;
  final IconData platformIcon;

  /// Overrides [platformIcon] with any widget (e.g. `SvgPicture.asset`,
  /// `Image.asset`) instead of the Material glyph. When set, [platformIcon]
  /// is ignored for rendering; sized to match the avatar's glyph slot.
  final Widget? platformIconWidget;

  /// When false, an amber "unverified" avatar badge, an "Unverified" label,
  /// and the Verify button are shown.
  final bool verified;

  final String unverifiedLabel;
  final String verifyLabel;
  final VoidCallback? onVerifyPressed;

  final VoidCallback? onDelete;

  /// Overrides the trailing delete icon with any widget, same rules as
  /// [platformIconWidget].
  final Widget? deleteIconWidget;

  /// Tooltip shown on the trailing delete icon button.
  final String deleteTooltip;

  /// Shows a bottom hairline divider inset past the avatar, matching the
  /// mobile settings-list design. Ignored on the wide layout.
  final bool showDivider;

  const SessionDeviceListItem({
    super.key,
    required this.deviceName,
    required this.lastActiveText,
    this.platformIcon = Icons.web,
    this.platformIconWidget,
    this.verified = true,
    this.unverifiedLabel = 'Unverified',
    this.verifyLabel = 'Verify',
    this.onVerifyPressed,
    this.onDelete,
    this.deleteIconWidget,
    this.deleteTooltip = 'Delete',
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < mobileBreakpoint;
        final avatarSize = isMobile ? 44.0 : 56.0;

        final row = Padding(
          padding: EdgeInsets.symmetric(
            horizontal: LinagoraSpacing.base,
            vertical:
            isMobile ? LinagoraSpacing.base * 2 : LinagoraSpacing.base,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SessionDeviceAvatar(
                icon: platformIcon,
                iconWidget: platformIconWidget,
                verified: verified,
                size: avatarSize,
              ),
              const SizedBox(width: LinagoraSpacing.base),
              Expanded(
                child: _Content(
                  deviceName: deviceName,
                  lastActiveText: lastActiveText,
                  verified: verified,
                  unverifiedLabel: unverifiedLabel,
                  isMobile: isMobile,
                ),
              ),
              if (!verified) ...[
                const SizedBox(width: LinagoraSpacing.base),
                SizedBox(
                  width: 88,
                  height: 40,
                  child: LinagoraButton(
                    label: verifyLabel,
                    onPressed: onVerifyPressed,
                    size: LinagoraButtonSize.xs,
                  ),
                ),
              ],
              if (onDelete != null) ... [
                const SizedBox(width: LinagoraSpacing.base),
                _DeleteButton(
                  onDelete: onDelete,
                  iconWidget: deleteIconWidget,
                  tooltip: deleteTooltip,
                ),
              ],
            ],
          ),
        );

        if (!isMobile || !showDivider) {
          return row;
        }

        // Inset the divider past the avatar (avatar width + horizontal
        // padding on both sides), matching the settings-list design. Drawn
        // as a separate line below the row so it doesn't shift row content.
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            row,
            Padding(
              padding: const EdgeInsets.only(
                left: LinagoraSpacing.base * 5,
              ),
              child: Divider(
                height: LinagoraDividerStyle
                    .material()
                    .thickness,
                thickness: LinagoraDividerStyle
                    .material()
                    .thickness,
                color: LinagoraDividerStyle
                    .material()
                    .color,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Content extends StatelessWidget {
  final String deviceName;
  final String lastActiveText;
  final bool verified;
  final String unverifiedLabel;
  final bool isMobile;

  const _Content({
    required this.deviceName,
    required this.lastActiveText,
    required this.verified,
    required this.unverifiedLabel,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final colors = LinagoraSysColors.material();
    final textTheme = LinagoraTextTheme.material();
    final textThemeExtension = LinagoraTextThemeExtension.material();
    final titleStyle = (isMobile
            ? textThemeExtension.bodyMedium2
            : textTheme.bodyMedium)
        ?.copyWith(color: colors.onSurface);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          deviceName,
          style: titleStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          lastActiveText,
          style: textTheme.bodyMedium
              ?.copyWith(color: LinagoraRefColors.material().tertiary[30]),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (!verified)
          Text(
            unverifiedLabel,
            style: textTheme.bodyMedium?.copyWith(color: colors.onWarning),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final VoidCallback? onDelete;
  final Widget? iconWidget;
  final String tooltip;

  const _DeleteButton({
    required this.onDelete,
    this.iconWidget,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final colors = LinagoraSysColors.material();
    return LinagoraIconButton(
      icon: Icons.delete_outline,
      color: colors.onTertiaryContainer,
      tooltip: tooltip,
      onPressed: onDelete,
      iconWidget: iconWidget,
    );
  }
}
