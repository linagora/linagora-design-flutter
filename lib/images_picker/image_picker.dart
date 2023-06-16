import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/images_picker/image_picker_grid_with_counter.dart';
import 'package:linagora_design_flutter/images_picker/view_permission_not_authorized.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:photo_manager/photo_manager.dart';

import 'images_picker_grid.dart';

class ImagePicker {
  static Future<T?> showImagesGridBottomSheet<T>({
    required BuildContext context,
    required ImagePickerGridController controller,
    required PermissionStatus permissionStatus,
    double? heightOfBottomSheet,
    Widget? goToSettingsWidget,
    CounterImageBuilder? counterImageBuilder,
    Widget? cameraWidget,
    Widget? bottomWidget,
    ImageProvider<Object>? backgroundImageCamera,
    Color? backgroundColor,
    Color? assetBackgroundColor,
    Widget? selectMoreImageWidget,
    double initialChildSize = 0.4,
    double minChildSize = 0.4,
    double maxChildSize = 0.9,
    bool isScrollControlled = true,
    bool expandDraggableScrollableSheet = false
  }) async {
    AssetPathEntity? assetPath;

    final permission = permissionStatus == PermissionStatus.granted || permissionStatus == PermissionStatus.limited;
    if (permission) {
      final assetsPath = await getAllAssetPaths(hasAll: true, onlyAll: false);
      if (assetsPath.isNotEmpty) {
        assetPath = assetsPath.first;
      }
    }

    Widget buildBodyBottomSheet(AssetPathEntity? assetPathEntity, ScrollController scrollController) {
      if (permissionStatus == PermissionStatus.permanentlyDenied || permissionStatus == PermissionStatus.denied) {
        return PermissionNotAuthorizedWidget(
          backgroundColor: backgroundColor,
          goToSettingsWidget: goToSettingsWidget,
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
                cameraWidget: cameraWidget,
                selectMoreImageWidget: selectMoreImageWidget,
                isLimitSelectImage: permissionStatus == PermissionStatus.limited,
                scrollController: scrollController)
            : ImagesPickerGrid(
                assetPath: assetPathEntity,
                controller: controller,
                scrollController: scrollController,
                assetBackgroundColor: assetBackgroundColor,
                backgroundImage: backgroundImageCamera,
                selectMoreImageWidget: selectMoreImageWidget,
                isLimitSelectImage: permissionStatus == PermissionStatus.limited,
                cameraWidget: cameraWidget);
        } else {
          return const SizedBox.shrink();
        }
      }
    }

    // ignore: use_build_context_synchronously
    return showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      isScrollControlled: isScrollControlled,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        expand: expandDraggableScrollableSheet,
        builder: (BuildContext context, ScrollController scrollController) {
          return SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            controller: scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0) + MediaQuery.of(context).viewInsets,
                    height: heightOfBottomSheet ?? _defaultBottomSheetHeight(context),
                    child: Column(
                      children: [
                        Expanded(child: buildBodyBottomSheet(assetPath, scrollController)),
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: bottomWidget ?? const SizedBox.shrink(),
                        ),
                      ],
                    )
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static double _defaultBottomSheetHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.9 - MediaQuery.of(context).viewInsets.bottom;
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
      type: RequestType.common,
      filterOption: filterOption,
    );
  }
}