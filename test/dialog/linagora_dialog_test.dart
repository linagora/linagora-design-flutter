import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

const _title = 'Your email domain is pending activation';
const _message = 'You cannot send emails at this time.';

Widget _host(Widget child, {TextDirection textDirection = TextDirection.ltr}) =>
    MaterialApp(
      home: Directionality(
        textDirection: textDirection,
        child: Scaffold(body: child),
      ),
    );

LinagoraDialogAction _action(String label, {VoidCallback? onPressed}) =>
    LinagoraDialogAction(label: label, onPressed: onPressed ?? () {});

Future<void> _setSurface(WidgetTester t, Size size) async {
  addTearDown(() => t.binding.setSurfaceSize(null));
  await t.binding.setSurfaceSize(size);
}

final _surface = find.byWidgetPredicate(
  (widget) =>
      widget is DecoratedBox &&
      widget.decoration is BoxDecoration &&
      (widget.decoration as BoxDecoration).boxShadow != null,
);

BoxDecoration _surfaceDecoration(WidgetTester t) =>
    t.widget<DecoratedBox>(_surface).decoration as BoxDecoration;

Text _text(WidgetTester t, String data) => t.widget<Text>(find.text(data));

Color? _buttonBackground(WidgetTester t, Key key) {
  final button = t.widget<ButtonStyleButton>(find.byKey(key));
  return button.style?.backgroundColor?.resolve({});
}

Color? _buttonForeground(WidgetTester t, Key key, [Set<WidgetState>? states]) {
  final button = t.widget<ButtonStyleButton>(find.byKey(key));
  return button.style?.foregroundColor?.resolve(states ?? {});
}

Future<void> _loadTwakeInter() async {
  final loader = FontLoader('packages/linagora_design_flutter/TwakeInter')
    ..addFont(rootBundle.load('assets/fonts/TwakeInter-Regular.ttf'))
    ..addFont(rootBundle.load('assets/fonts/TwakeInter-Medium.ttf'))
    ..addFont(rootBundle.load('assets/fonts/TwakeInter-SemiBold.ttf'))
    ..addFont(rootBundle.load('assets/fonts/TwakeInter-Bold.ttf'));
  await loader.load();
}

void main() {
  setUpAll(_loadTwakeInter);

  group('LinagoraDialog surface', () {
    testWidgets('is a 544 wide white card with an 8 radius and two shadows', (
      t,
    ) async {
      await _setSurface(t, const Size(1440, 900));
      await t.pumpWidget(
        _host(
          LinagoraDialog(
            title: _title,
            message: _message,
            closeTooltip: 'Close',
            onClose: () {},
          ),
        ),
      );

      expect(t.getSize(_surface).width, 544);
      final decoration = _surfaceDecoration(t);
      expect(decoration.color, Colors.white);
      expect(decoration.borderRadius, BorderRadius.circular(8));
      expect(decoration.boxShadow, const [
        BoxShadow(
          color: Color(0x26000000),
          offset: Offset(0, 4),
          blurRadius: 8,
          spreadRadius: 3,
        ),
        BoxShadow(
          color: Color(0x4D000000),
          offset: Offset(0, 1),
          blurRadius: 3,
        ),
      ]);
    });

    testWidgets('keeps the 16px gutter on a phone', (t) async {
      await _setSurface(t, const Size(360, 640));
      await t.pumpWidget(
        _host(
          LinagoraDialog(
            title: _title,
            message: _message,
            closeTooltip: 'Close',
            onClose: () {},
          ),
        ),
      );

      expect(t.getSize(_surface).width, 360 - 2 * 16);
      expect(t.getTopLeft(_surface).dx, 16);
    });

    testWidgets('matches the Figma frame height with a primary action', (
      t,
    ) async {
      await _setSurface(t, const Size(1440, 900));
      await t.pumpWidget(
        _host(
          LinagoraDialog(
            title: _title,
            closeTooltip: 'Close',
            message:
                'You cannot send emails at this time. Contact your '
                'administrator if the problem persists.',
            onClose: () {},
            primaryAction: _action('Got it'),
          ),
        ),
      );

      // Header 56 + content 24/42/24 + footer 40/24 = 210 in Figma.
      expect(t.getSize(_surface).height, 210);
    });

    testWidgets('scrolls the content but keeps header and footer on screen', (
      t,
    ) async {
      await _setSurface(t, const Size(400, 320));
      await t.pumpWidget(
        _host(
          LinagoraDialog(
            title: _title,
            closeTooltip: 'Close',
            message: List.filled(80, 'long line').join(' '),
            onClose: () {},
            primaryAction: _action('Got it'),
          ),
        ),
      );

      expect(t.takeException(), isNull);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(
        find.byKey(LinagoraDialog.closeButtonKey).hitTestable(),
        findsOneWidget,
      );
      expect(
        find.byKey(LinagoraDialog.primaryActionKey).hitTestable(),
        findsOneWidget,
      );
    });

    test('scrim is the backdrop colour at 40%', () {
      expect(LinagoraDialogStyle.barrierColor, const Color(0x661C1B1F));
    });
  });

  group('LinagoraDialog header', () {
    testWidgets('shows the title in the h4 style, start-aligned', (t) async {
      await t.pumpWidget(
        _host(
          LinagoraDialog(
            title: _title,
            message: _message,
            closeTooltip: 'Close',
            onClose: () {},
          ),
        ),
      );

      final style = _text(t, _title).style!;
      expect(style.fontSize, 22);
      expect(style.fontWeight, FontWeight.w600);
      expect(style.height, 25.7 / 22);
      expect(style.letterSpacing, 0);
      expect(style.color, const Color(0xE6424244));
      expect(style.fontFamily, 'packages/linagora_design_flutter/TwakeInter');
      expect(
        t.getTopLeft(find.text(_title)).dx - t.getTopLeft(_surface).dx,
        32,
      );
    });

    testWidgets('is 56 tall with or without the icon buttons', (t) async {
      double headerHeight() =>
          t.getTopLeft(find.byType(SingleChildScrollView)).dy -
          t.getTopLeft(_surface).dy;

      await t.pumpWidget(
        _host(
          LinagoraDialog(
            message: _message,
            closeTooltip: 'Close',
            backTooltip: 'Back',
            title: 'Short',
            onClose: () {},
            onBack: () {},
          ),
        ),
      );
      expect(headerHeight(), 56);

      await t.pumpWidget(
        _host(const LinagoraDialog(message: _message, title: 'Short')),
      );
      expect(headerHeight(), 56);
    });

    testWidgets('wraps a long title instead of overflowing', (t) async {
      await t.pumpWidget(
        _host(
          LinagoraDialog(
            title: _title,
            message: _message,
            closeTooltip: 'Close',
            backTooltip: 'Back',
            onClose: () {},
            onBack: () {},
          ),
        ),
      );

      expect(t.takeException(), isNull);
      expect(t.getSize(find.text(_title)).height, greaterThan(25.7));
    });

    testWidgets('should not show a close or back button without callbacks', (
      t,
    ) async {
      await t.pumpWidget(
        _host(const LinagoraDialog(title: _title, message: _message)),
      );

      expect(find.byKey(LinagoraDialog.closeButtonKey), findsNothing);
      expect(find.byKey(LinagoraDialog.backButtonKey), findsNothing);
      expect(find.byType(IconButton), findsNothing);
    });

    testWidgets('close is a 40px button at the end with its tooltip', (
      t,
    ) async {
      var taps = 0;
      await t.pumpWidget(
        _host(
          LinagoraDialog(
            title: _title,
            message: _message,
            closeTooltip: 'Close',
            onClose: () => taps++,
          ),
        ),
      );

      final close = find.byKey(LinagoraDialog.closeButtonKey);
      expect(t.getSize(close), const Size(40, 40));
      expect(t.getTopRight(close).dx, t.getTopRight(_surface).dx - 32);
      final button = t.widget<IconButton>(close);
      expect(button.tooltip, 'Close');
      expect(button.iconSize, 24);
      expect(button.color, const Color(0xA3424244));
      expect((button.icon as Icon).icon, Icons.close);

      await t.tap(close);
      expect(taps, 1);
    });

    testWidgets('back sits before the title and calls onBack', (t) async {
      var taps = 0;
      await t.pumpWidget(
        _host(
          LinagoraDialog(
            title: _title,
            message: _message,
            backTooltip: 'Back',
            onBack: () => taps++,
          ),
        ),
      );

      final back = find.byKey(LinagoraDialog.backButtonKey);
      final button = t.widget<IconButton>(back);
      expect(button.tooltip, 'Back');
      expect((button.icon as Icon).icon, Icons.arrow_back);
      expect(t.getTopLeft(back).dx, t.getTopLeft(_surface).dx + 32);
      expect(t.getTopLeft(find.text(_title)).dx, t.getTopRight(back).dx + 4);

      await t.tap(back);
      expect(taps, 1);
    });

    testWidgets('mirrors the header in RTL', (t) async {
      await t.pumpWidget(
        _host(
          LinagoraDialog(
            title: _title,
            message: _message,
            closeTooltip: 'Close',
            onClose: () {},
          ),
          textDirection: TextDirection.rtl,
        ),
      );

      expect(
        t.getTopLeft(find.byKey(LinagoraDialog.closeButtonKey)).dx,
        t.getTopLeft(_surface).dx + 32,
      );
    });

    testWidgets('names the route after the title and marks it a header', (
      t,
    ) async {
      final semantics = t.ensureSemantics();
      await t.pumpWidget(
        _host(
          LinagoraDialog(
            title: _title,
            message: _message,
            closeTooltip: 'Close',
            onClose: () {},
          ),
        ),
      );

      expect(
        t.getSemantics(find.byType(LinagoraDialog)),
        matchesSemantics(label: _title, scopesRoute: true, namesRoute: true),
      );
      expect(find.bySemanticsLabel(_title).evaluate().isNotEmpty, isTrue);
      final titleNode = t.getSemantics(find.text(_title));
      expect(titleNode.flagsCollection.isHeader, isTrue);
      semantics.dispose();
    });
  });

  group('LinagoraDialog content', () {
    testWidgets('shows the message in the body1 style with 32/24 padding', (
      t,
    ) async {
      await t.pumpWidget(
        _host(
          LinagoraDialog(
            title: _title,
            message: _message,
            closeTooltip: 'Close',
            onClose: () {},
          ),
        ),
      );

      final style = _text(t, _message).style!;
      expect(style.fontSize, 16);
      expect(style.fontWeight, FontWeight.w400);
      expect(style.height, 21 / 16);
      expect(style.letterSpacing, -0.15);
      expect(style.color, const Color(0xE6424244));
      final scroll = t.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(
        scroll.padding,
        const EdgeInsetsDirectional.symmetric(horizontal: 32, vertical: 24),
      );
    });

    testWidgets('puts extra content 16 below the message', (t) async {
      const key = Key('extra');
      await t.pumpWidget(
        _host(
          const LinagoraDialog(
            title: _title,
            message: _message,
            content: SizedBox(key: key, height: 56),
          ),
        ),
      );

      expect(
        t.getTopLeft(find.byKey(key)).dy,
        t.getBottomLeft(find.text(_message)).dy + 16,
      );
    });

    testWidgets('should not add the gap when there is no message', (t) async {
      const key = Key('extra');
      await t.pumpWidget(
        _host(
          const LinagoraDialog(
            title: _title,
            message: null,
            content: SizedBox(key: key, height: 56),
          ),
        ),
      );

      expect(
        t.getTopLeft(find.byKey(key)).dy -
            t.getTopLeft(find.byType(SingleChildScrollView)).dy,
        24,
      );
      expect(find.byType(Text), findsOneWidget);
    });
  });

  group('LinagoraDialog footer', () {
    testWidgets('should not render a footer or divider without actions', (
      t,
    ) async {
      await t.pumpWidget(
        _host(
          LinagoraDialog(
            title: _title,
            message: _message,
            closeTooltip: 'Close',
            onClose: () {},
            fixedActions: true,
          ),
        ),
      );

      expect(find.byType(LinagoraButton), findsNothing);
      expect(find.byType(Divider), findsNothing);
    });

    testWidgets('end-aligns a lone primary action 24 above the bottom', (
      t,
    ) async {
      var taps = 0;
      await t.pumpWidget(
        _host(
          LinagoraDialog(
            title: _title,
            message: _message,
            primaryAction: _action('Got it', onPressed: () => taps++),
          ),
        ),
      );

      final primary = find.byKey(LinagoraDialog.primaryActionKey);
      expect(t.getSize(primary).height, 40);
      expect(t.getBottomRight(primary).dx, t.getBottomRight(_surface).dx - 32);
      expect(t.getBottomRight(primary).dy, t.getBottomRight(_surface).dy - 24);
      expect(find.byKey(LinagoraDialog.secondaryActionKey), findsNothing);
      expect(find.byType(Divider), findsNothing);

      expect(
        _buttonBackground(t, LinagoraDialog.primaryActionKey),
        const Color(0xFF0A84FF),
      );
      expect(
        _buttonForeground(t, LinagoraDialog.primaryActionKey),
        Colors.white,
      );
      final label = _text(t, 'Got it');
      expect(label.maxLines, 1);

      await t.tap(primary);
      expect(taps, 1);
    });

    testWidgets('uses the 24/10 padding and the medium label style', (t) async {
      await t.pumpWidget(
        _host(
          LinagoraDialog(
            title: _title,
            message: _message,
            primaryAction: _action('Got it'),
          ),
        ),
      );

      final button = t.widget<ButtonStyleButton>(
        find.byKey(LinagoraDialog.primaryActionKey),
      );
      expect(
        button.style?.padding?.resolve({}),
        const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      );
      final textStyle = button.style?.textStyle?.resolve({});
      expect(textStyle?.fontSize, 14);
      expect(textStyle?.fontWeight, FontWeight.w500);
      expect(textStyle?.height, 20 / 14);
      expect(textStyle?.letterSpacing, 0.1);
      expect(
        button.style?.backgroundColor?.resolve({WidgetState.hovered}),
        const Color(0xFF006BD8),
      );
    });

    testWidgets('puts the outlined secondary 8 before the primary', (t) async {
      var cancelled = 0;
      await t.pumpWidget(
        _host(
          LinagoraDialog(
            title: _title,
            message: _message,
            secondaryAction: _action('Cancel', onPressed: () => cancelled++),
            primaryAction: _action('Got it'),
          ),
        ),
      );

      final secondary = find.byKey(LinagoraDialog.secondaryActionKey);
      final primary = find.byKey(LinagoraDialog.primaryActionKey);
      expect(t.widget(secondary), isA<OutlinedButton>());
      expect(t.getTopLeft(primary).dx, t.getTopRight(secondary).dx + 8);
      expect(
        _buttonForeground(t, LinagoraDialog.secondaryActionKey),
        const Color(0xFF0A84FF),
      );
      final side = t
          .widget<ButtonStyleButton>(secondary)
          .style
          ?.side
          ?.resolve({});
      expect(side?.color, const Color(0xFF0A84FF));

      await t.tap(secondary);
      expect(cancelled, 1);
    });

    testWidgets('keeps a lone secondary action at the end', (t) async {
      await t.pumpWidget(
        _host(
          LinagoraDialog(
            title: _title,
            message: _message,
            secondaryAction: _action('Cancel'),
          ),
        ),
      );

      final secondary = find.byKey(LinagoraDialog.secondaryActionKey);
      expect(t.getTopRight(secondary).dx, t.getTopRight(_surface).dx - 32);
      expect(find.byKey(LinagoraDialog.primaryActionKey), findsNothing);
    });

    testWidgets('paints a destructive primary in the error colour', (t) async {
      await t.pumpWidget(
        _host(
          const LinagoraDialog(
            title: _title,
            message: _message,
            primaryAction: LinagoraDialogAction(
              label: 'Remove access',
              onPressed: _noop,
              destructive: true,
            ),
          ),
        ),
      );

      expect(
        _buttonBackground(t, LinagoraDialog.primaryActionKey),
        const Color(0xFFFF3347),
      );
    });

    testWidgets('disables actions without a callback', (t) async {
      await t.pumpWidget(
        _host(
          const LinagoraDialog(
            title: _title,
            message: _message,
            secondaryAction: LinagoraDialogAction(
              label: 'Cancel',
              onPressed: null,
            ),
            primaryAction: LinagoraDialogAction(
              label: 'Got it',
              onPressed: null,
            ),
          ),
        ),
      );

      final primary = t.widget<ButtonStyleButton>(
        find.byKey(LinagoraDialog.primaryActionKey),
      );
      expect(primary.enabled, isFalse);
      expect(
        primary.style?.backgroundColor?.resolve({WidgetState.disabled}),
        LinagoraButton.disabledContainerColor,
      );
      final secondary = t.widget<ButtonStyleButton>(
        find.byKey(LinagoraDialog.secondaryActionKey),
      );
      expect(secondary.enabled, isFalse);
      expect(
        secondary.style?.side?.resolve({WidgetState.disabled})?.color,
        LinagoraButton.disabledContentColor,
      );
    });

    testWidgets('divides fixed actions and pads them 16 vertically', (t) async {
      await t.pumpWidget(
        _host(
          LinagoraDialog(
            title: _title,
            message: _message,
            fixedActions: true,
            primaryAction: _action('Got it'),
          ),
        ),
      );

      final divider = t.widget<Divider>(find.byType(Divider));
      expect(divider.color, const Color(0x1F1D192B));
      expect(divider.thickness, 1);
      final primary = find.byKey(LinagoraDialog.primaryActionKey);
      expect(
        t.getTopLeft(primary).dy,
        t.getBottomLeft(find.byType(Divider)).dy + 16,
      );
      expect(t.getBottomRight(primary).dy, t.getBottomRight(_surface).dy - 16);
    });

    testWidgets('ellipsizes long labels instead of overflowing on a phone', (
      t,
    ) async {
      await _setSurface(t, const Size(320, 640));
      await t.pumpWidget(
        _host(
          LinagoraDialog(
            title: _title,
            message: _message,
            secondaryAction: _action('A very long secondary action label'),
            primaryAction: _action('A very long primary action label'),
          ),
        ),
      );

      expect(t.takeException(), isNull);
    });
  });

  group('LinagoraDialogStyle', () {
    testWidgets('overrides only the tokens it is given', (t) async {
      final style = LinagoraDialogStyle.material().copyWith(
        maxWidth: 400,
        primaryActionColor: const Color(0xFF00AA00),
      );
      await _setSurface(t, const Size(1440, 900));
      await t.pumpWidget(
        _host(
          LinagoraDialog(
            title: _title,
            message: _message,
            style: style,
            primaryAction: _action('Got it'),
          ),
        ),
      );

      expect(t.getSize(_surface).width, 400);
      expect(
        _buttonBackground(t, LinagoraDialog.primaryActionKey),
        const Color(0xFF00AA00),
      );
      expect(
        _text(t, _title).style,
        LinagoraDialogStyle.material().titleTextStyle,
      );
    });

    test('copyWith without arguments keeps every token', () {
      final base = LinagoraDialogStyle.material();
      final copy = base.copyWith();
      expect(copy.surfaceColor, base.surfaceColor);
      expect(copy.surfaceRadius, base.surfaceRadius);
      expect(copy.surfaceShadow, base.surfaceShadow);
      expect(copy.maxWidth, base.maxWidth);
      expect(copy.headerPadding, base.headerPadding);
      expect(copy.headerGap, base.headerGap);
      expect(copy.contentPadding, base.contentPadding);
      expect(copy.contentGap, base.contentGap);
      expect(copy.footerPadding, base.footerPadding);
      expect(copy.fixedFooterPadding, base.fixedFooterPadding);
      expect(copy.actionGap, base.actionGap);
      expect(copy.dividerColor, base.dividerColor);
      expect(copy.titleTextStyle, base.titleTextStyle);
      expect(copy.messageTextStyle, base.messageTextStyle);
      expect(copy.actionTextStyle, base.actionTextStyle);
      expect(copy.iconButtonSize, base.iconButtonSize);
      expect(copy.iconSize, base.iconSize);
      expect(copy.iconColor, base.iconColor);
      expect(copy.actionHeight, base.actionHeight);
      expect(copy.actionPadding, base.actionPadding);
      expect(copy.primaryActionColor, base.primaryActionColor);
      expect(copy.primaryActionHoverColor, base.primaryActionHoverColor);
      expect(copy.destructiveActionColor, base.destructiveActionColor);
      expect(copy.onActionColor, base.onActionColor);
    });

    test('copyWith replaces every token', () {
      const color = Color(0xFF123456);
      const style = TextStyle(fontSize: 1);
      const padding = EdgeInsets.all(1);
      const shadow = [BoxShadow(color: color)];
      final copy = LinagoraDialogStyle.material().copyWith(
        surfaceColor: color,
        surfaceRadius: 1,
        surfaceShadow: shadow,
        maxWidth: 1,
        headerPadding: padding,
        headerGap: 1,
        contentPadding: padding,
        contentGap: 1,
        footerPadding: padding,
        fixedFooterPadding: padding,
        actionGap: 1,
        dividerColor: color,
        titleTextStyle: style,
        messageTextStyle: style,
        actionTextStyle: style,
        iconButtonSize: 1,
        iconSize: 1,
        iconColor: color,
        actionHeight: 1,
        actionPadding: padding,
        primaryActionColor: color,
        primaryActionHoverColor: color,
        destructiveActionColor: color,
        onActionColor: color,
      );
      expect([
        copy.surfaceColor,
        copy.dividerColor,
        copy.iconColor,
        copy.primaryActionColor,
        copy.primaryActionHoverColor,
        copy.destructiveActionColor,
        copy.onActionColor,
      ], everyElement(color));
      expect([
        copy.surfaceRadius,
        copy.maxWidth,
        copy.headerGap,
        copy.contentGap,
        copy.actionGap,
        copy.iconButtonSize,
        copy.iconSize,
        copy.actionHeight,
      ], everyElement(1));
      expect([
        copy.headerPadding,
        copy.contentPadding,
        copy.footerPadding,
        copy.fixedFooterPadding,
        copy.actionPadding,
      ], everyElement(padding));
      expect([
        copy.titleTextStyle,
        copy.messageTextStyle,
        copy.actionTextStyle,
      ], everyElement(style));
      expect(copy.surfaceShadow, shadow);
    });
  });
}

void _noop() {}
