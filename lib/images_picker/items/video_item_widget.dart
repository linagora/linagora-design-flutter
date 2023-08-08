import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/extensions/duration_extension.dart';
import 'package:linagora_design_flutter/images_picker/image_item_widget.dart';
import 'package:photo_manager/photo_manager.dart';

class VideoItemWidget extends StatelessWidget {

  final AssetEntity entity;

  final ThumbnailOption option;

  final bool isOriginal;
  
  const VideoItemWidget({
    super.key, 
    required this.entity, 
    required this.option, 
    required this.isOriginal,
  });

  @override
  Widget build(BuildContext context) {
    final assetProvider = AssetEntityImageProvider(
      entity,
      isOriginal: isOriginal,
      thumbnailSize: ImagePickerItemWidget.thumbnailDefaultSize,
    );
    return Stack(
      alignment: Alignment.center,
      children: [
        ExtendedImage(
          image: assetProvider,
          width: option.size.width.toDouble(),
          height: option.size.height.toDouble(),
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          loadStateChanged: (ExtendedImageState state) {
            Widget loader = const SizedBox.shrink();
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                loader = const ColoredBox(color: Color(0x10ffffff));
                break;
              case LoadState.completed:
                loader = RepaintBoundary(child: state.completedWidget);
                break;
              case LoadState.failed:
                loader = const Center(child: Icon(Icons.error),);
                break;
            }
            return loader;
          },
        ),
        Container(
          width: ImagePickerItemWidget.thumbnailDefaultSize.width.toDouble(),
          height: ImagePickerItemWidget.thumbnailDefaultSize.height.toDouble(),
          alignment: Alignment.bottomRight,
          padding: const EdgeInsetsDirectional.only(bottom: 4.0, end: 4.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.5),
              ],
              stops: const [
                0.75,
                0.8,
                1,
              ],
            ),
          ),
          child: Text(
            entity.videoDuration.durationIndicatorBuilder(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}