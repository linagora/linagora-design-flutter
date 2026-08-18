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
}

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
  expect(
    style.shape?.resolve({}),
    isA<StadiumBorder>(),
  );
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

Future<void> _pump(WidgetTester tester, Widget button) {
  return tester.pumpWidget(
    MaterialApp(home: Scaffold(body: Center(child: button))),
  );
}

void _noop() {}
