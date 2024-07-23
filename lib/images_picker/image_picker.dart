import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/images_picker/image_item_widget.dart';
import 'package:linagora_design_flutter/images_picker/image_picker_grid_with_counter.dart';
import 'package:linagora_design_flutter/images_picker/use_camera_widget.dart';
import 'package:linagora_design_flutter/images_picker/view_permission_not_authorized.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:photo_manager/photo_manager.dart';

import 'images_picker_grid.dart';

class ImagePicker {
  static Future<T?> showImagesGridBottomSheet<T>({
    required BuildContext context,
    required ImagePickerGridController controller,
    required PermissionStatus permissionStatus,
    required void Function(BuildContext context) onGoToSettings,
    double? heightOfBottomSheet,
    Widget? goToSettingsWidget,
    CounterImageBuilder? counterImageBuilder,
    Widget? cameraWidget,
    Widget? bottomWidget,
    ImageProvider<Object>? backgroundImageCamera,
    void Function()? onCameraPressed,
    Color? backgroundColor,
    Color? assetBackgroundColor,
    Widget? selectMoreImageWidget,
    double initialChildSize = 0.4,
    double minChildSize = 0.4,
    double maxChildSize = 0.9,
    bool isScrollControlled = true,
    bool expandDraggableScrollableSheet = false,
    Widget? expandedWidget,
    AssetItemBuilder? assetItemBuilder,
    EdgeInsets? gridPadding,
    RequestType type = RequestType.common,
  }) async {
    AssetPathEntity? assetPath;

    final permission = permissionStatus == PermissionStatus.granted ||
        permissionStatus == PermissionStatus.limited;
    if (permission) {
      final assetsPath = await getAllAssetPaths(
        hasAll: true,
        onlyAll: false,
        type: type,
      );
      if (assetsPath.isNotEmpty) {
        assetPath = assetsPath.first;
      }
    }

    Widget buildBodyBottomSheet(
        AssetPathEntity? assetPathEntity, ScrollController scrollController) {
      if (permissionStatus == PermissionStatus.permanentlyDenied ||
          permissionStatus == PermissionStatus.denied) {
        return PermissionNotAuthorizedWidget(
          backgroundColor: backgroundColor,
          backgroundImageCamera: backgroundImageCamera,
          goToSettingsWidget: goToSettingsWidget,
          cameraWidget: cameraWidget,
          onCameraPressed: onCameraPressed,
          onGoToSettings: onGoToSettings,
        );
      } else {
        if (assetPathEntity != null) {
          return counterImageBuilder != null
              ? ImagePickerGridWithCounter(
                  assetPath: assetPathEntity,
                  counterBuilder: counterImageBuilder,
                  controller: controller,
                  assetBackgroundColor: assetBackgroundColor,
                  backgroundImageCamera: backgroundImageCamera,
                  onCameraPressed: onCameraPressed,
                  cameraWidget: cameraWidget,
                  selectMoreImageWidget: selectMoreImageWidget,
                  isLimitSelectImage:
                      permissionStatus == PermissionStatus.limited,
                  scrollController: scrollController,
                  assetItemBuilder: assetItemBuilder,
                  gridPadding: gridPadding,
                )
              : ImagesPickerGrid(
                  assetPath: assetPathEntity,
                  controller: controller,
                  scrollController: scrollController,
                  assetBackgroundColor: assetBackgroundColor,
                  backgroundImage: backgroundImageCamera,
                  selectMoreImageWidget: selectMoreImageWidget,
                  isLimitSelectImage:
                      permissionStatus == PermissionStatus.limited,
                  cameraWidget: cameraWidget,
                  onCameraPressed: onCameraPressed,
                  assetItemBuilder: assetItemBuilder,
                  gridPadding: gridPadding,
                );
        } else {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(left: 4.0, top: 12.0),
                  width: 100,
                  height: 100,
                  child: cameraWidget ??
                      UseCameraWidget(
                          backgroundImage: backgroundImageCamera,
                          onPressed: onCameraPressed),
                ),
              )
            ],
          );
        }
      }
    }

    // ignore: use_build_context_synchronously
    return showModalBottomSheet(
      context: context,
      backgroundColor:
          backgroundColor ?? Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: MediaQuery.viewInsetsOf(context),
        child: Stack(
          children: [
            SizedBox(
                height:
                    heightOfBottomSheet ?? _defaultBottomSheetHeight(context),
                child: Column(
                  children: [
                    Expanded(
                        child: buildBodyBottomSheet(
                            assetPath, ScrollController())),
                    expandedWidget ?? const SizedBox.shrink(),
                  ],
                )),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: bottomWidget ?? const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  static double _defaultBottomSheetHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height * 0.9 -
        MediaQuery.viewInsetsOf(context).bottom;
  }

  static Future<List<AssetPathEntity>> getAllAssetPaths({
    bool hasAll = true,
    bool onlyAll = false,
    RequestType type = RequestType.common,
    PMFilter? filterOption,
  }) async {
    return await PhotoManager.getAssetPathList(
      hasAll: hasAll,
      onlyAll: onlyAll,
      type: type,
      filterOption: filterOption,
    );
  }
}
