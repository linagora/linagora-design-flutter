import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/images_picker/images_picker.dart';
import 'package:linagora_design_flutter/images_picker/images_picker_grid.dart';
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

class ImagesPickerExample extends StatefulWidget {
  const ImagesPickerExample({super.key});

  @override
  State<ImagesPickerExample> createState() => _ImagesPickerExampleState();
}

class _ImagesPickerExampleState extends State<ImagesPickerExample> {
  final controller = ImagePickerGridController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      for (final value in controller.selectedAssets) {
        print(value);
      }
      print('\n');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Demo images picker"),),
      body: FutureBuilder<AssetPathEntity>(
        future: loadAssetsPath(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done && !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator.adaptive(),);
          }
          return ImagesPickerGrid(
            assetPath: snapshot.data!,
            controller: controller
          );
        }
      ),
    );
  }
}