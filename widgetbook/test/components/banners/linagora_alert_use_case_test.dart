import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/components/banners/linagora_alert_use_case.dart';

void main() {
  testWidgets('the use case builds from its default knobs', _defaultKnobs);
  testWidgets('knobs reach the alert', _forwardsKnobs);
  testWidgets('action knobs reach both action models', _forwardsActionKnobs);
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
  final alert = _alert(tester);
  expect(alert.action?.label, 'Not spam');
  expect(alert.action?.onPressed, isNotNull);
  expect(alert.action?.icon, isNull);
  expect(alert.secondaryAction, isNull);
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

Future<void> _forwardsActionKnobs(WidgetTester tester) async {
  await _pumpUseCase(tester, linagoraAlertUseCase, knobs: {
    'Action label': 'Move to inbox',
    'Action icon': 'true',
    'Secondary action': 'true',
    'Secondary action label': 'Report sender',
  });

  final alert = _alert(tester);
  expect(alert.action?.label, 'Move to inbox');
  expect(alert.action?.onPressed, isNotNull);
  expect(alert.action?.icon, Icons.shield_outlined);
  expect(alert.secondaryAction?.label, 'Report sender');
  expect(alert.secondaryAction?.onPressed, isNotNull);
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
  expect(alert.action, isNull);
  expect(alert.secondaryAction?.label, 'Report phishing');
  expect(alert.secondaryAction?.onPressed, isNotNull);
  expect(alert.onClose, isNotNull);
  expect(alert.showPointer, isTrue);
  expect(tester.takeException(), isNull);
}
