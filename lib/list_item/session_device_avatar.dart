import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';

/// A circular status avatar for a device/session: a solid success/warning
/// circle holding a platform glyph, with a warning badge overlaid when
/// unverified. Reusable outside [SessionDeviceListItem].
///
/// Provide either [icon] (a Material glyph) or [iconWidget] (an arbitrary
/// widget such as `SvgPicture.asset`).
class SessionDeviceAvatar extends StatelessWidget {
  /// Material glyph for the platform. Required unless [iconWidget] is provided.
  final IconData? icon;

  /// Overrides [icon] with any widget (e.g. `SvgPicture.asset`). When set,
  /// [icon] is ignored for rendering; sized to the avatar's glyph slot.
  final Widget? iconWidget;

  /// When false, the circle turns warning-colored and a warning badge is
  /// overlaid at the bottom-right.
  final bool verified;

  /// Diameter of the avatar circle.
  final double size;

  const SessionDeviceAvatar({
    super.key,
    this.icon,
    this.iconWidget,
    required this.verified,
    required this.size,
  }) : assert(
          icon != null || iconWidget != null,
          'Provide either icon or iconWidget',
        );

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
