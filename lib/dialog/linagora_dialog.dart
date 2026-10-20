import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/buttons/linagora_button.dart';
import 'package:linagora_design_flutter/buttons/linagora_button_variant.dart';
import 'package:linagora_design_flutter/dialog/linagora_dialog_style.dart';

/// One footer button of a [LinagoraDialog].
@immutable
class LinagoraDialogAction {
  final String label;

  /// Null disables the button.
  final VoidCallback? onPressed;

  /// Paints a primary action in the error colour, for a destructive or
  /// irreversible confirmation.
  final bool destructive;

  const LinagoraDialogAction({
    required this.label,
    required this.onPressed,
    this.destructive = false,
  });
}

/// The design library's `🔷 dialog`: a header with an optional back button,
/// the title and an optional close button; a message with optional extra
/// content; and a footer with at most one secondary and one primary action,
/// end-aligned.
///
/// Route-agnostic: put it inside `showDialog`, `Get.dialog` or an overlay,
/// with [LinagoraDialogStyle.barrierColor] as the scrim. The content scrolls
/// when the dialog outgrows the screen, while the header and footer stay put.
class LinagoraDialog extends StatelessWidget {
  static const Key backButtonKey = ValueKey('linagora_dialog_back');
  static const Key closeButtonKey = ValueKey('linagora_dialog_close');
  static const Key primaryActionKey =
      ValueKey('linagora_dialog_primary_action');
  static const Key secondaryActionKey =
      ValueKey('linagora_dialog_secondary_action');

  final String title;
  final String? message;

  /// Shown under [message], e.g. a summary of the item the dialog is about.
  final Widget? content;
  final LinagoraDialogAction? primaryAction;
  final LinagoraDialogAction? secondaryAction;

  /// Header back button. Null hides it.
  final VoidCallback? onBack;

  /// Also the back button's screen-reader name. Defaults to
  /// [MaterialLocalizations.backButtonTooltip].
  final String? backTooltip;

  /// Header close button. Null hides it.
  final VoidCallback? onClose;

  /// Also the close button's screen-reader name. Defaults to
  /// [MaterialLocalizations.closeButtonTooltip].
  final String? closeTooltip;

  /// Separates the footer from the content with a divider, for content long
  /// enough to scroll under it (`fixed actions=true`).
  final bool fixedActions;

  /// Space kept around the dialog on small screens.
  final EdgeInsetsGeometry insetPadding;

  /// Defaults to the Figma tokens.
  final LinagoraDialogStyle? style;

  const LinagoraDialog({
    super.key,
    required this.title,
    this.message,
    this.content,
    this.primaryAction,
    this.secondaryAction,
    this.onBack,
    this.backTooltip,
    this.onClose,
    this.closeTooltip,
    this.fixedActions = false,
    this.insetPadding =
        const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 24),
    this.style,
  });

  bool get _hasActions => primaryAction != null || secondaryAction != null;

  @override
  Widget build(BuildContext context) {
    final tokens = style ?? LinagoraDialogStyle.material();
    final radius = BorderRadius.circular(tokens.surfaceRadius);
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      label: title,
      explicitChildNodes: true,
      child: Center(
        child: Padding(
          padding: insetPadding,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: tokens.maxWidth),
            child: Material(
              type: MaterialType.transparency,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: tokens.surfaceColor,
                  borderRadius: radius,
                  boxShadow: tokens.surfaceShadow,
                ),
                child: ClipRRect(
                  borderRadius: radius,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(context, tokens),
                      Flexible(child: _buildContent(tokens)),
                      if (_hasActions && fixedActions)
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: tokens.dividerColor,
                        ),
                      if (_hasActions) _buildFooter(tokens),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, LinagoraDialogStyle tokens) {
    final localizations = MaterialLocalizations.of(context);
    final onBack = this.onBack;
    final onClose = this.onClose;
    return Padding(
      padding: tokens.headerPadding,
      child: ConstrainedBox(
        // Keeps the header height when neither icon button is shown.
        constraints: BoxConstraints(minHeight: tokens.iconButtonSize),
        child: Row(
          children: [
            if (onBack != null) ...[
              _LinagoraDialogIconButton(
                buttonKey: backButtonKey,
                icon: Icons.arrow_back,
                tooltip: backTooltip ?? localizations.backButtonTooltip,
                onPressed: onBack,
                tokens: tokens,
              ),
              SizedBox(width: tokens.headerGap),
            ],
            Expanded(
              child: Semantics(
                header: true,
                child: Text(title, style: tokens.titleTextStyle),
              ),
            ),
            if (onClose != null) ...[
              SizedBox(width: tokens.headerGap),
              _LinagoraDialogIconButton(
                buttonKey: closeButtonKey,
                icon: Icons.close,
                tooltip: closeTooltip ?? localizations.closeButtonTooltip,
                onPressed: onClose,
                tokens: tokens,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContent(LinagoraDialogStyle tokens) {
    final message = this.message;
    final content = this.content;
    return SingleChildScrollView(
      padding: tokens.contentPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (message != null) Text(message, style: tokens.messageTextStyle),
          if (message != null && content != null)
            SizedBox(height: tokens.contentGap),
          if (content != null) content,
        ],
      ),
    );
  }

  Widget _buildFooter(LinagoraDialogStyle tokens) {
    final primaryAction = this.primaryAction;
    final secondaryAction = this.secondaryAction;
    return Padding(
      padding: fixedActions ? tokens.fixedFooterPadding : tokens.footerPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (secondaryAction != null)
            Flexible(
              child: _buildSecondaryAction(tokens, secondaryAction),
            ),
          if (secondaryAction != null && primaryAction != null)
            SizedBox(width: tokens.actionGap),
          if (primaryAction != null)
            Flexible(child: _buildPrimaryAction(tokens, primaryAction)),
        ],
      ),
    );
  }

  Widget _buildPrimaryAction(
    LinagoraDialogStyle tokens,
    LinagoraDialogAction action,
  ) {
    final color = action.destructive
        ? tokens.destructiveActionColor
        : tokens.primaryActionColor;
    return LinagoraButton(
      buttonKey: primaryActionKey,
      label: action.label,
      onPressed: action.onPressed,
      variant: LinagoraButtonVariant.filled,
      height: tokens.actionHeight,
      padding: tokens.actionPadding,
      textStyle: tokens.actionTextStyle,
      backgroundColor: color,
      foregroundColor: tokens.onActionColor,
      disabledBackgroundColor: LinagoraButton.disabledContainerColor,
      disabledForegroundColor: LinagoraButton.disabledContentColor,
      // The destructive colour has no hover shade in the design, so it keeps
      // the state layer instead.
      hoverBackgroundColor:
          action.destructive ? null : tokens.primaryActionHoverColor,
    );
  }

  Widget _buildSecondaryAction(
    LinagoraDialogStyle tokens,
    LinagoraDialogAction action,
  ) =>
      LinagoraButton(
        buttonKey: secondaryActionKey,
        label: action.label,
        onPressed: action.onPressed,
        variant: LinagoraButtonVariant.outlined,
        height: tokens.actionHeight,
        padding: tokens.actionPadding,
        textStyle: tokens.actionTextStyle,
        foregroundColor: tokens.primaryActionColor,
        disabledForegroundColor: LinagoraButton.disabledContentColor,
        hoverOverlayColor: LinagoraButton.primaryHoverOverlayColor,
        style: ButtonStyle(
          side: WidgetStateProperty.resolveWith(
            (states) => BorderSide(
              color: states.contains(WidgetState.disabled)
                  ? LinagoraButton.disabledContentColor
                  : tokens.primaryActionColor,
            ),
          ),
        ),
      );
}

class _LinagoraDialogIconButton extends StatelessWidget {
  final Key buttonKey;
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final LinagoraDialogStyle tokens;

  const _LinagoraDialogIconButton({
    required this.buttonKey,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: tokens.iconButtonSize,
        child: IconButton(
          key: buttonKey,
          tooltip: tooltip,
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          iconSize: tokens.iconSize,
          color: tokens.iconColor,
          icon: Icon(icon),
        ),
      );
}
