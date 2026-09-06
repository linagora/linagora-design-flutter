import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  for (final testCase in _tapTargetCases) {
    testWidgets(
      'uses the ${testCase.tapTargetSize.name} target in ${testCase.materialLabel}',
      (tester) => _tapTargetSize(tester, testCase),
    );
  }
  testWidgets(
    'supports a custom circular Material interaction boundary',
    _customMaterialInteractionBoundary,
  );
}

Future<void> _tapTargetSize(
  WidgetTester tester,
  _TapTargetCase testCase,
) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(useMaterial3: testCase.useMaterial3),
      home: Scaffold(
        body: Center(
          child: LinagoraIconButton(
            icon: Icons.more_vert,
            onPressed: _noop,
            tapTargetSize: testCase.tapTargetSize,
          ),
        ),
      ),
    ),
  );

  expect(
    tester.getSize(find.byType(IconButton)),
    testCase.expectedSize,
  );
}

Future<void> _customMaterialInteractionBoundary(WidgetTester tester) async {
  const padding = EdgeInsets.all(8);
  await tester.pumpWidget(
    const MaterialApp(
      home: Scaffold(
        body: Center(
          child: LinagoraIconButton(
            icon: Icons.content_copy,
            onPressed: _noop,
            padding: padding,
            shape: CircleBorder(),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.standard,
          ),
        ),
      ),
    ),
  );

  final button = tester.widget<IconButton>(find.byType(IconButton));
  expect(tester.getSize(find.byType(IconButton)), const Size.square(40));
  expect(button.padding, padding);
  expect(button.style!.shape!.resolve({}), isA<CircleBorder>());
}

const _tapTargetCases = [
  _TapTargetCase(
    useMaterial3: false,
    tapTargetSize: MaterialTapTargetSize.padded,
    expectedSize: Size.square(40),
  ),
  _TapTargetCase(
    useMaterial3: false,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    expectedSize: Size.square(32),
  ),
  _TapTargetCase(
    useMaterial3: true,
    tapTargetSize: MaterialTapTargetSize.padded,
    expectedSize: Size.square(40),
  ),
  _TapTargetCase(
    useMaterial3: true,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    expectedSize: Size(32, 24),
  ),
];

class _TapTargetCase {
  const _TapTargetCase({
    required this.useMaterial3,
    required this.tapTargetSize,
    required this.expectedSize,
  });

  final bool useMaterial3;
  final MaterialTapTargetSize tapTargetSize;
  final Size expectedSize;

  String get materialLabel => useMaterial3 ? 'Material 3' : 'Material 2';
}

void _noop() {}
