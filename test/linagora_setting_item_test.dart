import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  testWidgets('does not overflow with long title/subtitle on narrow width', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            child: LinagoraSettingItem(
              title: 'A very long setting title that should wrap and clip',
              subtitle:
                  'A very long setting description that should wrap onto '
                  'two lines and then get ellipsized instead of overflowing',
              leadingIcon: Icons.chat_bubble_outline,
              onTap: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('disabled item does not invoke onTap', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LinagoraSettingItem(
            title: 'Name',
            subtitle: 'Description',
            leadingIcon: Icons.chat_bubble_outline,
            enabled: false,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byType(InkWell));
    await tester.pump();

    expect(tapped, isFalse);
  });

  testWidgets('loading shows spinner instead of chevron and blocks tap', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LinagoraSettingItem(
            title: 'Name',
            subtitle: 'Description',
            leadingIcon: Icons.chat_bubble_outline,
            loading: true,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsNothing);

    await tester.tap(find.byType(InkWell));
    await tester.pump();

    expect(tapped, isFalse);
  });

  testWidgets('shows divider when showDivider is true', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LinagoraSettingItem(
            title: 'Name',
            subtitle: 'Description',
            leadingIcon: Icons.chat_bubble_outline,
            showDivider: true,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(Divider), findsOneWidget);
  });

  testWidgets('shows count next to the title', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LinagoraSettingItem(
            title: 'Name',
            subtitle: 'Description',
            count: 3,
            leadingIcon: Icons.chat_bubble_outline,
          ),
        ),
      ),
    );

    expect(find.text('Name 3', findRichText: true), findsOneWidget);
  });

  group('selectable toggle', () {
    Widget buildToggle({
      required bool value,
      ValueChanged<bool>? onChanged,
      bool enabled = true,
      String? subtitle,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: LinagoraSettingItem.selectable(
            title: 'Name',
            subtitle: subtitle,
            leadingIcon: Icons.chat_bubble_outline,
            value: value,
            onChanged: onChanged,
            enabled: enabled,
          ),
        ),
      );
    }

    testWidgets('shows a switch instead of the chevron', (tester) async {
      await tester.pumpWidget(buildToggle(value: true, onChanged: (_) {}));

      expect(find.byType(Switch), findsOneWidget);
      expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
      expect(find.byIcon(Icons.chevron_right), findsNothing);
    });

    testWidgets('tapping the row toggles the value', (tester) async {
      bool? changed;
      await tester.pumpWidget(
        buildToggle(value: false, onChanged: (v) => changed = v),
      );

      await tester.tap(find.text('Name'));
      await tester.pump();

      expect(changed, isTrue);
    });

    testWidgets('tapping the switch toggles the value', (tester) async {
      bool? changed;
      await tester.pumpWidget(
        buildToggle(value: true, onChanged: (v) => changed = v),
      );

      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(changed, isFalse);
    });

    testWidgets('disabled toggle ignores taps', (tester) async {
      var calls = 0;
      await tester.pumpWidget(
        buildToggle(value: false, enabled: false, onChanged: (_) => calls++),
      );

      await tester.tap(find.text('Name'));
      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(calls, 0);
      expect(tester.widget<Switch>(find.byType(Switch)).onChanged, isNull);
    });

    testWidgets('renders without subtitle and does not overflow', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              child: LinagoraSettingItem.selectable(
                title: 'A very long setting title that should be ellipsized',
                leadingIcon: Icons.chat_bubble_outline,
                count: 12,
                value: true,
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(
          find.ancestor(
            of: find.byType(Switch),
            matching: find.byType(OverflowBox),
          ),
        ),
        const Size(39, 24),
      );
    });
  });

  testWidgets('title-only item uses the title-only min height', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.topCenter,
            child: LinagoraSettingItem(
              title: 'Name',
              leadingIcon: Icons.chat_bubble_outline,
            ),
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byType(LinagoraSettingItem)).height,
      LinagoraSettingItem.titleOnlyMinHeight,
    );
  });

  testWidgets('omits the leading slot when no icon is given', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LinagoraSettingItem(title: 'Name', showDivider: true),
        ),
      ),
    );

    final itemLeft = tester.getTopLeft(find.byType(LinagoraSettingItem)).dx;
    expect(tester.getTopLeft(find.text('Name')).dx - itemLeft, 8);
    expect(tester.getTopLeft(find.byType(Divider)).dx - itemLeft, 8);
  });

  testWidgets('padding override applies to the row and the divider', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LinagoraSettingItem(
            title: 'Name',
            subtitle: 'Description',
            leadingIcon: Icons.chat_bubble_outline,
            padding: LinagoraSettingItem.insetPadding,
            showDivider: true,
          ),
        ),
      ),
    );

    final itemLeft = tester.getTopLeft(find.byType(LinagoraSettingItem)).dx;
    expect(tester.getTopLeft(find.byType(Icon).first).dx - itemLeft, 24);
    expect(tester.getTopLeft(find.byType(Divider)).dx - itemLeft, 56);
  });

  testWidgets('null subtitleMaxLines shows the whole subtitle', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LinagoraSettingItem(
            title: 'Name',
            subtitle: 'Long description',
            subtitleMaxLines: null,
          ),
        ),
      ),
    );

    expect(tester.widget<Text>(find.text('Long description')).maxLines, isNull);
  });

  group('selectable checkbox', () {
    Widget buildCheckbox({
      required bool value,
      ValueChanged<bool>? onChanged,
      bool enabled = true,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: LinagoraSettingItem.selectable(
            control: LinagoraSettingItemControl.checkbox,
            title: 'Name',
            subtitle: 'Description',
            leadingIcon: Icons.chat_bubble_outline,
            value: value,
            onChanged: onChanged,
            enabled: enabled,
          ),
        ),
      );
    }

    testWidgets('shows the checkbox state', (tester) async {
      await tester.pumpWidget(buildCheckbox(value: true, onChanged: (_) {}));
      expect(find.byIcon(Icons.check_box_outlined), findsOneWidget);
      expect(find.byType(Switch), findsNothing);
      expect(find.byIcon(Icons.chevron_right), findsNothing);

      await tester.pumpWidget(buildCheckbox(value: false, onChanged: (_) {}));
      expect(find.byIcon(Icons.check_box_outline_blank), findsOneWidget);
    });

    testWidgets('tapping the row toggles the value', (tester) async {
      bool? changed;
      await tester.pumpWidget(
        buildCheckbox(value: true, onChanged: (v) => changed = v),
      );

      await tester.tap(find.byIcon(Icons.check_box_outlined));
      await tester.pump();

      expect(changed, isFalse);
    });

    testWidgets('exposes checked semantics', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(buildCheckbox(value: true, onChanged: (_) {}));

      expect(
        tester.getSemantics(find.text('Name')),
        matchesSemantics(
          label: 'Name\nDescription',
          hasCheckedState: true,
          isChecked: true,
          hasEnabledState: true,
          isEnabled: true,
          hasTapAction: true,
          isFocusable: true,
          hasFocusAction: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('disabled checkbox ignores taps', (tester) async {
      var calls = 0;
      await tester.pumpWidget(
        buildCheckbox(value: false, enabled: false, onChanged: (_) => calls++),
      );

      await tester.tap(find.text('Name'));
      await tester.pump();

      expect(calls, 0);
    });
  });

  testWidgets('titleColor/subtitleColor/iconColor override the default styling '
      '(e.g. a destructive row)', (tester) async {
    const errorColor = Color(0xFFFF3347);
    final defaultTitleColor = LinagoraSysColors.material().onSurface;
    final defaultSubtitleColor = LinagoraRefColors.material().tertiary[30];
    final defaultIconColor = defaultSubtitleColor;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LinagoraSettingItem(
            title: 'Remove device',
            subtitle: 'Sign out and remove this session permanently',
            leadingIcon: Icons.delete_outline,
            titleColor: errorColor,
            subtitleColor: errorColor,
            iconColor: errorColor,
          ),
        ),
      ),
    );
    await tester.pump();

    final titleText = tester.widget<Text>(find.text('Remove device'));
    final subtitleText = tester.widget<Text>(
      find.text('Sign out and remove this session permanently'),
    );
    final icon = tester.widget<Icon>(find.byIcon(Icons.delete_outline));
    final chevron = tester.widget<Icon>(find.byIcon(Icons.chevron_right));

    expect(titleText.style?.color, errorColor);
    expect(titleText.style?.color, isNot(defaultTitleColor));
    expect(subtitleText.style?.color, errorColor);
    expect(subtitleText.style?.color, isNot(defaultSubtitleColor));
    expect(icon.color, errorColor);
    expect(icon.color, isNot(defaultIconColor));
    expect(chevron.color, errorColor);
    expect(chevron.color, isNot(defaultIconColor));
  });

  testWidgets('without color overrides, defaults are unchanged', (
    tester,
  ) async {
    final defaultTitleColor = LinagoraSysColors.material().onSurface;
    final defaultSubtitleColor = LinagoraRefColors.material().tertiary[30];
    final defaultIconColor = defaultSubtitleColor;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LinagoraSettingItem(
            title: 'Name',
            subtitle: 'Description',
            leadingIcon: Icons.chat_bubble_outline,
          ),
        ),
      ),
    );
    await tester.pump();

    final titleText = tester.widget<Text>(find.text('Name'));
    final subtitleText = tester.widget<Text>(find.text('Description'));
    final icon = tester.widget<Icon>(find.byIcon(Icons.chat_bubble_outline));
    final chevron = tester.widget<Icon>(find.byIcon(Icons.chevron_right));

    expect(titleText.style?.color, defaultTitleColor);
    expect(subtitleText.style?.color, defaultSubtitleColor);
    expect(icon.color, defaultIconColor);
    expect(chevron.color, defaultIconColor);
  });

  testWidgets('crossAxisAlignment positions the content, not the trailing', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.topCenter,
            child: LinagoraSettingItem(
              title: 'Name',
              subtitle: 'Description',
              leadingIcon: Icons.chat_bubble_outline,
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
        ),
      ),
    );

    final itemTop = tester.getTopLeft(find.byType(LinagoraSettingItem)).dy;
    final itemCenter = tester.getCenter(find.byType(LinagoraSettingItem)).dy;
    expect(
      tester.getTopLeft(find.byIcon(Icons.chat_bubble_outline)).dy - itemTop,
      16,
    );
    expect(tester.getCenter(find.byIcon(Icons.chevron_right)).dy, itemCenter);
  });
}
