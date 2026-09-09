import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linagora_design_flutter/buttons/linagora_button.dart';
import 'package:linagora_design_flutter/buttons/linagora_button_size.dart';
import 'package:linagora_design_flutter/buttons/linagora_icon_button.dart';
import 'package:linagora_design_flutter/images/linagora_design_images.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// Actions available for an event's video conference link.
///
/// The video and copy actions can be shown independently. Products can replace
/// either default asset with an [IconData] or arbitrary widget, including an
/// SVG, image, or brand-specific icon.
class EventConferenceActions extends StatelessWidget {
  static const Color defaultVideoButtonBackground = Color(0xFFF67E35);
  static const Color defaultVideoButtonForeground = Color(0xFFFFFFFF);
  static const Color defaultCopyIconColor = Color(0xA3424244);
  static const Color defaultCopyOverlayColor = Color(0xFF424244);
  static const double defaultVideoIconSize = 24;
  static const double defaultCopyIconSize = 24;
  static const double defaultActionGap = 16;
  static const EdgeInsets defaultCopyButtonPadding = EdgeInsets.all(8);

  /// Whether to render the video conference button.
  final bool showVideoButton;

  /// Whether to render the copy-link icon button.
  final bool showCopyButton;

  /// Callback for the video conference action. A null value disables the
  /// visible button.
  final VoidCallback? onVideoButtonPressed;

  /// Callback for the copy-link action. A null value disables the visible
  /// button.
  final VoidCallback? onCopyLinkPressed;

  /// Localised label for the video conference button.
  final String videoButtonLabel;

  /// Material icon that replaces the default video icon when [videoIconWidget]
  /// is null.
  final IconData? videoIcon;

  /// Arbitrary video icon that takes precedence over [videoIcon].
  final Widget? videoIconWidget;

  /// Material icon that replaces the default copy icon when [copyIconWidget]
  /// is null.
  final IconData? copyIcon;

  /// Arbitrary copy icon that takes precedence over [copyIcon].
  final Widget? copyIconWidget;

  /// Fixed outer size of the video icon slot.
  final double videoIconSize;

  /// Fixed outer size of the copy icon slot.
  final double copyIconSize;

  /// Tooltip and semantic label for the copy-link icon button.
  final String? copyButtonTooltip;

  /// Optional visual overrides for the video conference button.
  final ButtonStyle? videoButtonStyle;

  /// Colour applied when [copyIcon] is used instead of an arbitrary widget.
  final Color? copyIconColor;

  /// Base colour Material uses to derive the copy button's pressed, hover,
  /// and focus state layers.
  final Color copyOverlayColor;

  const EventConferenceActions({
    super.key,
    this.showVideoButton = true,
    this.showCopyButton = true,
    this.onVideoButtonPressed,
    this.onCopyLinkPressed,
    this.videoButtonLabel = 'Join the video conference',
    this.videoIcon,
    this.videoIconWidget,
    this.copyIcon,
    this.copyIconWidget,
    this.videoIconSize = defaultVideoIconSize,
    this.copyIconSize = defaultCopyIconSize,
    this.copyButtonTooltip = 'Copy link',
    this.videoButtonStyle,
    this.copyIconColor = defaultCopyIconColor,
    this.copyOverlayColor = defaultCopyOverlayColor,
  }) : assert(videoIconSize > 0, 'Video icon size must be positive'),
       assert(copyIconSize > 0, 'Copy icon size must be positive');

  @override
  Widget build(BuildContext context) {
    if (!showVideoButton && !showCopyButton) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // The label ellipsizes rather than overflowing once the row is
        // narrower than the button's natural width.
        if (showVideoButton) Flexible(child: _buildVideoButton()),
        if (showVideoButton && showCopyButton)
          const SizedBox(width: defaultActionGap),
        if (showCopyButton) _buildCopyButton(),
      ],
    );
  }

  Widget _buildVideoButton() {
    return LinagoraButton(
      label: videoButtonLabel,
      icon: videoIcon,
      iconWidget: _videoIconWidget,
      iconSpacing: 12,
      onPressed: onVideoButtonPressed,
      size: LinagoraButtonSize.m,
      style: _videoButtonStyle,
    );
  }

  Widget _buildCopyButton() {
    return LinagoraIconButton(
      icon: copyIcon,
      iconWidget: _copyIconWidget,
      iconSize: copyIconSize,
      color: copyIconColor,
      overlayColor: copyOverlayColor,
      padding: defaultCopyButtonPadding,
      shape: const CircleBorder(),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.standard,
      onPressed: onCopyLinkPressed,
      tooltip: copyButtonTooltip,
    );
  }

  Widget? get _videoIconWidget {
    final customIcon = videoIconWidget;
    if (customIcon != null) {
      return SizedBox.square(dimension: videoIconSize, child: customIcon);
    }
    if (videoIcon != null) return null;
    return SizedBox.square(
      dimension: videoIconSize,
      child: SvgPicture.asset(
        LinagoraDesignImages.videoConferenceIcon,
        package: LinagoraDesignImages.packageName,
      ),
    );
  }

  Widget? get _copyIconWidget {
    final customIcon = copyIconWidget;
    if (customIcon != null) return customIcon;
    if (copyIcon != null) return null;
    return SvgPicture.asset(
      LinagoraDesignImages.copyLinkIcon,
      package: LinagoraDesignImages.packageName,
    );
  }

  ButtonStyle get _videoButtonStyle {
    final defaultStyle = _defaultVideoButtonStyle.copyWith(
      iconSize: WidgetStatePropertyAll(videoIconSize),
    );
    return videoButtonStyle?.merge(defaultStyle) ?? defaultStyle;
  }

  static final ButtonStyle _defaultVideoButtonStyle = ButtonStyle(
    backgroundColor: const WidgetStatePropertyAll(defaultVideoButtonBackground),
    foregroundColor: const WidgetStatePropertyAll(defaultVideoButtonForeground),
    iconSize: const WidgetStatePropertyAll(defaultVideoIconSize),
    minimumSize: const WidgetStatePropertyAll(Size(0, 40)),
    padding: const WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    shape: const WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    ),
    textStyle: WidgetStatePropertyAll(LinagoraTextTheme.material().labelLarge),
  );
}
