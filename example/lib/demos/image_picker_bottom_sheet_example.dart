import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/images_picker/asset_counter.dart';
import 'package:linagora_design_flutter/images_picker/images_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerBottomSheetExample extends StatelessWidget {
  const ImagePickerBottomSheetExample(
      {super.key, required this.permissionStatus});

  final PermissionStatus permissionStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("image picker in bottom sheet"),
      ),
      body: Center(
        child: TextButton(
          onPressed: () => ImagePicker.showImagesGridBottomSheet(
            counterImageBuilder: (counterImage) => counterImage == 0
                ? const SizedBox.shrink()
                : Text('$counterImage'),
            controller: ImagePickerGridController(AssetCounter()),
            context: context,
            goToSettingsWidget: null,
            initialChildSize: 0.6,
            backgroundImageCamera: const NetworkImage(
                "https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000&q=80"),
            permissionStatus: permissionStatus,
            expandedWidget: const SizedBox(
              height: 90,
            ),
            bottomWidget: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextField(
                              maxLines: 4,
                              minLines: 4,
                              onTap: () => {},
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.tag_faces,
                                ),
                                hintText: 'Captions',
                              ),
                            ),
                          ),
                          InkWell(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                            onTap: () {},
                            child: const Icon(
                              Icons.send,
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
          ),
          child: const Text("Open image picker"),
        ),
      ),
    );
  }
}
