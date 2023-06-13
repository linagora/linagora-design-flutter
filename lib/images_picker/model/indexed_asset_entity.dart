import 'package:equatable/equatable.dart';
import 'package:photo_manager/photo_manager.dart';

class IndexedAssetEntity with EquatableMixin {

  final int index;

  final AssetEntity asset;

  IndexedAssetEntity({
    required this.index,
    required this.asset,
  });

  @override
  List<Object?> get props => [index, asset];
}