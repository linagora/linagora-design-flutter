import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/buttons/linagora_button.dart';
import 'package:linagora_design_flutter/empty_state/linagora_empty_card_style.dart';

/// The call to action of a [LinagoraEmptyCard].
@immutable
class LinagoraEmptyCardAction {
  final String label;
  final IconData? icon;

  /// Null disables the button.
  final VoidCallback? onPressed;

  const LinagoraEmptyCardAction({
    required this.label,
    required this.onPressed,
    this.icon,
  });
}

/// A short bordered card for a list that has nothing yet.
///
/// Distinct from [LinagoraEmptyState], which is a tall filled card with a
/// large illustration and no action. Width defaults to the parent (typically
/// the screen); pass [width] to lock a fixed size.
class LinagoraEmptyCard extends StatelessWidget {
  static const Key actionKey = ValueKey('linagora_empty_card_action');

  final Widget? illustration;
  final String title;
  final String? message;
  final LinagoraEmptyCardAction? action;
  final bool bordered;

  /// Null fills the parent width (`double.infinity`).
  final double? width;
  final LinagoraEmptyCardStyle? style;

  const LinagoraEmptyCard({
    super.key,
    required this.title,
    this.illustration,
    this.message,
    this.action,
    this.bordered = true,
    this.width,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = style ?? LinagoraEmptyCardStyle.material();
    final illustration = this.illustration;
    final message = this.message?.trim();
    final action = this.action;

    return Container(
      width: width ?? double.infinity,
      padding: tokens.padding,
      decoration: _decoration(tokens),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (illustration != null) ...[
            Padding(
              padding: tokens.illustrationPadding,
              child: ExcludeSemantics(child: illustration),
            ),
            SizedBox(height: tokens.illustrationGap),
          ],
          Semantics(
            header: true,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: tokens.titleTextStyle,
            ),
          ),
          if (message != null && message.isNotEmpty) ...[
            SizedBox(height: tokens.messageGap),
            Padding(
              padding: tokens.messagePadding,
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: tokens.messageTextStyle,
              ),
            ),
          ],
          if (action != null) ...[
            Padding(
              padding: tokens.actionPadding,
              child: LinagoraButton(
                key: actionKey,
                label: action.label,
                icon: action.icon,
                onPressed: action.onPressed,
                minimumHeight: tokens.actionHeight,
                padding: tokens.actionButtonPadding,
                iconSize: tokens.actionIconSize,
                backgroundColor: tokens.actionBackgroundColor,
                foregroundColor: tokens.actionForegroundColor,
                disabledBackgroundColor: tokens.actionDisabledBackgroundColor,
                disabledForegroundColor: tokens.actionDisabledForegroundColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  BoxDecoration _decoration(LinagoraEmptyCardStyle tokens) {
    return BoxDecoration(
      color: tokens.backgroundColor,
      borderRadius: BorderRadius.circular(tokens.radius),
      border: bordered ? Border.all(color: tokens.borderColor) : null,
    );
  }
}
