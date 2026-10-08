import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/components/file_transfer/linagora_file_transfer_use_case.dart';

void main() {
  testWidgets('renders the dialog with one row by default', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: WidgetbookScope(
          state: WidgetbookState(
            root: WidgetbookRoot(children: const []),
            queryParams: {'knobs': FieldCodec.encodeQueryGroup(const {})},
          ),
          child: const Builder(builder: linagoraFileTransferDialogUseCase),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Attaching file'), findsOneWidget);
    expect(find.byType(LinagoraFileTransferRow), findsOneWidget);
  });
}
