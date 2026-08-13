import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const double sidebarWidth = 204;

/// Ambient conditions used by [pumpSidebar].
class SidebarSurface {
  const SidebarSurface({
    this.width = sidebarWidth,
    this.brightness = Brightness.light,
    this.textDirection = TextDirection.ltr,
  });

  final double width;
  final Brightness brightness;
  final TextDirection textDirection;
}

Future<void> pumpSidebar(
  WidgetTester tester,
  Widget child, {
  SidebarSurface surface = const SidebarSurface(),
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(brightness: surface.brightness),
      home: Scaffold(
        body: Directionality(
          textDirection: surface.textDirection,
          child: SizedBox(width: surface.width, child: child),
        ),
      ),
    ),
  );
}
