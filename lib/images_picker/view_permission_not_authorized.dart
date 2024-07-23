import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/images_picker/use_camera_widget.dart';

class PermissionNotAuthorizedWidget extends StatelessWidget {
  const PermissionNotAuthorizedWidget({
    required this.onGoToSettings,
    super.key,
    this.backgroundColor,
    this.goToSettingsWidget,
    this.onCameraPressed,
    this.backgroundImageCamera,
    this.cameraWidget,
  });

  final Color? backgroundColor;

  final Widget? goToSettingsWidget;

  final ImageProvider<Object>? backgroundImageCamera;

  final void Function()? onCameraPressed;

  final Widget? cameraWidget;

  final void Function(BuildContext context) onGoToSettings;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 4,
          margin: const EdgeInsets.symmetric(vertical: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: backgroundColor ??
                LinagoraSysColors.material().outline.withOpacity(0.4),
          ),
        ),
        Expanded(
          child: GridView.custom(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            childrenDelegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == 0) {
                  return cameraWidget ??
                      UseCameraWidget(
                        backgroundImage: backgroundImageCamera,
                        onPressed: onCameraPressed,
                      );
                }
                return GestureDetector(
                  onTap: () => onGoToSettings(context),
                  child: goToSettingsWidget ??
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Icon(
                          Icons.photo,
                          color: Theme.of(context).colorScheme.surfaceVariant,
                        ),
                      ),
                );
              },
              childCount: 2,
            ),
          ),
        )
      ],
    );
  }
}
