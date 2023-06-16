import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/images_picker/asset_counter.dart';
import 'package:linagora_design_flutter/images_picker/image_item_widget.dart';
import 'package:linagora_design_flutter/images_picker/images_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:collection/collection.dart';

class ImagesPickerGrid extends StatefulWidget {

  const ImagesPickerGrid({
    super.key,
    this.controller,
    required this.assetPath,
    required this.scrollController,
    this.cameraWidget,
    this.onCameraPressed,
    this.backgroundImage,
    this.pageSize = maxImagesPerPage,
    this.itemsPerWidth = 3,
    this.assetBackgroundColor,
    this.thumbnailOption = const ThumbnailOption(size: ImageItemWidget.thumbnailDefaultSize),
    this.isLimitSelectImage = false,
    this.selectMoreImageWidget
  });

  static const maxImagesPerPage = 10;

  final ScrollController scrollController;

  final AssetPathEntity assetPath;

  final ImagePickerGridController? controller;

  final Widget? cameraWidget;

  final void Function()? onCameraPressed;

  final ImageProvider<Object>? backgroundImage;

  final int pageSize;

  final int itemsPerWidth;

  final ThumbnailOption thumbnailOption;

  final Color? assetBackgroundColor;

  /// ONLY SUPPORT FOR IOS 14+
  final Widget? selectMoreImageWidget;

  final bool? isLimitSelectImage;

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

    /// Register your callback.
    PhotoManager.addChangeCallback(changeNotify);

    /// Enable change notify.
    PhotoManager.startChangeNotify();
    controller.assetPath = widget.assetPath;
    _loadAssets(_currentPage);
  }

  void changeNotify(MethodCall call) async {
    log("ImagesPickerGrid::changeNotify(): MethodCall = $call");
    final newCount = call.arguments['newCount'];
    final oldCount = call.arguments['oldCount'];
    if (newCount == 0) {
      _loadAssets(0);
    } else {
      _getAssetListIncrease(newCount, oldCount);
    }
  }

  Future<void> _getAssetListIncrease(int newCount, int oldCount) async {
    final newItems = await controller._getAssetListRange(start: 0, end: newCount);
    _totalEntitiesCount = newItems.length;
    if (mounted) {
      setState(() {
        _currentPage = _calculateCurrentPage(oldCount, widget.pageSize);
        _hasMoreToLoad = controller._totalAssets.length < _totalEntitiesCount;
        controller.removeAllSelectedItem();
      });
    }
  }

  int _calculateCurrentPage(int totalImages, int imagesPerPage) {
    if (imagesPerPage != 0) {
      return (totalImages - 1) ~/ imagesPerPage;
    } else {
      return imagesPerPage;
    }
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

    int childCount = controller._totalAssets.length + 1;

    if (widget.isLimitSelectImage == true) {
      childCount = childCount + 1;
    }

    return GridView.custom(
      physics: const ClampingScrollPhysics(),
      controller: widget.scrollController,
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

          assetCounter.initializeIfNeeded(index: imageIndex);

          if (index == childCount - 1 && widget.isLimitSelectImage == true) {
            return GestureDetector(
              onTap: () async {
                await PhotoManager.presentLimited();
              },
              child: widget.selectMoreImageWidget ?? Icon(
                Icons.add_photo_alternate,
                size: 40,
                color: LinagoraSysColors.material().primary)
            );
          }

          return ImageItemWidget(
            key: ValueKey(imageIndex),
            index: imageIndex,
            entity: controller._totalAssets[imageIndex], 
            option: widget.thumbnailOption,
            assetCounter: assetCounter,
            backgroundColor: widget.assetBackgroundColor,
          );
        },
        childCount: childCount,
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
    _assetCounter.addListener(notifyListeners);
  }

  Future<List<AssetEntity>> _getAllAssets({
    required int page, 
    required int size
  }) async {
    _totalAssets = await assetPath!.getAssetListPaged(page: page, size: size);
    return _totalAssets;
  }

  Future<List<AssetEntity>> _getAssetListRange({
    required int start,
    required int end
  }) async {
    _totalAssets = await assetPath!.getAssetListRange(start: start, end: end);
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

  void clearAssetCounter() {
    _assetCounter.clear();
  }

  void removeAllSelectedItem() {
    _assetCounter.removeAllSelectedItem();
  }

  List<IndexedAssetEntity> get sortedSelectedAssets {
    return selectedAssets.sorted((a, b) => a.index.compareTo(b.index));
  }
}

