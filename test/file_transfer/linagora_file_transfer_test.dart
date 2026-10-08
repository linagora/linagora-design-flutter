import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

Widget _host(Widget child, {Size size = const Size(1200, 800)}) => MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: size),
        child: Scaffold(body: Center(child: child)),
      ),
    );

Widget _row({
  double? progress,
  VoidCallback? onCancel,
  LinagoraFileTransferLayout layout = LinagoraFileTransferLayout.wide,
  String name = 'report.pdf',
}) =>
    LinagoraFileTransferRow(
      fileName: name,
      statusLabel: '332M',
      progress: progress,
      onCancel: onCancel,
      layout: layout,
    );

double? _barValue(WidgetTester t) =>
    t.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator)).value;

void main() {
  group('LinagoraFileTransferRow', () {
    testWidgets('null progress is indeterminate', (t) async {
      await t.pumpWidget(_host(_row()));
      expect(_barValue(t), isNull);
    });

    testWidgets('progress animates to its value and clamps', (t) async {
      await t.pumpWidget(_host(_row(progress: 0.4)));
      await t.pumpAndSettle();
      expect(_barValue(t), 0.4);
      await t.pumpWidget(_host(_row(progress: 3)));
      await t.pumpAndSettle();
      expect(_barValue(t), 1.0);
      await t.pumpWidget(_host(_row(progress: double.nan)));
      await t.pumpAndSettle();
      expect(_barValue(t), 0.0);
    });

    testWidgets('no onCancel hides the button, tap calls it otherwise',
        (t) async {
      await t.pumpWidget(_host(_row(progress: 0.5)));
      expect(find.byKey(LinagoraFileTransferRow.cancelButtonKey), findsNothing);
      var taps = 0;
      await t.pumpWidget(_host(_row(progress: 0.5, onCancel: () => taps++)));
      await t.tap(find.byKey(LinagoraFileTransferRow.cancelButtonKey));
      expect(taps, 1);
    });

    testWidgets('a settled row keeps the cancel slot and the bar width',
        (t) async {
      await t.pumpWidget(_host(_row(progress: 0.5, onCancel: () {})));
      final running = t.getSize(find.byType(LinearProgressIndicator)).width;
      await t.pumpWidget(_host(_row(progress: 0.5)));
      expect(t.getSize(find.byType(LinearProgressIndicator)).width, running);
    });

    testWidgets('announces name and status, cancel shows its tooltip',
        (t) async {
      final semantics = t.ensureSemantics();
      await t.pumpWidget(_host(Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final name in ['a.pdf', 'b.pdf'])
            LinagoraFileTransferRow(
              fileName: name,
              statusLabel: '332M',
              progress: 0.5,
              onCancel: () {},
              cancelTooltip: 'Cancel upload',
            ),
        ],
      )));
      final rows = find.byType(LinagoraFileTransferRow);
      expect(t.getSemantics(rows.first),
          containsSemantics(label: 'a.pdf, 332M'));
      expect(t.getSemantics(rows.last),
          containsSemantics(label: 'b.pdf, 332M'));
      expect(find.byTooltip('Cancel upload'), findsNWidgets(2));
      semantics.dispose();
    });

    testWidgets('wide keeps the bar beside the chip, compact below it',
        (t) async {
      await t.pumpWidget(_host(_row(progress: 0.5)));
      final wideBar = t.getTopLeft(find.byType(LinearProgressIndicator)).dy;
      final wideName = t.getTopLeft(find.text('report.pdf')).dy;
      expect((wideBar - wideName).abs(), lessThan(20));
      await t.pumpWidget(_host(_row(
        progress: 0.5,
        layout: LinagoraFileTransferLayout.compact,
      )));
      final compactBar = t.getTopLeft(find.byType(LinearProgressIndicator)).dy;
      final compactName = t.getTopLeft(find.text('report.pdf')).dy;
      expect(compactBar - compactName, greaterThan(20));
    });

    testWidgets('tints the close icon with closeIconColor', (t) async {
      await t.pumpWidget(_host(_row(progress: 0.5, onCancel: () {})));
      final icon = t.widget<SvgPicture>(find.descendant(
        of: find.byKey(LinagoraFileTransferRow.cancelButtonKey),
        matching: find.byType(SvgPicture),
      ));
      expect(
        icon.colorFilter,
        ColorFilter.mode(
          LinagoraFileTransferStyle.wide().closeIconColor,
          BlendMode.srcIn,
        ),
      );
    });

    testWidgets('compact bar starts under the chip and the label hugs the close',
        (t) async {
      await t.pumpWidget(_host(SizedBox(
        width: 361,
        child: _row(
          progress: 0.5,
          onCancel: () {},
          layout: LinagoraFileTransferLayout.compact,
        ),
      )));
      final left = t.getTopLeft(find.byType(SizedBox).first).dx;
      final bar = find.byType(LinearProgressIndicator);
      expect(t.getTopLeft(bar).dx - left, 24);
      expect(t.getTopRight(bar).dx - left, 345);
      expect(t.getTopRight(find.text('332M')).dx - left, 305);
    });

    testWidgets('chip keeps the 191x36 frame size despite its border',
        (t) async {
      await t.pumpWidget(_host(_row(progress: 0.5)));
      final chip = find.ancestor(
        of: find.text('report.pdf'),
        matching: find.byType(DecoratedBox),
      ).first;
      expect(t.getSize(chip), const Size(191, 36));
    });

    testWidgets('a long name ellipsises without overflow', (t) async {
      await t.pumpWidget(_host(
        _row(progress: 0.5, name: 'a' * 200),
        size: const Size(400, 800),
      ));
      expect(t.takeException(), isNull);
    });
  });

  group('LinagoraFileTransferDialog', () {
    Widget dialog({
      int count = 3,
      bool showCancelAll = true,
      VoidCallback? onClose,
      VoidCallback? onCancelAll,
      LinagoraFileTransferLayout layout = LinagoraFileTransferLayout.wide,
    }) =>
        LinagoraFileTransferDialog(
          title: 'Attaching file',
          description: const TextSpan(text: 'desc'),
          itemCount: count,
          itemBuilder: (_, i) => _row(progress: 0.5, name: 'f$i'),
          cancelLabel: 'Cancel',
          onClose: onClose,
          onCancelAll: onCancelAll,
          showCancelAll: showCancelAll,
          layout: layout,
        );

    testWidgets('builds every item inside one list', (t) async {
      await t.pumpWidget(_host(dialog()));
      expect(find.byType(LinagoraFileTransferRow), findsNWidgets(3));
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('close and cancel-all fire their callbacks', (t) async {
      var closes = 0, cancels = 0;
      await t.pumpWidget(_host(dialog(
        onClose: () => closes++,
        onCancelAll: () => cancels++,
      )));
      await t.tap(find.byKey(LinagoraFileTransferDialog.closeButtonKey));
      await t.tap(find.byKey(LinagoraFileTransferDialog.cancelAllButtonKey));
      expect([closes, cancels], [1, 1]);
    });

    testWidgets('hidden cancel-all keeps its height and ignores taps',
        (t) async {
      await t.pumpWidget(_host(dialog()));
      final shown = t.getSize(find.byType(LinagoraFileTransferDialog));
      var cancels = 0;
      await t.pumpWidget(_host(dialog(
        showCancelAll: false,
        onCancelAll: () => cancels++,
      )));
      expect(t.getSize(find.byType(LinagoraFileTransferDialog)), shown);
      await t.tap(
        find.byKey(LinagoraFileTransferDialog.cancelAllButtonKey),
        warnIfMissed: false,
      );
      expect(cancels, 0);
    });

    testWidgets('hidden cancel-all leaves the focus and semantics trees',
        (t) async {
      await t.pumpWidget(_host(dialog(showCancelAll: false)));
      expect(
        find.ancestor(
          of: find.byKey(LinagoraFileTransferDialog.cancelAllButtonKey),
          matching: find.byWidgetPredicate(
              (w) => w is ExcludeFocus && w.excluding),
        ),
        findsOneWidget,
      );
      expect(
        find.ancestor(
          of: find.byKey(LinagoraFileTransferDialog.cancelAllButtonKey),
          matching: find.byWidgetPredicate(
              (w) => w is ExcludeSemantics && w.excluding),
        ),
        findsOneWidget,
      );
    });

    testWidgets('header close shows its tooltip', (t) async {
      await t.pumpWidget(_host(LinagoraFileTransferDialog(
        title: 'Attaching file',
        description: const TextSpan(text: 'desc'),
        itemCount: 0,
        itemBuilder: (_, i) => const SizedBox(),
        cancelLabel: 'Cancel',
        onClose: () {},
        closeTooltip: 'Close',
      )));
      expect(find.byTooltip('Close'), findsOneWidget);
    });

    testWidgets('null onClose hides the header close', (t) async {
      await t.pumpWidget(_host(dialog()));
      expect(find.byKey(LinagoraFileTransferDialog.closeButtonKey),
          findsNothing);
    });

    testWidgets('compact sheet matches the mobile frame height', (t) async {
      await t.pumpWidget(_host(SizedBox(
        width: 361,
        child: LinagoraFileTransferDialog(
          layout: LinagoraFileTransferLayout.compact,
          title: 'Attaching file',
          description: const TextSpan(text: 'One line'),
          itemCount: 1,
          itemBuilder: (_, __) => _row(
            progress: 0.5,
            onCancel: () {},
            layout: LinagoraFileTransferLayout.compact,
          ),
          cancelLabel: 'Cancel',
          onCancelAll: () {},
        ),
      )));
      expect(
        t.getSize(find.byKey(LinagoraFileTransferDialog.cancelAllButtonKey)).height,
        40,
      );
      // header 48 + 1 line 20 + row 8+40+8+6+8 + footer 2+40+8
      expect(t.getSize(find.byType(LinagoraFileTransferDialog)).height, 188);
    });

    testWidgets('cancel aligns end on wide and start on compact', (t) async {
      await t.pumpWidget(_host(SizedBox(width: 600, child: dialog())));
      final wide = t.getCenter(
        find.byKey(LinagoraFileTransferDialog.cancelAllButtonKey)).dx;
      await t.pumpWidget(_host(SizedBox(
        width: 600,
        child: dialog(layout: LinagoraFileTransferLayout.compact),
      )));
      final compact = t.getCenter(
        find.byKey(LinagoraFileTransferDialog.cancelAllButtonKey)).dx;
      expect(wide, greaterThan(compact));
    });
  });

  group('LinagoraFileTransferStyle', () {
    test('forLayout returns cached tokens per layout', () {
      expect(
        identical(
          LinagoraFileTransferStyle.forLayout(LinagoraFileTransferLayout.wide),
          LinagoraFileTransferStyle.wide(),
        ),
        isTrue,
      );
      expect(LinagoraFileTransferStyle.wide(),
          isNot(LinagoraFileTransferStyle.compact()));
      expect(
        identical(
          LinagoraFileTransferStyle.forLayout(
              LinagoraFileTransferLayout.compact),
          LinagoraFileTransferStyle.compact(),
        ),
        isTrue,
      );
    });

    test('compact keeps its own radius, title and status label', () {
      final wide = LinagoraFileTransferStyle.wide();
      final compact = LinagoraFileTransferStyle.compact();
      expect([wide.surfaceRadius, compact.surfaceRadius], [6, 14]);
      expect([wide.titleTextStyle.fontSize, compact.titleTextStyle.fontSize],
          [24, 16]);
      expect(
          [wide.statusTextStyle.fontSize, compact.statusTextStyle.fontSize],
          [16, 13]);
      expect(compact.statusTextStyle.fontWeight, FontWeight.w400);
      expect([wide.statusLabelWidth, compact.statusLabelWidth], [88, 64]);
    });

    test('copyWith sets every token and each one breaks equality', () {
      final base = LinagoraFileTransferStyle.wide();
      for (final (name, changed, read, value) in _tokenOverrides(base)) {
        expect(read(changed), value, reason: name);
        expect(changed, isNot(base), reason: name);
        expect(changed.hashCode, isNot(base.hashCode), reason: name);
      }
    });

    test('copyWith overrides one token and keeps equality', () {
      final base = LinagoraFileTransferStyle.wide();
      final changed = base.copyWith(barHeight: 10);
      expect(changed.barHeight, 10);
      expect(changed, isNot(base));
      expect(changed.copyWith(barHeight: base.barHeight), base);
      expect(changed.copyWith(barHeight: base.barHeight).hashCode,
          base.hashCode);
    });

    testWidgets('a custom style reaches the bar', (t) async {
      final style = LinagoraFileTransferStyle.wide().copyWith(barHeight: 12);
      await t.pumpWidget(_host(LinagoraFileTransferRow(
        fileName: 'a',
        statusLabel: 'b',
        progress: 0.5,
        style: style,
      )));
      expect(
        t.widget<LinearProgressIndicator>(
            find.byType(LinearProgressIndicator)).minHeight,
        12,
      );
    });
  });

  group('LinagoraFileTransferLeading', () {
    testWidgets('defaults to the theme primary, takes a custom color',
        (t) async {
      Color? iconColor() => t.widget<Icon>(find.byType(Icon)).color;
      await t.pumpWidget(_host(const LinagoraFileTransferLeading()));
      final context = t.element(find.byType(LinagoraFileTransferLeading));
      expect(iconColor(), Theme.of(context).colorScheme.primary);
      await t.pumpWidget(_host(const LinagoraFileTransferLeading(
        color: Color(0xFF123456),
      )));
      expect(iconColor(), const Color(0xFF123456));
    });
  });

  group('LinagoraFileTransferSurface', () {
    testWidgets('wide caps its width', (t) async {
      await t.pumpWidget(_host(const LinagoraFileTransferSurface(
        child: SizedBox(height: 50, width: 2000),
      )));
      expect(
        t.getSize(find.byType(DecoratedBox).last).width,
        LinagoraFileTransferStyle.wide().maxWidth,
      );
    });

    testWidgets('names its route for screen readers', (t) async {
      final semantics = t.ensureSemantics();
      await t.pumpWidget(_host(const LinagoraFileTransferSurface(
        semanticLabel: 'Upload dialog',
        child: SizedBox(height: 50),
      )));
      expect(
        t.getSemantics(find.byType(LinagoraFileTransferSurface)),
        matchesSemantics(
          label: 'Upload dialog',
          scopesRoute: true,
          namesRoute: true,
        ),
      );
      semantics.dispose();
    });

    testWidgets('compact sits at the bottom, full width', (t) async {
      await t.pumpWidget(_host(const LinagoraFileTransferSurface(
        layout: LinagoraFileTransferLayout.compact,
        child: SizedBox(height: 50),
      )));
      final rect = t.getRect(find.byType(DecoratedBox).last);
      final screen = t.getRect(find.byType(Scaffold));
      expect(rect.width, screen.width);
      expect(rect.bottom, screen.bottom);
    });

    testWidgets('compact keeps the content above the bottom inset',
        (t) async {
      await t.pumpWidget(const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(
            size: Size(400, 800),
            padding: EdgeInsets.only(bottom: 34),
          ),
          child: LinagoraFileTransferSurface(
            layout: LinagoraFileTransferLayout.compact,
            child: SizedBox(key: ValueKey('content'), height: 50),
          ),
        ),
      ));
      final card = t.getRect(find
          .descendant(
            of: find.byType(LinagoraFileTransferSurface),
            matching: find.byType(DecoratedBox),
          )
          .first);
      final content = t.getRect(find.byKey(const ValueKey('content')));
      expect(card.bottom - content.bottom, 34);
    });

    testWidgets('wide keeps its inset padding on a narrow screen', (t) async {
      t.view.physicalSize = const Size(400, 800);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      await t.pumpWidget(_host(const LinagoraFileTransferSurface(
        child: SizedBox(height: 50, width: 2000),
      )));
      expect(t.getSize(find.byType(DecoratedBox).last).width, 400 - 48);
    });
  });
}

typedef _TokenOverride = (
  String,
  LinagoraFileTransferStyle,
  Object Function(LinagoraFileTransferStyle),
  Object,
);

List<_TokenOverride> _tokenOverrides(LinagoraFileTransferStyle b) {
  const c = Color(0xFF123456);
  const i = EdgeInsets.all(3);
  const t = TextStyle(fontSize: 3);
  const sh = [BoxShadow(blurRadius: 3)];
  const d = Duration(seconds: 3);
  return [
    ('surfaceColor', b.copyWith(surfaceColor: c), (s) => s.surfaceColor, c),
    ('surfaceRadius', b.copyWith(surfaceRadius: 3),
        (s) => s.surfaceRadius, 3.0),
    ('surfaceShadow', b.copyWith(surfaceShadow: sh),
        (s) => s.surfaceShadow, sh),
    ('maxWidth', b.copyWith(maxWidth: 3), (s) => s.maxWidth, 3.0),
    ('maxListHeight', b.copyWith(maxListHeight: 3),
        (s) => s.maxListHeight, 3.0),
    ('headerPadding', b.copyWith(headerPadding: i), (s) => s.headerPadding, i),
    ('descriptionPadding', b.copyWith(descriptionPadding: i),
        (s) => s.descriptionPadding, i),
    ('rowPadding', b.copyWith(rowPadding: i), (s) => s.rowPadding, i),
    ('cancelPadding', b.copyWith(cancelPadding: i), (s) => s.cancelPadding, i),
    ('titleTextStyle', b.copyWith(titleTextStyle: t),
        (s) => s.titleTextStyle, t),
    ('bodyTextStyle', b.copyWith(bodyTextStyle: t), (s) => s.bodyTextStyle, t),
    ('emphasisTextStyle', b.copyWith(emphasisTextStyle: t),
        (s) => s.emphasisTextStyle, t),
    ('statusTextStyle', b.copyWith(statusTextStyle: t),
        (s) => s.statusTextStyle, t),
    ('statusLabelWidth', b.copyWith(statusLabelWidth: 3),
        (s) => s.statusLabelWidth, 3.0),
    ('fileNameTextStyle', b.copyWith(fileNameTextStyle: t),
        (s) => s.fileNameTextStyle, t),
    ('cancelTextStyle', b.copyWith(cancelTextStyle: t),
        (s) => s.cancelTextStyle, t),
    ('chipWidth', b.copyWith(chipWidth: 3), (s) => s.chipWidth, 3.0),
    ('chipRadius', b.copyWith(chipRadius: 3), (s) => s.chipRadius, 3.0),
    ('chipPadding', b.copyWith(chipPadding: i), (s) => s.chipPadding, i),
    ('chipBackgroundColor', b.copyWith(chipBackgroundColor: c),
        (s) => s.chipBackgroundColor, c),
    ('chipBorderColor', b.copyWith(chipBorderColor: c),
        (s) => s.chipBorderColor, c),
    ('barHeight', b.copyWith(barHeight: 3), (s) => s.barHeight, 3.0),
    ('barRadius', b.copyWith(barRadius: 3), (s) => s.barRadius, 3.0),
    ('barTrackColor', b.copyWith(barTrackColor: c), (s) => s.barTrackColor, c),
    ('barColor', b.copyWith(barColor: c), (s) => s.barColor, c),
    ('progressAnimationDuration', b.copyWith(progressAnimationDuration: d),
        (s) => s.progressAnimationDuration, d),
    ('compactBarPadding', b.copyWith(compactBarPadding: i),
        (s) => s.compactBarPadding, i),
    ('compactBarGap', b.copyWith(compactBarGap: 3),
        (s) => s.compactBarGap, 3.0),
    ('itemGap', b.copyWith(itemGap: 3), (s) => s.itemGap, 3.0),
    ('closeButtonSize', b.copyWith(closeButtonSize: 3),
        (s) => s.closeButtonSize, 3.0),
    ('rowCloseIconSize', b.copyWith(rowCloseIconSize: 3),
        (s) => s.rowCloseIconSize, 3.0),
    ('headerCloseIconSize', b.copyWith(headerCloseIconSize: 3),
        (s) => s.headerCloseIconSize, 3.0),
    ('footerPadding', b.copyWith(footerPadding: i),
        (s) => s.footerPadding, i),
    ('closeIconColor', b.copyWith(closeIconColor: c),
        (s) => s.closeIconColor, c),
  ];
}
