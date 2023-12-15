import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class ImageItemWidget extends StatelessWidget {
  
  final AssetEntity entity;

  final ThumbnailOption option;

  final bool isOriginal;
  
  const ImageItemWidget({
    super.key, 
    required this.entity, 
    required this.option, 
    required this.isOriginal,
  });
  
  @override
  Widget build(BuildContext context) {
    final thumbnailSize = ThumbnailSize.square((option.size.width * MediaQuery.of(context).devicePixelRatio).toInt());
    return AssetEntityImage(
      entity,
      thumbnailSize: thumbnailSize,
      thumbnailFormat: option.format,
      width: thumbnailSize.width.toDouble(),
      height: thumbnailSize.height.toDouble(),
      isOriginal: isOriginal,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.medium,
      loadingBuilder:(context, child, loadingProgress) {
        if (loadingProgress != null && loadingProgress.cumulativeBytesLoaded != loadingProgress.expectedTotalBytes) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          ); 
        }
        return child;
      },
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Icon(Icons.error_outline),
        );
      },
      gaplessPlayback: true,
    );
  }


}