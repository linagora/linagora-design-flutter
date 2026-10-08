import 'package:flutter/material.dart';
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

    testWidgets('null onClose hides the header close', (t) async {
      await t.pumpWidget(_host(dialog()));
      expect(find.byKey(LinagoraFileTransferDialog.closeButtonKey),
          findsNothing);
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
  });
}
