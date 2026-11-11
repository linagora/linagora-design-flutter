import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

const _sections = [
  LinagoraAccountSection(
    title: 'Your mailbox',
    items: [
      LinagoraAccountItem(
        id: 'me',
        name: 'Nora Hale',
        email: 'nora.hale@example.com',
      ),
    ],
  ),
  LinagoraAccountSection(
    title: 'Delegated to you',
    items: [
      LinagoraAccountItem(
        id: 'mira',
        name: 'Mira Calder',
        email: 'mira.calder@example.com',
      ),
    ],
  ),
];

Widget _host(Widget child, {TextDirection textDirection = TextDirection.ltr}) {
  return MaterialApp(
    home: Directionality(
      textDirection: textDirection,
      child: Scaffold(
        body: Align(
          alignment: AlignmentDirectional.topEnd,
          child: Padding(padding: const EdgeInsets.all(40), child: child),
        ),
      ),
    ),
  );
}

Widget _switcher({
  String? selectedId = 'me',
  ValueChanged<String>? onSelected,
}) {
  return LinagoraAccountSwitcher<String>(
    label: 'Viewing Nora Hale',
    sections: _sections,
    selectedId: selectedId,
    onSelected: onSelected ?? (_) {},
    menuSemanticLabel: 'Switch mailbox',
  );
}

Finder get _chip => find.byKey(LinagoraAccountSwitcher.chipKey);
Finder get _menu => find.byKey(LinagoraAccountSwitcher.menuKey);

Future<void> _open(WidgetTester tester) async {
  await tester.tap(_chip);
  await tester.pumpAndSettle();
}

void main() {
  _menuTests();
  _styleTests();
  _switcherTests();
}

void _menuTests() {
  group('LinagoraAccountMenu', () {
    testWidgets('lists sections in order and checks the selected account', (
      tester,
    ) async {
      await _listsSections(tester);
    });
    testWidgets('hides a section without accounts', _hidesEmptySection);
    testWidgets(
      'lists every account in every non-empty section',
      _listsManyKinds,
    );
    testWidgets(
      'shows a header and a footer around the sections',
      _headerFooter,
    );
    testWidgets('renders the profile header and action footer', _profileChrome);
    testWidgets('names each section for screen readers', _sectionSemantics);
    testWidgets('omits the email line when the account has none', _omitsEmail);
    testWidgets('keeps the copy icon 8 after the header email', _headerCopyGap);
    testWidgets(
      'starts the footer labels at x60 in the avatar menu',
      _footerLabelInset,
    );
  });
}

void _styleTests() {
  group('LinagoraAccountSwitcherStyle', () {
    test('dropdown tokens match the stand-alone menu', _dropdownTokens);
    test('avatarMenu widens and retokens the profile panel', _avatarMenuTokens);
  });
}

void _switcherTests() {
  group('LinagoraAccountSwitcher', () {
    testWidgets('is a 32 high chip with the label', _chipHeight);
    testWidgets('grows past 32 when the text scale does', _chipGrowsWithText);
    testWidgets(
      'opens a 256 wide menu under the chip, end-aligned',
      _opensMenu,
    );
    testWidgets('mirrors the menu alignment in RTL', _mirrorsInRtl);
    for (final direction in TextDirection.values) {
      testWidgets(
        'keeps the menu on screen from a chip at the start edge '
        '(${direction.name})',
        (tester) => _menuStaysOnScreen(tester, direction),
      );
    }
    testWidgets('caps the menu height to the room below', _capsMenuHeight);
    testWidgets(
      'caps the menu at menuMaxHeight on a tall screen',
      _capsAtMenuMaxHeight,
    );
    testWidgets(
      'opens the menu above when the chip sits at the bottom',
      _opensAboveAtBottom,
    );
    testWidgets('reports the picked account and closes', _reportsPick);
    testWidgets(
      'does not reclaim focus after a pick that pushes a route',
      _pickThatPushesLeavesFocus,
    );
    testWidgets('closes on a tap outside without picking', _tapOutside);
    testWidgets(
      'closes on Escape and gives the focus back to the chip',
      _escape,
    );
    testWidgets('closes when the chip is tapped again', _toggleChip);
    testWidgets(
      'closes when a route covers it and leaves that route focused',
      _coveredRouteKeepsFocus,
    );
    testWidgets('disposes cleanly while the menu is open', _disposeWhileOpen);
    testWidgets('announces the chip as an expandable button', _chipSemantics);
    testWidgets(
      'hides the label and keeps a semantic name when compact',
      _nullLabel,
    );
    testWidgets('outlines only the compact chip', _compactBorder);
    testWidgets('sizes the compact chip at 40', _compactSize);
    testWidgets('uses the dark tokens when given', _darkTokens);
    test('rejects a chip with neither label nor semanticLabel', _rejectsBlank);
  });
}

Future<void> _menuStaysOnScreen(
  WidgetTester tester,
  TextDirection direction,
) async {
  tester.view.physicalSize = const Size(360, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      // The menu lives in the root overlay, so the direction must sit above it.
      builder: (context, child) =>
          Directionality(textDirection: direction, child: child!),
      home: Scaffold(
        body: Align(
          alignment: AlignmentDirectional.topStart,
          child: LinagoraAccountSwitcher<String>(
            label: 'Me',
            sections: _sections,
            selectedId: 'me',
            onSelected: (_) {},
            menuSemanticLabel: 'Switch mailbox',
          ),
        ),
      ),
    ),
  );
  await _open(tester);

  expect(tester.getRect(_chip).width, lessThan(256));
  final menu = tester.getRect(_menu);
  expect(menu.width, 256);
  expect(menu.left, greaterThanOrEqualTo(8));
  expect(menu.right, lessThanOrEqualTo(352));
}

Future<void> _capsMenuHeight(WidgetTester tester) async {
  tester.view.physicalSize = const Size(400, 200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Align(alignment: Alignment.topRight, child: _switcher()),
      ),
    ),
  );
  await _open(tester);

  final chip = tester.getRect(_chip);
  final menu = tester.getRect(_menu);
  expect(menu.bottom, lessThanOrEqualTo(192));
  expect(menu.top, chip.bottom + 6);
  expect(tester.takeException(), isNull);
}

Future<void> _opensAboveAtBottom(WidgetTester tester) async {
  tester.view.physicalSize = const Size(400, 200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Align(alignment: Alignment.bottomRight, child: _switcher()),
      ),
    ),
  );
  await _open(tester);

  final chip = tester.getRect(_chip);
  final menu = tester.getRect(_menu);
  expect(menu.height, greaterThan(0));
  expect(menu.bottom, lessThanOrEqualTo(chip.top - 6 + 0.5));
  expect(menu.top, greaterThanOrEqualTo(8));
  expect(find.text('Mira Calder'), findsOneWidget);
  expect(tester.takeException(), isNull);
}

Future<void> _listsSections(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      SizedBox(
        width: 256,
        child: LinagoraAccountMenu<String>(
          sections: _sections,
          selectedId: 'mira',
          onSelected: (_) {},
        ),
      ),
    ),
  );

  expect(
    tester.getRect(find.text('Your mailbox')).top,
    lessThan(tester.getRect(find.text('Delegated to you')).top),
  );
  // Selected highlight is inset; section title keeps the same content rhythm.
  final style = LinagoraAccountSwitcherStyle.material();
  final mira = find.byKey(LinagoraAccountMenu.itemKey('mira'));
  final me = find.byKey(LinagoraAccountMenu.itemKey('me'));
  final menuLeft = tester
      .getRect(find.byType(LinagoraAccountMenu<String>))
      .left;
  expect(
    tester.getRect(mira).left - menuLeft,
    style.itemPadding.resolve(TextDirection.ltr).left,
  );
  expect(
    tester.getRect(find.text('Nora Hale')).left,
    tester.getRect(find.text('Your mailbox')).left +
        style.tileStyle.padding.resolve(TextDirection.ltr).left,
  );
  expect(tester.widget<LinagoraPersonTile>(mira).selected, isTrue);
  expect(tester.widget<LinagoraPersonTile>(me).selected, isFalse);
  expect(tester.widget<LinagoraPersonTile>(mira).subtitleMaxLines, 1);
  expect(tester.widget<LinagoraPersonTile>(me).subtitleMaxLines, 1);
  expect(
    find.descendant(of: mira, matching: find.byIcon(Icons.check)),
    findsOneWidget,
  );
  expect(find.byIcon(Icons.check), findsOneWidget);
}

Future<void> _hidesEmptySection(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      SizedBox(
        width: 256,
        child: LinagoraAccountMenu<String>(
          sections: const [
            LinagoraAccountSection(
              title: 'Your mailbox',
              items: [LinagoraAccountItem(id: 'me', name: 'Nora Hale')],
            ),
            LinagoraAccountSection(title: 'Delegated to you', items: []),
          ],
          selectedId: 'me',
          onSelected: (_) {},
        ),
      ),
    ),
  );

  expect(find.text('Your mailbox'), findsOneWidget);
  expect(find.text('Nora Hale'), findsOneWidget);
  expect(find.text('Delegated to you'), findsNothing);
}

Future<void> _listsManyKinds(WidgetTester tester) async {
  String? picked;
  await tester.pumpWidget(
    _host(
      SizedBox(
        width: 326,
        child: LinagoraAccountMenu<String>(
          selectedId: 'support',
          onSelected: (id) => picked = id,
          sections: const [
            LinagoraAccountSection(
              title: 'Your mailbox',
              items: [LinagoraAccountItem(id: 'me', name: 'Nora Hale')],
            ),
            LinagoraAccountSection(
              title: 'Delegated to you',
              items: [
                LinagoraAccountItem(id: 'mira', name: 'Mira Calder'),
                LinagoraAccountItem(id: 'jess', name: 'Jessica Biel'),
              ],
            ),
            LinagoraAccountSection(
              title: 'Team mailboxes',
              items: [
                LinagoraAccountItem(id: 'support', name: 'Support'),
                LinagoraAccountItem(id: 'sales', name: 'Sales'),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  expect(find.text('Your mailbox'), findsOneWidget);
  expect(find.text('Delegated to you'), findsOneWidget);
  expect(find.text('Team mailboxes'), findsOneWidget);
  expect(find.text('Jessica Biel'), findsOneWidget);
  expect(find.text('Sales'), findsOneWidget);
  expect(
    tester
        .widget<LinagoraPersonTile>(
          find.byKey(LinagoraAccountMenu.itemKey('support')),
        )
        .selected,
    isTrue,
  );
  await tester.tap(find.byKey(LinagoraAccountMenu.itemKey('jess')));
  expect(picked, 'jess');
}

Future<void> _headerFooter(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      SizedBox(
        width: 256,
        child: LinagoraAccountMenu<String>(
          sections: _sections,
          selectedId: 'me',
          onSelected: (_) {},
          header: const Text('Header'),
          footer: const Text('Sign out'),
        ),
      ),
    ),
  );

  expect(
    tester.getRect(find.text('Header')).bottom,
    lessThanOrEqualTo(tester.getRect(find.text('Your mailbox')).top),
  );
  expect(
    tester.getRect(find.text('Sign out')).top,
    greaterThanOrEqualTo(tester.getRect(find.text('Mira Calder')).bottom),
  );
}

Future<void> _profileChrome(WidgetTester tester) async {
  var copied = false;
  var managed = false;
  var signedOut = false;
  final style = LinagoraAccountSwitcherStyle.material().avatarMenu();
  await tester.pumpWidget(
    _host(
      SizedBox(
        width: style.menuWidth,
        child: LinagoraAccountMenu<String>(
          sections: _sections,
          selectedId: 'me',
          onSelected: (_) {},
          style: style,
          header: LinagoraAccountMenuHeader(
            avatar: SizedBox.square(dimension: style.headerAvatarSize),
            name: 'Nora Hale',
            email: 'nora.hale@example.com',
            onCopyEmail: () => copied = true,
            copyTooltip: 'Copy email',
            badge: const Text('Delegated mailbox'),
            style: style,
          ),
          footer: LinagoraAccountMenuActions(
            manageLabel: 'Manage account',
            signOutLabel: 'Sign out',
            onManageAccount: () => managed = true,
            onSignOut: () => signedOut = true,
            style: style,
          ),
        ),
      ),
    ),
  );

  expect(find.text('Delegated mailbox'), findsOneWidget);
  expect(find.text('Manage account'), findsOneWidget);
  expect(style.menuWidth, 326);
  expect(style.footerIconSize, 20);
  expect(style.footerIconColor, const Color(0xA3424244));
  final manage = tester.widget<LinagoraPersonTile>(
    find.byKey(LinagoraAccountMenuActions.manageKey),
  );
  expect(manage.style, same(style.footerTileStyle));
  expect(manage.style!.minHeight, 40);
  expect(manage.style!.avatarSize, style.footerIconSize);
  final menuLeft = tester
      .getRect(find.byType(LinagoraAccountMenu<String>))
      .left;
  final manageIcon = find.descendant(
    of: find.byKey(LinagoraAccountMenuActions.manageKey),
    matching: find.byType(SvgPicture),
  );
  expect(tester.getRect(manageIcon).left - menuLeft, 24);
  final selectedRow = find.byKey(LinagoraAccountMenu.itemKey('me'));
  final checkIcon = find.descendant(
    of: selectedRow,
    matching: find.byIcon(Icons.check),
  );
  expect(
    tester.getRect(selectedRow).right - tester.getRect(checkIcon).right,
    12,
  );
  await tester.tap(find.byKey(LinagoraAccountMenuHeader.copyKey));
  await tester.tap(find.byKey(LinagoraAccountMenuActions.manageKey));
  await tester.tap(find.byKey(LinagoraAccountMenuActions.signOutKey));
  expect(copied, isTrue);
  expect(managed, isTrue);
  expect(signedOut, isTrue);
}

void _dropdownTokens() {
  final style = LinagoraAccountSwitcherStyle.material();
  final type = LinagoraTypography.material();
  expect(style.menuPadding, const EdgeInsets.fromLTRB(0, 12, 0, 16));
  expect(
    style.sectionPadding,
    const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 8),
  );
  expect(style.sectionGap, 0);
  expect(style.itemPadding, const EdgeInsets.symmetric(horizontal: 16));
  expect(style.headerPadding, const EdgeInsets.fromLTRB(16, 8, 16, 8));
  expect(style.headerAvatarSize, 32);
  expect(style.headerAvatarGap, 8);
  expect(style.headerEmailGap, 8);
  expect(style.headerCopyIconSize, 24);
  expect(style.headerNameTextStyle.fontSize, type.h4.fontSize);
  expect(style.headerNameTextStyle.height, type.h4.height);
  expect(style.headerEmailTextStyle.height, type.body2.height);
  expect(
    style.footerDividerColor,
    LinagoraSysColors.material().surfaceTint.withValues(alpha: 0.16),
  );
  expect(style.tileStyle.minHeight, 56);
  expect(style.tileStyle.avatarSize, 32);
  expect(
    style.tileStyle.padding,
    const EdgeInsetsDirectional.fromSTEB(16, 8, 8, 8),
  );
  expect(style.tileStyle.subtitleGap, 4);
  expect(style.tileStyle.nameTextStyle.height, type.body2.height);
  expect(style.footerTileStyle.minHeight, 40);
  expect(style.footerTileStyle.avatarSize, style.footerIconSize);
  expect(
    style.footerTileStyle.padding,
    const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
  );
  expect(
    LinagoraAccountSwitcherStyle.dark().footerDividerColor,
    const Color(0x1FFFFFFF),
  );
}

void _avatarMenuTokens() {
  final style = LinagoraAccountSwitcherStyle.material().avatarMenu();
  expect(style.menuWidth, 326);
  expect(style.menuRadius, 14);
  expect(style.menuPadding, const EdgeInsets.fromLTRB(0, 16, 0, 8));
  expect(
    style.sectionPadding,
    const EdgeInsetsDirectional.fromSTEB(24, 4, 24, 4),
  );
  expect(style.sectionGap, 8);
  expect(style.itemPadding, const EdgeInsets.symmetric(horizontal: 19.5));
  expect(style.footerTileStyle.avatarSize, style.footerIconSize);
  expect(
    style.footerTileStyle.padding,
    const EdgeInsetsDirectional.fromSTEB(4.5, 4, 8, 4),
  );
}

Future<void> _sectionSemantics(WidgetTester tester) async {
  final handle = tester.ensureSemantics();
  await tester.pumpWidget(
    _host(
      SizedBox(
        width: 256,
        child: LinagoraAccountMenu<String>(
          sections: _sections,
          selectedId: 'me',
          onSelected: (_) {},
        ),
      ),
    ),
  );

  expect(find.bySemanticsLabel('Delegated to you'), findsOneWidget);
  handle.dispose();
}

Future<void> _omitsEmail(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      SizedBox(
        width: 256,
        child: LinagoraAccountMenu<String>(
          sections: const [
            LinagoraAccountSection(
              title: 'Your mailbox',
              items: [LinagoraAccountItem(id: 'me', name: 'Nora Hale')],
            ),
          ],
          selectedId: 'me',
          onSelected: (_) {},
        ),
      ),
    ),
  );

  expect(
    tester.widget<LinagoraPersonTile>(find.byType(LinagoraPersonTile)).subtitle,
    isNull,
  );
}

Future<void> _chipHeight(WidgetTester tester) async {
  await tester.pumpWidget(_host(_switcher()));

  expect(tester.getSize(_chip).height, 32);
  expect(find.text('Viewing Nora Hale'), findsOneWidget);
  expect(_menu, findsNothing);
}

Future<void> _chipGrowsWithText(WidgetTester tester) async {
  await tester.pumpWidget(
    MediaQuery(
      data: const MediaQueryData(textScaler: TextScaler.linear(2)),
      child: _host(_switcher()),
    ),
  );

  final label = tester.getSize(find.text('Viewing Nora Hale'));
  expect(label.height, greaterThan(32));
  expect(tester.getSize(_chip).height, greaterThanOrEqualTo(label.height));
}

Future<void> _opensMenu(WidgetTester tester) async {
  await tester.pumpWidget(_host(_switcher()));
  await _open(tester);

  final chip = tester.getRect(_chip);
  final menu = tester.getRect(_menu);
  expect(menu.width, 256);
  expect(menu.top, chip.bottom + 6);
  expect(menu.right, chip.right);
}

Future<void> _mirrorsInRtl(WidgetTester tester) async {
  await tester.pumpWidget(_host(_switcher(), textDirection: TextDirection.rtl));
  await _open(tester);

  expect(tester.getRect(_menu).left, tester.getRect(_chip).left);
}

Future<void> _reportsPick(WidgetTester tester) async {
  final picked = <String>[];
  await tester.pumpWidget(_host(_switcher(onSelected: picked.add)));
  await _open(tester);

  await tester.tap(find.text('Mira Calder'));
  await tester.pumpAndSettle();

  expect(picked, ['mira']);
  expect(_menu, findsNothing);
}

Future<void> _pickThatPushesLeavesFocus(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      _switcher(
        onSelected: (_) {
          tester
              .state<NavigatorState>(find.byType(Navigator))
              .push(
                MaterialPageRoute<void>(
                  builder: (context) => const Scaffold(body: Text('Mailbox')),
                ),
              );
        },
      ),
    ),
  );
  await _open(tester);
  final chipFocus = tester.widget<InkWell>(_chip).focusNode!;

  await tester.tap(find.text('Mira Calder'));
  await tester.pumpAndSettle();

  expect(find.text('Mailbox'), findsOneWidget);
  expect(_menu, findsNothing);
  expect(chipFocus.hasPrimaryFocus, isFalse);
}

Future<void> _tapOutside(WidgetTester tester) async {
  final picked = <String>[];
  await tester.pumpWidget(_host(_switcher(onSelected: picked.add)));
  await _open(tester);

  await tester.tapAt(const Offset(10, 500));
  await tester.pumpAndSettle();

  expect(_menu, findsNothing);
  expect(picked, isEmpty);
}

Future<void> _escape(WidgetTester tester) async {
  await tester.pumpWidget(_host(_switcher()));
  await _open(tester);

  await tester.sendKeyEvent(LogicalKeyboardKey.escape);
  await tester.pumpAndSettle();

  expect(_menu, findsNothing);
  final chipFocus = Focus.of(tester.element(find.text('Viewing Nora Hale')));
  expect(chipFocus.hasPrimaryFocus, isTrue);
}

Future<void> _toggleChip(WidgetTester tester) async {
  await tester.pumpWidget(_host(_switcher()));
  await _open(tester);

  await tester.tap(_chip, warnIfMissed: false);
  await tester.pumpAndSettle();

  expect(_menu, findsNothing);
}

Future<void> _coveredRouteKeepsFocus(WidgetTester tester) async {
  await tester.pumpWidget(_host(_switcher()));
  await _open(tester);

  final navigator = tester.state<NavigatorState>(find.byType(Navigator));
  navigator.push(
    MaterialPageRoute<void>(
      builder: (context) => const Scaffold(body: TextField(autofocus: true)),
    ),
  );
  await tester.pumpAndSettle();

  expect(_menu, findsNothing);
  expect(
    tester
        .widget<EditableText>(find.byType(EditableText))
        .focusNode
        .hasPrimaryFocus,
    isTrue,
  );
}

Future<void> _disposeWhileOpen(WidgetTester tester) async {
  await tester.pumpWidget(_host(_switcher()));
  await _open(tester);

  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();

  expect(tester.takeException(), isNull);
}

Future<void> _chipSemantics(WidgetTester tester) async {
  final handle = tester.ensureSemantics();
  await tester.pumpWidget(_host(_switcher()));

  expect(
    tester.getSemantics(_chip),
    containsSemantics(
      label: 'Viewing Nora Hale',
      isButton: true,
      hasExpandedState: true,
      isExpanded: false,
    ),
  );

  await _open(tester);
  expect(tester.getSemantics(_chip), containsSemantics(isExpanded: true));
  expect(find.bySemanticsLabel('Switch mailbox'), findsOneWidget);
  handle.dispose();
}

Future<void> _nullLabel(WidgetTester tester) async {
  final handle = tester.ensureSemantics();
  await tester.pumpWidget(
    _host(
      LinagoraAccountSwitcher<String>(
        semanticLabel: 'Switch mailbox',
        sections: _sections,
        selectedId: 'me',
        onSelected: (_) {},
        menuSemanticLabel: 'Switch mailbox',
        avatar: const SizedBox.square(dimension: 24),
        style: LinagoraAccountSwitcherStyle.material().compact(),
      ),
    ),
  );

  expect(find.text('Viewing Nora Hale'), findsNothing);
  expect(find.descendant(of: _chip, matching: find.byType(Text)), findsNothing);
  expect(
    tester.getSemantics(_chip),
    containsSemantics(label: 'Switch mailbox', isButton: true),
  );
  handle.dispose();
}

Future<void> _compactBorder(WidgetTester tester) async {
  await tester.pumpWidget(_host(_switcher()));
  expect(_chipShape(tester).side.color, Colors.transparent);

  await tester.pumpWidget(
    _host(
      LinagoraAccountSwitcher<String>(
        semanticLabel: 'Switch mailbox',
        sections: _sections,
        selectedId: 'me',
        onSelected: (_) {},
        menuSemanticLabel: 'Switch mailbox',
        style: LinagoraAccountSwitcherStyle.material().compact(),
      ),
    ),
  );
  final compact = LinagoraAccountSwitcherStyle.material().compact();
  expect(_chipShape(tester).side.color, compact.chipBorderColor);
  expect(_chipShape(tester).side.width, 1);
}

Future<void> _compactSize(WidgetTester tester) async {
  final style = LinagoraAccountSwitcherStyle.material().compact();
  await tester.pumpWidget(
    _host(
      LinagoraAccountSwitcher<String>(
        semanticLabel: 'Switch mailbox',
        sections: _sections,
        selectedId: 'me',
        onSelected: (_) {},
        menuSemanticLabel: 'Switch mailbox',
        avatar: const SizedBox.square(dimension: 24),
        style: style,
      ),
    ),
  );

  expect(tester.getSize(_chip).height, 40);
  expect(style.chipHeight, 40);
  expect(style.chipRadius, 20);
  expect(style.chipAvatarSize, 24);
  expect(
    tester
        .widget<SizedBox>(
          find.descendant(of: _chip, matching: find.byType(SizedBox)).first,
        )
        .width,
    24,
  );
}

Future<void> _darkTokens(WidgetTester tester) async {
  final style = LinagoraAccountSwitcherStyle.dark();
  await tester.pumpWidget(
    _host(
      LinagoraAccountSwitcher<String>(
        label: 'Viewing Nora Hale',
        sections: _sections,
        selectedId: 'me',
        onSelected: (_) {},
        menuSemanticLabel: 'Switch mailbox',
        style: style,
      ),
    ),
  );

  expect(style.chipColor, const Color(0x14FFFFFF));
  expect(style.menuColor, const Color(0xFF3F4249));
  expect(style.checkIconColor, const Color(0xFF9BBEFA));
  expect(style.chipTextStyle.color, Colors.white);
  expect(tester.widget<Material>(_chipMaterial).color, style.chipColor);
}

void _rejectsBlank() {
  expect(
    () => LinagoraAccountSwitcher<String>(
      sections: _sections,
      selectedId: 'me',
      onSelected: (_) {},
      menuSemanticLabel: 'Switch mailbox',
    ),
    throwsAssertionError,
  );
}

RoundedRectangleBorder _chipShape(WidgetTester tester) =>
    tester.widget<Material>(_chipMaterial).shape! as RoundedRectangleBorder;

Finder get _chipMaterial => find.ancestor(
  of: _chip,
  matching: find.byWidgetPredicate(
    (widget) => widget is Material && widget.shape != null,
  ),
);

const _shellKey = ValueKey('account_menu_shell');

Future<void> _pumpAvatarMenu(WidgetTester tester) async {
  final style = LinagoraAccountSwitcherStyle.material().avatarMenu();
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: LinagoraAccountMenuShell(
            key: _shellKey,
            maxHeight: 900,
            style: style,
            child: LinagoraAccountMenu<String>(
              sections: _sections,
              selectedId: 'me',
              onSelected: (_) {},
              style: style,
              header: LinagoraAccountMenuHeader(
                avatar: const SizedBox(),
                name: 'Nora Hale',
                email: 'nora.hale@example.com',
                onCopyEmail: () {},
                style: style,
              ),
              footer: LinagoraAccountMenuActions(
                manageLabel: 'Manage account',
                signOutLabel: 'Sign out',
                onManageAccount: () {},
                onSignOut: () {},
                style: style,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> _headerCopyGap(WidgetTester tester) async {
  await _pumpAvatarMenu(tester);

  final email = tester.getRect(find.text('nora.hale@example.com').first);
  final copyIcon = tester.getRect(
    find.descendant(
      of: find.byKey(LinagoraAccountMenuHeader.copyKey),
      matching: find.byType(SvgPicture),
    ),
  );
  // Design: email and content_copy sit in a row with an 8 gap.
  expect(copyIcon.left - email.right, 8);
}

Future<void> _footerLabelInset(WidgetTester tester) async {
  await _pumpAvatarMenu(tester);

  final menuLeft = tester.getRect(find.byKey(_shellKey)).left;
  // Design: icon at x24, 20 wide, then a 16 gap before the label.
  for (final label in ['Manage account', 'Sign out']) {
    expect(tester.getRect(find.text(label)).left - menuLeft, 60);
  }
}

Future<void> _capsAtMenuMaxHeight(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final many = [
    for (var i = 0; i < 40; i++)
      LinagoraAccountItem(id: 'd$i', name: 'Delegate $i', email: 'd$i@x.com'),
  ];
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.topRight,
          child: LinagoraAccountSwitcher<String>(
            label: 'Viewing Nora Hale',
            sections: [
              _sections.first,
              LinagoraAccountSection(title: 'Delegated to you', items: many),
            ],
            selectedId: 'me',
            onSelected: (_) {},
            menuSemanticLabel: 'Switch mailbox',
          ),
        ),
      ),
    ),
  );
  await _open(tester);

  final maxHeight = LinagoraAccountSwitcherStyle.material().menuMaxHeight;
  expect(tester.getRect(_menu).height, lessThanOrEqualTo(maxHeight));
}
