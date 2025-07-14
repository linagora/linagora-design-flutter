import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/images/linagora_design_images.dart';
import 'package:vector_graphics/vector_graphics.dart';

typedef OnConfirmButtonAction = void Function();
typedef OnCancelButtonAction = void Function();
typedef OnCloseButtonAction = void Function();

class ConfirmationDialogBuilder extends StatelessWidget {
  final String title;
  final String textContent;
  final String confirmText;
  final String cancelText;
  final Widget? additionalWidgetContent;
  final Color? cancelBackgroundButtonColor;
  final Color? confirmBackgroundButtonColor;
  final Color? cancelLabelButtonColor;
  final Color? confirmLabelButtonColor;
  final TextStyle? styleTextCancelButton;
  final TextStyle? styleTextConfirmButton;
  final EdgeInsets? outsideDialogPadding;
  final EdgeInsetsGeometry? margin;
  final double maxWidth;
  final Alignment? alignment;
  final bool showAsBottomSheet;
  final List<TextSpan>? listTextSpan;
  final bool isArrangeActionButtonsVertical;
  final bool useIconAsBasicLogo;
  final bool isScrollContentEnabled;
  final OnConfirmButtonAction? onConfirmButtonAction;
  final OnCancelButtonAction? onCancelButtonAction;
  final OnCloseButtonAction? onCloseButtonAction;

  const ConfirmationDialogBuilder({
    super.key,
    this.title = '',
    this.textContent = '',
    this.confirmText = '',
    this.cancelText = '',
    this.additionalWidgetContent,
    this.cancelBackgroundButtonColor,
    this.confirmBackgroundButtonColor,
    this.cancelLabelButtonColor,
    this.confirmLabelButtonColor,
    this.styleTextCancelButton,
    this.styleTextConfirmButton,
    this.outsideDialogPadding,
    this.margin,
    this.maxWidth = double.infinity,
    this.alignment,
    this.showAsBottomSheet = false,
    this.listTextSpan,
    this.isArrangeActionButtonsVertical = false,
    this.useIconAsBasicLogo = false,
    this.isScrollContentEnabled = false,
    this.onConfirmButtonAction,
    this.onCancelButtonAction,
    this.onCloseButtonAction,
  });

  @override
  Widget build(BuildContext context) {
    return showAsBottomSheet
        ? _BodyContent(
            title: title,
            textContent: textContent,
            confirmText: confirmText,
            cancelText: cancelText,
            additionalWidgetContent: additionalWidgetContent,
            cancelBackgroundButtonColor: cancelBackgroundButtonColor,
            confirmBackgroundButtonColor: confirmBackgroundButtonColor,
            cancelLabelButtonColor: cancelLabelButtonColor,
            confirmLabelButtonColor: confirmLabelButtonColor,
            margin: margin,
            maxWidth: maxWidth,
            listTextSpan: listTextSpan,
            isArrangeActionButtonsVertical: isArrangeActionButtonsVertical,
            useIconAsBasicLogo: useIconAsBasicLogo,
            isScrollContentEnabled: isScrollContentEnabled,
            onConfirmButtonAction: onConfirmButtonAction,
            onCancelButtonAction: onCancelButtonAction,
            onCloseButtonAction: onCloseButtonAction,
          )
        : Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            insetPadding: outsideDialogPadding,
            alignment: alignment ?? Alignment.center,
            backgroundColor: Colors.white,
            child: _BodyContent(
              title: title,
              textContent: textContent,
              confirmText: confirmText,
              cancelText: cancelText,
              additionalWidgetContent: additionalWidgetContent,
              cancelBackgroundButtonColor: cancelBackgroundButtonColor,
              confirmBackgroundButtonColor: confirmBackgroundButtonColor,
              cancelLabelButtonColor: cancelLabelButtonColor,
              confirmLabelButtonColor: confirmLabelButtonColor,
              margin: margin,
              maxWidth: maxWidth,
              listTextSpan: listTextSpan,
              isArrangeActionButtonsVertical: isArrangeActionButtonsVertical,
              useIconAsBasicLogo: useIconAsBasicLogo,
              isScrollContentEnabled: isScrollContentEnabled,
              onConfirmButtonAction: onConfirmButtonAction,
              onCancelButtonAction: onCancelButtonAction,
              onCloseButtonAction: onCloseButtonAction,
            ),
          );
  }
}

class _BodyContent extends StatelessWidget {
  final String title;
  final String textContent;
  final String confirmText;
  final String cancelText;
  final Widget? additionalWidgetContent;
  final Color? cancelBackgroundButtonColor;
  final Color? confirmBackgroundButtonColor;
  final Color? cancelLabelButtonColor;
  final Color? confirmLabelButtonColor;
  final EdgeInsetsGeometry? margin;
  final double maxWidth;
  final List<TextSpan>? listTextSpan;
  final bool isArrangeActionButtonsVertical;
  final bool useIconAsBasicLogo;
  final bool isScrollContentEnabled;
  final OnConfirmButtonAction? onConfirmButtonAction;
  final OnCancelButtonAction? onCancelButtonAction;
  final OnCloseButtonAction? onCloseButtonAction;

  const _BodyContent({
    required this.title,
    required this.textContent,
    required this.confirmText,
    required this.cancelText,
    required this.maxWidth,
    required this.isArrangeActionButtonsVertical,
    required this.useIconAsBasicLogo,
    this.isScrollContentEnabled = false,
    this.additionalWidgetContent,
    this.cancelBackgroundButtonColor,
    this.confirmBackgroundButtonColor,
    this.cancelLabelButtonColor,
    this.confirmLabelButtonColor,
    this.margin,
    this.listTextSpan,
    this.onConfirmButtonAction,
    this.onCancelButtonAction,
    this.onCloseButtonAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final child = Container(
      width: 421,
      constraints: BoxConstraints(maxWidth: maxWidth),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      margin: margin,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 32,
              end: 32,
              top: 24,
              bottom: 32,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTitle(textTheme),
                _buildContent(textTheme),
                _buildAdditionalContent(),
                _buildActionButtons(context),
              ].where((widget) => widget != const SizedBox.shrink()).toList(),
            ),
          ),
          if (_showCloseButton()) _buildCloseButton(),
        ],
      ),
    );

    if (isScrollContentEnabled) {
      return SingleChildScrollView(child: child);
    } else {
      return child;
    }
  }

  bool _showCloseButton() => onCloseButtonAction != null;

  Widget _buildCloseButton() {
    if (_showCloseButton()) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          onPressed: onCloseButtonAction,
          icon: const SvgPicture(
            AssetBytesLoader(LinagoraDesignImages.svgBytesClose),
          ),
          padding: const EdgeInsets.all(9),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildTitle(TextTheme textTheme) {
    return title.trim().isNotEmpty
        ? Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF424244),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildContent(TextTheme textTheme) {
    if (textContent.trim().isNotEmpty) {
      return Padding(
        padding: const EdgeInsetsDirectional.only(top: 32),
        child: Text(
          textContent,
          style: textTheme.bodyMedium,
        ),
      );
    } else if (listTextSpan != null) {
      return Padding(
        padding: const EdgeInsetsDirectional.only(top: 32),
        child: RichText(
          text: TextSpan(
            style: textTheme.bodyMedium,
            children: listTextSpan,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildAdditionalContent() {
    return additionalWidgetContent != null
        ? Padding(
            padding: const EdgeInsetsDirectional.only(top: 16),
            child: additionalWidgetContent!,
          )
        : const SizedBox.shrink();
  }

  Widget _buildActionButtons(BuildContext context) {
    if (isArrangeActionButtonsVertical ||
        cancelText.isEmpty ||
        confirmText.isEmpty) {
      return Padding(
        padding: const EdgeInsetsDirectional.only(top: 44),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (cancelText.isNotEmpty)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: _ConfirmDialogButton(
                  label: cancelText,
                  backgroundColor: cancelBackgroundButtonColor,
                  textColor: cancelLabelButtonColor,
                  onTapAction: onCancelButtonAction,
                ),
              ),
            if (confirmText.isNotEmpty && cancelText.isNotEmpty)
              const SizedBox(height: 8),
            if (confirmText.isNotEmpty)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: _ConfirmDialogButton(
                  label: confirmText,
                  backgroundColor: confirmBackgroundButtonColor ??
                      LinagoraSysColors.material().primary,
                  textColor: confirmLabelButtonColor ?? Colors.white,
                  onTapAction: onConfirmButtonAction,
                ),
              ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsetsDirectional.only(
          top: 44,
          start: 12,
          end: 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                constraints: const BoxConstraints(minWidth: 67),
                height: 48,
                child: _ConfirmDialogButton(
                  label: cancelText,
                  backgroundColor: cancelBackgroundButtonColor,
                  textColor: cancelLabelButtonColor,
                  onTapAction: onCancelButtonAction,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Container(
                constraints: const BoxConstraints(minWidth: 135),
                height: 48,
                child: _ConfirmDialogButton(
                  label: confirmText,
                  backgroundColor: confirmBackgroundButtonColor ??
                      LinagoraSysColors.material().primary,
                  textColor: confirmLabelButtonColor ?? Colors.white,
                  onTapAction: onConfirmButtonAction,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

class _ConfirmDialogButton extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTapAction;

  const _ConfirmDialogButton({
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.onTapAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const outlineBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(100)),
    );

    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        overlayColor: theme.colorScheme.outline.withOpacity(0.08),
        shape: outlineBorder,
        padding: const EdgeInsets.symmetric(horizontal: 10),
      ),
      onPressed: onTapAction,
      child: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(color: textColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
