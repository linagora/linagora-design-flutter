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
  testWidgets(
    'lets an explicit width win over a customised popoverStyle width',
    _explicitDefaultWidthWinsOverPopoverStyle,
  );
  testWidgets(
    'fires onCancel and exposes closeSemanticLabel from the close button',
    _closeButtonContract,
  );
  testWidgets(
    'fires onCancel and onConfirm when the Cancel and Confirm buttons are tapped',
    _actionButtonCallbacks,
  );
  testWidgets(
    "gives the arrow's physical side the extra content inset under RTL",
    _rtlContentInsetMatchesArrowSide,
  );
  testWidgets(
    'applies popoverStyle overrides to the shape and button tokens',
    _popoverStyleOverridesApply,
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

/// The widget's doc comment for `width` says "Explicit width wins over
/// popoverStyle", but the implementation detects "unset" by comparing
/// `width == defaultWidth`. An explicit width equal to the default is
/// indistinguishable from "left unset", so it silently loses to a
/// customised `popoverStyle.width` instead of winning as documented.
Future<void> _explicitDefaultWidthWinsOverPopoverStyle(
  WidgetTester tester,
) async {
  await _pumpPopover(
    tester,
    width: LinagoraSidebarConfirmPopover.defaultWidth,
    popoverStyle: const LinagoraSidebarConfirmPopoverStyle(width: 340),
  );

  final cardSize = tester.getSize(find.byKey(_cardKey));
  expect(
    cardSize.width - _shape(tester).arrowSize,
    LinagoraSidebarConfirmPopover.defaultWidth,
  );

  await _pumpPopover(
    tester,
    popoverStyle: const LinagoraSidebarConfirmPopoverStyle(width: 340),
  );
  expect(
    tester.getSize(find.byKey(_cardKey)).width - _shape(tester).arrowSize,
    340,
    reason: 'an omitted width delegates to popoverStyle',
  );
}

/// Pins the close button's current contract — tap fires [onCancel] and its
/// semantics label matches [closeSemanticLabel] — as a safety net before any
/// future refactor onto `LinagoraIconButton`.
Future<void> _closeButtonContract(WidgetTester tester) async {
  final handle = tester.ensureSemantics();
  try {
    var cancelled = false;
    await _pumpPopover(tester, onCancel: () => cancelled = true);

    expect(
      tester.getSemantics(find.bySemanticsLabel('Close clear confirmation')),
      matchesSemantics(
        label: 'Close clear confirmation',
        hasTapAction: true,
        hasFocusAction: true,
        isButton: true,
        isFocusable: true,
      ),
    );

    await tester.tap(
      find.ancestor(
        of: find.byIcon(Icons.close),
        matching: find.byType(InkResponse),
      ),
    );
    await tester.pump();
    expect(cancelled, isTrue);
  } finally {
    handle.dispose();
  }
}

Future<void> _actionButtonCallbacks(WidgetTester tester) async {
  var cancelled = false;
  var confirmed = false;
  await _pumpPopover(
    tester,
    onCancel: () => cancelled = true,
    onConfirm: () => confirmed = true,
  );

  await tester.tap(_buttonFinder('Cancel'));
  await tester.pump();
  expect(cancelled, isTrue);
  expect(confirmed, isFalse);

  await tester.tap(_buttonFinder('Clean'));
  await tester.pump();
  expect(confirmed, isTrue);
}

/// The widget's own comment says "the arrow occupies space inside the
/// layout bounds, so only the side it sits on needs an additional inset
/// before content begins." Under RTL the arrow moves to the physical right
/// (`arrowSide` flips to `end`, and `LinagoraSidebarPopoverShape` paints
/// `end` on the physical right), so the physical-right inset should carry
/// the extra `arrowSize` clearance and the physical-left inset should not.
/// `EdgeInsetsDirectional`'s RTL resolution swaps `start`/`end` onto
/// right/left, but `startPadding`/`endPadding` weren't swapped to match,
/// so today the extra clearance lands on the side with no arrow.
Future<void> _rtlContentInsetMatchesArrowSide(WidgetTester tester) async {
  await _pumpPopover(tester, textDirection: TextDirection.rtl);

  final shape = _shape(tester);
  expect(shape.arrowSide, LinagoraSidebarPopoverArrowSide.end);

  final padding = tester
      .widget<Padding>(
        find.byWidgetPredicate(
          (w) => w is Padding && w.padding is EdgeInsetsDirectional,
        ),
      )
      .padding as EdgeInsetsDirectional;
  final resolved = padding.resolve(TextDirection.rtl);

  expect(resolved.right, 20, reason: 'arrow sits on the physical right');
  expect(resolved.left, 12, reason: 'no arrow sits on the physical left');
}

Future<void> _popoverStyleOverridesApply(WidgetTester tester) async {
  const overrideStyle = LinagoraSidebarConfirmPopoverStyle(
    cardBorderRadius: 4,
    arrowSize: 6,
    buttonBorderRadius: 2,
    cancelBackgroundColor: Color(0xFF112233),
  );
  await _pumpPopover(tester, popoverStyle: overrideStyle);

  final shape = _shape(tester);
  expect(shape.borderRadius, 4);
  expect(shape.arrowSize, 6);

  const states = <WidgetState>{};
  expect(
    _buttonStyle(tester, 'Cancel').backgroundColor?.resolve(states),
    const Color(0xFF112233),
  );
  final buttonShape =
      _buttonStyle(tester, 'Cancel').shape?.resolve(states)
          as RoundedRectangleBorder?;
  expect(
    buttonShape?.borderRadius,
    const BorderRadius.all(Radius.circular(2)),
  );
}

Future<void> _pumpPopover(
  WidgetTester tester, {
  Brightness brightness = Brightness.light,
  LinagoraSidebarConfirmButtonVariant confirmButtonVariant =
      LinagoraSidebarConfirmButtonVariant.primary,
  LinagoraSidebarStyle? style,
  double? width,
  LinagoraSidebarConfirmPopoverStyle? popoverStyle,
  VoidCallback? onCancel,
  VoidCallback? onConfirm,
  TextDirection textDirection = TextDirection.ltr,
}) {
  final background = brightness == Brightness.dark
      ? const Color(0xFF1C1B1F)
      : const Color(0xFFF7F7F8);
  return tester.pumpWidget(
    MaterialApp(
      home: Theme(
        data: ThemeData(brightness: brightness),
        child: Directionality(
          textDirection: textDirection,
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
                      onCancel: onCancel ?? _noop,
                      onConfirm: onConfirm ?? _noop,
                      confirmButtonVariant: confirmButtonVariant,
                      style: style,
                      width: width,
                      popoverStyle: popoverStyle,
                    ),
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
