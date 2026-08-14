import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

/// Where a row's text lands, rather than where its box does.
///
/// A paragraph is taller than the glyphs inside it and hangs lower, so lining
/// boxes up left the count low in its pill and the label low against its
/// chevron. These render with the shipped font and read the painted pixels.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(_loadTwakeInter);

  test('measures the shipped font, not a stand-in', _fontIsTwakeInter);
  testWidgets('centres a full count in its pill', _countIsCentred('999+'));
  testWidgets('centres a single digit in its pill', _countIsCentred('3'));
  testWidgets('lines the label up with its chevron', _labelMeetsTheChevron);
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

/// As close as antialiasing lets two edges be read.
const _tolerance = 0.13;

const _pixelRatio = 8.0;

WidgetTesterCallback _countIsCentred(String label) {
  return (tester) async {
    final pixels = await _render(
      tester,
      LinagoraSidebarBadge(label: label),
      padding: 4,
    );
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

/// A chevron sits on the label's line, not on the paragraph around it.
///
/// The chevron is read as a box, not as ink: an icon font centres its glyph in
/// the square it is given, and the stand-in glyph a test renders does not.
Future<void> _labelMeetsTheChevron(WidgetTester tester) async {
  const label = 'Personal folders';
  final pixels = await _render(
    tester,
    const SizedBox(
      width: 220,
      child: LinagoraSidebarItem(
        label: label,
        icon: Icons.folder_outlined,
        expanded: true,
      ),
    ),
  );

  final labelInk = pixels.inkRows(150, within: find.text(label));
  final chevron = pixels.middleOf(find.byIcon(Icons.keyboard_arrow_down));

  expect(
    pixels.centreOf(labelInk),
    closeTo(chevron, _tolerance),
    reason: 'the label and the chevron are on different lines',
  );
}

Future<_Pixels> _render(
  WidgetTester tester,
  Widget child, {
  double padding = 0,
}) async {
  final key = GlobalKey();
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: RepaintBoundary(
            key: key,
            // Opaque, so the paint reads as plain darkness rather than as
            // alpha over nothing.
            child: ColoredBox(
              color: const Color(0xFFFFFFFF),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: child,
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
    tester: tester,
    origin: tester.getRect(find.byKey(key)).topLeft,
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
    required this.tester,
    required this.origin,
    required this.width,
    required this.height,
    required this.rgba,
  });

  final WidgetTester tester;

  /// Where the captured image starts, so a widget's rect can be read in it.
  final Offset origin;

  final int width;
  final int height;
  final Uint8List rgba;

  /// The rows holding anything darker than [red], top and bottom included, and
  /// optionally only across the columns a [within] widget occupies.
  List<int> inkRows(int red, {Finder? within}) {
    final columns = within == null
        ? (from: 0, to: width)
        : _columnsOf(tester.getRect(within));
    final rows = [
      for (var y = 0; y < height; y++)
        if (_darkestInRow(y, columns.from, columns.to) < red) y,
    ];
    expect(rows, isNotEmpty, reason: 'nothing was painted below $red');
    return rows;
  }

  /// The middle of a run of rows, in logical pixels down the image.
  double centreOf(List<int> rows) => (rows.first + rows.last) / 2 / _pixelRatio;

  /// The middle of a widget's box, in the same logical pixels.
  double middleOf(Finder finder) =>
      tester.getRect(finder).center.dy - origin.dy;

  ({int from, int to}) _columnsOf(Rect rect) {
    final local = rect.shift(-origin);
    return (
      from: (local.left * _pixelRatio).floor().clamp(0, width),
      to: (local.right * _pixelRatio).ceil().clamp(0, width),
    );
  }

  int _darkestInRow(int y, int from, int to) {
    var darkest = 255;
    for (var x = from; x < to; x++) {
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
