import 'dart:ui';
import 'package:flutter/material.dart';

class ReactionsDialogWidget extends StatefulWidget {
  const ReactionsDialogWidget({
    super.key,
    required this.id,
    required this.messageWidget,
    this.widgetAlignment = Alignment.centerRight,
    this.menuItemsWidth = 0.45,
    this.filter,
    this.padding,
    required this.reactionWidget,
    this.paddingReactionWidget,
    this.contextMenuWidget,
    this.isOwnMessage = true,
  });

  // Id for the hero widget
  final String id;

  // The message widget to be displayed in the dialog
  final Widget messageWidget;

  // The widget to be displayed for the reaction
  final Widget reactionWidget;

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

  @override
  State<ReactionsDialogWidget> createState() => _ReactionsDialogWidgetState();
}

class _ReactionsDialogWidgetState extends State<ReactionsDialogWidget> {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: widget.isOwnMessage
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: widget.paddingReactionWidget ??
                    const EdgeInsets.only(bottom: 8.0),
                child: Align(
                  alignment: widget.widgetAlignment,
                  child: widget.reactionWidget,
                ),
              ),
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * 0.5,
                  ),
                  child: Hero(
                    tag: widget.id,
                    child: widget.messageWidget,
                  ),
                ),
              ),
              if (widget.contextMenuWidget != null)
                Align(
                  alignment: widget.widgetAlignment,
                  child: widget.contextMenuWidget!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
