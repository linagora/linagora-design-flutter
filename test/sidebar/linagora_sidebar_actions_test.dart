import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

import 'linagora_sidebar_test_utils.dart';

void main() {
  testWidgets(
    'keeps hover actions visible and the row unhovered while a menu is open',
    _menuActionKeepsTrailingVisible,
  );
  testWidgets('blocks repeated menu activation while pending', _blocksReentry);
  testWidgets('accepts a menu future with a result', _menuResultFuture);
  testWidgets('resets a declined menu action immediately', _declinedMenuResets);
  testWidgets('resets a failed menu action without re-raising', _failedMenuResets);
  testWidgets('survives disposal while a menu is pending', _disposedWhilePending);
  testWidgets('hides sibling actions while one is open', _twoActionsInOneRow);
  testWidgets('keeps an open action active when stable entries reorder', _reorderedActions);
  testWidgets('hugs its content inside a bounded parent', _actionHugsItsContent);
  testWidgets('reports a point menu anchor in root overlay coordinates', _pointAnchor);
  testWidgets('reports a menu anchor below the action', _belowMenuAnchor);
  testWidgets('centres text actions in their Material', _centresTextAction);
  testWidgets('does not select a row while Clean opens', _popoverDoesNotTapRow);
  testWidgets('closes a popover from its barrier', _popoverBarrierDismissal);
  testWidgets('closes a popover from Escape', _popoverEscapeDismissal);
  testWidgets('labels a modal popover route', _popoverModalSemantics);
  testWidgets('closes a popover on a route change', _popoverRouteDismissal);
  testWidgets('keeps the row flat under an open popover', _popoverKeepsRowFlat);
  testWidgets('lays out a popover at its content size', _popoverContentSize);
  testWidgets('wraps popover content and restores focus', _popoverWrapperAndFocus);
  testWidgets('keeps a non-dismissible popover open', _popoverBarrierOptOut);
  testWidgets('mirrors popover placement in RTL', _popoverRtlPlacement);
  testWidgets('washes an active action from the dark token', _darkActiveWash);
  testWidgets('section headers report disclosure geometry', _headerGeometry);
  testWidgets('rejects two disclosure callbacks at once', _headerCallbackAssert);
  testWidgets('confirmation popover mirrors its arrow in RTL', _confirmPopover);
  testWidgets('colours the confirm button from the tokens', _confirmColours);
  testWidgets(
    'blocks a trailing action while the row is disabled',
    _disabledRowBlocksAction,
  );
}

Future<void> _menuActionKeepsTrailingVisible(WidgetTester tester) async {
  final hovering = ValueNotifier(true);
  final completion = Completer<void>();
  var rowTapCount = 0;

  await pumpSidebar(
    tester,
    ValueListenableBuilder<bool>(
      valueListenable: hovering,
      builder: (context, isHovered, child) => LinagoraSidebarItem(
        label: 'Spam',
        badgeLabel: '3',
        hovered: isHovered,
        onTap: () => rowTapCount++,
        hoverTrailing: LinagoraSidebarItemActions(
          actions: [
            LinagoraSidebarItemActionEntry(
              id: 'more-spam',
              child: LinagoraSidebarMenuAction(
              semanticLabel: 'More Spam actions',
              child: const Icon(Icons.more_horiz),
              onPressed: (_) => completion.future,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  expect(find.text('3'), findsNothing);
  await tester.tap(find.bySemanticsLabel('More Spam actions'));
  await tester.pump();

  expect(_actionOf(tester).active, isTrue);
  expect(_rowMaterialOf(tester).color, Colors.transparent);
  expect(_rowInkWellOf(tester).splashColor, Colors.transparent);
  expect(_rowInkWellOf(tester).highlightColor, Colors.transparent);
  expect(rowTapCount, 0);

  hovering.value = false;
  await tester.pump();

  // The pointer left, but the open menu keeps its trigger on screen.
  expect(find.bySemanticsLabel('More Spam actions'), findsOneWidget);
  expect(find.text('3'), findsNothing);
  expect(_rowMaterialOf(tester).color, Colors.transparent);

  completion.complete();
  await tester.pump();

  expect(find.bySemanticsLabel('More Spam actions'), findsNothing);
  expect(find.text('3'), findsOneWidget);
}

Future<void> _blocksReentry(WidgetTester tester) async {
  var calls = 0;
  final completion = Completer<void>();
  await pumpSidebar(
    tester,
    LinagoraSidebarMenuAction(
      semanticLabel: 'More actions',
      child: const Icon(Icons.more_horiz),
      onPressed: (_) {
        calls++;
        return completion.future;
      },
    ),
  );

  await tester.tap(find.bySemanticsLabel('More actions'));
  await tester.tap(find.bySemanticsLabel('More actions'));
  await tester.pump();

  expect(calls, 1);
  completion.complete();
  await tester.pump();
}

Future<void> _menuResultFuture(WidgetTester tester) async {
  final completion = Completer<String?>();
  await pumpSidebar(
    tester,
    LinagoraSidebarMenuAction(
      semanticLabel: 'More actions',
      child: const Icon(Icons.more_horiz),
      onPressed: (_) => completion.future,
    ),
  );

  await tester.tap(find.bySemanticsLabel('More actions'));
  await tester.pump();
  expect(_actionOf(tester).active, isTrue);

  completion.complete('Mark as read');
  await tester.pump();
  expect(_actionOf(tester).active, isFalse);
}

Future<void> _declinedMenuResets(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    const LinagoraSidebarMenuAction(
      semanticLabel: 'Unavailable menu',
      onPressed: _noMenu,
      child: Icon(Icons.more_horiz),
    ),
  );

  await tester.tap(find.bySemanticsLabel('Unavailable menu'));
  await tester.pump();

  expect(
    tester.widget<LinagoraSidebarItemAction>(
      find.byType(LinagoraSidebarItemAction),
    ).active,
    isFalse,
  );
}

Future<void>? _noMenu(LinagoraSidebarActionDetails details) => null;

/// Re-raising the product's failure would surface it a second time, from a
/// future nobody awaits — which fails this test outright.
Future<void> _failedMenuResets(WidgetTester tester) async {
  final completion = Completer<void>();
  await pumpSidebar(
    tester,
    LinagoraSidebarMenuAction(
      semanticLabel: 'More actions',
      child: const Icon(Icons.more_horiz),
      onPressed: (_) => completion.future,
    ),
  );

  await tester.tap(find.bySemanticsLabel('More actions'));
  await tester.pump();
  expect(_actionOf(tester).active, isTrue);

  completion.completeError(StateError('the product menu failed'));
  await tester.pump();

  expect(_actionOf(tester).active, isFalse);
}

Future<void> _disposedWhilePending(WidgetTester tester) async {
  final completion = Completer<void>();
  await pumpSidebar(
    tester,
    LinagoraSidebarItem(
      label: 'Spam',
      hovered: true,
      onTap: () {},
      hoverTrailing: LinagoraSidebarItemActions(
        actions: [
          LinagoraSidebarItemActionEntry(
            id: 'more-spam',
            child: LinagoraSidebarMenuAction(
            semanticLabel: 'More Spam actions',
            child: const Icon(Icons.more_horiz),
            onPressed: (_) => completion.future,
            ),
          ),
        ],
      ),
    ),
  );

  await tester.tap(find.bySemanticsLabel('More Spam actions'));
  await tester.pump();

  // A virtualized sidebar recycles the row while its menu is still open.
  await pumpSidebar(tester, const SizedBox.shrink());
  completion.complete();
  await tester.pump();

  expect(tester.takeException(), isNull);
}

Future<void> _twoActionsInOneRow(WidgetTester tester) async {
  final row = _TwoActionsRow();
  addTearDown(row.dispose);
  await pumpSidebar(tester, row.widget);

  final positions = row.positions(tester);
  await row.openClean(tester);
  _expectCleanOnly(tester, row, positions);

  await row.closeClean(tester);
  expect(find.bySemanticsLabel('Clean Spam'), findsNothing);
  expect(find.text('3'), findsOneWidget);

  await row.showActions(tester);
  await row.openMore(tester);
  _expectMoreOnly(tester, row, positions);

  row.completeMore();
  await tester.pump();
  expect(find.bySemanticsLabel('Clean Spam'), findsOneWidget);
  expect(find.bySemanticsLabel('More Spam actions'), findsOneWidget);
}

Future<void> _reorderedActions(WidgetTester tester) async {
  const cleanKey = Key('reordered-clean-action');
  const moreKey = Key('reordered-more-action');
  final reversed = ValueNotifier(false);
  final completion = Completer<void>();
  addTearDown(reversed.dispose);

  await pumpSidebar(
    tester,
    ValueListenableBuilder<bool>(
      valueListenable: reversed,
      builder: (context, isReversed, child) {
        const clean = LinagoraSidebarItemActionEntry(
          id: 'clean',
          child: LinagoraSidebarItemAction(
            key: cleanKey,
            semanticLabel: 'Clean Spam',
            onTap: _noop,
            child: Text('Clean'),
          ),
        );
        final more = LinagoraSidebarItemActionEntry(
          id: 'more',
          child: LinagoraSidebarMenuAction(
            key: moreKey,
            semanticLabel: 'More Spam actions',
            child: const Icon(Icons.more_horiz),
            onPressed: (_) => completion.future,
          ),
        );
        return LinagoraSidebarItem(
          label: 'Spam',
          hovered: true,
          onTap: _noop,
          hoverTrailing: LinagoraSidebarItemActions(
            actions: isReversed ? [more, clean] : [clean, more],
          ),
        );
      },
    ),
  );

  await tester.tap(find.bySemanticsLabel('More Spam actions'));
  await tester.pump();
  reversed.value = true;
  await tester.pump();

  expect(find.bySemanticsLabel('More Spam actions'), findsOneWidget);
  expect(_visibilityOf(tester, find.byKey(cleanKey)).visible, isFalse);
  expect(_visibilityOf(tester, find.byKey(moreKey)).visible, isTrue);

  completion.complete();
  await tester.pump();
  expect(_visibilityOf(tester, find.byKey(cleanKey)).visible, isTrue);
  expect(find.bySemanticsLabel('More Spam actions'), findsOneWidget);
}

class _TwoActionsRow {
  static const cleanActionKey = Key('clean-spam-action');
  static const moreActionKey = Key('more-spam-action');

  final hovering = ValueNotifier(true);
  final _moreCompletion = Completer<void>();

  Finder get cleanAction => find.byKey(cleanActionKey);
  Finder get moreAction => find.byKey(moreActionKey);

  Widget get widget => ValueListenableBuilder<bool>(
    valueListenable: hovering,
    builder: (context, isHovered, child) => LinagoraSidebarItem(
      label: 'Spam',
      badgeLabel: '3',
      hovered: isHovered,
      onTap: _noop,
      hoverTrailing: LinagoraSidebarItemActions(
        actions: [
          LinagoraSidebarItemActionEntry(
            id: 'clean-spam',
            child: LinagoraSidebarPopoverAction(
            key: cleanActionKey,
            semanticLabel: 'Clean Spam',
            child: const Text('Clean'),
            popoverBuilder: (context, close) => Material(
              child: TextButton(
                onPressed: close,
                child: const Text('Close Clean'),
              ),
            ),
            ),
          ),
          LinagoraSidebarItemActionEntry(
            id: 'more-spam',
            child: LinagoraSidebarMenuAction(
            key: moreActionKey,
            semanticLabel: 'More Spam actions',
            child: const Icon(Icons.more_horiz),
            onPressed: (_) => _moreCompletion.future,
            ),
          ),
        ],
      ),
    ),
  );

  _ActionPositions positions(WidgetTester tester) => _ActionPositions(
    clean: tester.getCenter(cleanAction),
    more: tester.getCenter(moreAction),
  );

  Future<void> openClean(WidgetTester tester) async {
    await tester.tap(find.bySemanticsLabel('Clean Spam'));
    await tester.pump();
    hovering.value = false;
    await tester.pump();
  }

  Future<void> closeClean(WidgetTester tester) async {
    await tester.tap(find.text('Close Clean'));
    await tester.pump();
  }

  Future<void> showActions(WidgetTester tester) async {
    hovering.value = true;
    await tester.pump();
    expect(find.bySemanticsLabel('Clean Spam'), findsOneWidget);
    expect(find.bySemanticsLabel('More Spam actions'), findsOneWidget);
  }

  Future<void> openMore(WidgetTester tester) async {
    await tester.tap(find.bySemanticsLabel('More Spam actions'));
    await tester.pump();
  }

  void completeMore() => _moreCompletion.complete();

  void dispose() => hovering.dispose();
}

class _ActionPositions {
  const _ActionPositions({required this.clean, required this.more});

  final Offset clean;
  final Offset more;
}

void _expectCleanOnly(
  WidgetTester tester,
  _TwoActionsRow row,
  _ActionPositions positions,
) {
  // The active trigger stays put, but its sibling cannot compete with the
  // product UI it opened.
  expect(find.bySemanticsLabel('Clean Spam'), findsOneWidget);
  expect(_visibilityOf(tester, row.moreAction).visible, isFalse);
  expect(find.text('3'), findsNothing);
  expect(tester.getCenter(row.cleanAction), positions.clean);
  expect(tester.getCenter(row.moreAction), positions.more);
}

void _expectMoreOnly(
  WidgetTester tester,
  _TwoActionsRow row,
  _ActionPositions positions,
) {
  expect(_visibilityOf(tester, row.cleanAction).visible, isFalse);
  expect(find.bySemanticsLabel('More Spam actions'), findsOneWidget);
  expect(tester.getCenter(row.cleanAction), positions.clean);
  expect(tester.getCenter(row.moreAction), positions.more);
}

Future<void> _actionHugsItsContent(WidgetTester tester) async {
  const actionKey = Key('clean-action');
  // Align hands down loose constraints, the shape a real trailing slot has.
  await pumpSidebar(
    tester,
    const Align(
      alignment: AlignmentDirectional.centerStart,
      child: LinagoraSidebarItemAction(
        key: actionKey,
        semanticLabel: 'Clean Spam',
        onTap: _noop,
        active: true,
        padding: LinagoraSidebarItemAction.textPadding,
        child: Text('Clean'),
      ),
    ),
  );

  final wash = tester.getSize(
    find.descendant(of: find.byKey(actionKey), matching: find.byType(Material)),
  );
  final label = tester.getSize(find.text('Clean'));
  final washCenter = tester.getCenter(
    find.descendant(of: find.byKey(actionKey), matching: find.byType(Material)),
  );
  final labelCenter = tester.getCenter(find.text('Clean'));

  // The active wash is a pill around the label, not a bar across the row.
  expect(wash.width, lessThan(sidebarWidth));
  expect(wash.width, closeTo(label.width + 16, 0.01));
  expect(labelCenter.dy, closeTo(washCenter.dy, 0.01));
}

void _noop() {}

Visibility _visibilityOf(WidgetTester tester, Finder action) =>
    tester.widget<Visibility>(
      find.ancestor(of: action, matching: find.byType(Visibility)),
    );

Material _rowMaterialOf(WidgetTester tester) => tester.widget<Material>(
  find
      .descendant(
        of: find.byType(LinagoraSidebarItem),
        matching: find.byType(Material),
      )
      .first,
);

InkWell _rowInkWellOf(WidgetTester tester) => tester.widget<InkWell>(
  find
      .descendant(
        of: find.byType(LinagoraSidebarItem),
        matching: find.byType(InkWell),
      )
      .first,
);

LinagoraSidebarItemAction _actionOf(WidgetTester tester) =>
    tester.widget<LinagoraSidebarItemAction>(
      find.byType(LinagoraSidebarItemAction),
    );

Future<void> _pointAnchor(WidgetTester tester) async {
  LinagoraSidebarActionDetails? details;
  await pumpSidebar(
    tester,
    LinagoraSidebarItemAction(
      semanticLabel: 'More actions',
      child: const Icon(Icons.more_horiz),
      onPressed: (value) async => details = value,
    ),
  );

  await tester.tap(find.bySemanticsLabel('More actions'));
  await tester.pump();

  final value = details!;
  final centre = value.overlayBounds.center;

  expect(
    value.pointAnchor,
    RelativeRect.fromLTRB(
      centre.dx,
      centre.dy,
      value.overlaySize.width - centre.dx,
      value.overlaySize.height - centre.dy,
    ),
  );
}

Future<void> _belowMenuAnchor(WidgetTester tester) async {
  LinagoraSidebarActionDetails? details;
  await pumpSidebar(
    tester,
    LinagoraSidebarItemAction(
      semanticLabel: 'More actions',
      child: const Icon(Icons.more_horiz),
      onPressed: (value) async => details = value,
    ),
  );

  await tester.tap(find.bySemanticsLabel('More actions'));
  await tester.pump();

  final value = details!;
  final bounds = value.overlayBounds;
  final size = value.overlaySize;
  final below = size.height - bounds.bottom;

  // A zero-size rect under the leading edge, mirrored for RTL.
  expect(
    value.belowMenuAnchor(TextDirection.ltr),
    RelativeRect.fromLTRB(
      bounds.left,
      bounds.bottom,
      size.width - bounds.left,
      below,
    ),
  );
  expect(
    value.belowMenuAnchor(TextDirection.rtl),
    RelativeRect.fromLTRB(
      bounds.right,
      bounds.bottom,
      size.width - bounds.right,
      below,
    ),
  );
}

Future<void> _centresTextAction(WidgetTester tester) async {
  const actionKey = Key('clean-action');
  await pumpSidebar(
    tester,
    const LinagoraSidebarItem(
      label: 'Spam',
      hovered: true,
      onTap: _noop,
      hoverTrailing: LinagoraSidebarItemActions(
        actions: [
          LinagoraSidebarItemActionEntry(
            id: 'clean-spam',
            child: LinagoraSidebarItemAction(
            key: actionKey,
            semanticLabel: 'Clean Spam',
            onTap: _noop,
            active: true,
            padding: LinagoraSidebarItemAction.textPadding,
            child: Text('Clean'),
            ),
          ),
        ],
      ),
    ),
  );

  final material = find.descendant(
    of: find.byKey(actionKey),
    matching: find.byType(Material),
  );
  final text = find.text('Clean');

  expect(
    tester.getCenter(text).dx,
    closeTo(tester.getCenter(material).dx, 0.01),
  );
  expect(
    tester.getCenter(text).dy,
    closeTo(tester.getCenter(material).dy, 0.01),
  );
  expect(
    tester.getSize(material).width,
    closeTo(tester.getSize(text).width + 16, 0.01),
  );
}

Future<void> _popoverDoesNotTapRow(WidgetTester tester) async {
  var rowTapCount = 0;
  await pumpSidebar(
    tester,
    LinagoraSidebarItem(
      label: 'Spam',
      hovered: true,
      onTap: () => rowTapCount++,
      hoverTrailing: LinagoraSidebarItemActions(
        actions: [
          LinagoraSidebarItemActionEntry(
            id: 'clean-spam',
            child: LinagoraSidebarPopoverAction(
            semanticLabel: 'Clean Spam',
            popoverBuilder: (context, close) => const Material(
              child: Text('Confirm clear'),
            ),
            child: const Text('Clean'),
            ),
          ),
        ],
      ),
    ),
  );

  await tester.tap(find.bySemanticsLabel('Clean Spam'));
  await tester.pump();

  expect(find.text('Confirm clear'), findsOneWidget);
  expect(rowTapCount, 0);
}

/// Opens a popover trigger inside a row, and reports every visibility change.
Future<List<bool>> _openPopoverRow(WidgetTester tester) async {
  final visibility = <bool>[];
  await pumpSidebar(
    tester,
    LinagoraSidebarItem(
      label: 'Spam',
      hovered: true,
      onTap: () {},
      hoverTrailing: LinagoraSidebarItemActions(
        actions: [
          LinagoraSidebarItemActionEntry(
            id: 'clean-spam',
            child: LinagoraSidebarPopoverAction(
            semanticLabel: 'Clean Spam',
            onVisibleChange: visibility.add,
            popoverBuilder: (context, close) => Material(
              child: TextButton(
                onPressed: close,
                child: const Text('Confirm clear'),
              ),
            ),
            child: const Text('Clean'),
            ),
          ),
        ],
      ),
    ),
  );

  await tester.tap(find.bySemanticsLabel('Clean Spam'));
  await tester.pump();
  return visibility;
}

Future<void> _popoverBarrierDismissal(WidgetTester tester) async {
  final visibility = await _openPopoverRow(tester);
  expect(find.text('Confirm clear'), findsOneWidget);

  await tester.tapAt(const Offset(700, 500));
  await tester.pump();

  expect(find.text('Confirm clear'), findsNothing);
  expect(visibility, [true, false]);
}

Future<void> _popoverEscapeDismissal(WidgetTester tester) async {
  final visibility = await _openPopoverRow(tester);

  await tester.sendKeyEvent(LogicalKeyboardKey.escape);
  await tester.pump();

  expect(find.text('Confirm clear'), findsNothing);
  expect(visibility, [true, false]);
}

Future<void> _popoverModalSemantics(WidgetTester tester) async {
  final semantics = tester.ensureSemantics();
  await pumpSidebar(
    tester,
    LinagoraSidebarPopoverAction(
      semanticLabel: 'Clean Spam',
      modalSemanticLabel: 'Clear folder',
      popoverBuilder: (context, close) => const Material(
        child: Text('Confirm clear'),
      ),
      child: const Text('Clean'),
    ),
  );

  await tester.tap(find.bySemanticsLabel('Clean Spam'));
  await tester.pump();

  final modal = tester.getSemantics(find.bySemanticsLabel('Clear folder'));
  expect(modal.flagsCollection.scopesRoute, isTrue);
  expect(modal.flagsCollection.namesRoute, isTrue);
  semantics.dispose();
}

/// Navigating away must close a popover that lives in the root overlay, where
/// the outgoing route cannot take it along.
Future<void> _popoverRouteDismissal(WidgetTester tester) async {
  final visibility = await _openPopoverRow(tester);
  final navigator = Navigator.of(
    tester.element(find.byType(LinagoraSidebarPopoverAction)),
  );

  unawaited(
    navigator.push<void>(
      MaterialPageRoute<void>(builder: (context) => const SizedBox.shrink()),
    ),
  );
  await tester.pumpAndSettle();

  expect(visibility, [true, false]);

  navigator.pop();
  await tester.pumpAndSettle();

  expect(find.text('Confirm clear'), findsNothing);
}

/// The trigger carries the open state; the row behind it stays flat.
Future<void> _popoverKeepsRowFlat(WidgetTester tester) async {
  await _openPopoverRow(tester);

  final rowMaterial = tester.widget<Material>(
    find.descendant(
      of: find.byType(LinagoraSidebarItem),
      matching: find.byType(Material),
    ).first,
  );
  final rowInkWell = tester.widget<InkWell>(
    find.descendant(
      of: find.byType(LinagoraSidebarItem),
      matching: find.byType(InkWell),
    ).first,
  );
  final actionMaterial = tester.widget<Material>(
    find.descendant(
      of: find.byType(LinagoraSidebarItemAction),
      matching: find.byType(Material),
    ),
  );

  expect(rowMaterial.color, Colors.transparent);
  expect(actionMaterial.color, isNot(Colors.transparent));
  expect(
    (
      rowInkWell.overlayColor?.resolve({WidgetState.pressed}),
      rowInkWell.overlayColor?.resolve({WidgetState.hovered}),
      rowInkWell.overlayColor?.resolve({WidgetState.focused}),
      rowInkWell.overlayColor?.resolve({
        WidgetState.focused,
        WidgetState.hovered,
      }),
    ),
    (
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
    ),
  );
}

Future<void> _popoverContentSize(WidgetTester tester) async {
  const contentKey = Key('popover-content');
  await pumpSidebar(
    tester,
    LinagoraSidebarPopoverAction(
      semanticLabel: 'Open sized popover',
      popoverBuilder: (context, close) => SizedBox(
        key: contentKey,
        width: 300,
        height: 100,
        child: Material(
          child: TextButton(onPressed: close, child: const Text('Close')),
        ),
      ),
      child: const Icon(Icons.more_horiz),
    ),
  );

  await tester.tap(find.bySemanticsLabel('Open sized popover'));
  await tester.pump();

  expect(tester.getSize(find.byKey(contentKey)), const Size(300, 100));
}

Future<void> _popoverWrapperAndFocus(WidgetTester tester) async {
  const wrapperKey = Key('overlay-wrapper');
  await pumpSidebar(
    tester,
    LinagoraSidebarPopoverAction(
      semanticLabel: 'Clean Spam',
      overlayWrapper: (child) => KeyedSubtree(key: wrapperKey, child: child),
      popoverBuilder: (context, close) => Material(
        child: TextButton(onPressed: close, child: const Text('Confirm clear')),
      ),
      child: const Text('Clean'),
    ),
  );

  await tester.tap(find.bySemanticsLabel('Clean Spam'));
  await tester.pumpAndSettle();

  // The escape hatch a web product needs for PointerInterceptor.
  expect(
    find.descendant(of: find.byKey(wrapperKey), matching: find.text('Confirm clear')),
    findsOneWidget,
  );

  await tester.tap(find.text('Confirm clear'));
  await tester.pumpAndSettle();

  final trigger = tester.widget<InkWell>(
    find.descendant(
      of: find.byType(LinagoraSidebarPopoverAction),
      matching: find.byType(InkWell),
    ),
  );
  // Focus returns to the trigger, so traversal resumes where it left.
  expect(trigger.focusNode?.hasFocus, isTrue);
}

Future<void> _popoverBarrierOptOut(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    LinagoraSidebarPopoverAction(
      semanticLabel: 'Clean Spam',
      barrierDismissible: false,
      popoverBuilder: (context, close) => Material(
        child: TextButton(onPressed: close, child: const Text('Confirm clear')),
      ),
      child: const Text('Clean'),
    ),
  );

  await tester.tap(find.bySemanticsLabel('Clean Spam'));
  await tester.pumpAndSettle();
  await tester.tapAt(const Offset(700, 500));
  await tester.pumpAndSettle();

  // Only the product's own control may close this popover.
  expect(find.text('Confirm clear'), findsOneWidget);
  await tester.tap(find.text('Confirm clear'));
  await tester.pumpAndSettle();
  expect(find.text('Confirm clear'), findsNothing);
}

Future<void> _popoverRtlPlacement(WidgetTester tester) async {
  Future<CompositedTransformFollower> open(TextDirection direction) async {
    await pumpSidebar(
      tester,
      LinagoraSidebarPopoverAction(
        // A fresh state per direction, so the first popover cannot survive
        // into the second pump and block the tap with its barrier.
        key: ValueKey(direction),
        semanticLabel: 'Clean Spam',
        popoverBuilder: (context, close) =>
            const Material(child: Text('Confirm clear')),
        child: const Text('Clean'),
      ),
      surface: SidebarSurface(textDirection: direction),
    );
    await tester.tap(find.bySemanticsLabel('Clean Spam'));
    await tester.pumpAndSettle();
    return tester.widget<CompositedTransformFollower>(
      find.byType(CompositedTransformFollower),
    );
  }

  final ltr = await open(TextDirection.ltr);
  final rtl = await open(TextDirection.rtl);

  // Directional anchors mirror, so no caller has to branch on the locale.
  expect(ltr.targetAnchor, isNot(rtl.targetAnchor));
  expect(ltr.followerAnchor, isNot(rtl.followerAnchor));
}

Future<void> _darkActiveWash(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    const LinagoraSidebarItemAction(
      semanticLabel: 'Clean Spam',
      onTap: _noop,
      active: true,
      child: Icon(Icons.more_horiz),
    ),
    surface: const SidebarSurface(brightness: Brightness.dark),
  );

  final wash = tester.widget<Material>(
    find.descendant(
      of: find.byType(LinagoraSidebarItemAction),
      matching: find.byType(Material),
    ),
  );
  expect(wash.color, LinagoraSidebarStyle.dark().resolvedActionActiveBackground);
}

Future<void> _headerGeometry(WidgetTester tester) async {
  LinagoraSidebarActionDetails? details;
  await pumpSidebar(
    tester,
    LinagoraSidebarSectionHeader(
      label: 'Folders',
      expanded: false,
      expandToggleLabel: 'Expand folders',
      onExpandTogglePressed: (value) async => details = value,
    ),
  );

  await tester.tap(find.bySemanticsLabel('Expand folders'));
  await tester.pump();

  expect(details?.globalBounds.size, const Size.square(24));
}

Future<void> _confirmColours(WidgetTester tester) async {
  final style = LinagoraSidebarStyle.light();

  Future<ButtonStyle?> pumpConfirm({
    required LinagoraSidebarConfirmButtonVariant variant,
  }) async {
    await pumpSidebar(
      tester,
      LinagoraSidebarConfirmPopover(
        title: 'Clear folder',
        message: 'Everything in this folder will be removed.',
        cancelLabel: 'Cancel',
        confirmLabel: 'Clean',
        closeSemanticLabel: 'Close clear confirmation',
        onCancel: _noop,
        onConfirm: _noop,
        confirmButtonVariant: variant,
      ),
    );
    return tester
        .widget<LinagoraButton>(
          find.ancestor(
            of: find.text('Clean'),
            matching: find.byType(LinagoraButton),
          ),
        )
        .style;
  }

  const states = <WidgetState>{};
  final destructive = await pumpConfirm(
    variant: LinagoraSidebarConfirmButtonVariant.destructive,
  );
  expect(
    destructive?.backgroundColor?.resolve(states),
    style.resolvedDestructiveBackground,
  );
  expect(
    destructive?.foregroundColor?.resolve(states),
    style.resolvedConfirmForeground,
  );

  final standard = await pumpConfirm(
    variant: LinagoraSidebarConfirmButtonVariant.primary,
  );
  expect(
    standard?.backgroundColor?.resolve(states),
    style.activeForeground,
  );
}

Future<void> _headerCallbackAssert(WidgetTester tester) async {
  expect(
    () => LinagoraSidebarSectionHeader(
      label: 'Folders',
      expanded: false,
      expandToggleLabel: 'Expand folders',
      onExpandToggle: () {},
      onExpandTogglePressed: (_) {},
    ),
    throwsAssertionError,
  );
}

const _confirmKey = Key('confirm-popover');

Future<void> _pumpConfirmPopover(
  WidgetTester tester, {
  _ConfirmPopoverConfiguration configuration =
      const _ConfirmPopoverConfiguration(),
}) {
  return pumpSidebar(
    tester,
    LinagoraSidebarConfirmPopover(
      key: _confirmKey,
      title: 'Clear folder',
      message: 'Everything in this folder will be removed.',
      cancelLabel: 'Cancel',
      confirmLabel: 'Clean',
      closeSemanticLabel: 'Close clear confirmation',
      onCancel: configuration.callbacks.onCancel,
      onConfirm: configuration.callbacks.onConfirm,
    ),
    surface: SidebarSurface(textDirection: configuration.textDirection),
  );
}

class _ConfirmPopoverConfiguration {
  const _ConfirmPopoverConfiguration({
    this.textDirection = TextDirection.ltr,
    this.callbacks = const _ConfirmCallbacks(),
  });

  final TextDirection textDirection;
  final _ConfirmCallbacks callbacks;
}

class _ConfirmCallbacks {
  const _ConfirmCallbacks({this.onCancel = _noop, this.onConfirm = _noop});

  final VoidCallback onCancel;
  final VoidCallback onConfirm;
}

LinagoraSidebarPopoverArrowSide _arrowSideOf(WidgetTester tester) {
  final clipPath = tester.widget<ClipPath>(
    find.descendant(
      of: find.byKey(_confirmKey),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is ClipPath && widget.clipper is LinagoraSidebarPopoverShape,
      ),
    ),
  );
  return (clipPath.clipper as LinagoraSidebarPopoverShape).arrowSide;
}

Future<void> _confirmPopover(WidgetTester tester) async {
  var cancelCalls = 0;
  var confirmCalls = 0;
  await _pumpConfirmPopover(
    tester,
    configuration: _ConfirmPopoverConfiguration(
      callbacks: _ConfirmCallbacks(
        onCancel: () => cancelCalls++,
        onConfirm: () => confirmCalls++,
      ),
    ),
  );

  expect(_arrowSideOf(tester), LinagoraSidebarPopoverArrowSide.start);

  await tester.tap(find.text('Cancel'));
  await tester.tap(find.text('Clean'));

  expect((cancelCalls, confirmCalls), (1, 1));

  // The arrow points back at the trigger, which RTL moves to the other side.
  await _pumpConfirmPopover(
    tester,
    configuration: const _ConfirmPopoverConfiguration(
      textDirection: TextDirection.rtl,
    ),
  );

  expect(_arrowSideOf(tester), LinagoraSidebarPopoverArrowSide.end);
}

/// Pins the intended behaviour, not the current one: `item.enabled = false`
/// must block a `trailing` action from firing. It does not yet — see PR #103
/// review — so this currently fails until `enabled` is threaded down to the
/// trailing action.
Future<void> _disabledRowBlocksAction(WidgetTester tester) async {
  var opened = false;
  await pumpSidebar(
    tester,
    LinagoraSidebarItem(
      label: 'Spam',
      enabled: false,
      onTap: _noop,
      trailing: LinagoraSidebarItemActions(
        actions: [
          LinagoraSidebarItemActionEntry(
            id: 'more-spam',
            child: LinagoraSidebarMenuAction(
              semanticLabel: 'More Spam actions',
              child: const Icon(Icons.more_horiz),
              onPressed: (_) async {
                opened = true;
                return null;
              },
            ),
          ),
        ],
      ),
    ),
  );

  await tester.tap(find.byType(LinagoraSidebarMenuAction));
  await tester.pump();

  expect(opened, isFalse);
}
