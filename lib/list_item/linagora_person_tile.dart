import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linagora_design_flutter/extensions/string_extension.dart';
import 'package:linagora_design_flutter/images/linagora_design_images.dart';
import 'package:linagora_design_flutter/list_item/linagora_person_tile_style.dart';

/// Trailing remove control of a [LinagoraPersonTile].
@immutable
class LinagoraPersonTileAction {
  /// Tooltip and screen-reader name.
  final String tooltip;

  /// Null disables the button.
  final VoidCallback? onPressed;

  /// Distinguishes this button when several rows share a parent.
  final Key? key;

  const LinagoraPersonTileAction({
    required this.tooltip,
    required this.onPressed,
    this.key,
  });
}

/// A person or account row: optional avatar, name, optional detail, and
/// either a trailing remove [action] or a custom [trailing] widget.
///
/// Read-only without [onTap]. [selected] paints the active row. Null means
/// the row is not a selection control. Wrap rows in [LinagoraTileGroup] for
/// the outlined card used for one or many people.
class LinagoraPersonTile extends StatelessWidget {
  /// Convenience key for a single-row test. Pass it via [LinagoraPersonTileAction.key]
  /// (or [actionKeyFor]) when several rows share a parent.
  static const Key actionKey = ValueKey('linagora_person_tile_action');

  /// Key of the trailing action for the row identified by [id].
  static Key actionKeyFor(Object id) =>
      ValueKey('linagora_person_tile_action_$id');

  final String name;
  final String? subtitle;
  final int subtitleMaxLines;

  /// Omitted when null. Pass an avatar of the name's initials when the row
  /// should show a generated avatar.
  final Widget? avatar;
  final LinagoraPersonTileAction? action;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool? selected;
  final LinagoraPersonTileStyle? style;

  const LinagoraPersonTile({
    super.key,
    required this.name,
    this.subtitle,
    this.subtitleMaxLines = 2,
    this.avatar,
    this.action,
    this.trailing,
    this.onTap,
    this.selected,
    this.style,
  }) : assert(
         action == null || trailing == null,
         'Use either action or trailing',
       );

  @override
  Widget build(BuildContext context) {
    final tokens = style ?? LinagoraPersonTileStyle.material();
    final action = this.action;

    return Material(
      color: selected == true ? tokens.selectedColor : Colors.transparent,
      borderRadius: BorderRadius.circular(tokens.tileRadius),
      child: Row(
        children: [
          Expanded(child: _identity(tokens)),
          if (action != null)
            Padding(
              padding: EdgeInsetsDirectional.only(
                end: tokens.actionEndPadding,
              ),
              child: _actionButton(tokens, action),
            ),
        ],
      ),
    );
  }

  Widget _identity(LinagoraPersonTileStyle tokens) {
    final avatar = this.avatar;
    final trailing = this.trailing;
    final padding = action == null
        ? tokens.padding
        : tokens.padding.copyWith(end: tokens.trailingGap);
    final body = ConstrainedBox(
      constraints: BoxConstraints(minHeight: tokens.minHeight),
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            if (avatar != null) ...[
              SizedBox.square(
                dimension: tokens.avatarSize,
                child: ExcludeSemantics(child: avatar),
              ),
              SizedBox(width: tokens.avatarGap),
            ],
            Expanded(child: _texts(tokens)),
            if (trailing != null) ...[
              SizedBox(width: tokens.trailingGap),
              trailing,
            ],
          ],
        ),
      ),
    );

    // Named semantics wrap the ink well so keyboard focus keeps the label.
    // The ink well covers the padding, so the whole row except the action
    // is the tap target.
    return MergeSemantics(
      child: Semantics(
        button: onTap != null,
        selected: selected,
        onTap: onTap,
        child: onTap == null
            ? body
            : InkWell(
                borderRadius: BorderRadius.circular(tokens.tileRadius),
                hoverColor: tokens.hoverColor,
                onTap: onTap,
                excludeFromSemantics: true,
                child: body,
              ),
      ),
    );
  }

  Widget _texts(LinagoraPersonTileStyle tokens) {
    final subtitle = this.subtitle;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: tokens.nameTextStyle,
        ),
        if (subtitle != null && !subtitle.isVisuallyBlank) ...[
          SizedBox(height: tokens.subtitleGap),
          Text(
            subtitle,
            maxLines: subtitleMaxLines,
            overflow: TextOverflow.ellipsis,
            style: tokens.subtitleTextStyle,
          ),
        ],
      ],
    );
  }

  Widget _actionButton(
    LinagoraPersonTileStyle tokens,
    LinagoraPersonTileAction action,
  ) {
    return IconButton(
      key: action.key,
      tooltip: action.tooltip,
      onPressed: action.onPressed,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.tightFor(
        width: tokens.actionButtonSize,
        height: tokens.actionButtonSize,
      ),
      color: tokens.actionIconColor,
      icon: SvgPicture.asset(
        LinagoraDesignImages.deleteIcon,
        package: LinagoraDesignImages.packageName,
        width: tokens.actionIconSize,
        height: tokens.actionIconSize,
        colorFilter: ColorFilter.mode(
          tokens.actionIconColor,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
