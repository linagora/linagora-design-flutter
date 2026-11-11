import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/components/account_switcher/linagora_account_switcher_use_case.dart';

void main() {
  testWidgets('default knobs reach the chip', _defaultKnobsReachTheChip);
  testWidgets('the selected account updates the chip', _selectedUpdatesChip);
  testWidgets('the avatar knob removes the leading slot', _avatarKnob);
  testWidgets('the compact knob drops the label', _compactKnob);
  testWidgets('the dark theme picks the dark style', _darkTheme);
  testWidgets('default menu knobs show the header and footer', _defaultMenu);
  testWidgets('menu knobs add the header and footer', _menuKnobs);
  testWidgets('status badge shows under the header', _statusBadge);
  testWidgets('the dark theme picks the dark menu style', _darkMenuTheme);
}

Future<void> _defaultKnobsReachTheChip(WidgetTester tester) async {
  final switcher = await _useCaseWidget<LinagoraAccountSwitcher<String>>(
    tester,
    const {},
    linagoraAccountSwitcherUseCase,
  );
  expect(switcher.label, 'Viewing Nora Hale');
  expect(switcher.avatar, isNotNull);
  expect(switcher.selectedId, 'me');
  expect(switcher.style, LinagoraAccountSwitcherStyle.material());
}

Future<void> _selectedUpdatesChip(WidgetTester tester) async {
  await _useCaseWidget<LinagoraAccountSwitcher<String>>(
    tester,
    const {},
    linagoraAccountSwitcherUseCase,
  );
  await tester.tap(find.byKey(LinagoraAccountSwitcher.chipKey));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(LinagoraAccountMenu.itemKey('delegated-1')));
  await tester.pumpAndSettle();
  final switcher = tester.widget<LinagoraAccountSwitcher<String>>(
    find.byType(LinagoraAccountSwitcher<String>),
  );
  expect(switcher.selectedId, 'delegated-1');
  expect(switcher.label, 'Viewing Mira Calder');
}

Future<void> _avatarKnob(WidgetTester tester) async {
  final switcher = await _useCaseWidget<LinagoraAccountSwitcher<String>>(
    tester,
    const {'Avatar': 'false'},
    linagoraAccountSwitcherUseCase,
  );
  expect(switcher.avatar, isNull);
}

Future<void> _compactKnob(WidgetTester tester) async {
  final switcher = await _useCaseWidget<LinagoraAccountSwitcher<String>>(
    tester,
    const {'Compact': 'true'},
    linagoraAccountSwitcherUseCase,
  );
  final expected = LinagoraAccountSwitcherStyle.material().compact();
  expect(switcher.label, isNull);
  expect(switcher.semanticLabel, 'Switch mailbox');
  expect(switcher.style?.chipHeight, expected.chipHeight);
  expect(switcher.style?.chipRadius, expected.chipRadius);
  expect(switcher.style?.chipAvatarSize, expected.chipAvatarSize);
  expect(switcher.style?.chipBorderColor, expected.chipBorderColor);
  expect(switcher.style?.chipColor, expected.chipColor);
}

Future<void> _darkTheme(WidgetTester tester) async {
  final switcher = await _useCaseWidget<LinagoraAccountSwitcher<String>>(
    tester,
    const {},
    linagoraAccountSwitcherUseCase,
    brightness: Brightness.dark,
  );
  expect(switcher.style, LinagoraAccountSwitcherStyle.dark());
}

Future<void> _defaultMenu(WidgetTester tester) async {
  final menu = await _useCaseWidget<LinagoraAccountMenu<String>>(
    tester,
    const {},
    linagoraAccountMenuUseCase,
  );
  expect(menu.header, isA<LinagoraAccountMenuHeader>());
  expect(menu.footer, isA<LinagoraAccountMenuActions>());
  expect(find.text('Sign out'), findsOneWidget);
  expect(find.text('Manage account'), findsOneWidget);
  expect(menu.style?.menuWidth, 326);
  expect(find.byType(Scrollbar), findsWidgets);
}

Future<void> _menuKnobs(WidgetTester tester) async {
  final menu = await _useCaseWidget<LinagoraAccountMenu<String>>(
    tester,
    const {'Header': 'false', 'Footer': 'false'},
    linagoraAccountMenuUseCase,
  );
  expect(menu.header, isNull);
  expect(menu.footer, isNull);
  expect(find.text('Sign out'), findsNothing);
}

Future<void> _statusBadge(WidgetTester tester) async {
  await _useCaseWidget<LinagoraAccountMenu<String>>(
    tester,
    const {'Status badge': 'true'},
    linagoraAccountMenuUseCase,
  );
  expect(find.text('Personal mailbox'), findsOneWidget);
}

Future<void> _darkMenuTheme(WidgetTester tester) async {
  final menu = await _useCaseWidget<LinagoraAccountMenu<String>>(
    tester,
    const {},
    linagoraAccountMenuUseCase,
    brightness: Brightness.dark,
  );
  expect(menu.style?.menuWidth, 326);
  expect(
    menu.style?.menuColor,
    LinagoraAccountSwitcherStyle.dark().avatarMenu().menuColor,
  );
}

Future<W> _useCaseWidget<W extends Widget>(
  WidgetTester tester,
  Map<String, String> knobs,
  Widget Function(BuildContext context) builder, {
  Brightness brightness = Brightness.light,
}) async {
  await tester.pumpWidget(
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
  return tester.widget<W>(find.byType(W));
}
