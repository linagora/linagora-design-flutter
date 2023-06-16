import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/images_picker/images_picker.dart';
import 'package:photo_manager/photo_manager.dart';

typedef CounterImageBuilder = Widget Function(int counterImage);

class ImagePickerGridWithCounter extends StatefulWidget {

  final AssetPathEntity assetPath;

  final CounterImageBuilder counterBuilder;

  final ImagePickerGridController? controller;

  final Color? assetBackgroundColor;

  final Widget? cameraWidget;

  final ImageProvider<Object>? backgroundImageCamera;

  final bool? isLimitSelectImage;

  final Widget? selectMoreImageWidget;

  final ScrollController scrollController;

  const ImagePickerGridWithCounter({
    super.key,
    required this.assetPath,
    required this.counterBuilder,
    required this.scrollController,
    this.assetBackgroundColor,
    this.cameraWidget,
    this.backgroundImageCamera,
    this.controller,
    this.isLimitSelectImage = false,
    this.selectMoreImageWidget
  });

  @override
  State<ImagePickerGridWithCounter> createState() => _ImagePickerGridWithCounterState();
}

class _ImagePickerGridWithCounterState extends State<ImagePickerGridWithCounter> {
  late final controller = widget.controller ?? ImagePickerGridController();

  final imageCounterNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      imageCounterNotifier.value = controller.selectedAssets.length;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: imageCounterNotifier,
          builder: (context, value, child) {
            if (value == 0) {
              return Column(
                children: [
                  const SizedBox(height: 16.0,),
                  Container(
                    height: 4.0,
                    width: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }
            return widget.counterBuilder(value);
          }
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 7.0,
              vertical: 4.0,
            ),
            child: ImagesPickerGrid(
              assetPath: widget.assetPath,
              controller: controller,
              assetBackgroundColor: widget.assetBackgroundColor,
              cameraWidget: widget.cameraWidget,
              backgroundImage: widget.backgroundImageCamera,
              isLimitSelectImage: widget.isLimitSelectImage,
              selectMoreImageWidget: widget.selectMoreImageWidget,
              scrollController: widget.scrollController,
            ),
          ),
        ),
      ],
    );
  }
}