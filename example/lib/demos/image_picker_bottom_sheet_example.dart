import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/images_picker/images_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerBottomSheetExample extends StatelessWidget {
  const ImagePickerBottomSheetExample({super.key, required this.permissionStatus});

  final PermissionStatus permissionStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("image picker in bottom sheet"),),
      body: Center(
        child: TextButton(
          onPressed: () => ImagePicker.showImagesGridBottomSheet(
            counterImageBuilder: (counterImage) => counterImage == 0 ? const SizedBox.shrink() : Text('$counterImage'),
            controller: ImagePickerGridController(),
            context: context,
            goToSettingsWidget: null,
            backgroundImageCamera: const NetworkImage("https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000&q=80"),
            permissionStatus: permissionStatus,
          ),
          child: const Text("Open image picker"),
        ),
      ),
    );
  }
}