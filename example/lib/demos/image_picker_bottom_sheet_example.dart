import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/images_picker/image_picker.dart';
import 'package:linagora_design_flutter/images_picker/images_picker.dart';
import 'package:photo_manager/photo_manager.dart';

Future<AssetPathEntity> loadAssetsPath() async {
  await PhotoManager.requestPermissionExtend();
  final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
    onlyAll: true,
    filterOption: FilterOptionGroup(
      imageOption: const FilterOption(
        sizeConstraint: SizeConstraint(ignoreSize: true),
      ),
    ),
  );
  return paths[0];
}

class ImagePickerBottomSheetExample extends StatelessWidget {
  const ImagePickerBottomSheetExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("image picker in bottom sheet"),),
      body: Center(
        child: FutureBuilder(
          future: loadAssetsPath(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return TextButton(
              onPressed: () => ImagePicker.showImagesGridBottomSheet(
                counterImageBuilder: (counterImage) => counterImage == 0 ? const SizedBox.shrink() : Text('$counterImage'),
                controller: ImagePickerGridController(),
                context: context, 
                assetPath: snapshot.data!, 
                noImagesWidget: null,
                backgroundImageCamera: const NetworkImage("https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000&q=80"),
                bottomWidget: TextField(),
              ),
              child: const Text("Open image picker"),
            );
          }
        ),
      ),
    );
  }

}