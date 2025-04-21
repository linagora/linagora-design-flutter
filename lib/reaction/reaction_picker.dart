import 'package:flutter/material.dart';

import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:linagora_design_flutter/reaction/app_emojis.dart';

typedef OnClickEmojiReactionAction = void Function(
  String emoji,
);

class ReactionsPicker extends StatelessWidget {
  final OnClickEmojiReactionAction? onClickEmojiReactionAction;
  final Color? backgroundColor;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final double? height;
  final List<String>? emojis;
  final String? myEmojiReacted;
  final double borderRadius;
  final TextStyle? emojiTextStyle;
  final List<BoxShadow>? boxShadow;

  const ReactionsPicker({
    super.key,
    this.onClickEmojiReactionAction,
    this.backgroundColor,
    this.animationDuration,
    this.animationCurve,
    this.height,
    this.emojis = AppEmojis.emojisDefault,
    this.myEmojiReacted,
    this.borderRadius = 32,
    this.emojiTextStyle,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: animationDuration ?? const Duration(milliseconds: 250),
      curve: animationCurve ?? Curves.easeInOut,
      height: height ?? 56,
      child: Material(
        color: Colors.transparent,
        child: Builder(
          builder: (context) {
            final emojis = List<String>.from(AppEmojis.emojisDefault);
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: backgroundColor ??
                        LinagoraSysColors.material().onPrimary,
                    borderRadius: BorderRadius.all(
                      Radius.circular(borderRadius),
                    ),
                    boxShadow: boxShadow ??
                        const [
                          BoxShadow(
                            color: Color(0x26000000),
                            offset: Offset(0, 4),
                            blurRadius: 8,
                            spreadRadius: 3,
                          ),
                          BoxShadow(
                            color: Color(0x4D000000),
                            offset: Offset(0, 1),
                            blurRadius: 3,
                            spreadRadius: 0,
                          ),
                        ],
                  ),
                  child: Row(
                    children: emojis.map((emoji) {
                      return InkWell(
                        onTap: () async {
                          Navigator.of(context).pop();
                          onClickEmojiReactionAction?.call(emoji);
                        },
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        child: Container(
                          height: height ?? 56,
                          width: height ?? 56,
                          alignment: Alignment.center,
                          decoration: myEmojiReacted != null
                              ? BoxDecoration(
                                  color: LinagoraSysColors.material()
                                      .onSurface
                                      .withOpacity(0.1),
                                  shape: BoxShape.circle,
                                )
                              : null,
                          margin: const EdgeInsets.symmetric(
                            vertical: 4,
                          ),
                          child: Text(
                            emoji,
                            style:
                                emojiTextStyle ?? const TextStyle(fontSize: 30),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                /// TODO: Implement the emoji picker later
                // InkWell(
                //   borderRadius: BorderRadius.circular(8),
                //   child: Container(
                //     margin: const EdgeInsets.symmetric(horizontal: 8),
                //     width: 56,
                //     height: 56,
                //     decoration: BoxDecoration(
                //       color: LinagoraSysColors.material().onPrimary,
                //       shape: BoxShape.circle,
                //     ),
                //     child: const Icon(Icons.add_outlined),
                //   ),
                //   onTap: () => onPickEmojiReaction?.call(),
                // ),
              ],
            );
          },
        ),
      ),
    );
  }
}
