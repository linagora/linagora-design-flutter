import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

const _box = 160.0;

void main() {
  for (final asset in [
    LinagoraDesignImages.sidebarSearchIcon,
    LinagoraDesignImages.sidebarAddIcon,
  ]) {
    testWidgets('draws $asset edge to edge in its box', (tester) async {
      final ink = await _inkBounds(tester, asset);

      expect(ink, const Rect.fromLTWH(0, 0, _box, _box));
    });
  }
}

/// Bounds of the opaque pixels of [asset] drawn in a [_box] square.
Future<Rect> _inkBounds(WidgetTester tester, String asset) async {
  final key = GlobalKey();
  await tester.runAsync(() async {
    await tester.pumpWidget(
      Center(
        child: RepaintBoundary(
          key: key,
          child: SizedBox.square(
            dimension: _box,
            child: SvgPicture.asset(asset),
          ),
        ),
      ),
    );
    // The SVG decodes off the test clock.
    await Future<void>.delayed(const Duration(milliseconds: 200));
  });
  await tester.pump();

  final pixels = await tester.runAsync(() async {
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    return (width: image.width, bytes: bytes!);
  });

  var left = _box, top = _box, right = 0.0, bottom = 0.0;
  for (var index = 3; index < pixels!.bytes.lengthInBytes; index += 4) {
    if (pixels.bytes.getUint8(index) < 128) continue;
    final x = (index ~/ 4) % pixels.width, y = (index ~/ 4) ~/ pixels.width;
    left = x < left ? x.toDouble() : left;
    top = y < top ? y.toDouble() : top;
    right = x + 1 > right ? x + 1.0 : right;
    bottom = y + 1 > bottom ? y + 1.0 : bottom;
  }
  return Rect.fromLTRB(left, top, right, bottom);
}
