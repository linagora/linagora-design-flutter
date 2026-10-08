import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/components/file_transfer/linagora_file_transfer_simulated_use_case.dart';

Future<void> _pumpUseCase(WidgetTester tester) => tester.pumpWidget(
      MaterialApp(
        home: WidgetbookScope(
          state: WidgetbookState(
            root: WidgetbookRoot(children: const []),
            queryParams: {'knobs': FieldCodec.encodeQueryGroup(const {})},
          ),
          child: const Builder(builder: linagoraFileTransferSimulatedUseCase),
        ),
      ),
    );

void main() {
  testWidgets('progress advances, a row can be cancelled, restart resets',
      (tester) async {
    await _pumpUseCase(tester);
    await tester.pump(const Duration(seconds: 2));

    final bar = tester.widgetList<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(bar.any((b) => (b.value ?? 0) > 0), isTrue);

    await tester.tap(find.byKey(LinagoraFileTransferRow.cancelButtonKey).first);
    await tester.pump();
    expect(find.text('Cancelled'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('demo_restart')));
    await tester.pump();
    expect(find.text('Cancelled'), findsNothing);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Cancel all settles every row and hides the footer button',
      (tester) async {
    await _pumpUseCase(tester);
    await tester.pump();

    await tester.tap(find.byKey(LinagoraFileTransferDialog.cancelAllButtonKey));
    await tester.pump();

    expect(find.text('Cancelled'), findsNWidgets(3));
    expect(find.byKey(LinagoraFileTransferRow.cancelButtonKey), findsNothing);

    await tester.pumpWidget(const SizedBox());
  });
}
