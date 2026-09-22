import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/banners/linagora_alert_action.dart';
import 'package:linagora_design_flutter/banners/linagora_alert_pointer.dart';
import 'package:linagora_design_flutter/banners/linagora_alert_style.dart';
import 'package:linagora_design_flutter/buttons/linagora_button.dart';
import 'package:linagora_design_flutter/buttons/linagora_button_size.dart';
import 'package:linagora_design_flutter/buttons/linagora_button_variant.dart';
import 'package:linagora_design_flutter/buttons/linagora_icon_button.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';
import 'package:linagora_design_flutter/style/linagora_typography.dart';

/// A rounded, accent-tinted notice: a leading icon, an optional title, a
/// message, and any combination of a primary action, a secondary action, a
/// dismiss control, and a pointer that turns the alert into a callout.
///
/// Every slot but [message] is optional, so one widget covers the range from
/// a single-line hint to a titled warning with two actions. The container
/// fills the width it is given and hugs its content; the icon and the text
/// align to the first line while the trailing controls follow
/// [actionsAlignment].
///
/// ```dart
/// LinagoraAlert(
///   color: LinagoraAlertColor.error,
///   title: 'This message may be dangerous',
///   message: 'This message contains a suspicious link.',
///   action: LinagoraAlertAction(
///     label: 'Not spam',
///     onPressed: () => markAsNotSpam(),
///   ),
/// )
/// ```
class LinagoraAlert extends StatelessWidget {
  /// Corner radius of the container.
  static const double borderRadius = LinagoraSpacing.base;

  /// Outer size of the leading icon.
  static const double iconSize = LinagoraSpacing.base * 2;

  /// Outer size of the dismiss glyph.
  static const double closeIconSize = 24;

  /// Square tap target the dismiss glyph sits in.
  static const double closeSlotSize = 32;

  /// Space between the leading icon and the text block.
  static const double iconSpacing = LinagoraSpacing.base * 2;

  /// Space between the text block and the trailing controls.
  static const double actionsSpacing = LinagoraSpacing.base * 1.5;

  /// Height the action buttons never drop below.
  static const double actionMinHeight = 32;

  /// Minimum width kept for the message when trailing controls are present.
  static const double _minimumTextWidth = 32;

  /// Width of the pointer that [showPointer] reveals.
  static const double pointerWidth = 24;

  /// Height of the pointer that [showPointer] reveals.
  static const double pointerHeight = 12;

  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: LinagoraSpacing.base * 2,
    vertical: LinagoraSpacing.base,
  );

  /// Primary action padding — a pill that reads as a button.
  static const EdgeInsets _actionPadding = EdgeInsets.symmetric(
    horizontal: LinagoraSpacing.base * 2,
    vertical: LinagoraSpacing.base,
  );

  /// Secondary action padding — tighter, so it reads as a link beside the
  /// primary action.
  static const EdgeInsets _secondaryActionPadding = EdgeInsets.symmetric(
    horizontal: 6,
    vertical: LinagoraSpacing.base,
  );

  /// Body text. The only required slot.
  final String message;

  /// Shown above [message] in a heavier weight. Null renders no title line.
  final String? title;

  /// Severity, which picks the accent colour and the default [icon].
  final LinagoraAlertColor color;

  /// Whether the container is tinted or sits bare on the surface.
  final LinagoraAlertVariant variant;

  /// Vertical rhythm of the text block.
  final LinagoraAlertSize size;

  /// Vertical placement of the trailing controls.
  ///
  /// At widths too narrow to keep the content and controls usable in one row,
  /// the controls move below the content and align to the logical end.
  final LinagoraAlertActionsAlignment actionsAlignment;

  /// Horizontal alignment of the title and message.
  final LinagoraAlertTextAlignment textAlignment;

  /// Entry of the shared text scale the title is set in.
  final LinagoraTypographyVariant titleVariant;

  /// Entry of the shared text scale the message is set in.
  final LinagoraTypographyVariant messageVariant;

  /// Set false to drop the leading icon and let the text start at the
  /// container's padding.
  final bool showIcon;

  /// Adds a pointer centred on the bottom edge when the resolved background is
  /// visible, turning the alert into a callout for the content below it.
  final bool showPointer;

  /// Overrides the glyph [color] would pick. Ignored when [iconWidget] is set.
  final IconData? icon;

  /// Replaces the leading icon with any widget (e.g. `SvgPicture.asset`),
  /// sized to [iconSize].
  final Widget? iconWidget;

  /// Primary action. Null omits the button; a null callback inside the action
  /// keeps a disabled button visible.
  final LinagoraAlertAction? action;

  /// Secondary action, shown after [action] in a lighter treatment.
  final LinagoraAlertAction? secondaryAction;

  /// Shows a trailing dismiss (X) control.
  final VoidCallback? onClose;

  /// Overrides the dismiss glyph, same rules as [iconWidget].
  final Widget? closeIconWidget;

  /// Tooltip and semantic label of the dismiss control.
  final String closeTooltip;

  /// Whether assistive technologies announce the alert when it appears or
  /// changes.
  final bool liveRegion;

  /// Overrides the accent that [color] resolves to, tints included.
  final Color? accentColor;

  /// Overrides the container fill. Wins over [variant].
  final Color? backgroundColor;

  /// Overrides the title and message colour.
  final Color? foregroundColor;

  /// Caps [message] before it ellipsizes. Null lets it wrap freely.
  final int? messageMaxLines;

  /// Caps [title] before it ellipsizes. Null lets it wrap freely.
  final int? titleMaxLines;

  /// Caps the width of each action button, past which its label ellipsizes.
  ///
  /// Without a cap a long label would push the message out of the row on a
  /// narrow alert. Each button is measured at its own intrinsic width first,
  /// so a short label never claims the whole cap.
  final double actionMaxWidth;

  /// Share of the alert's inner width the trailing controls may take
  /// together, which keeps the message readable once the alert narrows past
  /// what [actionMaxWidth] alone can protect. Ignored when the alert is laid
  /// out against an unbounded width.
  final double actionsMaxWidthFraction;

  const LinagoraAlert({
    super.key,
    required this.message,
    this.title,
    this.color = LinagoraAlertColor.error,
    this.variant = LinagoraAlertVariant.filled,
    this.size = LinagoraAlertSize.normal,
    this.actionsAlignment = LinagoraAlertActionsAlignment.center,
    this.textAlignment = LinagoraAlertTextAlignment.start,
    this.titleVariant = LinagoraTypographyVariant.h5,
    this.messageVariant = LinagoraTypographyVariant.body2,
    this.showIcon = true,
    this.showPointer = false,
    this.icon,
    this.iconWidget,
    this.action,
    this.secondaryAction,
    this.onClose,
    this.closeIconWidget,
    this.closeTooltip = 'Dismiss',
    this.liveRegion = true,
    this.accentColor,
    this.backgroundColor,
    this.foregroundColor,
    this.messageMaxLines,
    this.titleMaxLines,
    this.actionMaxWidth = 160,
    this.actionsMaxWidthFraction = 0.5,
  })  : assert(
          actionsMaxWidthFraction > 0 && actionsMaxWidthFraction <= 1,
          'Actions max width fraction must be within (0, 1]',
        ),
        assert(
          messageMaxLines == null || messageMaxLines > 0,
          'Message max lines must be positive',
        ),
        assert(
          titleMaxLines == null || titleMaxLines > 0,
          'Title max lines must be positive',
        ),
        assert(actionMaxWidth > 0, 'Action max width must be positive');

  bool get _hasTitle => title?.isNotEmpty ?? false;

  bool get _hasAction => action != null;

  bool get _hasSecondaryAction => secondaryAction != null;

  bool get _hasTrailing => _hasAction || _hasSecondaryAction || onClose != null;

  @override
  Widget build(BuildContext context) {
    final palette = _palette(context);
    final metrics = LinagoraAlertMetrics.resolve(size);
    final container = _buildContainer(context, palette, metrics);
    final pointerColor = backgroundColor ?? palette.background;
    final hasVisiblePointer = showPointer && pointerColor.a > 0;

    return Semantics(
      container: true,
      liveRegion: liveRegion,
      child: !hasVisiblePointer
          ? container
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                container,
                LinagoraAlertPointer(
                  width: pointerWidth,
                  height: pointerHeight,
                  color: pointerColor,
                ),
              ],
            ),
    );
  }

  Widget _buildContainer(
    BuildContext context,
    LinagoraAlertPalette palette,
    LinagoraAlertMetrics metrics,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? palette.background,
        borderRadius: const BorderRadius.all(Radius.circular(borderRadius)),
      ),
      padding: _padding,
      // The trailing cluster is a non-flex row child, so it is measured at
      // its own width before the message gets what is left. Reading the
      // inner width here lets that measurement be capped, instead of letting
      // long labels push the message out of the row.
      child: LayoutBuilder(
        builder: (context, constraints) {
          final hasBoundedWidth = constraints.hasBoundedWidth;
          final content = _buildContent(
            context,
            palette,
            metrics,
            hasBoundedWidth: hasBoundedWidth,
          );
          if (_hasTrailing && _shouldStackTrailing(constraints)) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                content,
                const SizedBox(height: actionsSpacing),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: _buildTrailing(
                    context,
                    palette,
                    constraints.maxWidth,
                  ),
                ),
              ],
            );
          }
          return Row(
            // An unbounded parent asks the alert to shrink-wrap instead of
            // filling a finite surface, so loose flex must replace Expanded.
            mainAxisSize:
                hasBoundedWidth ? MainAxisSize.max : MainAxisSize.min,
            // Places the trailing cluster against the content block as a
            // whole, while the inner row keeps the icon on the first line.
            crossAxisAlignment: switch (actionsAlignment) {
              LinagoraAlertActionsAlignment.top => CrossAxisAlignment.start,
              LinagoraAlertActionsAlignment.center => CrossAxisAlignment.center,
              LinagoraAlertActionsAlignment.bottom => CrossAxisAlignment.end,
            },
            children: [
              if (hasBoundedWidth)
                Expanded(child: content)
              else
                Flexible(fit: FlexFit.loose, child: content),
              if (_hasTrailing) ...[
                const SizedBox(width: actionsSpacing),
                _buildTrailing(
                  context,
                  palette,
                  _trailingMaxWidth(constraints),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  double _trailingMaxWidth(BoxConstraints constraints) {
    if (!constraints.maxWidth.isFinite) return double.infinity;
    final requested = constraints.maxWidth * actionsMaxWidthFraction;
    final contentMinimum = _minimumTextWidth +
        (showIcon ? iconSize + iconSpacing : 0);
    final available = math.max(
      0.0,
      constraints.maxWidth - actionsSpacing - contentMinimum,
    );
    final rigidTrailingWidth = onClose == null ? 0.0 : closeSlotSize;
    return math.min(math.max(requested, rigidTrailingWidth), available);
  }

  bool _shouldStackTrailing(BoxConstraints constraints) {
    if (!constraints.maxWidth.isFinite) return false;
    final contentMinimum = _minimumTextWidth +
        (showIcon ? iconSize + iconSpacing : 0);
    final trailingMinimum =
        (_hasAction
            ? _actionMinimumWidth(
                padding: _actionPadding,
                hasIcon: action?.hasIcon ?? false,
              )
            : 0) +
        (_hasSecondaryAction
            ? _actionMinimumWidth(
                padding: _secondaryActionPadding,
                hasIcon: secondaryAction?.hasIcon ?? false,
              )
            : 0) +
        (onClose == null ? 0 : closeSlotSize);
    return constraints.maxWidth <
        contentMinimum + actionsSpacing + trailingMinimum;
  }

  double _actionMinimumWidth({
    required EdgeInsets padding,
    bool hasIcon = false,
  }) {
    final rigidContentWidth =
        padding.horizontal + (hasIcon ? iconSize + LinagoraSpacing.base : 0);
    return math.max(actionMinHeight, rigidContentWidth);
  }

  /// Resolves the palette, then applies the caller's colour overrides.
  LinagoraAlertPalette _palette(BuildContext context) {
    final theme = Theme.of(context);
    final resolved = LinagoraAlertPalette.resolve(
      color,
      brightness: theme.brightness,
      variant: variant,
      onSurface: theme.colorScheme.onSurface,
    );
    final accent = accentColor;
    final foreground = foregroundColor;
    if (accent == null && foreground == null) return resolved;
    return LinagoraAlertPalette(
      accent: accent ?? resolved.accent,
      background: accent != null && variant == LinagoraAlertVariant.filled
          ? accent.withValues(alpha: LinagoraAlertPalette.containerOpacity)
          : resolved.background,
      foreground: foreground ?? resolved.foreground,
      closeForeground: resolved.closeForeground,
    );
  }

  Widget _buildContent(
    BuildContext context,
    LinagoraAlertPalette palette,
    LinagoraAlertMetrics metrics, {
    required bool hasBoundedWidth,
  }) {
    final text = _buildText(context, palette, metrics);
    if (!showIcon) return text;

    return Row(
      mainAxisSize: hasBoundedWidth ? MainAxisSize.max : MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: metrics.iconTopPadding),
          child: _buildLeadingIcon(palette),
        ),
        const SizedBox(width: iconSpacing),
        if (hasBoundedWidth)
          Expanded(child: text)
        else
          Flexible(fit: FlexFit.loose, child: text),
      ],
    );
  }

  Widget _buildLeadingIcon(LinagoraAlertPalette palette) {
    final iconWidget = this.iconWidget;
    if (iconWidget != null) {
      return SizedBox.square(dimension: iconSize, child: iconWidget);
    }
    return Icon(icon ?? _defaultIcon, size: iconSize, color: palette.accent);
  }

  IconData get _defaultIcon => switch (color) {
        LinagoraAlertColor.primary ||
        LinagoraAlertColor.secondary =>
          Icons.info,
        LinagoraAlertColor.error => Icons.error,
        LinagoraAlertColor.warning => Icons.warning_rounded,
        LinagoraAlertColor.success => Icons.check_circle,
      };

  bool get _centred => textAlignment == LinagoraAlertTextAlignment.center;

  Widget _buildText(
    BuildContext context,
    LinagoraAlertPalette palette,
    LinagoraAlertMetrics metrics,
  ) {
    final textAlign = _centred ? TextAlign.center : TextAlign.start;
    final message = Text(
      this.message,
      style: _messageStyle(context).copyWith(color: palette.foreground),
      textAlign: textAlign,
      maxLines: messageMaxLines,
      overflow: messageMaxLines == null ? null : TextOverflow.ellipsis,
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: metrics.textVerticalPadding),
      child: !_hasTitle
          ? message
          : Column(
              crossAxisAlignment: _centred
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title!,
                  style:
                      _titleStyle(context).copyWith(color: palette.foreground),
                  textAlign: textAlign,
                  maxLines: titleMaxLines,
                  overflow:
                      titleMaxLines == null ? null : TextOverflow.ellipsis,
                ),
                SizedBox(height: metrics.textSpacing),
                message,
              ],
            ),
    );
  }

  TextStyle _titleStyle(BuildContext context) =>
      LinagoraTypography.of(context).resolve(titleVariant);

  TextStyle _messageStyle(BuildContext context) =>
      LinagoraTypography.of(context).resolve(messageVariant);

  Widget _buildTrailing(
    BuildContext context,
    LinagoraAlertPalette palette,
    double maxWidth,
  ) {
    final actionTextStyle = LinagoraTypography.of(context).buttonMedium;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Loose flex: each button keeps its own width while the pair fits,
          // and they share the cap evenly once it binds. The dismiss control
          // stays rigid so it is never squeezed out of its tap target.
          if (_hasAction)
            Flexible(
              child: _buildAction(
                action: action!,
                palette: palette,
                padding: _actionPadding,
                filled: true,
                textStyle: actionTextStyle,
              ),
            ),
          if (_hasSecondaryAction)
            Flexible(
              child: _buildAction(
                action: secondaryAction!,
                palette: palette,
                padding: _secondaryActionPadding,
                filled: false,
                textStyle: actionTextStyle,
              ),
            ),
          if (onClose != null) _buildClose(palette),
        ],
      ),
    );
  }

  /// The actions read as accent-coloured pills rather than filled buttons, so
  /// they never compete with the alert's own container.
  Widget _buildAction({
    required LinagoraAlertAction action,
    required LinagoraAlertPalette palette,
    required EdgeInsets padding,
    required bool filled,
    required TextStyle textStyle,
  }) {
    final hasIcon = action.hasIcon;
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = math.min(
          actionMaxWidth,
          constraints.maxWidth,
        );
        final rigidContentWidth =
            padding.horizontal +
            (hasIcon ? iconSize + LinagoraSpacing.base : 0);
        final labelWidth = math.max(0.0, availableWidth - rigidContentWidth);
        final labelPainter = TextPainter(
          text: TextSpan(text: action.label, style: textStyle),
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
          locale: Localizations.maybeLocaleOf(context),
          maxLines: 1,
          ellipsis: '…',
        )..layout(maxWidth: labelWidth);
        final isLabelTruncated = labelPainter.didExceedMaxLines;
        labelPainter.dispose();

        return LinagoraButton(
          label: action.label,
          onPressed: action.onPressed,
          size: LinagoraButtonSize.xs,
          variant: LinagoraButtonVariant.text,
          padding: padding,
          minimumHeight: actionMinHeight,
          textStyle: textStyle,
          constraints: BoxConstraints(maxWidth: actionMaxWidth),
          icon: action.icon,
          iconWidget: action.iconWidget,
          iconSize: hasIcon ? iconSize : null,
          iconColor: hasIcon ? palette.accent : null,
          foregroundColor: palette.accent,
          backgroundColor: filled ? palette.actionBackground : null,
          disabledForegroundColor: LinagoraButton.disabledContentColor,
          disabledBackgroundColor:
              filled ? LinagoraButton.disabledContainerColor : null,
          hoverBackgroundColor: filled ? palette.actionHoverBackground : null,
          hoverOverlayColor: filled ? null : palette.actionHoverBackground,
          tooltip: isLabelTruncated ? action.label : null,
        );
      },
    );
  }

  Widget _buildClose(LinagoraAlertPalette palette) {
    return SizedBox.square(
      dimension: closeSlotSize,
      child: LinagoraIconButton(
        icon: Icons.close,
        iconWidget: closeIconWidget,
        iconSize: closeIconSize,
        color: palette.closeForeground,
        tooltip: closeTooltip,
        onPressed: onClose,
        overlayColor: palette.actionHoverBackground,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
