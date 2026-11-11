import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

Widget _host(
  Widget child, {
  double width = 398,
  TextDirection direction = TextDirection.ltr,
}) {
  return MaterialApp(
    home: Directionality(
      textDirection: direction,
      child: Scaffold(
        body: Center(
          child: SizedBox(width: width, child: child),
        ),
      ),
    ),
  );
}

Color? _materialColor(WidgetTester tester) {
  return tester
      .widget<Material>(
        find
            .descendant(
              of: find.byType(LinagoraPersonTile),
              matching: find.byType(Material),
            )
            .first,
      )
      .color;
}

void main() {
  group('LinagoraPersonTile', () {
    testWidgets('is 56 high with a 32 avatar', _is56HighWithAvatar);
    testWidgets('omits the avatar when none is given', _omitsAvatar);
    testWidgets('shows the detail under the name', _showsDetailUnderName);
    testWidgets('drops a blank detail', _dropsBlankDetail);
    testWidgets('runs the trailing action and not the row', _actionSkipsRow);
    testWidgets('disables the action without a callback', _disablesAction);
    testWidgets('dims the remove glyph without a callback', _dimsDisabledGlyph);
    testWidgets(
      'a disabled action does not open the row',
      _disabledActionSkipsRow,
    );
    testWidgets('shows a custom trailing widget', _showsTrailing);
    testWidgets(
      'lines a trailing widget up with the remove column',
      _trailingAlignsWithActionColumn,
    );
    testWidgets('keeps the action at the end in RTL', _actionStaysAtEndInRtl);
    testWidgets(
      'paints the selected row and reports taps',
      _selectedReportsTaps,
    );
    testWidgets('opens on a tap in the row padding', _paddingOpensRow);
    testWidgets(
      'is read-only and transparent without onTap',
      _readOnlyWithoutTap,
    );
    testWidgets(
      'selected without onTap stays filled and not tappable',
      _selectedWithoutTap,
    );
    testWidgets(
      'ellipsizes a long name and detail in a narrow row',
      _ellipsizes,
    );
    testWidgets(
      'announces name, detail and selection as one node',
      _announcesRow,
    );
    testWidgets(
      'keeps the accessible name on the focused row',
      _focusedRowKeepsName,
    );
    testWidgets(
      'a row outside a selection group has no selected state',
      _omitsSelectedState,
    );
    testWidgets('keeps the trailing action a separate node', _actionIsSeparate);
    testWidgets(
      'gives each row its own action key in a group',
      _uniqueActionKeys,
    );
  });

  group('LinagoraTileGroup', () {
    testWidgets(
      'stacks rows in an outlined card with dividers',
      _outlinedCard,
    );
    testWidgets('fills the archive card and skips the outline', _filledCard);
    testWidgets('has no header for a single row', _singleRow);
    testWidgets('renders an empty card', _emptyCard);
    testWidgets('paints the dark tokens', _darkGroup);
    testWidgets('outlines the dark card', _darkOutlinedGroup);
    test('copyWith overrides one field and keeps the rest', _copyWith);
  });
}

Future<void> _is56HighWithAvatar(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraPersonTile(
        name: 'Nora Hale',
        avatar: Icon(Icons.person, key: ValueKey('avatar')),
      ),
    ),
  );

  expect(tester.getSize(find.byType(LinagoraPersonTile)).height, 56);
  _expectAvatarMetrics(tester);
}

void _expectAvatarMetrics(WidgetTester tester) {
  final avatar = tester.getRect(find.byKey(const ValueKey('avatar')));
  final row = tester.getRect(find.byType(LinagoraPersonTile));
  expect(avatar.width, 32);
  expect(avatar.left - row.left, 16);
  _expectNameBesideAvatar(tester, avatar);
}

void _expectNameBesideAvatar(WidgetTester tester, Rect avatar) {
  expect(tester.getRect(find.text('Nora Hale')).left - avatar.right, 16);
  final name = tester.widget<Text>(find.text('Nora Hale')).style;
  expect(name?.fontSize, 16);
  expect(name?.height, 21 / 16);
}

Future<void> _omitsAvatar(WidgetTester tester) async {
  await tester.pumpWidget(_host(const LinagoraPersonTile(name: 'Nora Hale')));

  expect(find.byType(RoundAvatar), findsNothing);
  expect(find.byType(Icon), findsNothing);
}

Future<void> _showsDetailUnderName(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraPersonTile(
        name: 'Nora Hale',
        subtitle: 'nora.hale@example.com',
      ),
    ),
  );

  final name = tester.getRect(find.text('Nora Hale'));
  final subtitle = tester.getRect(find.text('nora.hale@example.com'));
  expect(subtitle.top, greaterThanOrEqualTo(name.bottom));
  expect(
    tester.widget<Text>(find.text('nora.hale@example.com')).style?.color,
    const Color(0xA3424244),
  );
}

Future<void> _dropsBlankDetail(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(const LinagoraPersonTile(name: 'Nora Hale', subtitle: '  \u200B')),
  );

  expect(find.byType(Text), findsOneWidget);
  expect(tester.getSize(find.byType(LinagoraPersonTile)).height, 56);
}

Future<void> _actionSkipsRow(WidgetTester tester) async {
  var removed = 0;
  var rowTaps = 0;
  await tester.pumpWidget(
    _host(
      LinagoraPersonTile(
        name: 'Nora Hale',
        onTap: () => rowTaps++,
        action: LinagoraPersonTileAction(
          key: LinagoraPersonTile.actionKey,
          tooltip: 'Remove',
          onPressed: () => removed++,
        ),
      ),
    ),
  );

  await tester.tap(find.byKey(LinagoraPersonTile.actionKey));

  expect(removed, 1);
  expect(rowTaps, 0);
  expect(find.byTooltip('Remove'), findsOneWidget);
  final action = tester.getRect(find.byKey(LinagoraPersonTile.actionKey));
  final row = tester.getRect(find.byType(LinagoraPersonTile));
  expect(action.size, const Size(32, 32));
  expect(row.right - action.center.dx, 24);
}

Future<void> _disablesAction(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraPersonTile(
        name: 'Nora Hale',
        action: LinagoraPersonTileAction(
          key: LinagoraPersonTile.actionKey,
          tooltip: 'Remove',
          onPressed: null,
        ),
      ),
    ),
  );

  final button = tester.widget<IconButton>(
    find.byKey(LinagoraPersonTile.actionKey),
  );
  expect(button.onPressed, isNull);
}

Future<void> _dimsDisabledGlyph(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      Column(
        children: [
          LinagoraPersonTile(
            name: 'Nora Hale',
            action: LinagoraPersonTileAction(
              key: LinagoraPersonTile.actionKeyFor('enabled'),
              tooltip: 'Remove',
              onPressed: () {},
            ),
          ),
          LinagoraPersonTile(
            name: 'Milo Kent',
            action: LinagoraPersonTileAction(
              key: LinagoraPersonTile.actionKeyFor('disabled'),
              tooltip: 'Remove',
              onPressed: null,
            ),
          ),
        ],
      ),
    ),
  );

  expect(
    _glyphFilter(tester, 'disabled'),
    isNot(_glyphFilter(tester, 'enabled')),
  );
}

ColorFilter? _glyphFilter(WidgetTester tester, String id) {
  return tester
      .widget<SvgPicture>(
        find.descendant(
          of: find.byKey(LinagoraPersonTile.actionKeyFor(id)),
          matching: find.byType(SvgPicture),
        ),
      )
      .colorFilter;
}

Future<void> _disabledActionSkipsRow(WidgetTester tester) async {
  var rowTaps = 0;
  await tester.pumpWidget(
    _host(
      LinagoraPersonTile(
        name: 'Nora Hale',
        onTap: () => rowTaps++,
        action: const LinagoraPersonTileAction(
          key: LinagoraPersonTile.actionKey,
          tooltip: 'Remove',
          onPressed: null,
        ),
      ),
    ),
  );

  await tester.tap(find.byKey(LinagoraPersonTile.actionKey));

  expect(rowTaps, 0);
}

Future<void> _showsTrailing(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraPersonTile(name: 'Nora Hale', trailing: Text('deleted')),
    ),
  );

  expect(find.text('deleted'), findsOneWidget);
}

Future<void> _trailingAlignsWithActionColumn(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraTileGroup(
        filled: true,
        children: [
          LinagoraPersonTile(name: 'Thomas Leroy', trailing: Text('deleted')),
        ],
      ),
    ),
  );

  final row = tester.getRect(find.byType(LinagoraPersonTile));
  expect(row.right - tester.getRect(find.text('deleted')).right, 56);
}

Future<void> _actionStaysAtEndInRtl(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      LinagoraPersonTile(
        name: 'Nora Hale',
        action: LinagoraPersonTileAction(
          key: LinagoraPersonTile.actionKey,
          tooltip: 'Remove',
          onPressed: () {},
        ),
      ),
      direction: TextDirection.rtl,
    ),
  );

  final tile = tester.getRect(find.byType(LinagoraPersonTile));
  final action = tester.getRect(find.byKey(LinagoraPersonTile.actionKey));
  expect(action.left, greaterThanOrEqualTo(tile.left));
  expect(action.right, lessThan(tester.getRect(find.text('Nora Hale')).left));
}

Future<void> _selectedReportsTaps(WidgetTester tester) async {
  var taps = 0;
  await tester.pumpWidget(
    _host(
      LinagoraPersonTile(
        name: 'Nora Hale',
        selected: true,
        onTap: () => taps++,
      ),
    ),
  );

  await tester.tap(find.text('Nora Hale'));

  expect(taps, 1);
  expect(_materialColor(tester), const Color(0x140A84FF));
}

Future<void> _paddingOpensRow(WidgetTester tester) async {
  var taps = 0;
  var removed = 0;
  await tester.pumpWidget(
    _host(
      LinagoraPersonTile(
        name: 'Nora Hale',
        onTap: () => taps++,
        action: LinagoraPersonTileAction(
          key: LinagoraPersonTile.actionKey,
          tooltip: 'Remove',
          onPressed: () => removed++,
        ),
      ),
    ),
  );

  final row = tester.getRect(find.byType(LinagoraPersonTile));
  await tester.tapAt(row.centerLeft + const Offset(4, 0));
  await tester.tapAt(row.topCenter + const Offset(0, 2));
  await tester.tapAt(row.bottomCenter - const Offset(0, 2));
  final action = tester.getRect(find.byKey(LinagoraPersonTile.actionKey));
  await tester.tapAt(action.centerLeft - const Offset(4, 0));

  expect(taps, 4);
  expect(removed, 0);
}

Future<void> _readOnlyWithoutTap(WidgetTester tester) async {
  await tester.pumpWidget(_host(const LinagoraPersonTile(name: 'Nora Hale')));

  expect(find.byType(InkWell), findsNothing);
  expect(_materialColor(tester), Colors.transparent);
}

Future<void> _selectedWithoutTap(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(const LinagoraPersonTile(name: 'Nora Hale', selected: true)),
  );

  expect(find.byType(InkWell), findsNothing);
  expect(_materialColor(tester), const Color(0x140A84FF));
}

Future<void> _ellipsizes(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      LinagoraPersonTile(
        name: 'A very long display name that does not fit',
        subtitle: 'a.very.long.address.that.does.not.fit@example.com',
        action: LinagoraPersonTileAction(
          key: LinagoraPersonTile.actionKey,
          tooltip: 'Remove',
          onPressed: () {},
        ),
      ),
      width: 160,
    ),
  );

  expect(tester.takeException(), isNull);
  final name = tester.renderObject<RenderParagraph>(
    find.text('A very long display name that does not fit'),
  );
  final detail = tester.renderObject<RenderParagraph>(
    find.text('a.very.long.address.that.does.not.fit@example.com'),
  );
  expect(name.didExceedMaxLines, isTrue);
  expect(name.size.height, 21);
  expect(detail.didExceedMaxLines, isTrue);
}

Future<void> _announcesRow(WidgetTester tester) async {
  final handle = tester.ensureSemantics();
  await tester.pumpWidget(
    _host(
      LinagoraPersonTile(
        name: 'Nora Hale',
        subtitle: 'nora.hale@example.com',
        selected: true,
        onTap: () {},
      ),
    ),
  );

  expect(
    tester.getSemantics(find.text('Nora Hale')),
    matchesSemantics(
      label: 'Nora Hale\nnora.hale@example.com',
      isButton: true,
      isFocusable: true,
      hasSelectedState: true,
      isSelected: true,
      hasTapAction: true,
      hasFocusAction: true,
    ),
  );
  handle.dispose();
}

Future<void> _focusedRowKeepsName(WidgetTester tester) async {
  final handle = tester.ensureSemantics();
  await tester.pumpWidget(
    _host(
      LinagoraPersonTile(
        name: 'Nora Hale',
        subtitle: 'nora.hale@example.com',
        onTap: () {},
      ),
    ),
  );

  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.pump();

  expect(
    tester.getSemantics(find.text('Nora Hale')),
    matchesSemantics(
      label: 'Nora Hale\nnora.hale@example.com',
      isButton: true,
      hasTapAction: true,
      hasFocusAction: true,
      isFocusable: true,
      isFocused: true,
    ),
  );
  handle.dispose();
}

Future<void> _omitsSelectedState(WidgetTester tester) async {
  final handle = tester.ensureSemantics();
  await tester.pumpWidget(_host(const LinagoraPersonTile(name: 'Nora Hale')));

  expect(
    tester.getSemantics(find.text('Nora Hale')),
    matchesSemantics(label: 'Nora Hale', hasSelectedState: false),
  );

  await tester.pumpWidget(
    _host(LinagoraPersonTile(name: 'Nora Hale', selected: false, onTap: () {})),
  );
  expect(
    tester.getSemantics(find.text('Nora Hale')),
    matchesSemantics(
      label: 'Nora Hale',
      isButton: true,
      isFocusable: true,
      hasTapAction: true,
      hasFocusAction: true,
      hasSelectedState: true,
      isSelected: false,
    ),
  );
  handle.dispose();
}

Future<void> _actionIsSeparate(WidgetTester tester) async {
  final handle = tester.ensureSemantics();
  await tester.pumpWidget(
    _host(
      LinagoraPersonTile(
        name: 'Nora Hale',
        onTap: () {},
        action: LinagoraPersonTileAction(
          key: LinagoraPersonTile.actionKey,
          tooltip: 'Remove',
          onPressed: () {},
        ),
      ),
    ),
  );

  expect(
    tester.getSemantics(find.byKey(LinagoraPersonTile.actionKey)),
    containsSemantics(tooltip: 'Remove', isButton: true, hasTapAction: true),
  );
  handle.dispose();
}

Future<void> _uniqueActionKeys(WidgetTester tester) async {
  var removed = '';
  await tester.pumpWidget(
    _host(
      LinagoraTileGroup(
        children: [
          for (final name in ['Nora Hale', 'Mira Calder'])
            LinagoraPersonTile(
              name: name,
              action: LinagoraPersonTileAction(
                tooltip: 'Remove',
                onPressed: () {},
              ),
            ),
        ],
      ),
    ),
  );
  expect(find.byKey(LinagoraPersonTile.actionKey), findsNothing);

  await tester.pumpWidget(
    _host(
      LinagoraTileGroup(
        children: [
          for (final name in ['Nora Hale', 'Mira Calder'])
            LinagoraPersonTile(
              name: name,
              action: LinagoraPersonTileAction(
                key: LinagoraPersonTile.actionKeyFor(name),
                tooltip: 'Remove',
                onPressed: () => removed = name,
              ),
            ),
        ],
      ),
    ),
  );
  expect(
    find.byKey(LinagoraPersonTile.actionKeyFor('Nora Hale')),
    findsOneWidget,
  );
  expect(
    find.byKey(LinagoraPersonTile.actionKeyFor('Mira Calder')),
    findsOneWidget,
  );

  await tester.tap(find.byKey(LinagoraPersonTile.actionKeyFor('Mira Calder')));
  expect(removed, 'Mira Calder');
}

Future<void> _outlinedCard(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraTileGroup(
        header: Text('Who has access'),
        children: [
          LinagoraPersonTile(name: 'Nora Hale'),
          LinagoraPersonTile(name: 'Milo Kent'),
          LinagoraPersonTile(name: 'Ada Quinn'),
        ],
      ),
    ),
  );

  expect(find.text('Who has access'), findsOneWidget);
  expect(
    LinagoraPersonTileStyle.material().headerTextStyle.height,
    18.4 / 14,
  );
  expect(find.byType(Divider), findsNWidgets(2));
  _expectOutlinedDecoration(tester);
  _expectHeaderAboveCard(tester);
}

void _expectOutlinedDecoration(WidgetTester tester) {
  final decoration = _cardDecoration(tester);
  expect(decoration.border, Border.all(color: const Color(0x29424244)));
  expect(decoration.color, isNull);
  expect(decoration.borderRadius, BorderRadius.circular(12));
}

void _expectHeaderAboveCard(WidgetTester tester) {
  expect(
    tester.getRect(find.text('Who has access')).bottom,
    lessThanOrEqualTo(
      tester.getRect(find.byKey(LinagoraTileGroup.cardKey)).top,
    ),
  );
}

Future<void> _filledCard(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraTileGroup(
        filled: true,
        children: [LinagoraPersonTile(name: 'Nora Hale')],
      ),
    ),
  );

  final decoration = _cardDecoration(tester);
  expect(decoration.color, const Color(0x0A424244));
  expect(decoration.border, isNull);
  expect(find.byType(Divider), findsNothing);
}

Future<void> _singleRow(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const LinagoraTileGroup(
        children: [LinagoraPersonTile(name: 'Nora Hale')],
      ),
    ),
  );

  expect(find.byType(Divider), findsNothing);
  expect(
    tester.getRect(find.byKey(LinagoraTileGroup.cardKey)).top,
    tester.getRect(find.byType(LinagoraTileGroup)).top,
  );
}

Future<void> _emptyCard(WidgetTester tester) async {
  await tester.pumpWidget(_host(const LinagoraTileGroup(children: [])));

  expect(find.byKey(LinagoraTileGroup.cardKey), findsOneWidget);
  expect(find.byType(Divider), findsNothing);
  expect(tester.takeException(), isNull);
}

BoxDecoration _cardDecoration(WidgetTester tester) {
  final card = tester.widget<DecoratedBox>(
    find.byKey(LinagoraTileGroup.cardKey),
  );
  return card.decoration as BoxDecoration;
}

Future<void> _darkGroup(WidgetTester tester) async {
  final style = LinagoraPersonTileStyle.dark();
  await tester.pumpWidget(
    _host(
      LinagoraTileGroup(
        style: style,
        filled: true,
        children: [
          LinagoraPersonTile(
            name: 'Nora Hale',
            subtitle: 'nora.hale@example.com',
            selected: true,
            style: style,
            action: const LinagoraPersonTileAction(
              tooltip: 'Remove',
              onPressed: null,
            ),
          ),
        ],
      ),
    ),
  );

  _expectDarkSurfaces(tester);
  _expectDarkText(tester);
  expect(
    tester.widget<IconButton>(find.byType(IconButton)).color,
    const Color(0xA3FFFFFF),
  );
}

Future<void> _darkOutlinedGroup(WidgetTester tester) async {
  final style = LinagoraPersonTileStyle.dark();
  await tester.pumpWidget(
    _host(
      LinagoraTileGroup(
        style: style,
        children: [
          LinagoraPersonTile(name: 'Nora Hale', style: style),
          LinagoraPersonTile(name: 'Milo Kent', style: style),
        ],
      ),
    ),
  );

  final decoration = _cardDecoration(tester);
  expect(decoration.border, Border.all(color: const Color(0x1FFFFFFF)));
  expect(decoration.color, isNull);
  expect(
    tester.widget<Divider>(find.byType(Divider)).color,
    const Color(0x1FFFFFFF),
  );
}

void _expectDarkSurfaces(WidgetTester tester) {
  expect(_cardDecoration(tester).border, isNull);
  expect(_cardDecoration(tester).color, const Color(0x0AFFFFFF));
  expect(_materialColor(tester), const Color(0x299BBEFA));
}

void _expectDarkText(WidgetTester tester) {
  expect(
    tester.widget<Text>(find.text('Nora Hale')).style?.color,
    Colors.white,
  );
  expect(
    tester.widget<Text>(find.text('nora.hale@example.com')).style?.color,
    const Color(0xA3FFFFFF),
  );
}

void _copyWith() {
  final base = LinagoraPersonTileStyle.material();
  final next = base.copyWith(avatarSize: 40);
  expect(next.avatarSize, 40);
  _expectCopyWithKeepsBase(base, next);
}

void _expectCopyWithKeepsBase(
  LinagoraPersonTileStyle base,
  LinagoraPersonTileStyle next,
) {
  expect(next.minHeight, base.minHeight);
  expect(next.padding, base.padding);
  expect(next.actionEndPadding, base.actionEndPadding);
  expect(next.avatarGap, base.avatarGap);
  expect(next.trailingGap, base.trailingGap);
  expect(next.nameTextStyle, base.nameTextStyle);
  expect(next.subtitleTextStyle, base.subtitleTextStyle);
  expect(next.subtitleGap, base.subtitleGap);
  expect(next.actionButtonSize, base.actionButtonSize);
  expect(next.actionIconSize, base.actionIconSize);
  expect(next.actionIconColor, base.actionIconColor);
  expect(next.selectedColor, base.selectedColor);
  expect(next.hoverColor, base.hoverColor);
  expect(next.tileRadius, base.tileRadius);
  expect(next.headerTextStyle, base.headerTextStyle);
  expect(next.headerGap, base.headerGap);
  expect(next.groupRadius, base.groupRadius);
  expect(next.groupBorderColor, base.groupBorderColor);
  expect(next.groupFillColor, base.groupFillColor);
}
