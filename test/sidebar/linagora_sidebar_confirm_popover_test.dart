import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  setUpAll(_loadTwakeInterFonts);
  testWidgets(
    'uses the shared confirmation geometry and light colour tokens',
    _lightTokens,
  );
  testWidgets(
    'uses primary treatment by default and destructive when selected',
    _confirmVariantSelection,
  );
  testWidgets('uses the dark confirmation colour tokens', _darkTokens);
  testWidgets(
    "keeps the injected style's brightness tokens when the ambient Theme "
    'disagrees with it',
    _injectedStyleOverridesAmbientBrightness,
  );
  test('uses the primary confirmation variant by default', _defaultVariant);
  test('clamps popover geometry to a small layout', _clampsPopoverShape);
}

void _clampsPopoverShape() {
  const shape = LinagoraSidebarPopoverShape(
    arrowSide: LinagoraSidebarPopoverArrowSide.start,
    arrowSize: 80,
    arrowOffset: 80,
    borderRadius: 80,
  );

  expect(() => shape.getClip(const Size(4, 3)), returnsNormally);
  expect(() => shape.getClip(Size.zero), returnsNormally);
}

void _defaultVariant() {
  const popover = LinagoraSidebarConfirmPopover(
    title: _title,
    message: _message,
    cancelLabel: 'Cancel',
    confirmLabel: 'Clean',
    closeSemanticLabel: 'Close clear confirmation',
    onCancel: _noop,
    onConfirm: _noop,
  );

  expect(
    popover.confirmButtonVariant,
    LinagoraSidebarConfirmButtonVariant.primary,
  );
}

const _cardKey = Key('confirmation-card');
const _captureKey = Key('confirmation-capture');
const _title = 'Clear folder';
const _message =
    'The messages in Trash folder will be permanently deleted and you will not be able to restore them.';

Future<void> _lightTokens(WidgetTester tester) async {
  await _pumpPopover(tester);

  final cardSize = tester.getSize(find.byKey(_cardKey));
  expect(cardSize.width, 308);
  expect(cardSize.height, 172);
  expect(
    cardSize.width - _shape(tester).arrowSize,
    LinagoraSidebarConfirmPopover.defaultWidth,
  );

  final titleOffset =
      tester.getTopLeft(find.text(_title)) -
      tester.getTopLeft(find.byKey(_cardKey));
  expect(titleOffset.dx, 20);
  expect(titleOffset.dy, 16);

  final titleStyle = tester.widget<Text>(find.text(_title)).style!;
  final messageStyle = tester.widget<Text>(find.text(_message)).style!;
  expect(titleStyle.fontSize, 17);
  expect(titleStyle.fontWeight, FontWeight.w700);
  expect(messageStyle.fontSize, 14);
  expect(messageStyle.fontWeight, FontWeight.w400);

  final closeAction = find.ancestor(
    of: find.byIcon(Icons.close),
    matching: find.byType(InkResponse),
  );
  final closeActionRect = tester.getRect(closeAction);
  final cardRect = tester.getRect(find.byKey(_cardKey));
  expect(closeActionRect.size, const Size(32, 32));
  expect(cardRect.right - closeActionRect.right, 12);
  expect(tester.widget<InkResponse>(closeAction).customBorder, isA<CircleBorder>());

  final style = _buttonStyle(tester, 'Cancel');
  const states = <WidgetState>{};
  expect(style.minimumSize?.resolve(states), const Size(0, 32));
  expect(
    style.padding?.resolve(states),
    const EdgeInsetsDirectional.symmetric(horizontal: 12),
  );
  expect(
    style.backgroundColor?.resolve(states),
    LinagoraSysColors.material().surface,
  );
  expect(
    _buttonStyle(tester, 'Clean').backgroundColor?.resolve(states),
    LinagoraSidebarStyle.light().activeForeground,
  );
  expect(tester.getSize(_buttonFinder('Cancel')).height, 32);
  expect(tester.getSize(_buttonFinder('Clean')).height, 32);
  expect(
    tester.getTopRight(_buttonFinder('Clean')).dx -
        tester.getTopRight(find.byKey(_cardKey)).dx,
    -12,
  );

  final shape = _shape(tester);
  expect(shape.arrowSide, LinagoraSidebarPopoverArrowSide.start);
  expect(shape.arrowSize, 8);
  expect(shape.arrowOffset, 30);
  expect(shape.borderRadius, 16);

  final shadow = const LinagoraSidebarConfirmPopoverStyle().resolveShadow(
    LinagoraSidebarStyle.light(),
  );
  expect(shadow.color, LinagoraSidebarStyle.light().resolvedPopoverShadowColor);
  expect(shadow.color.a, 0.24);
  expect(shadow.offset, const Offset(0, 8));
  expect(shadow.blurRadius, 24);
}

Future<void> _confirmVariantSelection(
  WidgetTester tester,
) async {
  await _pumpPopover(tester);

  const states = <WidgetState>{};
  expect(
    _buttonStyle(tester, 'Clean').backgroundColor?.resolve(states),
    LinagoraSidebarStyle.light().activeForeground,
  );

  await _pumpPopover(
    tester,
    confirmButtonVariant: LinagoraSidebarConfirmButtonVariant.destructive,
  );
  expect(
    _buttonStyle(tester, 'Clean').backgroundColor?.resolve(states),
    LinagoraSidebarStyle.light().resolvedDestructiveBackground,
  );
}

Future<void> _darkTokens(WidgetTester tester) async {
  await _pumpPopover(tester, brightness: Brightness.dark);

  const states = <WidgetState>{};
  expect(
    _buttonStyle(tester, 'Cancel').backgroundColor?.resolve(states),
    LinagoraSysColors.material().surfaceVariantDark,
  );
  expect(
    _buttonStyle(tester, 'Clean').backgroundColor?.resolve(states),
    LinagoraSidebarStyle.dark().activeForeground,
  );
  expect(_shape(tester).arrowSide, LinagoraSidebarPopoverArrowSide.start);
}

/// Pins `LinagoraSidebarStyle.brightness`'s documented contract: "Widgets
/// must use this instead of the ambient Theme when a sidebar style is
/// injected beneath a differently themed parent." The ambient [Theme] here
/// stays light while an explicit dark [LinagoraSidebarStyle] is injected, so
/// every colour token below must resolve to the dark set regardless of the
/// surrounding app theme.
Future<void> _injectedStyleOverridesAmbientBrightness(
  WidgetTester tester,
) async {
  await _pumpPopover(tester, style: LinagoraSidebarStyle.dark());

  final colors = LinagoraSysColors.material();
  final titleStyle = tester.widget<Text>(find.text(_title)).style!;
  expect(titleStyle.color, colors.onSurfaceDark);

  const states = <WidgetState>{};
  expect(
    _buttonStyle(tester, 'Cancel').backgroundColor?.resolve(states),
    colors.surfaceVariantDark,
  );
  expect(
    _buttonStyle(tester, 'Cancel').foregroundColor?.resolve(states),
    colors.onSurfaceDark,
  );
}

Future<void> _pumpPopover(
  WidgetTester tester, {
  Brightness brightness = Brightness.light,
  LinagoraSidebarConfirmButtonVariant confirmButtonVariant =
      LinagoraSidebarConfirmButtonVariant.primary,
  LinagoraSidebarStyle? style,
}) {
  final background = brightness == Brightness.dark
      ? const Color(0xFF1C1B1F)
      : const Color(0xFFF7F7F8);
  return tester.pumpWidget(
    MaterialApp(
      home: Theme(
        data: ThemeData(brightness: brightness),
        child: Center(
          child: RepaintBoundary(
            key: _captureKey,
            child: ColoredBox(
              color: background,
              child: SizedBox(
                width: 520,
                height: 320,
                child: Center(
                  child: LinagoraSidebarConfirmPopover(
                    key: _cardKey,
                    title: _title,
                    message: _message,
                    cancelLabel: 'Cancel',
                    confirmLabel: 'Clean',
                    closeSemanticLabel: 'Close clear confirmation',
                    onCancel: _noop,
                    onConfirm: _noop,
                    confirmButtonVariant: confirmButtonVariant,
                    style: style,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

ButtonStyle _buttonStyle(WidgetTester tester, String label) => tester
    .widget<LinagoraButton>(
      find.ancestor(
        of: find.text(label),
        matching: find.byType(LinagoraButton),
      ),
    )
    .style!;

Finder _buttonFinder(String label) =>
    find.ancestor(of: find.text(label), matching: find.byType(LinagoraButton));

LinagoraSidebarPopoverShape _shape(WidgetTester tester) =>
    tester
            .widget<ClipPath>(
              find.byWidgetPredicate(
                (widget) =>
                    widget is ClipPath &&
                    widget.clipper is LinagoraSidebarPopoverShape,
              ),
            )
            .clipper!
        as LinagoraSidebarPopoverShape;

void _noop() {}

Future<void> _loadTwakeInterFonts() async {
  final fontLoader = FontLoader('packages/linagora_design_flutter/TwakeInter')
    ..addFont(rootBundle.load('assets/fonts/TwakeInter-Regular.ttf'))
    ..addFont(rootBundle.load('assets/fonts/TwakeInter-Medium.ttf'))
    ..addFont(rootBundle.load('assets/fonts/TwakeInter-SemiBold.ttf'))
    ..addFont(rootBundle.load('assets/fonts/TwakeInter-Bold.ttf'));
  await fontLoader.load();
}
