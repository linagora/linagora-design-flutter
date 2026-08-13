import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

import 'linagora_sidebar_tree_list_test_utils.dart';

void main() {
  testWidgets('builds only rows near the viewport', _buildsVisibleRows);
  testWidgets('forwards scroll ownership to the list', _forwardsScrollOwnership);
  testWidgets('accepts a GlobalKey without claiming it twice', _acceptsAGlobalKey);
  testWidgets('keeps row elements when a sibling is inserted above', _keepsRowElementsOnInsert);
  testWidgets('restores its scroll offset from page storage', _restoresScrollOffset);
}

Future<void> _buildsVisibleRows(WidgetTester tester) async {
  var buildCount = 0;
  final entries = List.generate(
    200,
    (index) => LinagoraSidebarTreeListEntry(
      id: index,
      data: 'Folder $index',
    ),
  );

  await pumpSidebarTreeList(
    tester,
    Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        height: 72,
        child: LinagoraSidebarTreeList<String>(
          entries: entries,
          itemBuilder: (_, entry) {
            buildCount++;
            return SizedBox(height: 36, child: Text(entry.data));
          },
        ),
      ),
    ),
  );

  expect(buildCount, lessThan(entries.length));
  expect(tester.getRect(find.byType(ListView)).height, 72);
  expect(find.text('Folder 199'), findsNothing);
}

Future<void> _forwardsScrollOwnership(WidgetTester tester) async {
  final controller = ScrollController();
  addTearDown(controller.dispose);
  const key = PageStorageKey('folder-tree-list');

  await pumpSidebarTreeList(
    tester,
    LinagoraSidebarTreeList<String>(
      key: key,
      controller: controller,
      entries: const [
        LinagoraSidebarTreeListEntry(id: 'personal', data: 'Personal folders'),
      ],
      itemBuilder: sidebarTreeListFolderItem,
    ),
  );

  final list = tester.widget<ListView>(find.byType(ListView));
  expect(list.controller, same(controller));
  // The key stays on the tree list alone. Repeating it on the list it builds
  // makes a GlobalKey throw, and buys nothing: page storage reaches the scroll
  // position through any ancestor key.
  expect(list.key, isNull);
  expect(find.byKey(key), findsOneWidget);
}

/// A GlobalKey may only be claimed by one widget, so the tree list must not
/// hand its own key to the list it builds.
Future<void> _acceptsAGlobalKey(WidgetTester tester) async {
  await pumpSidebarTreeList(
    tester,
    LinagoraSidebarTreeList<String>(
      key: GlobalKey(),
      entries: const [
        LinagoraSidebarTreeListEntry(id: 'personal', data: 'Personal folders'),
      ],
      itemBuilder: sidebarTreeListFolderItem,
    ),
  );

  expect(tester.takeException(), isNull);
  expect(find.text('Personal folders'), findsOneWidget);
}

/// Expanding a folder inserts rows above existing ones. Those existing rows
/// carry stable IDs, so their elements have to move rather than be rebuilt,
/// or every row below a toggle loses hover, focus and product row state.
Future<void> _keepsRowElementsOnInsert(WidgetTester tester) async {
  Future<void> pump(List<String> ids) {
    return pumpSidebarTreeList(
      tester,
      LinagoraSidebarTreeList<String>(
        entries: [
          for (final id in ids)
            LinagoraSidebarTreeListEntry(id: id, data: id),
        ],
        itemBuilder: (_, entry) => _LifecycleRow(label: entry.data),
      ),
    );
  }

  await pump(['a', 'b', 'c']);
  expect(_LifecycleRowState.built, ['a', 'b', 'c']);

  _LifecycleRowState.built.clear();
  await pump(['inserted', 'a', 'b', 'c']);

  expect(_LifecycleRowState.built, ['inserted']);
}

/// Reports every row that is created from scratch, so a test can tell a moved
/// element from a rebuilt one.
class _LifecycleRow extends StatefulWidget {
  const _LifecycleRow({required this.label});

  final String label;

  @override
  State<_LifecycleRow> createState() => _LifecycleRowState();
}

class _LifecycleRowState extends State<_LifecycleRow> {
  static final List<String> built = <String>[];

  @override
  void initState() {
    super.initState();
    built.add(widget.label);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 36, child: Text(widget.label));
  }
}

Future<void> _restoresScrollOffset(WidgetTester tester) async {
  final bucket = PageStorageBucket();
  const key = PageStorageKey<String>('folder-tree-list');
  await pumpSidebarTreeList(
    tester,
    PageStorage(bucket: bucket, child: _scrollableTreeList(key)),
  );

  await tester.drag(find.byType(ListView), const Offset(0, -240));
  await tester.pumpAndSettle();
  final offset = _scrollOffset(tester);
  expect(offset, greaterThan(0));

  await pumpSidebarTreeList(tester, const SizedBox());
  await pumpSidebarTreeList(
    tester,
    PageStorage(bucket: bucket, child: _scrollableTreeList(key)),
  );

  expect(_scrollOffset(tester), closeTo(offset, 0.1));
}

Widget _scrollableTreeList(Key key) {
  return LinagoraSidebarTreeList<String>(
    key: key,
    entries: List.generate(
      100,
      (index) => LinagoraSidebarTreeListEntry(
        id: index,
        data: 'Folder $index',
      ),
    ),
    itemBuilder: (_, entry) => SizedBox(height: 36, child: Text(entry.data)),
  );
}

double _scrollOffset(WidgetTester tester) {
  return tester.state<ScrollableState>(find.byType(Scrollable)).position.pixels;
}
