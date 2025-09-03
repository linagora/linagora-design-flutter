import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_key_colors.dart';
import 'package:linagora_design_flutter/colors/linagora_ref_colors.dart';

class LinagoraDialogOption<T> extends Equatable {
  const LinagoraDialogOption({
    required this.name,
    required this.value,
    this.trailingIcon,
  });

  final String name;
  final T value;
  final Widget? trailingIcon;

  @override
  List<Object?> get props => [name, value, trailingIcon];
}

class OptionsDialog<T> extends StatelessWidget {
  const OptionsDialog({
    super.key,
    required this.title,
    required this.availableOptions,
    required this.onSelected,
    this.description,
    this.isBottomSheet = false,
  });

  final String title;
  final String? description;
  final List<LinagoraDialogOption<T>> availableOptions;
  final void Function(LinagoraDialogOption<T> selected) onSelected;
  final bool isBottomSheet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    Widget? descriptionWidget;

    final closeButton = Padding(
      padding: const EdgeInsets.all(4),
      child: IconButton(
        onPressed: Navigator.of(context).pop,
        icon: Icon(
          Icons.close,
          color: LinagoraRefColors.material().neutral[10],
        ),
      ),
    );

    final titleWidget = Text(
      title,
      textAlign: TextAlign.center,
      style: isBottomSheet
          ? textTheme.bodyLarge?.copyWith(
              fontSize: 17,
              height: 24 / 17,
              fontWeight: FontWeight.w600,
              color: LinagoraRefColors.material().neutral[10],
            )
          : textTheme.headlineSmall?.copyWith(
              fontSize: 24,
              height: 32 / 24,
              letterSpacing: 0,
              color: LinagoraRefColors.material().neutral[10],
            ),
    );

    final items = SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: availableOptions.map(
          (option) {
            return Column(
              children: [
                if (option != availableOptions.first)
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: 1,
                          color: LinagoraKeyColors.material()
                              .primary
                              .withValues(alpha: 0.16),
                        ),
                      ),
                    ),
                  ),
                Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () => onSelected(option),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.symmetric(
                                vertical: 2,
                              ),
                              child: Text(
                                option.name,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  height: 20 / 14,
                                  letterSpacing: 0.25,
                                  color:
                                      LinagoraRefColors.material().neutral[10],
                                ),
                              ),
                            ),
                          ),
                          if (option.trailingIcon != null)
                            Container(
                              width: 24,
                              height: 24,
                              margin:
                                  const EdgeInsetsDirectional.only(start: 8),
                              child: option.trailingIcon,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ).toList(),
      ),
    );

    if (description != null) {
      final descriptionTextStyle = isBottomSheet
          ? textTheme.bodyLarge?.copyWith(
              fontSize: 17,
              height: 24 / 17,
              color: LinagoraRefColors.material().neutral[10],
            )
          : textTheme.titleSmall?.copyWith(
              fontSize: 14,
              height: 20 / 14,
              color: LinagoraRefColors.material().neutral[10],
            );

      descriptionWidget = Padding(
        padding: const EdgeInsetsDirectional.all(8),
        child: Text(
          description!,
          style: descriptionTextStyle,
        ),
      );
    }

    if (isBottomSheet) {
      return Dialog(
        backgroundColor: LinagoraRefColors.material().neutral[99],
        insetPadding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const SizedBox(width: 48),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(top: 8),
                      child: titleWidget,
                    ),
                  ),
                  closeButton,
                ],
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (descriptionWidget != null)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(bottom: 8),
                          child: descriptionWidget,
                        ),
                      Flexible(child: items),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Dialog(
      child: Container(
        padding: const EdgeInsetsDirectional.all(16),
        decoration: BoxDecoration(
          color: LinagoraRefColors.material().neutral[100],
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        constraints: const BoxConstraints(maxWidth: 448),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const SizedBox(width: 48),
                Expanded(child: titleWidget),
                closeButton,
              ],
            ),
            if (descriptionWidget != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 8),
                child: descriptionWidget,
              ),
            Flexible(child: items),
          ],
        ),
      ),
    );
  }
}
