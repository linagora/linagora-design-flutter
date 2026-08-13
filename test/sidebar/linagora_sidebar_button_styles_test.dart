import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  testWidgets(
    'resolves sidebar primary action colours for enabled and disabled states',
    _sidebarPrimaryActionColours,
  );
  testWidgets('sizes the sidebar primary action', _sidebarPrimaryActionMetrics);
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
  }
}

Future<void> _sidebarPrimaryActionMetrics(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
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

void _noop() {}
