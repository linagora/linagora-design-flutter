import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/images_picker/asset_counter.dart';
import 'package:linagora_design_flutter/images_picker/items/image_item_widget.dart';
import 'package:linagora_design_flutter/images_picker/items/video_item_widget.dart';
import 'package:photo_manager/photo_manager.dart';

typedef AssetItemBuilder = Widget Function(AssetEntity entity, ThumbnailOption option, bool isOriginal); 

class ImagePickerItemWidget extends StatefulWidget {

  final AssetEntity entity;

  final ThumbnailOption option;
  
  final GestureTapCallback? onTap;

  final bool isOriginal;

  final int index;

  final AssetCounter assetCounter;

  static const thumbnailDefaultSize = ThumbnailSize.square(200);

  final Color? backgroundColor;

  final AssetItemBuilder? assetItemBuilder;

  const ImagePickerItemWidget({
    Key? key,
    required this.entity,
    required this.option,
    required this.assetCounter,
    required this.index,
    this.backgroundColor,
    this.isOriginal = false,
    this.onTap,
    this.assetItemBuilder,
  }) : super(key: key);

  @override
  State<ImagePickerItemWidget> createState() => _ImagePickerItemWidgetState();
}

class _ImagePickerItemWidgetState extends State<ImagePickerItemWidget> with SingleTickerProviderStateMixin {

  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final Animation<double> _scaleAnimation = Tween<double>(
    begin: 1.0,
    end: 0.75,
  ).animate(_animationController);

  late AssetCounter assetCounter;

  late ValueNotifier<int> cardinalNumberNotifier;

  @override
  void initState() {
    super.initState();
    assetCounter = widget.assetCounter;
    cardinalNumberNotifier = ValueNotifier(widget.assetCounter.getSelectedIndexAt(widget.index));
    assetCounter.registerListenerAtSelectedIndex(widget.index, () {
      cardinalNumberNotifier.value = assetCounter.getSelectedIndexAt(widget.index);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onSelectedAsset() {
    assetCounter.isSelected(widget.index)
      ? _animationController.reverse()
      : _animationController.forward();
    
    assetCounter.toggleAssetSelection(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    if (assetCounter.isSelected(widget.index)) {
      _animationController.value = _animationController.upperBound;
    } else {
      _animationController.value = _animationController.lowerBound;
    }

    return Stack(
      alignment: Alignment.topRight,
      children: [
        GestureDetector(
          onTap: () {
            widget.onTap?.call();
            _onSelectedAsset();
          },
          child: Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            ),
            margin: const EdgeInsets.all(2.0),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                child: itemWidgetFactory(
                  entity: widget.entity,
                  option: widget.option,
                  isOriginal: widget.isOriginal,
                ),
              ),
            ),
          )
        ),
        Positioned(
          top: 6.0,
          right: 6.0,
          child: InkWell(
            onTap: () {
              _onSelectedAsset();
            },
            child: ValueListenableBuilder(
              valueListenable: cardinalNumberNotifier,
              builder: (context, value, child) {
                return SelectedAssetWidget(
                  cardinalNumber: cardinalNumberNotifier.value,
                );
              }
            ),
          ),
        ),
      ],
    );
  }

  Widget itemWidgetFactory({
    required AssetEntity entity, 
    required ThumbnailOption option,
    required bool isOriginal,
    AssetItemBuilder? assetItemBuilder,
  }) {
    switch (entity.type) {
      case AssetType.video:
        return assetItemBuilder?.call(entity, option, isOriginal) ?? VideoItemWidget(
          entity: entity,
          option: option,
          isOriginal: isOriginal,
        );
      case AssetType.other:
      case AssetType.image:
      case AssetType.audio:
        return assetItemBuilder?.call(entity, option, isOriginal) ?? ImageItemWidget(
          entity: entity, 
          option: option, 
          isOriginal: isOriginal,
      );
    }
  }
}

class SelectedAssetWidget extends StatefulWidget {
  const SelectedAssetWidget({
    super.key,
    required this.cardinalNumber,
  });

  final int cardinalNumber;

  @override
  State<SelectedAssetWidget> createState() => _SelectedAssetWidgetState();
}

class _SelectedAssetWidgetState extends State<SelectedAssetWidget> with SingleTickerProviderStateMixin {

  late final AnimationController _controller = AnimationController(
    reverseDuration: const Duration(milliseconds: 500),
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  late bool isSelected = widget.cardinalNumber != 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SelectedAssetWidget oldWidget) {
    isSelected = widget.cardinalNumber != 0;
    super.didUpdateWidget(oldWidget);
  }

  void selectImage() {
    if (isSelected) {
      _controller.forward();
    } else if (_controller.isCompleted) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    selectImage();
    
    return Container(
      width: 20,
      height: 20,
      decoration: ShapeDecoration(
        color:Colors.transparent,
        shape: CircleBorder(
          side: BorderSide(
            width: isSelected ? 1 : 2,
            color: Theme.of(context).colorScheme.surfaceVariant,
          )
        )
      ),
      child: ScaleTransition(
        scale: _animation,
        child: isSelected
          ? Container(
              padding: const EdgeInsets.all(1.0),
              decoration: ShapeDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: const CircleBorder()
              ),
              alignment: Alignment.center,
              child: AutoSizeText(
                "${widget.cardinalNumber}", 
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.surface,
                ),
                minFontSize: 8,
              ),
            )
          : null,
      ),
    );
  }
}