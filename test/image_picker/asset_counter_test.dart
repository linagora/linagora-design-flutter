@TestOn('vm')
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/images_picker/asset_counter.dart';

void main() {
  late AssetCounter assetCounter;

  setUp(() {
    assetCounter = AssetCounter();
    // initialize asset counter for images from 0 to 5
    assetCounter.initializeIfNeeded(index: 0);
    assetCounter.initializeIfNeeded(index: 1);
    assetCounter.initializeIfNeeded(index: 2);
    assetCounter.initializeIfNeeded(index: 3);
    assetCounter.initializeIfNeeded(index: 4);
    assetCounter.initializeIfNeeded(index: 5);
  });

  group("AssetCounter class test", () {
    test("""GIVEN user did not select any item WHEN user select item number 2 
      THEN item number 2 should be selected
      AND its correspond selected index: 1""", () {
      assetCounter.toggleAssetSelection(2);

      //EXPECTED
      expect(assetCounter.currentTotalSelectedIndex, 1);
      expect(assetCounter.isSelected(2), true);
      expect(assetCounter.getSelectedIndexAt(2), 1);
    });

    test("""GIVEN user did not select any item 
      WHEN user select item number 1, item number 2, item number 3 
      THEN item number 1, 2, 3 should be selected
      AND its correspond selected index: 1, 2, 3""", () {
      
      assetCounter.toggleAssetSelection(1);
      assetCounter.toggleAssetSelection(2);
      assetCounter.toggleAssetSelection(3);

      //EXPECTED
      expect(assetCounter.currentTotalSelectedIndex, 3);
      expect(assetCounter.isSelected(1), true);
      expect(assetCounter.isSelected(2), true);
      expect(assetCounter.isSelected(3), true);
      expect(assetCounter.isSelected(4), false);
      expect(assetCounter.getSelectedIndexAt(1), 1);
      expect(assetCounter.getSelectedIndexAt(2), 2);
      expect(assetCounter.getSelectedIndexAt(3), 3);
      expect(assetCounter.getSelectedIndexAt(4), 0);
    });

    test("""GIVEN user did not select any item 
      WHEN user select item number 1, item number 2, item number 3 and unselect item number 1 
      THEN item number 2, 3 should be selected
      AND its correspond selected index: 1, 2""", () {
      assetCounter.toggleAssetSelection(1);
      assetCounter.toggleAssetSelection(2);
      assetCounter.toggleAssetSelection(3);
      assetCounter.toggleAssetSelection(1);

      //EXPECTED
      expect(assetCounter.currentTotalSelectedIndex, 2);
      expect(assetCounter.isSelected(1), false);
      expect(assetCounter.isSelected(2), true);
      expect(assetCounter.isSelected(3), true);
      expect(assetCounter.isSelected(4), false);
      expect(assetCounter.getSelectedIndexAt(1), 0);
      expect(assetCounter.getSelectedIndexAt(2), 1);
      expect(assetCounter.getSelectedIndexAt(3), 2);
      expect(assetCounter.getSelectedIndexAt(4), 0);
    });

    test("""GIVEN user did not select any item 
      WHEN user select item number 5, 4, 2, 1 then toggle item number 5 two times more
      THEN item number 5, 4, 2, 1 should be selected
      AND its correspond selected index: 4, 1, 2, 3""", () {
      assetCounter.toggleAssetSelection(5);
      assetCounter.toggleAssetSelection(4);
      assetCounter.toggleAssetSelection(2);
      assetCounter.toggleAssetSelection(1);
      assetCounter.toggleAssetSelection(5);
      assetCounter.toggleAssetSelection(5);


      //EXPECTED
      expect(assetCounter.currentTotalSelectedIndex, 4);
      expect(assetCounter.isSelected(1), true);
      expect(assetCounter.isSelected(2), true);
      expect(assetCounter.isSelected(3), false);
      expect(assetCounter.isSelected(4), true);
      expect(assetCounter.isSelected(5), true);
      expect(assetCounter.getSelectedIndexAt(1), 3);
      expect(assetCounter.getSelectedIndexAt(2), 2);
      expect(assetCounter.getSelectedIndexAt(3), 0);
      expect(assetCounter.getSelectedIndexAt(4), 1);
      expect(assetCounter.getSelectedIndexAt(5), 4);
    });

    test("""GIVEN user did not select any item 
      WHEN user select item number 5, 4, 2, 1 then user scroll down to load more item,
      and select item 10, 9 then unselect item number 1
      THEN item number 1,2,4,9,10 should be selected
      AND its correspond selected index: 3, 2, 1, 5, 4 """, () {
      assetCounter.toggleAssetSelection(5);
      assetCounter.toggleAssetSelection(4);
      assetCounter.toggleAssetSelection(2);
      assetCounter.toggleAssetSelection(1);

      // load next 5 images
      assetCounter.initializeIfNeeded(index:6);
      assetCounter.initializeIfNeeded(index:7);
      assetCounter.initializeIfNeeded(index:8);
      assetCounter.initializeIfNeeded(index:9);
      assetCounter.initializeIfNeeded(index:10);

      assetCounter.toggleAssetSelection(10);
      assetCounter.toggleAssetSelection(9);
      assetCounter.toggleAssetSelection(5);

      //EXPECTED
      expect(assetCounter.currentTotalSelectedIndex, 5);
      expect(assetCounter.isSelected(1), true);
      expect(assetCounter.isSelected(2), true);
      expect(assetCounter.isSelected(3), false);
      expect(assetCounter.isSelected(4), true);
      expect(assetCounter.isSelected(5), false);
      expect(assetCounter.isSelected(9), true);
      expect(assetCounter.isSelected(10), true);
      expect(assetCounter.getSelectedIndexAt(1), 3);
      expect(assetCounter.getSelectedIndexAt(2), 2);
      expect(assetCounter.getSelectedIndexAt(3), 0);
      expect(assetCounter.getSelectedIndexAt(4), 1);
      expect(assetCounter.getSelectedIndexAt(5), 0);
      expect(assetCounter.getSelectedIndexAt(9), 5);
      expect(assetCounter.getSelectedIndexAt(10), 4);
    });
  });
}