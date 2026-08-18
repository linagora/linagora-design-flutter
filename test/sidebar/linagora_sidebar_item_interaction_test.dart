import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

import 'linagora_sidebar_item_test_utils.dart';

void main() {
  testWidgets('renders a badge and calls onTap when enabled', _enabledTaps);
  testWidgets('does not call onTap when disabled', _disabledDoesNotTap);
  testWidgets(
    'swaps the badge for the hover trailing slot',
    onTargetPlatform(TargetPlatform.macOS, _hoverTrailing),
  );
  testWidgets(
    'keeps the focus ring visible while also hovered with a hoverTrailing slot',
    _focusRingSurvivesHover,
  );
  testWidgets('keeps Material touch feedback on every platform', _touchRipple);
  testWidgets(
    'keeps trailing actions independent from the row',
    _trailingAction,
  );
  testWidgets('styles text actions from the trailing token', _textActionStyle);
  testWidgets(
    'names a trailing action separately from the row',
    _trailingActionSemantics,
  );
  testWidgets(
    'handles tappable chevron interaction',
    _tappableChevronInteraction,
  );
  testWidgets('reports tappable chevron geometry', _tappableChevronGeometry);
  testWidgets('leaves the chevron inert without a toggle', _chevronInert);
  testWidgets('gives a tappable chevron a touch target', _chevronTapTarget);
  testWidgets('reports a secondary press', _secondaryPress);
  testWidgets('never hovers for a touch pointer', _touchDoesNotHover);
  testWidgets('renders a tooltip when given one', _tooltip);
  testWidgets('activates from the keyboard', _keyboardActivation);
  testWidgets(
    'ignores a mouse on a touch platform',
    onTargetPlatform(TargetPlatform.android, _mouseOnTouchPlatform),
  );
  testWidgets(
    'hovers on desktop without a browser',
    onTargetPlatform(TargetPlatform.macOS, _desktopHovers),
  );
  test(
    'validates the requirements for a tappable chevron',
    _validatesTappableChevron,
  );
}

Future<void> _enabledTaps(WidgetTester tester) async {
  var taps = 0;
  await pumpSidebarItem(
    tester,
    LinagoraSidebarItem(
      label: 'Action required',
      badgeLabel: '3',
      onTap: () => taps++,
    ),
  );

  expect(find.byType(LinagoraSidebarBadge), findsOneWidget);
  expect(find.text('3'), findsOneWidget);

  await tester.tap(find.text('Action required'));

  expect(taps, 1);
}

Future<void> _disabledDoesNotTap(WidgetTester tester) async {
  var taps = 0;
  await pumpSidebarItem(
    tester,
    LinagoraSidebarItem(label: 'Archives', enabled: false, onTap: () => taps++),
  );

  await tester.tap(find.text('Archives'));

  expect(taps, 0);
}

Future<void> _hoverTrailing(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(
      label: 'Spam',
      badgeLabel: '3',
      hoverTrailing: Text('Clean'),
      onTap: sidebarNoop,
    ),
  );

  expect(find.text('3'), findsOneWidget);
  expect(find.text('Clean'), findsNothing);

  await hoverSidebarItem(tester, find.text('Spam'));

  expect(find.text('Clean'), findsOneWidget);
  expect(find.text('3'), findsNothing);
}

/// `hoverTrailing` sets `suppressRowInkFeedback`, which routes `overlayColor`
/// through a resolver meant to keep a lone focus state visible while
/// suppressing everything else. It only checks `states.length == 1`, so a
/// row that is simultaneously keyboard-focused and pointer-hovered — the
/// common desktop/web case of tabbing to a row the mouse already rests on —
/// falls through to the same transparent branch as an unfocused hover.
Future<void> _focusRingSurvivesHover(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(
      label: 'Spam',
      hoverTrailing: Text('Clean'),
      onTap: sidebarNoop,
    ),
  );

  final inkWell = tester.widget<InkWell>(
    find.descendant(
      of: find.byType(LinagoraSidebarItem),
      matching: find.byType(InkWell),
    ),
  );

  expect(
    inkWell.overlayColor?.resolve({WidgetState.focused}),
    isNot(Colors.transparent),
  );
  expect(
    inkWell.overlayColor?.resolve({WidgetState.focused, WidgetState.hovered}),
    isNot(Colors.transparent),
    reason:
        'a keyboard-focused row must keep its focus ring even while the '
        'pointer also happens to be hovering it',
  );
}

Future<void> _touchRipple(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(label: 'Inbox', onTap: sidebarNoop),
  );

  final inkWell = tester.widget<InkWell>(find.byType(InkWell));

  expect(inkWell.hoverColor, Colors.transparent);
  expect(inkWell.splashColor, isNull);
  expect(inkWell.highlightColor, isNull);
}

Future<void> _trailingAction(WidgetTester tester) async {
  var rowTaps = 0;
  var cleanTaps = 0;
  await pumpSidebarItem(
    tester,
    LinagoraSidebarItem(
      label: 'Spam',
      onTap: () => rowTaps++,
      trailing: LinagoraSidebarItemAction(
        semanticLabel: 'Clean spam',
        onTap: () => cleanTaps++,
        child: const Text('Clean'),
      ),
    ),
  );

  await tester.tap(find.text('Clean'));

  expect(cleanTaps, 1);
  expect(rowTaps, 0);
  final action = find.byType(LinagoraSidebarItemAction);
  expect(
    find.ancestor(of: action, matching: find.byType(Material)),
    findsWidgets,
  );
  expect(
    find.descendant(of: action, matching: find.byType(InkWell)),
    findsOneWidget,
  );
  expect(
    tester
        .getSize(find.descendant(of: action, matching: find.byType(InkWell)))
        .height,
    LinagoraSidebarItemAction.minimumDimension,
  );
}

Future<void> _textActionStyle(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(
      label: 'Trash',
      trailing: LinagoraSidebarItemAction(
        semanticLabel: 'Clean Trash',
        onTap: sidebarNoop,
        child: Text('Clean'),
      ),
    ),
  );

  final action = find.byType(LinagoraSidebarItemAction);
  final textStyle = (tester
          .widget<RichText>(
            find.descendant(of: action, matching: find.byType(RichText)),
          )
          .text as TextSpan)
      .style!;

  expect(textStyle.fontSize, 11);
  expect(textStyle.height, 16 / 11);
  expect(textStyle.fontWeight, FontWeight.w500);
  expect(textStyle.letterSpacing, 0.5);
  expect(textStyle.color, LinagoraSidebarStyle.light().trailingForeground);
}

/// A screen reader reaches the action through its own node, so the row keeps
/// its own name and the action stays activatable on its own.
Future<void> _trailingActionSemantics(WidgetTester tester) async {
  final handle = tester.ensureSemantics();
  try {
    await pumpSidebarItem(
      tester,
      const LinagoraSidebarItem(
        label: 'Spam',
        onTap: sidebarNoop,
        trailing: LinagoraSidebarItemAction(
          semanticLabel: 'Clean spam',
          onTap: sidebarNoop,
          child: Text('Clean'),
        ),
      ),
    );

    expect(
      tester.getSemantics(find.byType(LinagoraSidebarItemAction)),
      matchesSemantics(
        label: 'Clean spam',
        isButton: true,
        isFocusable: true,
        hasTapAction: true,
        hasFocusAction: true,
      ),
    );
    expect(
      tester.getSemantics(find.byType(LinagoraSidebarItem)),
      containsSemantics(label: 'Spam'),
    );
  } finally {
    handle.dispose();
  }
}

Future<void> _tappableChevronInteraction(WidgetTester tester) async {
  final enabled = _ChevronCallbacks();
  await _tapTappableChevron(tester, enabled);
  expect((enabled.taps, enabled.toggles), (0, 1));

  await tester.tap(find.text('Folders'));
  expect((enabled.taps, enabled.toggles), (1, 1));

  final disabled = _ChevronCallbacks();
  await _tapTappableChevron(tester, disabled, enabled: false);
  expect(disabled.toggles, 0);
  expect(find.byType(InkResponse), findsNothing);
}

Future<void> _tappableChevronGeometry(WidgetTester tester) async {
  final _ExpandToggleRecorder recorder = _ExpandToggleRecorder();
  await pumpSidebarItem(
    tester,
    LinagoraSidebarItem(
      label: 'Folders',
      expanded: false,
      onExpandTogglePressed: recorder.press,
      expandToggleLabel: 'Expand',
    ),
  );

  await tester.tap(find.byIcon(Icons.keyboard_arrow_right));

  final details = recorder.details;
  expect(details, isNotNull);
  expect(
    details!.globalBounds.size,
    const Size.square(LinagoraSidebarControl.tapTarget),
  );
  expect(details.anchor.left, greaterThanOrEqualTo(0));
  expect(details.anchor.top, greaterThanOrEqualTo(0));
  expect(details.anchor.right, greaterThanOrEqualTo(0));
  expect(details.anchor.bottom, greaterThanOrEqualTo(0));
}

Future<void> _chevronInert(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    _chevronItem(const _ChevronItemConfiguration(expanded: true)),
  );

  expect(find.byType(InkResponse), findsNothing);
}

Future<void> _chevronTapTarget(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    _chevronItem(
      _ChevronItemConfiguration(
        expanded: true,
        callbacks: _ChevronCallbacks(),
        expandToggleLabel: 'Collapse',
      ),
    ),
  );

  final style = LinagoraSidebarStyle.light();
  final glyph = tester.getRect(find.byIcon(Icons.keyboard_arrow_down));
  final target = tester.getRect(find.byType(InkResponse));
  final label = tester.getRect(find.text('Folders'));

  expect(glyph.width, style.chevronSize);
  expect(target.width, greaterThanOrEqualTo(24));
  expect(glyph.left - label.right, closeTo(style.itemSpacing, 0.5));
  expect(tester.getSemantics(find.byType(InkResponse)).label, 'Collapse');
}

Future<void> _secondaryPress(WidgetTester tester) async {
  var presses = 0;
  await pumpSidebarItem(
    tester,
    LinagoraSidebarItem(
      label: 'Inbox',
      onTap: sidebarNoop,
      onSecondaryTapDown: (_) => presses++,
    ),
  );

  final mouse = await tester.createGesture(
    kind: PointerDeviceKind.mouse,
    buttons: kSecondaryMouseButton,
  );
  await mouse.downWithCustomEvent(
    tester.getCenter(find.text('Inbox')),
    PointerDownEvent(
      position: tester.getCenter(find.text('Inbox')),
      kind: PointerDeviceKind.mouse,
      buttons: kSecondaryMouseButton,
    ),
  );
  await mouse.up();
  await tester.pump();

  expect(presses, 1);
}

Future<void> _touchDoesNotHover(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(label: 'Inbox', onTap: sidebarNoop),
  );

  final touch = await tester.createGesture(kind: PointerDeviceKind.touch);
  addTearDown(() => touch.removePointer());
  await touch.addPointer(location: Offset.zero);
  await tester.pump();
  await touch.moveTo(tester.getCenter(find.text('Inbox')));
  await tester.pumpAndSettle();

  expect(sidebarBackground(tester), Colors.transparent);
}

Future<void> _tooltip(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(
      label: 'Inbox',
      tooltip: 'Inbox folder',
      onTap: sidebarNoop,
    ),
  );

  expect(tester.widget<Tooltip>(find.byType(Tooltip)).message, 'Inbox folder');
}

Future<void> _keyboardActivation(WidgetTester tester) async {
  var taps = 0;
  final focusNode = FocusNode();
  addTearDown(focusNode.dispose);

  await pumpSidebarItem(
    tester,
    LinagoraSidebarItem(
      label: 'Inbox',
      focusNode: focusNode,
      onTap: () => taps++,
    ),
  );

  focusNode.requestFocus();
  await tester.pump();
  await tester.sendKeyEvent(LogicalKeyboardKey.enter);
  await tester.pump();

  expect(taps, 1);
}

Future<void> _mouseOnTouchPlatform(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(label: 'Inbox', onTap: sidebarNoop),
  );

  await hoverSidebarItem(tester, find.text('Inbox'));

  expect(LinagoraSidebarItem.hoverSupported, isFalse);
  expect(sidebarBackground(tester), Colors.transparent);
}

Future<void> _desktopHovers(WidgetTester tester) async {
  await pumpSidebarItem(
    tester,
    const LinagoraSidebarItem(label: 'Inbox', onTap: sidebarNoop),
  );

  await hoverSidebarItem(tester, find.text('Inbox'));

  expect(LinagoraSidebarItem.hoverSupported, isTrue);
  expect(
    sidebarBackground(tester),
    LinagoraSidebarStyle.light().hoverBackground,
  );
}

void _validatesTappableChevron() {
  _expectChevronAssertion(
    () => _chevronItem(
      _ChevronItemConfiguration(
        callbacks: _ChevronCallbacks(),
        expandToggleLabel: 'Expand',
      ),
    ),
  );
  _expectChevronAssertion(
    () => _chevronItem(
      _ChevronItemConfiguration(
        expanded: false,
        callbacks: _ChevronCallbacks(),
      ),
    ),
  );
  _expectChevronAssertion(
    () => LinagoraSidebarItem(
      label: 'Folders',
      expanded: false,
      onExpandToggle: sidebarNoop,
      onExpandTogglePressed: _noopExpandToggle,
      expandToggleLabel: 'Expand',
    ),
  );
}

void _expectChevronAssertion(LinagoraSidebarItem Function() create) {
  expect(create, throwsAssertionError);
}

Future<void> _tapTappableChevron(
  WidgetTester tester,
  _ChevronCallbacks callbacks, {
  bool enabled = true,
}) async {
  await pumpSidebarItem(
    tester,
    _chevronItem(
      _ChevronItemConfiguration(
        expanded: false,
        enabled: enabled,
        callbacks: callbacks,
        expandToggleLabel: 'Expand',
      ),
    ),
  );
  await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
}

LinagoraSidebarItem _chevronItem(_ChevronItemConfiguration configuration) {
  final callbacks = configuration.callbacks;
  return LinagoraSidebarItem(
    label: 'Folders',
    expanded: configuration.expanded,
    enabled: configuration.enabled,
    onTap: callbacks?.onTap,
    onExpandToggle: callbacks?.onExpandToggle,
    expandToggleLabel: configuration.expandToggleLabel,
  );
}

class _ChevronItemConfiguration {
  const _ChevronItemConfiguration({
    this.expanded,
    this.enabled = true,
    this.callbacks,
    this.expandToggleLabel,
  });

  final bool? expanded;
  final bool enabled;
  final _ChevronCallbacks? callbacks;
  final String? expandToggleLabel;
}

class _ChevronCallbacks {
  int taps = 0;
  int toggles = 0;

  void onTap() => taps++;

  void onExpandToggle() => toggles++;
}

class _ExpandToggleRecorder {
  LinagoraSidebarActionDetails? details;

  Future<void> press(LinagoraSidebarActionDetails details) async {
    this.details = details;
  }
}

Future<void> _noopExpandToggle(LinagoraSidebarActionDetails details) async {}
