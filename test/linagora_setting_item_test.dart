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

  testWidgets('titleColor/subtitleColor/iconColor override the default styling '
      '(e.g. a destructive row)', (tester) async {
    const errorColor = Color(0xFFFF3347);

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
    expect(subtitleText.style?.color, errorColor);
    expect(icon.color, errorColor);
    expect(chevron.color, errorColor);
  });

  testWidgets('without color overrides, defaults are unchanged', (
    tester,
  ) async {
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

    expect(titleText.style?.color, LinagoraSysColors.material().onSurface);
    expect(
      subtitleText.style?.color,
      LinagoraRefColors.material().tertiary[30],
    );
  });
}
