import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';
import 'package:linagora_design_flutter/style/linagora_hover_style.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

enum LinagoraReactionItemSize {
  small(24),
  large(40);

  final double avatarSize;

  const LinagoraReactionItemSize(this.avatarSize);
}

/// Who reacted with which emoji.
class LinagoraReactionItem extends StatelessWidget {
  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: LinagoraSpacing.base * 2,
    vertical: LinagoraSpacing.base,
  );
  static const double _gap = LinagoraSpacing.base;
  static const double _emojiSize = LinagoraSpacing.base * 3;

  final String name;
  final String? emoji;

  /// A custom emoji, displayed instead of [emoji].
  final Widget? emojiImage;

  /// Clipped to a circle.
  final Widget avatar;

  final LinagoraReactionItemSize size;
  final VoidCallback? onTap;

  const LinagoraReactionItem({
    super.key,
    required this.name,
    required String this.emoji,
    required this.avatar,
    this.size = LinagoraReactionItemSize.small,
    this.onTap,
  }) : emojiImage = null;

  /// A reaction row showing a custom emoji [image].
  const LinagoraReactionItem.image({
    super.key,
    required this.name,
    required Widget image,
    required this.avatar,
    this.size = LinagoraReactionItemSize.small,
    this.onTap,
  }) : emoji = null,
       emojiImage = image;

  @override
  Widget build(BuildContext context) {
    final onSurface = LinagoraSysColors.material().onSurface;
    final hoverStyle = LinagoraHoverStyle.material();
    final avatarSize = size.avatarSize;
    final textTheme = LinagoraTextTheme.material();
    final emojiStyle = switch (size) {
      LinagoraReactionItemSize.small => textTheme.titleMedium,
      LinagoraReactionItemSize.large => textTheme.headlineMedium,
    };

    return Material(
      color: Colors.transparent,
      borderRadius: hoverStyle.borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: hoverStyle.hoverBorderRadius,
        hoverColor: Colors.transparent,
        highlightColor: hoverStyle.selectedColor,
        splashColor: hoverStyle.selectedColor,
        child: Padding(
          padding: _padding,
          child: Row(
            children: [
              SizedBox.square(
                dimension: avatarSize,
                child: ClipOval(child: avatar),
              ),
              const SizedBox(width: _gap),
              Expanded(
                child: Text(
                  name,
                  style: LinagoraTextThemeExtension.material().bodyMedium2
                      .copyWith(color: onSurface),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: _gap),
              if (emojiImage != null)
                SizedBox.square(dimension: _emojiSize, child: emojiImage)
              else
                SizedBox(
                  width: _emojiSize,
                  child: Text(
                    emoji ?? '',
                    textAlign: TextAlign.center,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    style: emojiStyle?.copyWith(color: onSurface),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
