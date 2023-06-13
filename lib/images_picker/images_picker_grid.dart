import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/images_picker/asset_counter.dart';
import 'package:linagora_design_flutter/images_picker/image_item_widget.dart';
import 'package:linagora_design_flutter/images_picker/images_picker.dart';
import 'package:photo_manager/photo_manager.dart';

class ImagesPickerGrid extends StatefulWidget {

  const ImagesPickerGrid({
    super.key,
    this.controller,
    required this.assetPath,
    this.cameraWidget,
    this.onCameraPressed,
    this.backgroundImage,
    this.pageSize = maxImagesPerPage,
    this.itemsPerWidth = 3,
    this.thumbnailOption = const ThumbnailOption(size: ImageItemWidget.thumbnailDefaultSize),
  });

  static const maxImagesPerPage = 10;

  final AssetPathEntity assetPath;

  final ImagePickerGridController? controller;

  final Widget? cameraWidget;

  final void Function()? onCameraPressed;

  final ImageProvider<Object>? backgroundImage;

  final int pageSize;

  final int itemsPerWidth;

  final ThumbnailOption thumbnailOption;

  @override
  State<ImagesPickerGrid> createState() => _ImagesPickerGridState();
}

class _ImagesPickerGridState extends State<ImagesPickerGrid> {
  bool isLoading = true;
  int _currentPage = 0;
  bool _hasMoreToLoad = true;
  int _totalEntitiesCount = 0;

  late final controller = widget.controller ?? ImagePickerGridController();

  @override
  void initState() {
    super.initState();
    controller.assetPath = widget.assetPath;
    _loadAssets(_currentPage);
  }

  Future<void> _loadAssets(int page) async {
    _totalEntitiesCount = await controller.totalAssetCount;
    await controller._getAllAssets(page: page, size: widget.pageSize);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
  
  Future<void> _loadMoreAsset() async {
    final List<AssetEntity> entities = await controller.assetPath!.getAssetListPaged(
      page: _currentPage + 1,
      size: widget.pageSize,
    );
    _totalEntitiesCount += entities.length;

    if (!mounted) {
      return;
    }
    if (entities.isNotEmpty) {
      setState(() {
        controller._totalAssets.addAll(entities);
        _currentPage++;
        _hasMoreToLoad = controller._totalAssets.length < _totalEntitiesCount;
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final assetCounter = controller._assetCounter;

    return GridView.custom(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.itemsPerWidth,
      ), 
      childrenDelegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            return widget.cameraWidget ?? UseCameraWidget(
              onPressed: widget.onCameraPressed,
              backgroundImage: widget.backgroundImage,
            );
          }

          int imageIndex = index - 1;

          if (index == controller._totalAssets.length + 1 - widget.pageSize && _hasMoreToLoad) {
            _loadMoreAsset();
          }

          assetCounter.initializeIfNeeded(imageIndex);

          return ImageItemWidget(
            key: ValueKey(imageIndex),
            index: imageIndex,
            entity: controller._totalAssets[imageIndex], 
            option: widget.thumbnailOption,
            assetCounter: assetCounter,
            backgroundColor: widget.assetBackgroundColor,
          );
        },
        childCount: controller._totalAssets.length + 1,
      ),
    );
  }
}

class ImagePickerGridController extends ChangeNotifier {

  ImagePickerGridController() {
    registerAssetCounterListener();
  }

  AssetPathEntity? assetPath;

  final _assetCounter = AssetCounter();

  Future<int> get totalAssetCount => assetPath!.assetCountAsync;

  List<AssetEntity> _totalAssets = [];

  List<AssetEntity> get totalAssets => _totalAssets;

  void registerAssetCounterListener() {
    _assetCounter.addListener(() {
      notifyListeners();
    });
  }

  Future<List<AssetEntity>> _getAllAssets({
    required int page, 
    required int size
  }) async {
    _totalAssets = await assetPath!.getAssetListPaged(page: page, size: size);
    return _totalAssets;
  }

  List<IndexedAssetEntity> get selectedAssets {
    final selectedIndexes = _assetCounter.selectedIndexes;

    return selectedIndexes
      .map((index) => IndexedAssetEntity(
        index: _assetCounter.getSelectedIndexAt(index), 
        asset: _totalAssets[index])
      )
      .toList();
  }
}

