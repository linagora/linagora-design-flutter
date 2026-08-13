import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

Future<void> pumpSidebarItem(
  WidgetTester tester,
  LinagoraSidebarItem item,
) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: SizedBox(width: 204, child: item)),
    ),
  );
}

Future<void> hoverSidebarItem(WidgetTester tester, Finder target) async {
  final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
  addTearDown(() => mouse.removePointer());
  await mouse.addPointer(location: Offset.zero);
  await tester.pump();
  await mouse.moveTo(tester.getCenter(target));
  await tester.pumpAndSettle();
}

Future<void> Function(WidgetTester) onTargetPlatform(
  TargetPlatform platform,
  Future<void> Function(WidgetTester) body,
) {
  return (tester) async {
    debugDefaultTargetPlatformOverride = platform;
    try {
      await body(tester);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  };
}

Color? sidebarBackground(WidgetTester tester) =>
    tester.widget<Material>(sidebarMaterialFinder).color;

Finder get sidebarRowFinder => find.byType(LinagoraSidebarItem);

Finder get sidebarMaterialFinder => find.descendant(
      of: find.byType(LinagoraSidebarItem),
      matching: find.byType(Material),
    );

void sidebarNoop() {}
