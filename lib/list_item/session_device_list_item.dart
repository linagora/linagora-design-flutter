import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/buttons/linagora_button.dart';
import 'package:linagora_design_flutter/buttons/linagora_button_size.dart';
import 'package:linagora_design_flutter/buttons/linagora_icon_button.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';
import 'package:linagora_design_flutter/style/linagora_divider_style.dart';

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
              _Avatar(
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
                // Bounded, not Expanded/Flexible: caps a long verifyLabel
                // so it can't force a Row overflow, while still leaving
                // _Content's Expanded as the primary space claimant.
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 120),
                  child: LinagoraButton(
                    label: verifyLabel,
                    onPressed: onVerifyPressed,
                    size:
                        isMobile ? LinagoraButtonSize.xs : LinagoraButtonSize.m,
                  ),
                ),
              ],
              const SizedBox(width: LinagoraSpacing.base),
              _DeleteButton(onDelete: onDelete, iconWidget: deleteIconWidget),
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
                height: LinagoraDividerStyle.material().thickness,
                thickness: LinagoraDividerStyle.material().thickness,
                color: LinagoraDividerStyle.material().color,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  final IconData icon;

  /// Overrides [icon] with any widget — see
  /// [SessionDeviceListItem.platformIconWidget].
  final Widget? iconWidget;
  final bool verified;
  final double size;

  const _Avatar({
    required this.icon,
    this.iconWidget,
    required this.verified,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final colors = LinagoraSysColors.material();
    // Figma: 44px avatar → ~18.86px badge circle → ~13.3px warning glyph.
    final badgeSize = size * 18.86 / 44;
    final badgeIconSize = size * 13.3 / 44;
    final glyphSize = size * 24 / 56;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: verified ? colors.success : colors.warning,
            ),
            child: Center(
              child: iconWidget != null
                  ? SizedBox.square(dimension: glyphSize, child: iconWidget)
                  : Icon(
                      icon,
                      size: glyphSize,
                      color: colors.onSuccess,
                    ),
            ),
          ),
          if (!verified)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: badgeSize,
                height: badgeSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.onPrimary,
                ),
                child: Icon(
                  Icons.warning_rounded,
                  size: badgeIconSize,
                  color: colors.onWarning,
                ),
              ),
            ),
        ],
      ),
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
    final textTheme = Theme.of(context).textTheme;
    final titleStyle = (isMobile && !verified
            ? textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)
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
          style: textTheme.bodyMedium?.copyWith(color: colors.tertiary),
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

  const _DeleteButton({required this.onDelete, this.iconWidget});

  @override
  Widget build(BuildContext context) {
    final colors = LinagoraSysColors.material();
    return LinagoraIconButton(
      icon: Icons.delete_outline,
      color: colors.tertiary,
      tooltip: 'Delete',
      onPressed: onDelete,
      iconWidget: iconWidget,
    );
  }
}
