import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

/// Where the badge's count lands, rather than where its box does.
///
/// The count is placed by arithmetic on the font's metrics, so nothing but
/// the painted pixels can confirm it. These render with the shipped font and
/// read them. Boxes are checked in `linagora_sidebar_typography_test.dart`.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(_loadTwakeInter);

  test('measures the shipped font, not a stand-in', _fontIsTwakeInter);
  testWidgets('centres a full count in its pill', _countIsCentred('999+'));
  testWidgets('centres a single digit in its pill', _countIsCentred('3'));
}

/// These tests turn on the real font's metrics, and the test font's are
/// symmetric enough to hide the drift they exist to catch. `999+` is 30px
/// wide in the design.
void _fontIsTwakeInter() {
  final painter = TextPainter(
    text: TextSpan(
      text: LinagoraSidebarBadge.widestLabel,
      style: LinagoraSidebarStyle.light().badgeTextStyle,
    ),
    textDirection: TextDirection.ltr,
  )..layout();

  expect(painter.width, closeTo(30, 1));
  painter.dispose();
}

/// Room for one ink row at either edge, which is where rasterizers differ
/// across platforms. The drift this guards against is three times as wide.
const _tolerance = 0.25;

const _pixelRatio = 8.0;

WidgetTesterCallback _countIsCentred(String label) {
  return (tester) async {
    final pixels = await _renderBadge(tester, label);
    final pill = pixels.inkRows(250);
    final ink = pixels.inkRows(140);

    // The pill is the only reference the eye has, so the gaps come off it
    // rather than off the widget's bounds.
    final scale =
        (pill.last - pill.first + 1) / LinagoraSidebarStyle.light().badgeHeight;
    final above = (ink.first - pill.first) / scale;
    final below = (pill.last - ink.last) / scale;

    expect(
      above,
      closeTo(below, _tolerance),
      reason: '"$label" sits off centre',
    );
  };
}

Future<_Pixels> _renderBadge(WidgetTester tester, String label) async {
  final key = GlobalKey();
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: RepaintBoundary(
            key: key,
            // Opaque, so the paint reads as darkness rather than as alpha
            // over nothing.
            child: ColoredBox(
              color: const Color(0xFFFFFFFF),
              // Room around the pill, so its own edge is never the first row.
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: LinagoraSidebarBadge(label: label),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  final boundary =
      key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final image =
      (await tester.runAsync(() => boundary.toImage(pixelRatio: _pixelRatio)))!;
  final data = (await tester.runAsync(
    () => image.toByteData(format: ui.ImageByteFormat.rawRgba),
  ))!;
  final pixels = _Pixels(
    width: image.width,
    height: image.height,
    rgba: data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
  );
  image.dispose();
  return pixels;
}

Future<void> _loadTwakeInter() async {
  final loader = FontLoader('packages/linagora_design_flutter/TwakeInter');
  loader.addFont(
    Future.value(
      File(
        'assets/fonts/TwakeInter-Medium.ttf',
      ).readAsBytesSync().buffer.asByteData(),
    ),
  );
  await loader.load();
}

class _Pixels {
  const _Pixels({
    required this.width,
    required this.height,
    required this.rgba,
  });

  final int width;
  final int height;
  final Uint8List rgba;

  /// The rows holding anything darker than [red], top and bottom included.
  List<int> inkRows(int red) {
    final rows = [
      for (var y = 0; y < height; y++)
        if (_darkestInRow(y) < red) y,
    ];
    expect(rows, isNotEmpty, reason: 'nothing was painted below $red');
    return rows;
  }

  int _darkestInRow(int y) {
    var darkest = 255;
    for (var x = 0; x < width; x++) {
      final pixel = (y * width + x) * 4;
      // A boundary whose width does not land on a whole device pixel leaves
      // the last column unpainted, and unpainted reads as black.
      if (rgba[pixel + 3] < 250) continue;
      final red = rgba[pixel];
      if (red < darkest) darkest = red;
    }
    return darkest;
  }
}
