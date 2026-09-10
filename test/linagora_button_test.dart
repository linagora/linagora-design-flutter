import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  testWidgets('xs renders a 32px stadium text button', _xsTextButton);
  testWidgets('text variant renders a TextButton', _textVariant);
  testWidgets('lets callers override the visual button style', _styleOverride);
  testWidgets('keeps the defaults a caller style leaves unset', _styleFallback);
  testWidgets(
    'applies width, outer padding, and alignment to the button layout',
    _layoutOptions,
  );
  testWidgets('preserves an icon widget size', _iconWidgetSize);
  testWidgets(
    'prefers an icon widget over an icon',
    _iconWidgetTakesPrecedence,
  );
  testWidgets('applies box constraints to the button layout', _constraints);
  test(
    'rejects width and constraints supplied together',
    _rejectsWidthAndConstraintsTogether,
  );
  testWidgets(
    'leaves every style field untouched when no colour is set',
    _defersToTheThemeByDefault,
  );
  testWidgets('paints the given container and label colours', _explicitColours);
  testWidgets('swaps the container on hover', _hoverBackground);
  testWidgets('washes a borderless button on hover', _hoverOverlay);
  testWidgets('dims to the disabled colours', _disabledColours);
  testWidgets('rounds the container to a given radius', _borderRadius);
  testWidgets('holds a minimum height and grows past it', _minimumHeight);
  testWidgets('shrinks to its label at zero minimum height', _inlineLink);
  testWidgets('tints an icon widget with the icon colour', _tintsIconWidget);
  testWidgets('dims an icon widget when disabled', _dimsIconWidget);
  testWidgets('shows a tooltip when provided', _tooltip);
  test('rejects invalid measurements', _rejectsInvalidMeasurements);
  testWidgets(
    'applies iconSize to an icon widget with no iconColor set',
    _iconWidgetSizeWithoutColour,
  );
  testWidgets(
    'suppresses the hover overlay when hoverBackgroundColor is also set',
    _hoverOverlaySuppressedByHoverBackground,
  );
}

/// A button that sets no colour must generate a [ButtonStyle] with those
/// fields left null, so the ambient theme keeps deciding exactly as it did
/// before these properties existed.
Future<void> _defersToTheThemeByDefault(WidgetTester tester) async {
  await _pump(
    tester,
    const LinagoraButton(label: 'Compose', onPressed: _noop, icon: Icons.add),
  );

  final style = _styleOf(tester);
  expect(style.backgroundColor, isNull);
  expect(style.foregroundColor, isNull);
  expect(style.overlayColor, isNull);
  expect(style.textStyle, isNull);
  expect(style.fixedSize, isNull);
  // A bare glyph still inherits size and colour from the button's IconTheme.
  final icon = tester.widget<Icon>(find.byType(Icon));
  expect(icon.size, isNull);
  expect(icon.color, isNull);
}

Future<void> _explicitColours(WidgetTester tester) async {
  await _pump(
    tester,
    const LinagoraButton(
      label: 'Yes',
      onPressed: _noop,
      backgroundColor: Color(0xFF0A84FF),
      foregroundColor: Color(0xFFFFFFFF),
    ),
  );

  final style = _styleOf(tester);
  expect(style.backgroundColor!.resolve({}), const Color(0xFF0A84FF));
  expect(style.foregroundColor!.resolve({}), const Color(0xFFFFFFFF));
}

Future<void> _hoverBackground(WidgetTester tester) async {
  await _pump(
    tester,
    const LinagoraButton(
      label: 'Yes',
      onPressed: _noop,
      backgroundColor: Color(0xFF0A84FF),
      hoverBackgroundColor: LinagoraButton.primaryHoverBackgroundColor,
    ),
  );

  final style = _styleOf(tester);
  expect(style.backgroundColor!.resolve({}), const Color(0xFF0A84FF));
  for (final state in _hoverLikeStates) {
    expect(
      style.backgroundColor!.resolve({state}),
      LinagoraButton.primaryHoverBackgroundColor,
    );
    // The container carries the change, so no layer is painted on top.
    expect(style.overlayColor!.resolve({state}), Colors.transparent);
  }
}

Future<void> _hoverOverlay(WidgetTester tester) async {
  await _pump(
    tester,
    const LinagoraButton(
      label: 'Propose a new time',
      onPressed: _noop,
      variant: LinagoraButtonVariant.text,
      hoverOverlayColor: LinagoraButton.primaryHoverOverlayColor,
    ),
  );

  final style = _styleOf(tester);
  expect(style.overlayColor!.resolve({}), isNull);
  for (final state in _hoverLikeStates) {
    expect(
      style.overlayColor!.resolve({state}),
      LinagoraButton.primaryHoverOverlayColor,
    );
  }
}

/// [hoverBackgroundColor]'s own doc: "Setting this suppresses the state
/// layer, since the container itself already carries the change" — that
/// suppression must hold even when the caller also passes a
/// [LinagoraButton.hoverOverlayColor], not just when it's the only hover
/// colour set.
Future<void> _hoverOverlaySuppressedByHoverBackground(
  WidgetTester tester,
) async {
  await _pump(
    tester,
    const LinagoraButton(
      label: 'Yes',
      onPressed: _noop,
      backgroundColor: Color(0xFF0A84FF),
      hoverBackgroundColor: LinagoraButton.primaryHoverBackgroundColor,
      hoverOverlayColor: LinagoraButton.primaryHoverOverlayColor,
    ),
  );

  final style = _styleOf(tester);
  for (final state in _hoverLikeStates) {
    expect(style.overlayColor!.resolve({state}), Colors.transparent);
  }
}

Future<void> _disabledColours(WidgetTester tester) async {
  await _pump(
    tester,
    const LinagoraButton(
      label: 'Yes',
      onPressed: null,
      backgroundColor: Color(0xFF0A84FF),
      foregroundColor: Color(0xFFFFFFFF),
      disabledBackgroundColor: LinagoraButton.disabledContainerColor,
      disabledForegroundColor: LinagoraButton.disabledContentColor,
      hoverBackgroundColor: LinagoraButton.primaryHoverBackgroundColor,
    ),
  );

  final style = _styleOf(tester);
  const disabled = {WidgetState.disabled};
  expect(
    style.backgroundColor!.resolve(disabled),
    LinagoraButton.disabledContainerColor,
  );
  expect(
    style.foregroundColor!.resolve(disabled),
    LinagoraButton.disabledContentColor,
  );
  // Disabled wins over hover rather than the two fighting.
  expect(
    style.backgroundColor!.resolve({
      WidgetState.disabled,
      WidgetState.hovered,
    }),
    LinagoraButton.disabledContainerColor,
  );
}

Future<void> _borderRadius(WidgetTester tester) async {
  await _pump(
    tester,
    const LinagoraButton(label: 'Save', onPressed: _noop, borderRadius: 4),
  );

  final shape = _styleOf(tester).shape!.resolve({})! as RoundedRectangleBorder;
  expect((shape.borderRadius as BorderRadius).topLeft.x, 4);
}

Future<void> _minimumHeight(WidgetTester tester) async {
  await _pump(
    tester,
    const LinagoraButton(
      label: 'Yes',
      onPressed: _noop,
      minimumHeight: LinagoraButton.mediumHeight,
      padding: LinagoraButton.mediumPadding,
    ),
  );
  expect(tester.getSize(_button).height, LinagoraButton.mediumHeight);

  await _pump(
    tester,
    const LinagoraButton(
      label: 'Yes',
      onPressed: _noop,
      minimumHeight: LinagoraButton.mediumHeight,
      padding: LinagoraButton.mediumPadding,
      icon: Icons.check,
      iconSize: 32,
      iconColor: Color(0xFF424244),
    ),
  );
  // Taller content grows the button instead of being squashed.
  expect(
    tester.getSize(_button).height,
    greaterThan(LinagoraButton.mediumHeight),
  );
}

Future<void> _inlineLink(WidgetTester tester) async {
  await _pump(
    tester,
    const LinagoraButton(
      label: 'More information',
      onPressed: _noop,
      variant: LinagoraButtonVariant.text,
      padding: EdgeInsets.zero,
      minimumHeight: 0,
    ),
  );

  expect(_styleOf(tester).padding!.resolve({}), EdgeInsets.zero);
  expect(tester.getSize(_button).height, lessThan(32));
}

Future<void> _tintsIconWidget(WidgetTester tester) async {
  await _pump(
    tester,
    const LinagoraButton(
      label: 'See in your Calendar',
      onPressed: _noop,
      iconWidget: Placeholder(),
      iconColor: Color(0xFF123456),
    ),
  );

  expect(
    _iconFilterOf(tester),
    const ColorFilter.mode(Color(0xFF123456), BlendMode.srcIn),
  );
}

Future<void> _dimsIconWidget(WidgetTester tester) async {
  await _pump(
    tester,
    const LinagoraButton(
      label: 'See in your Calendar',
      onPressed: null,
      iconWidget: Placeholder(),
      iconColor: Color(0xFF123456),
      disabledForegroundColor: LinagoraButton.disabledContentColor,
    ),
  );

  // The filter follows the resolved content colour, so a disabled icon dims
  // with its label.
  expect(
    _iconFilterOf(tester),
    const ColorFilter.mode(
      LinagoraButton.disabledContentColor,
      BlendMode.srcIn,
    ),
  );
}

Future<void> _tooltip(WidgetTester tester) async {
  await _pump(
    tester,
    const LinagoraButton(
      label: 'See all participants',
      onPressed: _noop,
      tooltip: 'See all participants',
    ),
  );

  expect(
    tester.widget<Tooltip>(find.byType(Tooltip)).message,
    'See all participants',
  );
}

void _rejectsInvalidMeasurements() {
  expect(
    () => LinagoraButton(label: 'L', onPressed: _noop, borderRadius: -1),
    throwsAssertionError,
  );
  expect(
    () => LinagoraButton(label: 'L', onPressed: _noop, iconSize: 0),
    throwsAssertionError,
  );
  expect(
    () => LinagoraButton(label: 'L', onPressed: _noop, height: 0),
    throwsAssertionError,
  );
  expect(
    () => LinagoraButton(label: 'L', onPressed: _noop, minimumHeight: -1),
    throwsAssertionError,
  );
}

const _hoverLikeStates = [
  WidgetState.hovered,
  WidgetState.focused,
  WidgetState.pressed,
];

Finder get _button => find.byWidgetPredicate((w) => w is ButtonStyleButton);

ButtonStyle _styleOf(WidgetTester tester) =>
    tester.widget<ButtonStyleButton>(_button).style!;

ColorFilter? _iconFilterOf(WidgetTester tester) => tester
    .widget<ColorFiltered>(
      find.descendant(of: _button, matching: find.byType(ColorFiltered)),
    )
    .colorFilter;

Future<void> _xsTextButton(WidgetTester tester) async {
  await _pump(
    tester,
    const LinagoraButton(
      label: 'Clean',
      variant: LinagoraButtonVariant.text,
      size: LinagoraButtonSize.xs,
      onPressed: _noop,
    ),
  );

  expect(tester.getSize(find.byType(TextButton)).height, 32);

  final style = tester.widget<TextButton>(find.byType(TextButton)).style!;
  expect(style.shape?.resolve({}), isA<StadiumBorder>());
  expect(
    style.padding?.resolve({}),
    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  );
}

Future<void> _textVariant(WidgetTester tester) async {
  await _pump(
    tester,
    const LinagoraButton(
      label: 'Clean',
      variant: LinagoraButtonVariant.text,
      onPressed: _noop,
    ),
  );

  expect(find.byType(TextButton), findsOneWidget);
  expect(find.byType(FilledButton), findsNothing);
  expect(find.byType(OutlinedButton), findsNothing);
}

/// Pins the direction of [ButtonStyle.merge]. Its receiver keeps its own
/// non-null values, so the caller's style has to be the receiver — every
/// property here is one the generated style also sets, with a different value.
Future<void> _styleOverride(WidgetTester tester) async {
  await _pump(
    tester,
    SizedBox(
      width: 204,
      child: LinagoraButton(
        label: 'Compose',
        icon: Icons.edit_outlined,
        iconSpacing: 7,
        onPressed: _noop,
        style: ButtonStyle(
          iconSize: const WidgetStatePropertyAll(12),
          minimumSize: const WidgetStatePropertyAll(Size(0, 40)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    ),
  );

  final button = tester.widget<FilledButton>(find.byType(FilledButton));
  final style = button.style!;
  final icon = tester.getRect(find.byIcon(Icons.edit_outlined));
  final label = tester.getRect(find.text('Compose'));

  expect(tester.getSize(find.byType(FilledButton)), const Size(204, 40));
  expect(style.iconSize?.resolve({}), 12);
  expect(style.shape?.resolve({}), isA<RoundedRectangleBorder>());
  expect(label.left - icon.right, 7);
}

/// The other half of the merge: a caller style that names only one property
/// must not wipe the rest of the generated defaults.
Future<void> _styleFallback(WidgetTester tester) async {
  await _pump(
    tester,
    const LinagoraButton(
      label: 'Clean',
      onPressed: _noop,
      style: ButtonStyle(iconSize: WidgetStatePropertyAll(12)),
    ),
  );

  final style = tester.widget<FilledButton>(find.byType(FilledButton)).style!;

  expect(style.iconSize?.resolve({}), 12);
  expect(style.shape?.resolve({}), isA<StadiumBorder>());
  expect(style.minimumSize?.resolve({}), const Size(0, 48));
  expect(style.tapTargetSize, MaterialTapTargetSize.shrinkWrap);
}

Future<void> _layoutOptions(WidgetTester tester) async {
  const clickableKey = Key('clickable-button');
  const layoutKey = Key('layout-container');

  await _pump(
    tester,
    const SizedBox(
      key: layoutKey,
      width: 360,
      child: LinagoraButton(
        label: 'Compose',
        onPressed: _noop,
        buttonKey: clickableKey,
        width: 180,
        outerPadding: EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.centerRight,
      ),
    ),
  );

  final buttonRect = tester.getRect(find.byKey(clickableKey));
  final layoutRect = tester.getRect(find.byKey(layoutKey));

  expect(buttonRect.width, 180);
  expect(buttonRect.right, closeTo(layoutRect.right - 12, 0.01));
}

Future<void> _iconWidgetSize(WidgetTester tester) async {
  const iconKey = Key('custom-icon');
  await _pump(
    tester,
    const LinagoraButton(
      label: 'Compose',
      iconWidget: SizedBox(key: iconKey, width: 12, height: 12),
      iconSpacing: 7,
      onPressed: _noop,
    ),
  );

  expect(tester.getSize(find.byKey(iconKey)), const Size(12, 12));
}

/// [iconSize] governs the outer icon slot regardless of whether the caller
/// also asked for a colour override — the two are documented as independent
/// ([iconSize]: "Outer size of the leading icon slot"), so the SizedBox that
/// sizes the slot must not be gated on [iconColor] being set.
Future<void> _iconWidgetSizeWithoutColour(WidgetTester tester) async {
  const iconKey = Key('custom-icon');
  await _pump(
    tester,
    const LinagoraButton(
      label: 'Compose',
      iconWidget: SizedBox(key: iconKey, width: 12, height: 12),
      iconSize: 32,
      onPressed: _noop,
    ),
  );

  expect(tester.getSize(find.byKey(iconKey)), const Size(32, 32));
}

Future<void> _iconWidgetTakesPrecedence(WidgetTester tester) async {
  const iconKey = Key('custom-icon');
  await _pump(
    tester,
    const LinagoraButton(
      label: 'Compose',
      icon: Icons.edit_outlined,
      iconWidget: SizedBox(key: iconKey, width: 12, height: 12),
      onPressed: _noop,
    ),
  );

  expect(find.byKey(iconKey), findsOneWidget);
  expect(find.byIcon(Icons.edit_outlined), findsNothing);
}

Future<void> _constraints(WidgetTester tester) async {
  const clickableKey = Key('clickable-button');

  await _pump(
    tester,
    const LinagoraButton(
      label: 'Compose',
      onPressed: _noop,
      buttonKey: clickableKey,
      constraints: BoxConstraints.tightFor(width: 160),
    ),
  );

  expect(tester.getSize(find.byKey(clickableKey)).width, 160);
}

void _rejectsWidthAndConstraintsTogether() {
  expect(
    () => LinagoraButton(
      label: 'Compose',
      onPressed: _noop,
      width: 160,
      constraints: const BoxConstraints(maxWidth: 160),
    ),
    throwsAssertionError,
  );
}

Future<void> _pump(WidgetTester tester, Widget button) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: Center(child: button)),
    ),
  );
}

void _noop() {}
