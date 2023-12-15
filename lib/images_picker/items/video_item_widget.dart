import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/extensions/duration_extension.dart';
import 'package:linagora_design_flutter/images_picker/image_item_widget.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

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
    final thumbnailSize = ThumbnailSize.square((option.size.width * MediaQuery.of(context).devicePixelRatio).toInt());
    return Stack(
      alignment: Alignment.center,
      children: [
        AssetEntityImage(
          entity,
          thumbnailSize: thumbnailSize,
          width: thumbnailSize.width.toDouble(),
          height: thumbnailSize.height.toDouble(),
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(Icons.error),
            );
          },
          gaplessPlayback: true,
          isOriginal: isOriginal,
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
            entity.videoDuration.mediaTimeLength(),
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