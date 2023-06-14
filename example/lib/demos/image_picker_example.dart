import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/images_picker/images_picker.dart';
import 'package:linagora_design_flutter/images_picker/images_picker_grid.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class ImagesPickerExample extends StatefulWidget {
  final PermissionStatus permissionStatus;
  const ImagesPickerExample({super.key, required this.permissionStatus});

  @override
  State<ImagesPickerExample> createState() => _ImagesPickerExampleState();
}

class _ImagesPickerExampleState extends State<ImagesPickerExample> {
  final controller = ImagePickerGridController();

  Future<AssetPathEntity> loadAssetsPath() async {
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

  @override
  void initState() {
    controller.addListener(() {
      for (final value in controller.selectedAssets) {
        print(value);
      }
      print('\n');
    });
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Demo images picker"),),
      body: widget.permissionStatus == PermissionStatus.granted || widget.permissionStatus == PermissionStatus.limited
        ? FutureBuilder<AssetPathEntity>(
          future: loadAssetsPath(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done && !snapshot.hasData) {
              return const Center(child: CircularProgressIndicator.adaptive(),);
            }
            return ImagesPickerGrid(
              assetPath: snapshot.data!,
              controller: controller,
              isLimitSelectImage: widget.permissionStatus == PermissionStatus.limited,
            );
          }
        )
        : Center(
          child: TextButton(
            onPressed: () async {
             PhotoManager.openSetting();
            },
            child: const Text("Go To Settings"),
          ),
        )
    );
  }
}