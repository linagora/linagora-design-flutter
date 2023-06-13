import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/images_picker/image_picker_grid_with_counter.dart';
import 'package:photo_manager/photo_manager.dart';

import 'images_picker_grid.dart';

class ImagePicker {
  static showImagesGridBottomSheet({
    required BuildContext context,
    required ImagePickerGridController controller,
    AssetPathEntity? assetPath,
    Widget? noImagesWidget,
    CounterImageBuilder? counterImageBuilder,
    Widget? cameraWidget,
    Widget? bottomWidget,
    ImageProvider<Object>? backgroundImageCamera,
    Color? backgroundColor,
    Color? assetBackgroundColor,
  }) async {
    if (assetPath == null) {
      final assetsPath = await getAllAssetPaths(hasAll: true, onlyAll: false);
      if (assetsPath.isNotEmpty) {
        assetPath = assetsPath[0];
      }
    }
    // ignore: use_build_context_synchronously
    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 2.0) + MediaQuery.of(context).viewInsets,
              height: MediaQuery.of(context).size.height / 2 + MediaQuery.of(context).viewInsets.bottom, 
              child: Column(
                children: [
                  Expanded(
                    child: assetPath != null 
                      ? counterImageBuilder != null 
                        ? ImagePickerGridWithCounter(
                          assetPath: assetPath, 
                          counterBuilder: counterImageBuilder,
                          controller: controller,
                          assetBackgroundColor: assetBackgroundColor,
                          backgroundImageCamera: backgroundImageCamera,
                          cameraWidget: cameraWidget,
                        )
                        : ImagesPickerGrid(
                          assetPath: assetPath,
                          controller: controller,
                          assetBackgroundColor: assetBackgroundColor,
                          backgroundImage: backgroundImageCamera,
                          cameraWidget: cameraWidget,
                        )
                      : noImagesWidget ?? const SizedBox.shrink(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: bottomWidget ?? const SizedBox.shrink(),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
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