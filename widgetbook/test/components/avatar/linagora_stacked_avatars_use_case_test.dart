import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/components/avatar/linagora_stacked_avatars_use_case.dart';
import 'package:widgetbook_workspace/components/chips/linagora_dismissible_chip_use_case.dart';
import 'package:widgetbook_workspace/components/chips/linagora_status_badge_use_case.dart';

void main() {
  testWidgets('default knobs reach the stack', _defaultStack);
  testWidgets('the count knob drops every avatar', _emptyStack);
  testWidgets('the size knobs reach the stack', _sizeKnobs);
  testWidgets('default knobs reach the chip', _defaultChip);
  testWidgets('the leading knob removes the slot', _leadingKnob);
  testWidgets('the label knob reaches the chip', _labelKnob);
  testWidgets('default knobs reach the badge', _defaultBadge);
  testWidgets('the label knob reaches the badge', _badgeLabelKnob);
  testWidgets('the dark theme picks the dark styles', _darkStyles);
}

Future<void> _defaultStack(WidgetTester tester) async {
  await _pump(tester, const {}, linagoraStackedAvatarsUseCase);
  final stack = tester.widget<LinagoraStackedAvatars>(
    find.byType(LinagoraStackedAvatars),
  );
  expect(stack.avatars, hasLength(2));
  expect(stack.maxVisible, 3);
  expect(stack.style!.size, 32);
}

Future<void> _emptyStack(WidgetTester tester) async {
  await _pump(tester, const {'Avatars': '0'}, linagoraStackedAvatarsUseCase);
  expect(
    tester
        .widget<LinagoraStackedAvatars>(find.byType(LinagoraStackedAvatars))
        .avatars,
    isEmpty,
  );
}

Future<void> _sizeKnobs(WidgetTester tester) async {
  await _pump(tester, const {'Max visible': '1', 'Size': '24'},
      linagoraStackedAvatarsUseCase);
  final stack = tester.widget<LinagoraStackedAvatars>(
    find.byType(LinagoraStackedAvatars),
  );
  expect(stack.maxVisible, 1);
  expect(stack.style!.size, 24);
}

Future<void> _defaultChip(WidgetTester tester) async {
  await _pump(tester, const {}, linagoraDismissibleChipUseCase);
  final chip = tester.widget<LinagoraDismissibleChip>(
    find.byType(LinagoraDismissibleChip),
  );
  expect(chip.label, 'Viewing Nora Hale');
  expect(chip.leading, isA<RoundAvatar>());
  expect((chip.leading! as RoundAvatar).size, 16);
}

Future<void> _leadingKnob(WidgetTester tester) async {
  final chip = await _chip(tester, const {'Leading': 'false'});
  expect(chip.leading, isNull);
}

Future<void> _labelKnob(WidgetTester tester) async {
  final chip = await _chip(tester, const {'Label': 'Viewing Mira Calder'});
  expect(chip.label, 'Viewing Mira Calder');
}

Future<LinagoraDismissibleChip> _chip(
  WidgetTester tester,
  Map<String, String> knobs,
) async {
  await _pump(tester, knobs, linagoraDismissibleChipUseCase);
  return tester.widget<LinagoraDismissibleChip>(
    find.byType(LinagoraDismissibleChip),
  );
}

typedef _UseCaseBuilder = Widget Function(BuildContext context);

Future<void> _defaultBadge(WidgetTester tester) async {
  await _pump(tester, const {}, linagoraStatusBadgeUseCase);
  final badge = tester.widget<LinagoraStatusBadge>(
    find.byType(LinagoraStatusBadge),
  );
  expect(badge.label, 'Delegated mailbox');
  expect(badge.style, LinagoraStatusBadgeStyle.material());
}

Future<void> _badgeLabelKnob(WidgetTester tester) async {
  await _pump(
    tester,
    const {'Label': ''},
    linagoraStatusBadgeUseCase,
  );
  expect(
    tester.widget<LinagoraStatusBadge>(find.byType(LinagoraStatusBadge)).label,
    isEmpty,
  );
  await _pump(
    tester,
    const {'Label': 'Shared'},
    linagoraStatusBadgeUseCase,
  );
  expect(
    tester.widget<LinagoraStatusBadge>(find.byType(LinagoraStatusBadge)).label,
    'Shared',
  );
}

Future<void> _darkStyles(WidgetTester tester) async {
  await _pump(
    tester,
    const {},
    linagoraStackedAvatarsUseCase,
    brightness: Brightness.dark,
  );
  expect(
    tester.widget<LinagoraStackedAvatars>(find.byType(LinagoraStackedAvatars))
        .style!
        .ringColor,
    LinagoraStackedAvatarsStyle.dark().ringColor,
  );

  await _pump(
    tester,
    const {},
    linagoraDismissibleChipUseCase,
    brightness: Brightness.dark,
  );
  expect(
    tester.widget<LinagoraDismissibleChip>(find.byType(LinagoraDismissibleChip))
        .style,
    LinagoraDismissibleChipStyle.dark(),
  );

  await _pump(
    tester,
    const {},
    linagoraStatusBadgeUseCase,
    brightness: Brightness.dark,
  );
  expect(
    tester.widget<LinagoraStatusBadge>(find.byType(LinagoraStatusBadge)).style,
    LinagoraStatusBadgeStyle.dark(),
  );
}

Future<void> _pump(
  WidgetTester tester,
  Map<String, String> knobs,
  _UseCaseBuilder builder, {
  Brightness brightness = Brightness.light,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(brightness: brightness),
      home: WidgetbookScope(
        state: WidgetbookState(
          root: WidgetbookRoot(children: const []),
          queryParams: {'knobs': FieldCodec.encodeQueryGroup(knobs)},
        ),
        child: Scaffold(body: Builder(builder: builder)),
      ),
    ),
  );
}
