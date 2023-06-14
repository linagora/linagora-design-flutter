import 'package:flutter/material.dart';

typedef IsSelectedNotifier =  ValueNotifier<bool>;

typedef SelectedIndexNotifier = ValueNotifier<int>;

class AssetCounter extends ChangeNotifier {
  
  final Map<int, IsSelectedNotifier> _isSelectedMap = {};

  final Map<int, SelectedIndexNotifier> _selectedIndexMap = {};

  int _totalSelected = 0;

  void initializeIfNeeded({required int index}) {
    _initializeIsSelectedIfNeeded(index: index);
    _initializeSelectedIndexIfNeeded(index: index);
  }

  _initializeSelectedIndexIfNeeded({required int index}) {
    _selectedIndexMap.putIfAbsent(index, () => ValueNotifier(0));
  }

  void _initializeIsSelectedIfNeeded({required int index}) {
    if (!_isSelectedMap.keys.contains(index)) {
      _isSelectedMap[index] = ValueNotifier<bool>(false);
      _registerListenerInSelectionAt(index);
    }
  }

  void toggleAssetSelection(int index) {
    if (_isSelectedMap[index] != null) {
      _isSelectedMap[index]!.value = !_isSelectedMap[index]!.value;
    }
  }

  void _registerListenerInSelectionAt(int index) {
    _isSelectedMap[index]!.addListener(() {
      if (_isSelectedMap[index]!.value) {
        _totalSelected++;
        _selectedIndexMap[index]!.value = _totalSelected;
      } else {
        _totalSelected--;
        _updateLargerSelectedIndexes(index);
      }
      notifyListeners();
    });
  }
  
  void _updateLargerSelectedIndexes(int index) {
    int tmp = _selectedIndexMap[index]!.value;
    for(final key in _selectedIndexMap.keys) {
      if (key == index) {
        _selectedIndexMap[key]!.value = 0;
      }
      if (_selectedIndexMap[key]!.value > tmp) {
          _selectedIndexMap[key]!.value--;
      }
    }
  }

  void registerListenerAtSelectedIndex(int index, VoidCallback listener) {
    if (_selectedIndexMap[index] != null) {
      _selectedIndexMap[index]!.addListener(listener);
    }
  }

  int getSelectedIndexAt(int index) {
    return _selectedIndexMap[index]?.value ?? 0;
  }

  int get currentTotalSelectedIndex {
    return _totalSelected;
  }

  bool isSelected(int index) {
    return _isSelectedMap[index]?.value ?? false;
  }

  List<int> get selectedIndexes {
    return _selectedIndexMap.keys.where(
      (key) => _isSelectedMap[key]?.value ?? false
    ).toList();
  }

  void removeAllSelectedItem() {
    _isSelectedMap.values.map((valueNotifier) => valueNotifier.value = false).toList();
  }

  void clear() {
    _selectedIndexMap.clear();
    _isSelectedMap.clear();
    _totalSelected = 0;
  }
}