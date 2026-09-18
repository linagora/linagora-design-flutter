import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/components/banners/linagora_alert_use_case.dart';

void main() {
  testWidgets('the use case builds from its default knobs', _defaultKnobs);
  testWidgets('knobs reach the alert', _forwardsKnobs);
  testWidgets('booleans add each slot', _addsSlots);
}

/// The design system exports a `WidgetBuilder` of its own, so spell the
/// signature out rather than import an ambiguous name.
typedef _UseCase = Widget Function(BuildContext context);

/// Every use case reads knobs, so each one needs a Widgetbook scope even
/// when the test leaves the knobs at their defaults.
Future<void> _pumpUseCase(
  WidgetTester tester,
  _UseCase useCase, {
  Map<String, String> knobs = const {},
}) {
  final state = WidgetbookState(
    root: WidgetbookRoot(children: const []),
    queryParams: {'knobs': FieldCodec.encodeQueryGroup(knobs)},
  );

  return tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(
        textTheme: LinagoraTextTheme.material(),
        extensions: [LinagoraTextThemeExtension.material()],
      ),
      home: WidgetbookScope(
        state: state,
        child: Scaffold(body: Builder(builder: useCase)),
      ),
    ),
  );
}

LinagoraAlert _alert(WidgetTester tester) {
  return tester.widget<LinagoraAlert>(find.byType(LinagoraAlert).first);
}

Future<void> _defaultKnobs(WidgetTester tester) async {
  await _pumpUseCase(tester, linagoraAlertUseCase);

  expect(find.byType(LinagoraAlert), findsOneWidget);
  expect(tester.takeException(), isNull);
}

Future<void> _forwardsKnobs(WidgetTester tester) async {
  await _pumpUseCase(tester, linagoraAlertUseCase, knobs: {
    'Colour': 'success',
    'Variant': 'standard',
    'Size': 'compact',
    'Actions alignment': 'bottom',
    'Text alignment': 'center',
    'Message': 'Saved',
    'Title text': 'All good',
    'Live region': 'false',
  });

  final alert = _alert(tester);
  expect(alert.color, LinagoraAlertColor.success);
  expect(alert.variant, LinagoraAlertVariant.standard);
  expect(alert.size, LinagoraAlertSize.compact);
  expect(alert.actionsAlignment, LinagoraAlertActionsAlignment.bottom);
  expect(alert.textAlignment, LinagoraAlertTextAlignment.center);
  expect(alert.message, 'Saved');
  expect(alert.title, 'All good');
  expect(alert.liveRegion, isFalse);
  expect(tester.takeException(), isNull);
}

Future<void> _addsSlots(WidgetTester tester) async {
  await _pumpUseCase(tester, linagoraAlertUseCase, knobs: {
    'Title': 'false',
    'Icon': 'false',
    'Action': 'false',
    'Secondary action': 'true',
    'Close': 'true',
    'Arrow': 'true',
  });

  final alert = _alert(tester);
  expect(alert.title, isNull);
  expect(alert.showIcon, isFalse);
  expect(alert.onActionPressed, isNull);
  expect(alert.onSecondaryActionPressed, isNotNull);
  expect(alert.onClose, isNotNull);
  expect(alert.showPointer, isTrue);
  expect(tester.takeException(), isNull);
}
