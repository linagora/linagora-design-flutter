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
