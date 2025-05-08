import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:linagora_design_flutter/reaction/reaction_picker.dart';

class ReactionsDialogWidget extends StatefulWidget {
  const ReactionsDialogWidget({
    super.key,
    required this.messageWidget,
    this.widgetAlignment = Alignment.centerRight,
    this.menuItemsWidth = 0.45,
    this.filter,
    this.padding,
    this.reactionWidget,
    this.paddingReactionWidget,
    this.contextMenuWidget,
    this.isOwnMessage = true,
    this.reactionsPicker,
    this.onClickEmojiReactionAction,
    this.backgroundColor,
    this.animationDuration,
    this.animationCurve,
    this.height,
    this.emojis,
    this.myEmojiReacted,
    this.borderRadius,
    this.emojiTextStyle,
    this.boxShadow,
    this.moreEmojiWidget,
    this.onPickEmojiReactionAction,
    this.enableMoreEmojiWidget,
    this.emojiSize,
  });

  // The message widget to be displayed in the dialog
  final Widget messageWidget;

  // The widget to be displayed for the reaction
  final Widget? reactionWidget;

  // The context menu widget to be displayed
  final Widget? contextMenuWidget;

  // The alignment of the widget
  final Alignment widgetAlignment;

  // The width of the menu items
  final double menuItemsWidth;

  // The filter to be applied to the background
  final ImageFilter? filter;

  // The padding to be applied to the dialog
  final EdgeInsets? padding;

  // The padding to be applied to the reaction widget
  final EdgeInsets? paddingReactionWidget;

  // The message widget to be displayed
  final bool isOwnMessage;

  // The reactions picker widget
  final ReactionsPicker? reactionsPicker;

  final OnClickEmojiReactionAction? onClickEmojiReactionAction;

  final Color? backgroundColor;

  final Duration? animationDuration;

  final Curve? animationCurve;

  final double? height;

  final List<String>? emojis;

  final String? myEmojiReacted;

  final double? borderRadius;

  final TextStyle? emojiTextStyle;

  final List<BoxShadow>? boxShadow;

  final Widget? moreEmojiWidget;

  final OnPickEmojiReactionAction? onPickEmojiReactionAction;

  final bool? enableMoreEmojiWidget;

  final double? emojiSize;

  @override
  State<ReactionsDialogWidget> createState() => _ReactionsDialogWidgetState();
}

class _ReactionsDialogWidgetState extends State<ReactionsDialogWidget> {
  final KeyboardVisibilityController keyboardVisibilityController =
      KeyboardVisibilityController();

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: widget.filter ??
          ImageFilter.blur(
            sigmaX: 9,
            sigmaY: 9,
          ),
      child: Center(
        child: Padding(
          padding:
              widget.padding ?? const EdgeInsets.only(right: 20.0, left: 20.0),
          child: KeyboardVisibilityBuilder(
            builder: (context, isKeyboardVisible) {
              return Column(
                mainAxisSize:
                    isKeyboardVisible ? MainAxisSize.max : MainAxisSize.min,
                crossAxisAlignment: widget.isOwnMessage
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: widget.paddingReactionWidget ??
                        const EdgeInsets.only(bottom: 8.0),
                    child: Align(
                      alignment: widget.widgetAlignment,
                      child: Material(
                        color: Colors.transparent,
                        child: widget.reactionWidget ??
                            ReactionsPicker(
                              onClickEmojiReactionAction:
                                  widget.onClickEmojiReactionAction,
                              backgroundColor: widget.backgroundColor,
                              animationDuration: widget.animationDuration,
                              animationCurve: widget.animationCurve,
                              height: widget.height,
                              emojis: widget.emojis,
                              myEmojiReacted: widget.myEmojiReacted,
                              borderRadius: widget.borderRadius ?? 32,
                              emojiTextStyle: widget.emojiTextStyle,
                              boxShadow: widget.boxShadow,
                              moreEmojiWidget: widget.moreEmojiWidget,
                              enableMoreEmojiWidget:
                                  widget.enableMoreEmojiWidget,
                              onPickEmojiReactionAction:
                                  widget.onPickEmojiReactionAction,
                              emojiSize: widget.emojiSize,
                            ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.sizeOf(context).height * 0.5,
                      ),
                      child: widget.messageWidget,
                    ),
                  ),
                  if (widget.contextMenuWidget != null)
                    Align(
                      alignment: widget.widgetAlignment,
                      child: widget.contextMenuWidget!,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
