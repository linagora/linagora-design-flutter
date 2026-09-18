import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  Widget host(
    Widget child, {
    double width = 600,
    Brightness brightness = Brightness.light,
  }) {
    return MaterialApp(
      theme: ThemeData(
        brightness: brightness,
        textTheme: LinagoraTextTheme.material(),
        extensions: [LinagoraTextThemeExtension.material()],
      ),
      home: Scaffold(
        // Scrollable so a deliberately narrow alert, which wraps tall, is
        // measured at its natural height instead of against the test surface.
        body: SingleChildScrollView(
          child: Center(child: SizedBox(width: width, child: child)),
        ),
      ),
    );
  }

  Container container(WidgetTester tester) {
    return tester.widget<Container>(
      find
          .descendant(
            of: find.byType(LinagoraAlert),
            matching: find.byType(Container),
          )
          .first,
    );
  }

  BoxDecoration decoration(WidgetTester tester) {
    return container(tester).decoration! as BoxDecoration;
  }

  TextStyle styleOf(WidgetTester tester, String text) {
    return tester.widget<Text>(find.text(text)).style!;
  }

  group('content slots', () {
    testWidgets('renders the message on its own', (tester) async {
      await tester.pumpWidget(host(const LinagoraAlert(message: 'Body')));

      expect(find.text('Body'), findsOneWidget);
      expect(find.byType(LinagoraButton), findsNothing);
      expect(find.byType(LinagoraIconButton), findsNothing);
      expect(find.byType(LinagoraAlertPointer), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders the title above the message when given',
        (tester) async {
      await tester.pumpWidget(
        host(const LinagoraAlert(title: 'Heads up', message: 'Body')),
      );

      expect(find.text('Heads up'), findsOneWidget);
      final title = tester.getTopLeft(find.text('Heads up'));
      final body = tester.getTopLeft(find.text('Body'));
      expect(title.dy, lessThan(body.dy));
      expect(title.dx, body.dx);
    });

    testWidgets('an empty title renders no title line', (tester) async {
      await tester.pumpWidget(
        host(const LinagoraAlert(title: '', message: 'Body')),
      );

      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('shows the severity glyph by default and drops it on request',
        (tester) async {
      await tester.pumpWidget(host(const LinagoraAlert(message: 'Body')));
      expect(find.byIcon(Icons.error), findsOneWidget);

      await tester.pumpWidget(
        host(const LinagoraAlert(message: 'Body', showIcon: false)),
      );
      expect(find.byIcon(Icons.error), findsNothing);
    });

    testWidgets('each colour carries its own default glyph', (tester) async {
      const expected = <LinagoraAlertColor, IconData>{
        LinagoraAlertColor.primary: Icons.info,
        LinagoraAlertColor.secondary: Icons.info,
        LinagoraAlertColor.error: Icons.error,
        LinagoraAlertColor.warning: Icons.warning_rounded,
        LinagoraAlertColor.success: Icons.check_circle,
      };

      for (final entry in expected.entries) {
        await tester.pumpWidget(
          host(LinagoraAlert(message: 'Body', color: entry.key)),
        );
        expect(
          find.byIcon(entry.value),
          findsOneWidget,
          reason: 'colour ${entry.key}',
        );
      }
    });

    testWidgets('an explicit icon overrides the severity glyph',
        (tester) async {
      await tester.pumpWidget(
        host(const LinagoraAlert(message: 'Body', icon: Icons.lock)),
      );

      expect(find.byIcon(Icons.lock), findsOneWidget);
      expect(find.byIcon(Icons.error), findsNothing);
    });

    testWidgets('an icon widget replaces the glyph and is sized to the token',
        (tester) async {
      await tester.pumpWidget(
        host(const LinagoraAlert(message: 'Body', iconWidget: FlutterLogo())),
      );

      expect(find.byType(FlutterLogo), findsOneWidget);
      expect(find.byIcon(Icons.error), findsNothing);
      expect(
        tester.getSize(find.byType(FlutterLogo)),
        const Size.square(LinagoraAlert.iconSize),
      );
    });

    testWidgets('the leading glyph matches the design at 16px',
        (tester) async {
      await tester.pumpWidget(host(const LinagoraAlert(message: 'Body')));

      expect(tester.widget<Icon>(find.byIcon(Icons.error)).size, 16);
    });

    testWidgets('max lines ellipsize instead of wrapping freely',
        (tester) async {
      const long = 'A very long alert message that would otherwise wrap over '
          'several lines inside a narrow container.';
      await tester.pumpWidget(
        host(
          const LinagoraAlert(
            title: long,
            message: long,
            messageMaxLines: 1,
            titleMaxLines: 1,
          ),
          width: 240,
        ),
      );

      for (final text in tester.widgetList<Text>(find.text(long))) {
        expect(text.maxLines, 1);
        expect(text.overflow, TextOverflow.ellipsis);
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('an unbounded message wraps rather than truncating',
        (tester) async {
      await tester.pumpWidget(host(const LinagoraAlert(message: 'Body')));

      final text = tester.widget<Text>(find.text('Body'));
      expect(text.maxLines, isNull);
      expect(text.overflow, isNull);
    });
  });

  group('trailing controls', () {
    testWidgets('the action needs both a label and a callback',
        (tester) async {
      await tester.pumpWidget(
        host(const LinagoraAlert(message: 'Body', actionLabel: 'Not spam')),
      );
      expect(find.byType(LinagoraButton), findsNothing);

      await tester.pumpWidget(
        host(LinagoraAlert(message: 'Body', onActionPressed: () {})),
      );
      expect(find.byType(LinagoraButton), findsNothing);
    });

    testWidgets('the secondary action needs both a label and a callback',
        (tester) async {
      await tester.pumpWidget(
        host(
          const LinagoraAlert(
            message: 'Body',
            secondaryActionLabel: 'Report phishing',
          ),
        ),
      );

      expect(find.byType(LinagoraButton), findsNothing);
    });

    testWidgets('both actions fire their own callbacks', (tester) async {
      var primary = 0;
      var secondary = 0;
      await tester.pumpWidget(
        host(
          LinagoraAlert(
            message: 'Body',
            actionLabel: 'Not spam',
            onActionPressed: () => primary++,
            secondaryActionLabel: 'Report phishing',
            onSecondaryActionPressed: () => secondary++,
          ),
        ),
      );

      await tester.tap(find.text('Not spam'));
      await tester.tap(find.text('Report phishing'));
      expect(primary, 1);
      expect(secondary, 1);
    });

    testWidgets('close fires its callback', (tester) async {
      var closed = 0;
      await tester.pumpWidget(
        host(LinagoraAlert(message: 'Body', onClose: () => closed++)),
      );

      await tester.tap(find.byIcon(Icons.close));
      expect(closed, 1);
    });

    testWidgets('the dismiss control sits after both actions', (tester) async {
      await tester.pumpWidget(
        host(
          LinagoraAlert(
            message: 'Body',
            actionLabel: 'Not spam',
            onActionPressed: () {},
            secondaryActionLabel: 'Report',
            onSecondaryActionPressed: () {},
            onClose: () {},
          ),
        ),
      );

      final primary = tester.getCenter(find.text('Not spam')).dx;
      final secondary = tester.getCenter(find.text('Report')).dx;
      final close = tester.getCenter(find.byIcon(Icons.close)).dx;
      expect(primary, lessThan(secondary));
      expect(secondary, lessThan(close));
    });

    testWidgets('a custom close widget replaces the glyph', (tester) async {
      await tester.pumpWidget(
        host(
          LinagoraAlert(
            message: 'Body',
            onClose: () {},
            closeIconWidget: const FlutterLogo(),
          ),
        ),
      );

      expect(find.byType(FlutterLogo), findsOneWidget);
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('the dismiss control keeps its 32px slot', (tester) async {
      await tester.pumpWidget(
        host(LinagoraAlert(message: 'Body', onClose: () {})),
      );

      expect(
        tester.getSize(find.byType(LinagoraIconButton)),
        const Size.square(LinagoraAlert.closeSlotSize),
      );
    });

    testWidgets('the action button honours the minimum height token',
        (tester) async {
      await tester.pumpWidget(
        host(
          LinagoraAlert(
            message: 'Body',
            actionLabel: 'Go',
            onActionPressed: () {},
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(LinagoraButton)).height,
        greaterThanOrEqualTo(LinagoraAlert.actionMinHeight),
      );
    });

    testWidgets('an action icon renders beside the label', (tester) async {
      await tester.pumpWidget(
        host(
          LinagoraAlert(
            message: 'Body',
            actionLabel: 'Not spam',
            onActionPressed: () {},
            actionIcon: Icons.shield,
          ),
        ),
      );

      expect(find.byIcon(Icons.shield), findsOneWidget);
    });
  });

  group('layout', () {
    testWidgets('container carries the radius and padding tokens',
        (tester) async {
      await tester.pumpWidget(host(const LinagoraAlert(message: 'Body')));

      expect(
        decoration(tester).borderRadius,
        const BorderRadius.all(Radius.circular(LinagoraAlert.borderRadius)),
      );
      expect(
        container(tester).padding,
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      );
    });

    testWidgets('the icon keeps the token gap from the text', (tester) async {
      await tester.pumpWidget(
        host(const LinagoraAlert(title: 'Heads up', message: 'Body')),
      );

      final iconRight = tester.getBottomRight(find.byIcon(Icons.error)).dx;
      final titleLeft = tester.getTopLeft(find.text('Heads up')).dx;
      expect(titleLeft - iconRight, closeTo(LinagoraAlert.iconSpacing, 0.01));
    });

    testWidgets('the icon aligns to the first line, not the block centre',
        (tester) async {
      await tester.pumpWidget(
        host(
          const LinagoraAlert(
            title: 'Heads up',
            message: 'A message long enough to wrap onto a second line inside '
                'this narrow alert container.',
          ),
          width: 320,
        ),
      );

      final icon = tester.getCenter(find.byIcon(Icons.error)).dy;
      final title = tester.getCenter(find.text('Heads up')).dy;
      expect(icon, closeTo(title, 1));
    });

    testWidgets('a titled alert matches the design height at full width',
        (tester) async {
      Future<double> heightOf(LinagoraAlertSize size) async {
        await tester.pumpWidget(
          host(
            LinagoraAlert(
              title: 'This message may be dangerous',
              message: 'This message contains a suspicious link.',
              actionLabel: 'Not spam',
              onActionPressed: () {},
              size: size,
            ),
            width: 1141,
          ),
        );
        return tester.getSize(find.byType(LinagoraAlert)).height;
      }

      // Within a pixel of the design: the line boxes round up in the design
      // tool and down here, so an exact match would assert the rasterizer
      // rather than the padding and gap tokens under test.
      final normal = await heightOf(LinagoraAlertSize.normal);
      final compact = await heightOf(LinagoraAlertSize.compact);
      expect(normal, closeTo(80, 1));
      expect(compact, closeTo(68, 1));
      expect(normal - compact, closeTo(12, 0.01));
    });

    testWidgets('actions alignment moves the cluster within the block',
        (tester) async {
      Future<double> actionCentre(LinagoraAlertActionsAlignment value) async {
        await tester.pumpWidget(
          host(
            LinagoraAlert(
              title: 'Heads up',
              message: 'A message long enough to wrap onto a second line '
                  'inside this narrow alert container.',
              actionLabel: 'Not spam',
              onActionPressed: () {},
              actionsAlignment: value,
            ),
            width: 360,
          ),
        );
        return tester.getCenter(find.byType(LinagoraButton)).dy;
      }

      final top = await actionCentre(LinagoraAlertActionsAlignment.top);
      final centre = await actionCentre(LinagoraAlertActionsAlignment.center);
      final bottom = await actionCentre(LinagoraAlertActionsAlignment.bottom);

      expect(top, lessThan(centre));
      expect(centre, lessThan(bottom));
    });

    testWidgets('centred text alignment centres the title and message',
        (tester) async {
      await tester.pumpWidget(
        host(
          const LinagoraAlert(
            title: 'Heads up',
            message: 'Body',
            textAlignment: LinagoraAlertTextAlignment.center,
          ),
        ),
      );

      expect(
        tester.widget<Text>(find.text('Heads up')).textAlign,
        TextAlign.center,
      );
      expect(
        tester.getCenter(find.text('Heads up')).dx,
        closeTo(tester.getCenter(find.text('Body')).dx, 0.01),
      );
    });

    testWidgets('the alert fills the width it is given', (tester) async {
      await tester.pumpWidget(
        host(const LinagoraAlert(message: 'Body'), width: 420),
      );

      expect(tester.getSize(find.byType(LinagoraAlert)).width, 420);
    });

    testWidgets('a long action label does not overflow a narrow alert',
        (tester) async {
      await tester.pumpWidget(
        host(
          LinagoraAlert(
            title: 'This message may be dangerous',
            message: 'This message contains a suspicious link. Do not click '
                'it, reply, or share personal information.',
            actionLabel: 'Report this as not spam right now',
            onActionPressed: () {},
            onClose: () {},
          ),
          width: 300,
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('both actions and a dismiss control fit a narrow alert',
        (tester) async {
      await tester.pumpWidget(
        host(
          LinagoraAlert(
            message: 'This message contains a suspicious link.',
            actionLabel: 'Not spam',
            onActionPressed: () {},
            secondaryActionLabel: 'Report phishing',
            onSecondaryActionPressed: () {},
            onClose: () {},
          ),
          width: 320,
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('moves trailing controls below content when width is critical',
        (tester) async {
      await tester.pumpWidget(
        host(
          LinagoraAlert(
            message: 'Body',
            actionLabel: 'Primary action',
            onActionPressed: () {},
            secondaryActionLabel: 'Secondary action',
            onSecondaryActionPressed: () {},
            onClose: () {},
          ),
          width: 120,
        ),
      );

      expect(
        tester.getTopLeft(find.byType(LinagoraIconButton)).dy,
        greaterThanOrEqualTo(tester.getBottomLeft(find.text('Body')).dy),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('shrink-wraps under unbounded horizontal constraints',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: LinagoraAlert(
                title: 'Heads up',
                message: 'Body',
                actionLabel: 'Not spam',
                onActionPressed: () {},
                secondaryActionLabel: 'Report phishing',
                onSecondaryActionPressed: () {},
                onClose: () {},
              ),
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byType(LinagoraAlert)).width, greaterThan(0));
      expect(tester.takeException(), isNull);
    });

    testWidgets('the maximum action share still reserves content width',
        (tester) async {
      await tester.pumpWidget(
        host(
          LinagoraAlert(
            message: 'Body',
            actionLabel: 'A very long primary action label',
            onActionPressed: () {},
            secondaryActionLabel: 'A very long secondary action label',
            onSecondaryActionPressed: () {},
            onClose: () {},
            actionsMaxWidthFraction: 1,
          ),
          width: 280,
        ),
      );

      expect(tester.getSize(find.text('Body')).width, greaterThan(0));
      expect(tester.takeException(), isNull);
    });

    testWidgets('a small action share still preserves the dismiss slot',
        (tester) async {
      await tester.pumpWidget(
        host(
          LinagoraAlert(
            message: 'Body',
            onClose: () {},
            actionsMaxWidthFraction: 0.01,
          ),
          width: 280,
        ),
      );

      expect(
        tester.getSize(find.byType(LinagoraIconButton)),
        const Size.square(LinagoraAlert.closeSlotSize),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('large accessible text remains overflow-free', (tester) async {
      await tester.pumpWidget(
        host(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(3)),
            child: LinagoraAlert(
              title: 'This message may be dangerous',
              message: 'This message contains a suspicious link.',
              actionLabel: 'Not spam',
              onActionPressed: () {},
              secondaryActionLabel: 'Report phishing',
              onSecondaryActionPressed: () {},
              onClose: () {},
            ),
          ),
          width: 280,
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('right-to-left layout keeps the controls in logical order',
        (tester) async {
      await tester.pumpWidget(
        host(
          Directionality(
            textDirection: TextDirection.rtl,
            child: LinagoraAlert(
              message: 'Body',
              actionLabel: 'Not spam',
              onActionPressed: () {},
              secondaryActionLabel: 'Report',
              onSecondaryActionPressed: () {},
              onClose: () {},
            ),
          ),
          width: 280,
        ),
      );

      final primary = tester.getCenter(find.text('Not spam')).dx;
      final secondary = tester.getCenter(find.text('Report')).dx;
      final close = tester.getCenter(find.byIcon(Icons.close)).dx;
      expect(close, lessThan(secondary));
      expect(secondary, lessThan(primary));
      expect(tester.takeException(), isNull);
    });
  });

  group('pointer', () {
    testWidgets('the pointer is hidden unless asked for', (tester) async {
      await tester.pumpWidget(host(const LinagoraAlert(message: 'Body')));

      expect(find.byType(LinagoraAlertPointer), findsNothing);
    });

    testWidgets('the pointer hangs below the container in its fill',
        (tester) async {
      await tester.pumpWidget(
        host(const LinagoraAlert(message: 'Body', showPointer: true)),
      );

      final pointer = find.byType(LinagoraAlertPointer);
      expect(pointer, findsOneWidget);
      expect(
        tester.getSize(pointer),
        const Size(LinagoraAlert.pointerWidth, LinagoraAlert.pointerHeight),
      );

      final alert = tester.getRect(find.byType(LinagoraAlert));
      final tail = tester.getRect(pointer);
      expect(tail.bottom, closeTo(alert.bottom, 0.01));
      expect(tail.center.dx, closeTo(alert.center.dx, 0.01));
      expect(
        tester.widget<LinagoraAlertPointer>(pointer).color,
        decoration(tester).color,
      );
    });

    testWidgets('the pointer adds exactly its own height', (tester) async {
      await tester.pumpWidget(host(const LinagoraAlert(message: 'Body')));
      final plain = tester.getSize(find.byType(LinagoraAlert)).height;

      await tester.pumpWidget(
        host(const LinagoraAlert(message: 'Body', showPointer: true)),
      );
      final withTail = tester.getSize(find.byType(LinagoraAlert)).height;

      expect(withTail - plain, closeTo(LinagoraAlert.pointerHeight, 0.01));
    });

    testWidgets('standard does not reserve space for an invisible pointer',
        (tester) async {
      await tester.pumpWidget(
        host(
          const LinagoraAlert(
            message: 'Body',
            variant: LinagoraAlertVariant.standard,
          ),
        ),
      );
      final plain = tester.getSize(find.byType(LinagoraAlert)).height;

      await tester.pumpWidget(
        host(
          const LinagoraAlert(
            message: 'Body',
            variant: LinagoraAlertVariant.standard,
            showPointer: true,
          ),
        ),
      );

      expect(find.byType(LinagoraAlertPointer), findsNothing);
      expect(tester.getSize(find.byType(LinagoraAlert)).height, plain);
    });

    testWidgets('standard can show a pointer with an explicit background',
        (tester) async {
      const background = Color(0xFF00FF00);
      await tester.pumpWidget(
        host(
          const LinagoraAlert(
            message: 'Body',
            variant: LinagoraAlertVariant.standard,
            showPointer: true,
            backgroundColor: background,
          ),
        ),
      );

      expect(find.byType(LinagoraAlertPointer), findsOneWidget);
      expect(
        tester.widget<LinagoraAlertPointer>(
          find.byType(LinagoraAlertPointer),
        ).color,
        background,
      );
    });
  });

  group('palette', () {
    testWidgets('filled tints the container with the accent', (tester) async {
      await tester.pumpWidget(host(const LinagoraAlert(message: 'Body')));

      expect(
        decoration(tester).color,
        LinagoraSysColors.material()
            .error
            .withValues(alpha: LinagoraAlertPalette.containerOpacity),
      );
    });

    testWidgets('standard drops the container fill', (tester) async {
      await tester.pumpWidget(
        host(
          const LinagoraAlert(
            message: 'Body',
            variant: LinagoraAlertVariant.standard,
          ),
        ),
      );

      expect(decoration(tester).color, Colors.transparent);
      expect(
        tester.widget<Icon>(find.byIcon(Icons.error)).color,
        LinagoraSysColors.material().error,
      );
    });

    testWidgets('text uses the light text token on a light surface',
        (tester) async {
      await tester.pumpWidget(
        host(const LinagoraAlert(title: 'Heads up', message: 'Body')),
      );

      final expected = LinagoraAlertPalette.lightTextColor
          .withValues(alpha: LinagoraAlertPalette.foregroundOpacity);
      expect(styleOf(tester, 'Heads up').color, expected);
      expect(styleOf(tester, 'Body').color, expected);
    });

    testWidgets('the dismiss glyph is lighter than the text', (tester) async {
      await tester.pumpWidget(
        host(LinagoraAlert(message: 'Body', onClose: () {})),
      );

      final close = tester.widget<LinagoraIconButton>(
        find.byType(LinagoraIconButton),
      );
      expect(close.color!.a, lessThan(styleOf(tester, 'Body').color!.a));
    });

    testWidgets('a dark surface takes its foreground from the theme',
        (tester) async {
      await tester.pumpWidget(
        host(
          const LinagoraAlert(message: 'Body'),
          brightness: Brightness.dark,
        ),
      );

      expect(
        styleOf(tester, 'Body').color,
        isNot(
          LinagoraAlertPalette.lightTextColor
              .withValues(alpha: LinagoraAlertPalette.foregroundOpacity),
        ),
      );
    });

    testWidgets('an accent override retints the container and the icon',
        (tester) async {
      const accent = Color(0xFF6750A4);
      await tester.pumpWidget(
        host(const LinagoraAlert(message: 'Body', accentColor: accent)),
      );

      expect(
        decoration(tester).color,
        accent.withValues(alpha: LinagoraAlertPalette.containerOpacity),
      );
      expect(tester.widget<Icon>(find.byIcon(Icons.error)).color, accent);
    });

    testWidgets('explicit background and foreground win over the palette',
        (tester) async {
      const background = Color(0xFF00FF00);
      const foreground = Color(0xFF0000FF);
      await tester.pumpWidget(
        host(
          LinagoraAlert(
            message: 'Body',
            backgroundColor: background,
            foregroundColor: foreground,
            onClose: () {},
          ),
        ),
      );

      expect(decoration(tester).color, background);
      expect(styleOf(tester, 'Body').color, foreground);
      expect(
        tester.widget<LinagoraIconButton>(find.byType(LinagoraIconButton)).color,
        LinagoraAlertPalette.lightTextColor.withValues(
          alpha: LinagoraAlertPalette.closeOpacity,
        ),
      );
    });
  });

  group('typography', () {
    testWidgets('title and message carry the design line boxes',
        (tester) async {
      await tester.pumpWidget(
        host(const LinagoraAlert(title: 'Heads up', message: 'Body')),
      );

      final title = styleOf(tester, 'Heads up');
      expect(title.fontSize, 16);
      expect(title.fontWeight, FontWeight.w600);
      expect(title.height, closeTo(21 / 16, 0.001));
      expect(title.letterSpacing, 0.15);

      final message = styleOf(tester, 'Body');
      expect(message.fontSize, 14);
      expect(message.fontWeight, FontWeight.w500);
      expect(message.height, closeTo(18.4 / 14, 0.001));
      expect(message.letterSpacing, 0.25);
    });

    testWidgets('typography survives a theme without the Linagora extension',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LinagoraAlert(title: 'Heads up', message: 'Body'),
          ),
        ),
      );

      expect(styleOf(tester, 'Heads up').fontSize, 16);
      expect(tester.takeException(), isNull);
    });

    testWidgets('actions use the shared button style without a theme extension',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LinagoraAlert(
              message: 'Body',
              actionLabel: 'Primary',
              onActionPressed: () {},
              secondaryActionLabel: 'Secondary',
              onSecondaryActionPressed: () {},
            ),
          ),
        ),
      );

      final expected = LinagoraTypography.material().buttonMedium;
      for (final action in
          tester.widgetList<LinagoraButton>(find.byType(LinagoraButton))) {
        expect(action.textStyle, expected);
      }
    });
  });

  group('semantics', () {
    testWidgets('announces as a live region by default and supports opting out',
        (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        await tester.pumpWidget(host(const LinagoraAlert(message: 'Body')));
        expect(
          tester
              .getSemantics(find.byType(LinagoraAlert))
              .flagsCollection
              .isLiveRegion,
          isTrue,
        );

        await tester.pumpWidget(
          host(const LinagoraAlert(message: 'Body', liveRegion: false)),
        );
        expect(
          tester
              .getSemantics(find.byType(LinagoraAlert))
              .flagsCollection
              .isLiveRegion,
          isFalse,
        );
      } finally {
        semantics.dispose();
      }
    });
  });

  group('style resolvers', () {
    test('standard and filled differ only in the container fill', () {
      final filled = LinagoraAlertPalette.resolve(LinagoraAlertColor.primary);
      final standard = LinagoraAlertPalette.resolve(
        LinagoraAlertColor.primary,
        variant: LinagoraAlertVariant.standard,
      );

      expect(filled.accent, standard.accent);
      expect(filled.foreground, standard.foreground);
      expect(standard.background, Colors.transparent);
      expect(
        filled.background,
        filled.accent.withValues(alpha: LinagoraAlertPalette.containerOpacity),
      );
    });

    test('action tints stay lighter than the container tint', () {
      final palette = LinagoraAlertPalette.resolve(LinagoraAlertColor.error);

      expect(palette.actionBackground.a, lessThan(palette.background.a));
      expect(
        palette.actionHoverBackground.a,
        greaterThan(palette.actionBackground.a),
      );
    });

    test('each colour resolves to the exact light and dark accent', () {
      final colors = LinagoraSysColors.material();
      final light = <LinagoraAlertColor, Color>{
        LinagoraAlertColor.primary: colors.primary,
        LinagoraAlertColor.secondary: colors.secondary,
        LinagoraAlertColor.error: colors.error,
        LinagoraAlertColor.warning: colors.warning,
        LinagoraAlertColor.success: colors.success,
      };
      final dark = <LinagoraAlertColor, Color>{
        LinagoraAlertColor.primary: colors.primaryDark,
        LinagoraAlertColor.secondary: colors.secondaryDark,
        LinagoraAlertColor.error: colors.errorDark,
        LinagoraAlertColor.warning: colors.warningDark,
        LinagoraAlertColor.success: colors.successDark,
      };

      for (final color in LinagoraAlertColor.values) {
        expect(
          LinagoraAlertPalette.resolve(color).accent,
          light[color],
          reason: 'light $color',
        );
        expect(
          LinagoraAlertPalette.resolve(
            color,
            brightness: Brightness.dark,
          ).accent,
          dark[color],
          reason: 'dark $color',
        );
      }
    });

    test('sizes resolve to the exact design metrics', () {
      final normal = LinagoraAlertMetrics.resolve(LinagoraAlertSize.normal);
      final compact = LinagoraAlertMetrics.resolve(LinagoraAlertSize.compact);

      expect(normal.textVerticalPadding, 8);
      expect(normal.textSpacing, 8);
      expect(normal.iconTopPadding, 10);
      expect(compact.textVerticalPadding, 4);
      expect(compact.textSpacing, 4);
      expect(compact.iconTopPadding, 6);
    });
  });

  group('validation', () {
    test('rejects invalid line and action constraints', () {
      expect(
        () => LinagoraAlert(
          message: 'Body',
          actionsMaxWidthFraction: 0,
        ),
        throwsAssertionError,
      );
      expect(
        () => LinagoraAlert(
          message: 'Body',
          actionsMaxWidthFraction: 1.01,
        ),
        throwsAssertionError,
      );
      expect(
        () => LinagoraAlert(message: 'Body', actionMaxWidth: 0),
        throwsAssertionError,
      );
      expect(
        () => LinagoraAlert(message: 'Body', messageMaxLines: 0),
        throwsAssertionError,
      );
      expect(
        () => LinagoraAlert(message: 'Body', titleMaxLines: 0),
        throwsAssertionError,
      );
    });

    test('rejects non-positive pointer dimensions', () {
      expect(
        () => LinagoraAlertPointer(color: Colors.red, width: 0),
        throwsAssertionError,
      );
      expect(
        () => LinagoraAlertPointer(color: Colors.red, height: 0),
        throwsAssertionError,
      );
    });
  });
}
