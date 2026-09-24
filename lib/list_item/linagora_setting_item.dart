import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_ref_colors.dart';
import 'package:linagora_design_flutter/colors/linagora_state_layer.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';
import 'package:linagora_design_flutter/style/linagora_divider_style.dart';
import 'package:linagora_design_flutter/style/linagora_hover_style.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

enum LinagoraSettingItemControl { toggle, checkbox }

/// A settings row with a trailing chevron, or a switch/checkbox with
/// [LinagoraSettingItem.selectable].
class LinagoraSettingItem extends StatelessWidget {
  static const double minHeight = 92;
  static const double titleOnlyMinHeight = 84;

  /// For items not flush with the screen edge.
  static const EdgeInsets insetPadding = EdgeInsets.fromLTRB(
    LinagoraSpacing.base * 3,
    LinagoraSpacing.base * 2,
    LinagoraSpacing.base * 2,
    LinagoraSpacing.base * 2,
  );

  static const EdgeInsets _padding = EdgeInsets.only(
    left: LinagoraSpacing.base,
    top: LinagoraSpacing.base * 2,
    bottom: LinagoraSpacing.base * 2,
  );
  static const EdgeInsets _togglePadding = EdgeInsets.symmetric(
    horizontal: LinagoraSpacing.base * 3,
    vertical: LinagoraSpacing.base * 2,
  );
  static const double _iconSize = LinagoraSpacing.base * 3;
  static const double _gap = LinagoraSpacing.base;
  static const double _textGap = LinagoraSpacing.base / 2;

  final String title;

  final String? subtitle;

  /// Null shows the whole subtitle.
  final int? subtitleMaxLines;

  /// Shown after [title].
  final int? count;

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

  final LinagoraSettingItemControl? control;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final EdgeInsets? padding;

  final bool showDivider;
  final bool enabled;

  /// Background shown while pressed/tapped. Defaults to
  /// [LinagoraHoverStyle.selectedColor].
  final Color? pressedColor;

  /// Background color override. Null means transparent.
  final Color? itemDecorationColor;

  final Color? titleColor;

  final Color? subtitleColor;

  final Color? iconColor;

  final CrossAxisAlignment? crossAxisAlignment;

  const LinagoraSettingItem({
    super.key,
    required this.title,
    this.subtitle,
    this.subtitleMaxLines = 2,
    this.count,
    this.leadingIcon,
    this.leading,
    this.onTap,
    this.trailing,
    this.loading = false,
    this.padding,
    this.showDivider = false,
    this.enabled = true,
    this.pressedColor,
    this.itemDecorationColor,
    this.titleColor,
    this.subtitleColor,
    this.iconColor,
    this.crossAxisAlignment,
  }) : control = null,
       value = false,
       onChanged = null;

  const LinagoraSettingItem.selectable({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    LinagoraSettingItemControl this.control = LinagoraSettingItemControl.toggle,
    this.subtitle,
    this.subtitleMaxLines = 2,
    this.count,
    this.leadingIcon,
    this.leading,
    this.padding,
    this.showDivider = false,
    this.enabled = true,
    this.pressedColor,
    this.itemDecorationColor,
    this.titleColor,
    this.subtitleColor,
    this.iconColor,
    this.crossAxisAlignment,
  }) : onTap = null,
       trailing = null,
       loading = false;

  bool get _hasLeading => leading != null || leadingIcon != null;

  VoidCallback? get _effectiveOnTap {
    if (!enabled || loading) return null;
    if (control == null) return onTap;
    final onChanged = this.onChanged;
    if (onChanged == null) return null;
    return () => onChanged(!value);
  }

  EdgeInsets get _effectivePadding =>
      padding ??
      switch (control) {
        null => _padding,
        LinagoraSettingItemControl.toggle => _togglePadding,
        LinagoraSettingItemControl.checkbox => insetPadding,
      };

  double get _dividerInset =>
      _effectivePadding.left + (_hasLeading ? _iconSize + _gap : 0);

  @override
  Widget build(BuildContext context) {
    final colors = LinagoraSysColors.material();
    final textThemeExtension = LinagoraTextThemeExtension.material();
    final textTheme = LinagoraTextTheme.material();
    final resolvedSubtitleColor =
        subtitleColor ??
        LinagoraRefColors.material().tertiary[30] ??
        const Color(0xFF99A0A9);
    final resolvedIconColor = iconColor ?? resolvedSubtitleColor;
    final subtitleStyle = textTheme.bodyMedium?.copyWith(
      color: resolvedSubtitleColor,
    );
    final subtitle = this.subtitle;
    final count = this.count;

    final hoverStyle = LinagoraHoverStyle.material();

    final content = Row(
      crossAxisAlignment: subtitle == null
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (_hasLeading) ...[
          SizedBox(
            width: _iconSize,
            height: _iconSize,
            child:
                leading ??
                Icon(leadingIcon, size: _iconSize, color: resolvedIconColor),
          ),
          const SizedBox(width: _gap),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text.rich(
                TextSpan(
                  text: title,
                  children: [
                    if (count != null)
                      TextSpan(text: ' $count', style: subtitleStyle),
                  ],
                ),
                style: textThemeExtension.bodyMedium2.copyWith(
                  color: titleColor ?? colors.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: _textGap),
                Text(
                  subtitle,
                  style: subtitleStyle,
                  maxLines: subtitleMaxLines,
                  overflow: subtitleMaxLines == null
                      ? TextOverflow.clip
                      : TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        if (control == LinagoraSettingItemControl.checkbox) ...[
          const SizedBox(width: _gap),
          Icon(
            value ? Icons.check_box_outlined : Icons.check_box_outline_blank,
            size: _iconSize,
            color: resolvedIconColor,
          ),
        ],
      ],
    );

    final Widget? centeredTrailing = switch (control) {
      LinagoraSettingItemControl.checkbox => null,
      LinagoraSettingItemControl.toggle => _SettingSwitch(
        value: value,
        onChanged: enabled ? onChanged : null,
      ),
      null when loading => SizedBox(
        width: _iconSize,
        height: _iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: resolvedIconColor,
        ),
      ),
      null =>
        trailing ??
            Icon(
              Icons.chevron_right,
              size: _iconSize,
              color: resolvedIconColor,
            ),
    };

    Widget item = Material(
      color: Colors.transparent,
      borderRadius: hoverStyle.borderRadius,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: hoverStyle.borderRadius,
          color: itemDecorationColor,
        ),
        child: InkWell(
          onTap: _effectiveOnTap,
          borderRadius: hoverStyle.hoverBorderRadius,
          hoverColor: Colors.transparent,
          highlightColor: pressedColor ?? hoverStyle.selectedColor,
          splashColor: pressedColor ?? hoverStyle.selectedColor,
          child: IntrinsicHeight(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: subtitle == null ? titleOnlyMinHeight : minHeight,
              ),
              child: Padding(
                padding: _effectivePadding,
                child: Row(
                  crossAxisAlignment:
                      crossAxisAlignment ?? CrossAxisAlignment.center,
                  children: [
                    Expanded(child: content),
                    if (centeredTrailing != null) ...[
                      const SizedBox(width: _gap),
                      Align(child: centeredTrailing),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (control == LinagoraSettingItemControl.checkbox) {
      item = Semantics(
        checked: value,
        enabled: enabled && onChanged != null,
        child: item,
      );
    }
    if (control != null) {
      item = MergeSemantics(child: item);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        item,
        if (showDivider)
          Padding(
            padding: EdgeInsets.only(left: _dividerInset),
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

class _SettingSwitch extends StatelessWidget {
  static const double _scale = 24 / 32;
  static const Size _size = Size(52 * _scale, 32 * _scale);

  final bool value;
  final ValueChanged<bool>? onChanged;

  const _SettingSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = LinagoraSysColors.material();
    final onSurfaceLayer = LinagoraStateLayer(colors.onSurface);
    final primaryLayer = LinagoraStateLayer(colors.primary);
    final disabledOnSurface = onSurfaceLayer.opacityLayer2;

    return SizedBox.fromSize(
      size: _size,
      child: OverflowBox(
        maxWidth: double.infinity,
        maxHeight: double.infinity,
        child: Transform.scale(
          scale: _scale,
          child: Switch(
            value: value,
            onChanged: onChanged,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            trackColor: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              if (states.contains(WidgetState.disabled)) {
                return selected ? disabledOnSurface : Colors.transparent;
              }
              return selected ? colors.primary : colors.surfaceVariant;
            }),
            trackOutlineColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.transparent;
              }
              return states.contains(WidgetState.disabled)
                  ? disabledOnSurface
                  : colors.outline;
            }),
            thumbColor: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              if (states.contains(WidgetState.disabled)) {
                return selected
                    ? colors.surface
                    : colors.onSurface.withValues(alpha: 0.38);
              }
              final interacting =
                  states.contains(WidgetState.pressed) ||
                  states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.focused);
              if (selected) {
                return interacting ? colors.primaryContainer : colors.onPrimary;
              }
              return interacting ? colors.onSurface : colors.outline;
            }),
            overlayColor: WidgetStateProperty.resolveWith((states) {
              final layer = states.contains(WidgetState.selected)
                  ? primaryLayer
                  : onSurfaceLayer;
              if (states.contains(WidgetState.pressed) ||
                  states.contains(WidgetState.focused)) {
                return layer.opacityLayer2;
              }
              if (states.contains(WidgetState.hovered)) {
                return layer.opacityLayer1;
              }
              return null;
            }),
          ),
        ),
      ),
    );
  }
}
