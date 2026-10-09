import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/components/file_transfer/linagora_file_transfer_use_case.dart';

Future<void> _pumpUseCase(
  WidgetTester tester, [
  Map<String, String> knobs = const {},
]) async {
  await tester.pumpWidget(
    MaterialApp(
      home: WidgetbookScope(
        state: WidgetbookState(
          root: WidgetbookRoot(children: const []),
          queryParams: {'knobs': FieldCodec.encodeQueryGroup(knobs)},
        ),
        child: const Builder(builder: linagoraFileTransferDialogUseCase),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('renders the dialog with one row by default', (tester) async {
    await _pumpUseCase(tester);

    expect(find.text('Attaching file'), findsOneWidget);
    expect(find.byType(LinagoraFileTransferRow), findsOneWidget);
    expect(find.byKey(LinagoraFileTransferDialog.closeButtonKey), findsNothing);
  });

  testWidgets('the close button knob adds the header close', (tester) async {
    await _pumpUseCase(tester, const {'Close button': 'true'});

    expect(
      find.byKey(LinagoraFileTransferDialog.closeButtonKey),
      findsOneWidget,
    );
  });
}
