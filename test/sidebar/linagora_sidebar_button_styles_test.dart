import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  testWidgets(
    'resolves sidebar primary action colours for enabled and disabled states',
    _sidebarPrimaryActionColours,
  );
  testWidgets('sizes the sidebar primary action', _sidebarPrimaryActionMetrics);
  testWidgets(
    'uses an injected sidebar style for a dark primary action',
    _injectedSidebarStyle,
  );
  testWidgets(
    'builds a primary action without repeating sidebar button wiring',
    _buildsPrimaryAction,
  );
  testWidgets(
    'sizes an icon widget to the sidebar style, not the button default',
    _sidebarPrimaryActionIconWidgetSize,
  );
  testWidgets(
    'keys colours off the resolved sidebar style, not ambient brightness',
    _mismatchedAmbientBrightness,
  );
}

Future<void> _buildsPrimaryAction(WidgetTester tester) async {
  var presses = 0;
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 204,
          child: LinagoraSidebarPrimaryAction(
            label: 'Create',
            icon: Icons.add,
            onPressed: () => presses++,
            buttonKey: const Key('primary-action'),
          ),
        ),
      ),
    ),
  );

  expect(tester.getSize(find.byType(FilledButton)), const Size(204, 40));
  await tester.tap(find.byKey(const Key('primary-action')));
  expect(presses, 1);
}

Future<void> _sidebarPrimaryActionIconWidgetSize(WidgetTester tester) async {
  const iconKey = Key('svg-icon');

  await tester.pumpWidget(
    const MaterialApp(
      home: Scaffold(
        body: LinagoraSidebarPrimaryAction(
          label: 'Create',
          onPressed: _noop,
          iconWidget: Icon(Icons.add, key: iconKey),
        ),
      ),
    ),
  );

  expect(tester.getSize(find.byKey(iconKey)), const Size(12, 12));
}

Future<void> _mismatchedAmbientBrightness(WidgetTester tester) async {
  final sidebarStyle = LinagoraSidebarStyle.dark();

  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
      home: Scaffold(
        body: LinagoraSidebarPrimaryAction(
          label: 'Create',
          onPressed: _noop,
          sidebarStyle: sidebarStyle,
        ),
      ),
    ),
  );

  final style = tester.widget<FilledButton>(find.byType(FilledButton)).style!;
  expect(style.backgroundColor?.resolve({}), sidebarStyle.activeForeground);
}

Future<void> _sidebarPrimaryActionColours(WidgetTester tester) async {
  for (final brightness in Brightness.values) {
    late ButtonStyle style;
    late ColorScheme colorScheme;
    // A bare [Theme] rather than a [MaterialApp]: the latter animates a
    // brightness swap, so the second pass would still read the first theme.
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Theme(
          data: ThemeData(brightness: brightness),
          child: Builder(
            builder: (context) {
              colorScheme = Theme.of(context).colorScheme;
              style = LinagoraSidebarButtonStyles.primaryAction(context);
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    final enabledStates = <WidgetState>{};
    final disabledStates = <WidgetState>{WidgetState.disabled};
    final hoveredStates = <WidgetState>{WidgetState.hovered};
    final pressedStates = <WidgetState>{WidgetState.pressed};
    final focusedStates = <WidgetState>{WidgetState.focused};
    final enabledBackground = brightness == Brightness.dark
        ? const Color(0xFF91BFFF)
        : colorScheme.primary;
    final enabledForeground = brightness == Brightness.dark
        ? const Color(0xE61D212A)
        : colorScheme.onPrimary;

    expect(style.backgroundColor?.resolve(enabledStates), enabledBackground);
    expect(style.foregroundColor?.resolve(enabledStates), enabledForeground);
    expect(
      style.backgroundColor?.resolve(disabledStates),
      colorScheme.onSurface.withValues(alpha: 0.12),
    );
    expect(
      style.foregroundColor?.resolve(disabledStates),
      colorScheme.onSurface.withValues(alpha: 0.38),
    );
    expect(style.overlayColor?.resolve(enabledStates), isNull);
    expect(
      style.overlayColor?.resolve(hoveredStates),
      enabledForeground.withValues(alpha: 0.08),
      reason: 'hovered, $brightness',
    );
    expect(
      style.overlayColor?.resolve(pressedStates),
      enabledForeground.withValues(alpha: 0.12),
      reason: 'pressed, $brightness',
    );
    expect(
      style.overlayColor?.resolve(focusedStates),
      enabledForeground.withValues(alpha: 0.12),
      reason: 'focused, $brightness',
    );
    expect(style.overlayColor?.resolve(disabledStates), isNull);
  }
}

Future<void> _sidebarPrimaryActionMetrics(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(visualDensity: VisualDensity.compact),
      home: Scaffold(
        body: SizedBox(
          width: 204,
          child: Builder(
            builder: (context) => LinagoraButton(
              label: 'Compose',
              icon: Icons.edit_outlined,
              iconSpacing: LinagoraSidebarButtonStyles.primaryActionIconSpacing,
              onPressed: _noop,
              style: LinagoraSidebarButtonStyles.primaryAction(context),
            ),
          ),
        ),
      ),
    ),
  );

  final style = tester.widget<FilledButton>(find.byType(FilledButton)).style!;
  final icon = tester.getRect(find.byIcon(Icons.edit_outlined));
  final label = tester.getRect(find.text('Compose'));

  expect(tester.getSize(find.byType(FilledButton)), const Size(204, 40));
  expect(style.visualDensity, VisualDensity.standard);
  expect(style.iconSize?.resolve({}), 12);
  expect(
    style.shape?.resolve({}),
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
  expect(
    label.left - icon.right,
    LinagoraSidebarButtonStyles.primaryActionIconSpacing,
  );
}

Future<void> _injectedSidebarStyle(WidgetTester tester) async {
  const background = Color(0xFF0055AA);
  final sidebarStyle = LinagoraSidebarStyle.dark().copyWith(
    item: const LinagoraSidebarItemStyleOverride(activeForeground: background),
  );

  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: Scaffold(
        body: LinagoraSidebarPrimaryAction(
          label: 'Create',
          onPressed: _noop,
          sidebarStyle: sidebarStyle,
        ),
      ),
    ),
  );

  final style = tester.widget<FilledButton>(find.byType(FilledButton)).style!;
  expect(style.backgroundColor?.resolve({}), background);
}

void _noop() {}
