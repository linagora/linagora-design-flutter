import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/images_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

void main() {
  group('newestFirstFilterOption', () {
    test('on Android sorts by creation date descending with no constraint', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);

      final filter = ImagePicker.newestFirstFilterOption();

      expect(filter, isA<CustomFilter>());
      final custom = filter! as CustomFilter;
      expect(custom.makeWhere(), isEmpty);
      final orderBy = custom.makeOrderBy();
      expect(orderBy, hasLength(1));
      expect(orderBy.first.column, CustomColumns.base.createDate);
      expect(orderBy.first.isAsc, isFalse);
    });

    test('on Android does not add the size and duration constraints', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);

      expect(
        ImagePicker.newestFirstFilterOption(),
        isNot(isA<FilterOptionGroup>()),
      );
    });

    for (final platform in TargetPlatform.values.where(
      (platform) => platform != TargetPlatform.android,
    )) {
      test('on $platform keeps the platform default order', () {
        debugDefaultTargetPlatformOverride = platform;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);

        expect(ImagePicker.newestFirstFilterOption(), isNull);
      });
    }
  });
}
