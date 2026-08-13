import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

Future<void> pumpSidebarTreeList(WidgetTester tester, Widget child) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 204,
          height: 180,
          child: child,
        ),
      ),
    ),
  );
}

Rect sidebarTreeListRowRect(WidgetTester tester, String label) {
  return tester.getRect(
    find.ancestor(of: find.text(label), matching: find.byType(Material)).first,
  );
}

Widget sidebarTreeListFolderItem(
  BuildContext context,
  LinagoraSidebarTreeListEntry<String> entry,
) {
  return LinagoraSidebarItem(label: entry.data, icon: Icons.folder_outlined);
}
