import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_ref_colors.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';
import 'package:linagora_design_flutter/style/linagora_divider_style.dart';
import 'package:linagora_design_flutter/style/linagora_hover_style.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// A row of a list of people or groups: avatar, title and a short detail.
class LinagoraAvatarListItem extends StatefulWidget {
  static const double avatarSize = 56;
  static const double titleIconSize = 20;

  /// Laid out in an [avatarSize] square.
  final Widget avatar;

  final String title;

  /// Semibold instead of medium.
  final bool isTitleEmphasized;

  /// Small icons following the title, laid out in [titleIconSize] squares.
  final List<Widget> titleIcons;

  /// One line above [subtitle], such as who wrote it.
  final String? subtitleHeading;

  final String? subtitle;

  final int subtitleMaxLines;

  /// Short text at the end of the title line, such as a time.
  final String? trailingLabel;

  final bool selected;

  final VoidCallback? onTap;

  final bool showDivider;

  const LinagoraAvatarListItem({
    super.key,
    required this.avatar,
    required this.title,
    this.isTitleEmphasized = false,
    this.titleIcons = const [],
    this.subtitleHeading,
    this.subtitle,
    this.subtitleMaxLines = 1,
    this.trailingLabel,
    this.selected = false,
    this.onTap,
    this.showDivider = true,
  });

  @override
  State<LinagoraAvatarListItem> createState() => _LinagoraAvatarListItemState();
}

class _LinagoraAvatarListItemState extends State<LinagoraAvatarListItem> {
  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: LinagoraSpacing.base,
    vertical: LinagoraSpacing.base / 2,
  );
  static const EdgeInsets _trailingPadding = EdgeInsets.all(
    LinagoraSpacing.base / 2,
  );
  static const double _titleIconGap = LinagoraSpacing.base / 2;

  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final hoverStyle = LinagoraHoverStyle.material();
    final dividerStyle = LinagoraDividerStyle.material();
    final textTheme = LinagoraTextTheme.material();
    final textThemeExtension = LinagoraTextThemeExtension.material();
    final onSurface = LinagoraSysColors.material().onSurface;
    final secondaryColor = LinagoraRefColors.material().tertiary[30];
    final subtitleHeading = widget.subtitleHeading;
    final subtitle = widget.subtitle;
    final trailingLabel = widget.trailingLabel;
    final hasDivider = widget.showDivider && !widget.selected && !_hovered;

    return Semantics(
      selected: widget.selected,
      child: Material(
        color: widget.selected ? hoverStyle.selectedColor : Colors.transparent,
        borderRadius: hoverStyle.borderRadius,
        child: InkWell(
          onTap: widget.onTap,
          onHover: (hovered) => setState(() => _hovered = hovered),
          borderRadius: hoverStyle.hoverBorderRadius,
          hoverColor: hoverStyle.hoverColor,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: dividerStyle.thickness,
                  color: hasDivider ? dividerStyle.color : Colors.transparent,
                ),
              ),
            ),
            child: Padding(
              padding: _padding,
              child: Row(
                children: [
                  SizedBox.square(
                    dimension: LinagoraAvatarListItem.avatarSize,
                    child: widget.avatar,
                  ),
                  const SizedBox(width: LinagoraSpacing.base),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.title,
                                      style:
                                          (widget.isTitleEmphasized
                                                  ? textThemeExtension
                                                        .bodyMedium2
                                                  : textTheme.bodyMedium)
                                              ?.copyWith(color: onSurface),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  for (final icon in widget.titleIcons)
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                        start: _titleIconGap,
                                      ),
                                      child: IconTheme.merge(
                                        data: IconThemeData(
                                          size: LinagoraAvatarListItem
                                              .titleIconSize,
                                          color: secondaryColor,
                                        ),
                                        child: SizedBox.square(
                                          dimension: LinagoraAvatarListItem
                                              .titleIconSize,
                                          child: icon,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (trailingLabel != null)
                              Padding(
                                padding: _trailingPadding,
                                child: Text(
                                  trailingLabel,
                                  style: textTheme.labelMedium?.copyWith(
                                    color: secondaryColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (subtitleHeading != null)
                          Text(
                            subtitleHeading,
                            style: textTheme.bodyMedium?.copyWith(
                              color: onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (subtitle != null)
                          Text(
                            subtitle,
                            style: subtitleHeading == null
                                ? textTheme.bodyMedium?.copyWith(
                                    color: secondaryColor,
                                  )
                                : textThemeExtension.bodyMedium3.copyWith(
                                    color: LinagoraRefColors.material()
                                        .tertiary[20],
                                  ),
                            maxLines: widget.subtitleMaxLines,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
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
