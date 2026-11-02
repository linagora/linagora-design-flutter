import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/images_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

void main() {
  test('newestFirstFilterOption sorts by creation date descending', () {
    final filter = ImagePicker.newestFirstFilterOption();

    expect(filter, isA<FilterOptionGroup>());
    final orders = (filter as FilterOptionGroup).orders;
    expect(orders, hasLength(1));
    expect(orders.first.type, OrderOptionType.createDate);
    expect(orders.first.asc, isFalse);
  });
}
