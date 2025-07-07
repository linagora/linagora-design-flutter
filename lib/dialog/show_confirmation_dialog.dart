import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linagora_design_flutter/colors/linagora_ref_colors.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/dialog/properties/dialog_button_properties.dart';
import 'package:linagora_design_flutter/images/linagora_design_images.dart';
import 'package:vector_graphics/vector_graphics.dart';

Future<T?> showConfirmationDialog<T>(
  BuildContext context, {
  required String title,
  required String? description,
  DialogButtonProperties confirmProperties = const DialogButtonProperties(
    label: 'Confirm',
    labelColor: null,
    backgroundColor: null,
    onPressed: null,
  ),
  DialogButtonProperties cancelProperties = const DialogButtonProperties(
    label: 'Cancel',
    labelColor: null,
    backgroundColor: null,
    onPressed: null,
  ),
}) async {
  return await showDialog<T?>(
    context: context,
    builder: (context) {
      return ConfirmationDialog(
        title: title,
        description: description,
        confirmProperties: confirmProperties,
        cancelProperties: cancelProperties,
      );
    },
  );
}

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.description,
    required this.confirmProperties,
    required this.cancelProperties,
  });

  final String title;
  final String? description;
  final DialogButtonProperties confirmProperties;
  final DialogButtonProperties cancelProperties;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 421),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: LinagoraRefColors.material().primary[100],
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const SvgPicture(
                    AssetBytesLoader(LinagoraDesignImages.svgBytesClose),
                  ),
                  padding: const EdgeInsets.all(9),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      fontSize: 24,
                      height: 32 / 24,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (description != null) ...[
                    Text(
                      description!,
                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        height: 24 / 16,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.15,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 22,
                            horizontal: 14,
                          ),
                          backgroundColor: cancelProperties.backgroundColor ??
                              LinagoraRefColors.material().primary[100],
                        ),
                        onPressed: cancelProperties.onPressed,
                        child: Text(
                          cancelProperties.label,
                          style: textTheme.labelLarge?.copyWith(
                            fontSize: 14,
                            height: 20 / 14,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.1,
                            color: cancelProperties.labelColor ??
                                LinagoraSysColors.material().primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 22,
                            horizontal: 26,
                          ),
                          backgroundColor: confirmProperties.backgroundColor ??
                              LinagoraRefColors.material().primary,
                        ),
                        onPressed: confirmProperties.onPressed,
                        child: Text(
                          confirmProperties.label,
                          style: textTheme.labelLarge?.copyWith(
                            fontSize: 14,
                            height: 20 / 14,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.1,
                            color: confirmProperties.labelColor ??
                                LinagoraRefColors.material().primary[100],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
